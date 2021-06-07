//
//  ChatRoomViewController.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/18.
//

import UIKit
import Firebase
import FirebaseFirestore


class ChatRoomViewController:UIViewController{
    
    let chatRoomtableView=ChatRoomtableView()
    private let cellID="cellID"
    var chatroom:ChatRoom?
    private var messages=[Message]()
    var user:User?{
        didSet{
            let label=UILabel()
            label.font = .boldSystemFont(ofSize: 22)
            label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            label.text=user?.name
            label.contentCompressionResistancePriority(for: .horizontal)
            navigationItem.titleView = label
        }
    }
    private let accessaryHeight:CGFloat=100
    private var safeAreaBottom:CGFloat{
        self.view.safeAreaInsets.bottom
    }
    var indexList:[Bool]=[]

    
    

    private lazy var chatInputAccessaryView:ChatInputAccessaryView={
        let view=ChatInputAccessaryView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
        view.delegate=self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupNotification()
        fetchMessages()
        
    }
    private func setupNotification(){
        
        let notification=NotificationCenter.default
        
        notification.addObserver(self, selector: #selector(keybordWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        notification.addObserver(self, selector: #selector(keybordWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func setupLayout(){
        
        navigationController?.navigationBar.barTintColor = .white
        chatRoomtableView.delegate=self
        chatRoomtableView.dataSource=self
        chatRoomtableView.register(UINib(nibName:"ChatRoomTableViewCell",bundle: nil), forCellReuseIdentifier: cellID)
        chatRoomtableView.contentInset = .init(top: 0, left: 0, bottom: 75, right: 0)
        chatRoomtableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 75, right: 0)
        chatRoomtableView.keyboardDismissMode = .interactive
        tabBarController?.tabBar.isHidden=true
        chatRoomtableView.backgroundColor = .rgb(red: 134, green: 179, blue: 224)
        view.addSubview(chatRoomtableView)
        chatRoomtableView.anchor(top:view.safeAreaLayoutGuide.topAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor, left:view.leftAnchor,right: view.rightAnchor)
    }
    
    @objc func keybordWillShow(_ notification:NSNotification){

        guard let userInfo=notification.userInfo else {return}
        if let keybordFrame=(userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue{
            if keybordFrame.height <= accessaryHeight{return}
            let bottom = keybordFrame.height-safeAreaBottom
            let moveY = chatRoomtableView.contentOffset.y+bottom-safeAreaBottom
            if (chatRoomtableView.contentOffset.y-chatRoomtableView.contentSize.height+bottom+100>0){
                return
            }
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
            
            chatRoomtableView.contentInset = contentInset
            chatRoomtableView.scrollIndicatorInsets = contentInset
            chatRoomtableView.contentOffset = CGPoint(x: 0, y: moveY)
        }
    }

    @objc func keybordWillHide(_ notification:NSNotification){
        chatRoomtableView.contentInset = .init(top: 0, left: 0, bottom: 75, right: 0)
        chatRoomtableView.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 75, right: 0)
    }
    
    func dateFormatterForDateLabel(date: Date,dataStyle: DateFormatter.Style,timeStyle:DateFormatter.Style) -> String {
       let formatter = DateFormatter()
       formatter.dateStyle = dataStyle
       formatter.timeStyle = timeStyle
       formatter.locale = Locale(identifier: "ja_JP")
       return formatter.string(from: date)
   }

    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     
        tabBarController?.tabBar.isHidden=false
        NotificationCenter.default.removeObserver(self)
    }
    
    override var inputAccessoryView: UIView?{
        get{
            return chatInputAccessaryView
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    private func fetchMessages(){
        guard let chatroomDocId=chatroom?.documentId else {return}
        
        Firestore.firestore().collection("chatRooms").document(chatroomDocId).collection("messages").addSnapshotListener { (snapshot, err) in
            if let err=err{
                print("メッセー情報の取得に失敗しました",err)
                return
            }
            snapshot?.documentChanges.forEach({ (documentchange) in
                switch documentchange.type{
                case .added:
                    let dic=documentchange.document.data()
                    let message=Message(dic: dic)
                    message.partnerUser = self.chatroom?.partnerUser
                    self.messages.append(message)
                    self.messages.sort { (m1, m2) -> Bool in
                        let m1Date=m1.createdAt.dateValue()
                        let m2Date=m2.createdAt.dateValue()
                        return m1Date < m2Date
                    }
                   
                    DispatchQueue.main.async {
                        // メインスレッドで実行 UIの処理など
                        self.chatRoomtableView.reloadData()
                        self.chatRoomtableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: false)
                    }
                    
                case .modified,.removed:
                    print("nothing to do")
                }
            })
        }
    }
}
extension ChatRoomViewController:chatInputAccessaryViewDelegate{
    func tappedSendButton(text: String) {
        
        guard let chatroomDocId = chatroom?.documentId else {return}
        
        
        guard let dic=UserDefaults.standard.dictionary(forKey:"User") else {return}
        guard let name=dic["name"] as? String else {return}
        guard let uid=Auth.auth().currentUser?.uid else {return}
        chatInputAccessaryView.removeText()
        let messageId=randomString(length: 20)

        let docData=[
            "name":name,
            "createdAt": Timestamp(),
            "uid":uid,
            "message":text
        ] as [String : Any]
        
        Firestore.firestore().collection("chatRooms").document(chatroomDocId).collection("messages").document(messageId)
            .setData (docData){ (err) in
                if let err=err{
                    print("メッセージの取得に保存しました",err)
                    return
                }
//                print("メッセージの保存に施行しました")
        }
        let latestmessageId=[
            "latestMessageId": messageId
        ]
        Firestore.firestore().collection("chatRooms").document(chatroomDocId)
            .updateData(latestmessageId){ (err) in
            if let err = err{
                print("chatRoomのアップrデートに失敗しました",err)
            }
//            print("成功しました")
        }
    }
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
 
}

extension ChatRoomViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatRoomtableView.estimatedRowHeight=10
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=chatRoomtableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ChatRoomTableViewCell
        cell.timeLabel.isHidden=true
        
        var timeStrig=""
        for (i,m) in zip(self.messages.indices,self.messages){

            let time = dateFormatterForDateLabel(date: m.createdAt.dateValue(), dataStyle: .long, timeStyle: .none)
            if (timeStrig != time && indexPath.row==i){
                    cell.timeLabel.text = time
                    cell.timeLabel.isHidden=false
            }
            timeStrig=time
        }
        cell.message=messages[indexPath.row]
        return cell
    }
}
