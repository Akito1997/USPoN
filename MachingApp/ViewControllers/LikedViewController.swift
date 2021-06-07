//
//  LikedViewController.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/17.
//

import UIKit
import Firebase
import Nuke
import FirebaseFirestore

protocol funcdelegate:AnyObject {
    func dontLike(tag:Int)
    func setTalkuser(tag:Int)
}

class LikedViewController:UIViewController,funcdelegate{
    
    private let cellID="cellID"
    var likedList:[String]=[]
    var users=[User]()
    lazy var bakView:UIView={
        let view=UIView()
        view.frame=self.view.frame
        view.backgroundColor = .rgb(red: 0, green: 0, blue: 0, alpha: 0.0)
        return view
    }()

    
    lazy var CollectionView:UICollectionView={
        
        let layout=UICollectionViewFlowLayout()
        layout.itemSize=CGSize(width: 120, height: 170)
        layout.minimumLineSpacing=60
        layout.minimumInteritemSpacing=20
        layout.sectionInset = UIEdgeInsets(top: 30, left: 40, bottom: 0, right: 40)
        
        let cv=UICollectionView(frame:view.frame, collectionViewLayout: layout)
        cv.delegate=self
        cv.dataSource=self
        cv.register(MyCollectionViewCell.nib(), forCellWithReuseIdentifier: "MyCollectionViewCell")
        cv.backgroundColor = .white
        cv.clipsToBounds=true
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        fetchUserFirebase()
    }
    private func fetchUserFirebase(){
        guard let uid=Auth.auth().currentUser?.uid else {return}
        Firestore.fetchUserlikedFormFirestore(uid: uid) { [weak self] (likedList) in
            self?.users.removeAll()
            if likedList.isEmpty{
                DispatchQueue.main.async {
                    self?.CollectionView.reloadData()
                }
            }else{
                for likedname in likedList{
                    Firestore.fetchUserFromFirestore(uid: likedname) { [weak self] (user, nomatch) in
                        if let user=user{
                            self?.users.append(user)
                            DispatchQueue.main.async {
                                self?.CollectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }

    private func setupLayout(){
        view.backgroundColor = .white
        view.addSubview(CollectionView)
        CollectionView.anchor(top:view.safeAreaLayoutGuide.topAnchor,bottom:view.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor)
    }
    func dontLike(tag:Int){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        if users.isEmpty{return}
        let targetuid=users[tag].myuid
        Firestore.deleteLikedFromFirestore(uid: uid, targetsuid: targetuid) {
            Firestore.removeMatchuid(uid: uid, targetsuid: targetuid) {
                
            }
        }
        
    }
    

    func setTalkuser(tag:Int){

        guard let uid = Auth.auth().currentUser?.uid else {return}
        if users.isEmpty{return}
        let partnerUid=self.users[tag].myuid
        Firestore.deleteLikedFromFirestore(uid: uid, targetsuid: partnerUid) {
            Firestore.setMessageToFirestore(uid: uid, partonerUid: partnerUid){
                Firestore.removeMatchuid(uid: uid, targetsuid: partnerUid){
                    
                }
            }
        }
        
    }
}

extension LikedViewController:UICollectionViewDelegate,UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=CollectionView.dequeueReusableCell(
            withReuseIdentifier:"MyCollectionViewCell",
            for: indexPath) as! MyCollectionViewCell
                
        cell.user=users[indexPath.row]
        cell.tag=indexPath.row
        cell.delegate=self

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell=CollectionView.cellForItem(at: indexPath) as? MyCollectionViewCell else {return}
        let position=CollectionView.centerPosition(cell: cell)
        
        let trans=CGAffineTransform(translationX: view.center.x-position.x, y:view.center.y-position.y-60)
        let gesture=Mygestrue(target: self, action: #selector(backCell))
        
        gesture.cell=cell
        self.bakView.addGestureRecognizer(gesture)
        collectionView.bringSubviewToFront(cell)

        UIView.animate(withDuration: 0.5) {
            cell.savebutton.isHidden=true
            cell.deletebutton.isHidden=true
            cell.transform = trans.scaledBy(x: 2.8, y: 2.8)
        }completion: { (finish) in
            if finish{
                self.view.addSubview(self.bakView)
            }
        }
    }

    @objc func backCell(_ recognizer:Mygestrue){
        guard let cell=recognizer.cell else {return}
        UIView.animate(withDuration: 0.4) {
            cell.transform = .identity
        }completion: { (finish) in
            if finish{
                cell.savebutton.isHidden=false
                cell.deletebutton.isHidden=false
                self.bakView.removeFromSuperview()
            }
        }
    }
}

class Mygestrue:UITapGestureRecognizer{
    var cell:MyCollectionViewCell?
}



