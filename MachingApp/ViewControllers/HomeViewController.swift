//
//  ViewController.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/02/17.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PKHUD
import RxCocoa
import RxSwift
import Nuke


class HomeViewController: UIViewController {
    
    var flag=false
    
    private var user:User?
    private var users=[User]()
    private var receiveuids=[String]()
    private let disposeBag=DisposeBag()
    private var likedlist=[String]()
        
    let cardView=UIView()
    let bottomControlView=BottomControlView()
    let CommentView=CommentViewController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    static var registerflag=false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Auth.auth().currentUser?.uid==nil || Auth.auth().currentUser?.isEmailVerified==false{
            let registerController=RegisterViewController()
            let nav=UINavigationController(rootViewController: registerController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
        //ログインした後はProfileVireCOntrollerにidousuru
        if HomeViewController.registerflag{
            tabBarController?.selectedIndex=3
            HomeViewController.registerflag=false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            FirebaseFromUser()
        
    }
    func FirebaseFromUser(){
        if !receiveuids.isEmpty{return}

        users=[]
        guard let uid=Auth.auth().currentUser?.uid else {return}
        Firestore.fetchUserFromFirestore(uid:uid) {[weak self] (user,match ) in
            if let user = user {
                self?.user=user
                self?.fetchUsers(match:match)
            }
        }
    }

    //MARK: Methods
    private func fetchUsers(match:[String]){
        guard let user = user else {return}
        guard let email=Auth.auth().currentUser?.email else {return}
        HUD.show(.progress)
        Firestore.fetchUserFromFirestore(match:match,myemail:email,targetgender: user.targetgender ) {[weak self] (users,uids) in
            HUD.hide()
            self?.receiveuids.removeAll()
            self?.users=users
            self?.users.forEach { (user) in
                let card=CardView(user: user)
                self?.cardView.addSubview(card)
                guard let url=URL(string:user.profile_imageurl) else {return}
                Nuke.loadImage(with: url,into: card.cardImageView)
                card.cardImageView.contentMode = .scaleAspectFill
                self?.receiveuids.append(user.myuid)
                card.delegate=self
                card.anchor(top:self?.cardView.topAnchor,bottom:self?.cardView.bottomAnchor,left: self?.cardView.leftAnchor,right: self?.cardView.rightAnchor)
            }
        }
    }
    
    func setLikeandNotLike(like:Bool){
        
        guard let uid=Auth.auth().currentUser?.uid else {return}
        guard let targetuid=self.receiveuids.first else {return}
        Firestore.removeMatchuid(uid: uid, targetsuid: targetuid) {}
        if like{
            Firestore.getMatchUser(targetuid: targetuid) { (list) in
                //相手のmatchリストになければ相手のlikedに追加しない
                if list.contains(uid){
                    Firestore.setDataLikedToFirestore(uid: uid, targetuid: targetuid) {
                    }
                }
            }
        }
        self.receiveuids.removeFirst()
    }
    
    
    private func setupLayout(){
        view.backgroundColor = .white
        
        let stackView=UIStackView(arrangedSubviews: [cardView,bottomControlView])
        stackView.translatesAutoresizingMaskIntoConstraints=false
        stackView.axis = .vertical
        
        self.view.addSubview(stackView)
        bottomControlView.reloadView.homedelegate=self
        [bottomControlView.heightAnchor.constraint(equalToConstant: 80),
         stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 30),
         stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
         stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
         stackView.rightAnchor.constraint(equalTo: view.rightAnchor)].forEach {
            $0.isActive=true
         }
    }
    
    func AlertToView(view:UIAlertController){
        present(view, animated: true){
            
        }
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

