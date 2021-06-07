//
//  CommentViewController.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/17.
//

import UIKit
import Firebase
import FirebaseFirestore

class CommentViewController:UIViewController{
    
    private let CommenttableView=CommentTableView()
    private let cellID="cellID"
    private var chatrooms=[ChatRoom]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CommenttableView.delegate=self
        CommenttableView.dataSource=self
        setupLayout()
        fetchChatroomsInfoFirestore()

    }
    private func fetchChatroomsInfoFirestore(){
        Firestore.fetchChatroomFromFirestore{ (chatroom) in
            guard let id=chatroom.documentId else {return}
            //同じ人がきたら排除する
            if chatroom.latestMessageId == ""{
                let countrySet = Set(chatroom.members)
                for i in self.chatrooms{
                    if countrySet.contains(i.members[0]) && countrySet.contains(i.members[1]){
                        return
                    }
                }
            }

            for (i,cm) in zip(self.chatrooms.indices,self.chatrooms){
                if id == cm.documentId{
                    self.chatrooms.remove(at: i)
                    //バッジで通知する
                    if let tabItem = self.tabBarController?.tabBar.items?[2] {
                            tabItem.badgeColor = .clear
                            tabItem.badgeValue = "●"
                            let badgeTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize:  10)]
                            tabItem.setBadgeTextAttributes(badgeTextAttributes, for: .normal)
                    }
                }
            }
            self.chatrooms.insert(chatroom, at: 0)
            DispatchQueue.main.async {
                self.CommenttableView.reloadData()
            }
        } removeFunc: {(chatroom) in
            //トーク履歴を削除
            guard let id=chatroom.documentId else {return}
            for (i,cm) in zip(self.chatrooms.indices,self.chatrooms){
                if id == cm.documentId{
                    self.chatrooms.remove(at: i)
                }
            }
            self.CommenttableView.reloadData()
        }
    }
    
    private func setupLayout(){
        
        navigationController?.navigationBar.barTintColor = .white
        //backボタンを消す
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
                   title: "",
                   style: .plain,
                   target: nil,
                   action: nil)
        view.backgroundColor = .white
        CommenttableView.backgroundColor = .white
        view.addSubview(CommenttableView)
        CommenttableView.anchor(top:view.topAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,toppadding:100)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabItem = self.tabBarController?.tabBar.items?[2] {
            let badgeTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize:  10) ]
            tabItem.setBadgeTextAttributes(badgeTextAttributes, for: .normal)
        }
    }
}
//MARK: tableviewのextension
extension CommentViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return chatrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CommenttableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cell = cell as? ChatListTableViewCell{
            cell.chatroom = chatrooms[indexPath.row]
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            cell.selectedBackgroundView = view
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc=ChatRoomViewController()
        vc.chatroom = chatrooms[indexPath.row]
        vc.user = chatrooms[indexPath.row].partnerUser
        CommenttableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "マッチ解除") { (action, view, completionHandler) in
            
            guard let messageId = self.chatrooms[indexPath.row].documentId else {return}
            guard let uid = Auth.auth().currentUser?.uid else {return}
            guard let targetUid = self.chatrooms[indexPath.row].partnerUser?.myuid else {return}
            
            let alert: UIAlertController = UIAlertController(title: "マッチ解除", message:  "本当にマッチを解除してよろしいですか？", preferredStyle:  UIAlertController.Style.alert)
            // 確定ボタンの処理
            let confirmAction: UIAlertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default, handler:{
                // 確定ボタンが押された時の処理をクロージャ実装する
                (action: UIAlertAction!) -> Void in
                //実際の処理
                self.chatrooms.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                let addelement = [uid,targetUid]
                Firestore.firestore().collection("chatRooms").document(messageId).updateData(["members":FieldValue.arrayRemove(addelement)])
                
            })
            // キャンセルボタンの処理
            let cancelAction: UIAlertAction = UIAlertAction(title: "いいえ", style: UIAlertAction.Style.cancel, handler:{
                // キャンセルボタンが押された時の処理をクロージャ実装する
                (action: UIAlertAction!) -> Void in

            })
            //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            //実際にAlertを表示する
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
        }
        
        let alertAction = UIContextualAction(style: .destructive, title:"通報") {
            (ctxAction, view, completionHandler) in
            
            guard let messageId = self.chatrooms[indexPath.row].documentId else {return}
            guard let uid = Auth.auth().currentUser?.uid else {return}
            guard let targetUid = self.chatrooms[indexPath.row].partnerUser?.myuid else {return}
            guard let name = self.chatrooms[indexPath.row].partnerUser?.name else {return}
            let addelement = [uid,targetUid]
            
            let alert=UIAlertController.createAlert(myuid: uid, targetuid: targetUid, name: name) {
                Firestore.firestore().collection("chatRooms").document(messageId).updateData(["members":FieldValue.arrayRemove(addelement)])
                
                self.showThank()
                self.chatrooms.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
        }
        
        alertAction.backgroundColor = #colorLiteral(red: 1, green: 0.7782791306, blue: 0, alpha: 1)
        return UISwipeActionsConfiguration(actions: [deleteAction,alertAction])
    }
    
    func showThank(){
        
        let label_1=UILabel()
        label_1.text = "ご報告ありがとうございました。"
        label_1.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        label_1.font = .boldSystemFont(ofSize: 18)
        label_1.textAlignment = .center
        let label_2=UILabel()
        label_2.text = "ご参考にさせていただきます"
        label_2.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        label_2.font = .boldSystemFont(ofSize: 18)
        label_2.textAlignment = .center
        
        let baseView=UIView()
        baseView.backgroundColor = .white
        baseView.addSubview(label_1)
        baseView.addSubview(label_2)
        
        self.view.addSubview(baseView)
        baseView.alpha=0
        baseView.layer.cornerRadius = 15
        baseView.clipsToBounds=true


        UIView.animate(withDuration: 1) {
            baseView.alpha=1
        } completion: { (finish) in
            UIView.animate(withDuration: 1) {
                baseView.alpha=0
            }completion: { (f) in
                baseView.removeFromSuperview()
            }
        }
        label_1.anchor(top:baseView.topAnchor,left: baseView.leftAnchor,right: baseView.rightAnchor,toppadding: 15)
        label_2.anchor(bottom:baseView.bottomAnchor,left: baseView.leftAnchor, right:baseView.rightAnchor,bottompadding: 15)
        baseView.anchor(top:view.topAnchor,bottom: view.bottomAnchor,left:view.leftAnchor,right: view.rightAnchor,toppadding:300,bottompadding: 470, leftpadding: 50,rightpadding: 50)
    }
}
