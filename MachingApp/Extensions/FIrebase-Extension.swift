//
//  FIrebase-Extension.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/11.
//

import Firebase
import FirebaseFirestore
import PKHUD


extension Auth{
    static func createUsertoFirebaseAuth(email:String?,password:String?,name:String?,completion:@escaping (Bool) -> Void){
        guard let email=email else {return}
        guard let password=password else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (auth, err) in
            if let err=err{
                print("auth情報の保存に成功しました",err)
                HUD.hide{(_) in
                    HUD.flash(.error,delay: 1)
                }
                return
            }
            Auth.auth().languageCode="ja"
            auth?.user.sendEmailVerification(completion: { (err) in
                if err==nil{
                    guard let uid=auth?.user.uid else {return}
                    print("auth情報の保存に成功しました",uid)
                    completion(true)
                    
                }
            })
        }
    }
    static func loginwithFirebase(email:String,password:String,completion: @escaping (Bool)->Void){

        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err=err{
                print("ログイン失敗",err)
                HUD.hide{(_) in
                    HUD.flash(.error,delay: 1)
                }
                return
            }
            print("ログイン成功")
            completion(true)
        }
    }
}


extension Firestore{
    static func setMessageToFirestore(uid:String,partonerUid:String,copmlition:@escaping ()->Void){
        
        let members=[uid,partonerUid]
        let dic=[
            "members":members,
            "latestMessageId":"",
            "createdAt":Timestamp()
        ] as [String : Any]
        
        Firestore.firestore().collection("chatRooms").addDocument(data: dic){ (err) in
            if let err=err{
                print("chatRoom情報の保存に失敗しました",err)
                return
            }
            copmlition()
        }
    }
    static func getMatchUser(targetuid:String,complition:@escaping ([String])->Void){
        
        Firestore.firestore().collection("users").document(targetuid).getDocument { (snapshot, err) in
            if let err=err{
                print("nomatchの情報を取得しました",err)
                return
            }
            
            guard let data=snapshot?.data() else {return}
            
            guard let matchList=data["match"] as? [String] else {return}

            complition(matchList)
        }
    }
    static func setDataLikedToFirestore(uid:String,targetuid:String,completion:@escaping ()->Void){
        let addelement=[uid]
        Firestore.firestore().collection("users").document(targetuid).updateData(["liked":FieldValue.arrayUnion(addelement)]){(err) in
            if let err=err{
                print("Likeに値が入りませんでした",err)
            }
            completion()
        }
    }
    
    static func deleteLikedFromFirestore(uid:String,targetsuid:String,compition:@escaping ()->Void){
        let addelement=[targetsuid]
        Firestore.firestore().collection("users").document(uid).updateData(["liked":FieldValue.arrayRemove(addelement)]) { (err) in
            if let err=err{
                print("nomatchのデリートに失敗しました",err)
            }
            compition()
        }
    }
    //notmatchに追加する
    static func removeMatchuid(uid:String,targetsuid:String,complition:@escaping ()->Void){
        
        let addelement=[targetsuid]
        Firestore.firestore().collection("users").document(uid).updateData(["match":FieldValue.arrayRemove(addelement)]){err in
            if let err=err{
                print(err)
            }
            complition()
        }
    }
    
    static func setUserDateToFirestore(document: [String : Any],uid:String,
                                       completion:@escaping (Bool) -> ()){
        Firestore.firestore().collection("users").document(uid).setData(document) { (err) in

            if let err=err{
                print("ユーザー情報の保存に失敗",err)
            }
            completion(true)
        }
    }
    static func upDateUserToFirestore(document: [String : Any],uid:String,
                                       completion:@escaping (Bool) -> ()){
        Firestore.firestore().collection("users").document(uid).updateData(document){ (err) in
            if let err=err{
                print(err)
            }
            completion(true)
        }
    }
    
    
    //Firestoreからユーザー情報を取得
    static func fetchUserFromFirestore(uid:String,completion:@escaping (User?,[String])->Void){
        
        Firestore.firestore().collection("users").document(uid)
            .getDocument{ (snapshot, err) in
            if let err=err{
                print("ユーザー情報の取得に失敗しました",err)
                return
            }
            guard let data=snapshot?.data() else {return}
            let user=User(dic: data)
            if let nomatch=data["match"] as? [String]{
                completion(user,nomatch)
            }
           
        }
    }
    
    //Firestoreから自分以外のユーザー情報を取得
    static func fetchUserFromFirestore(match:[String],myemail:String,targetgender:String,completion:@escaping ([User],[String])->Void){

        let  Ref=Firestore.firestore().collection("users")
        
        Ref.whereField("mygender", isEqualTo: targetgender).getDocuments { (snapshots, err) in
            if let err=err{
                print("ユーザー情婦の取得に失敗",err)
                return
            }
            
            let users=snapshots?.documents.map({ (snapshot) -> User in
                let dic=snapshot.data()
                let user=User(dic: dic)
                return user
            })
            let uids=snapshots?.documents.map({ (snapshot) -> String in
                return snapshot.documentID
            })
            var Users=[User]()
            var Uids=[String]()
            guard let uidList=uids else {return}
            guard let userList=users else {return}
            for (uid,user) in zip(uidList,userList){
                if match.contains(uid){
                    Users.append(user)
                    Uids.append(uid)
                }
            }
            completion(Users ,Uids)
        }
    }
    
    //Firestoreのlikedに値が入った時に、ユーザーに通知する
    static func fetchUserlikedFormFirestore(uid:String,complition:@escaping (([String])->Void)){
        Firestore.firestore().collection("users")
            .document(uid)
            .addSnapshotListener{ (querySnapshot, err) in
            
           if let err = err  {
                print("liked情報を取得に失敗しました\(err)")
                return
            }
            guard let snapshot=querySnapshot else {return}
            guard let data=snapshot.data() else {return}
            if let likedList=data["liked"] as? [String]{
                complition(likedList)
            }
        }
    }
    //Firestoreのtalkinguserが入った時に、ユーザーに通知する
    static func fetchChatroomFromFirestore(complition:@escaping ((ChatRoom)->Void),removeFunc:@escaping (ChatRoom)->Void){
        
        Firestore.firestore().collection("chatRooms")
            .addSnapshotListener { (snapshots, err) in
                if let err=err{
                    print("chatRoom情報の取得に失敗しました\(err)")
                    return
                }
                snapshots?.documentChanges.forEach({ (documentChange) in
                    switch documentChange.type{
                    case .added,.modified:
                        guard let uid=Auth.auth().currentUser?.uid else {return}
                        let dic=documentChange.document.data()
                        let chatroom=ChatRoom(dic: dic)
                        
                        chatroom.documentId = documentChange.document.documentID
                        
                        let isContain = chatroom.members.contains(uid)
                        
                        if !isContain{
                            removeFunc(chatroom)
                            return
                        }
                        
                        chatroom.members.forEach { (memberuid) in
                            if memberuid != uid{
                                Firestore.firestore().collection("users").document(memberuid).getDocument { (userSnapshot, err) in
                                    if let err=err{
                                        print("ユーザー情報の取得に失敗しました",err)
                                        return
                                    }
                                    
                                    guard let dic=userSnapshot?.data() else {return}
                                    chatroom.partnerUser=User(dic: dic)
                                    
                                    guard let chatroomId=chatroom.documentId else {return}
                                    let messageId=chatroom.latestMessageId
                                    
                                    if messageId == ""{
                                        complition(chatroom)
                                        return
                                    }
                                    
                                    Firestore.firestore().collection("chatRooms").document(chatroomId).collection("messages").document(messageId).getDocument { (messageSnapshot, err) in
                                        if let err=err{
                                            print("失敗しました",err)
                                        }
                                        guard let dic=messageSnapshot?.data() else {return}
                                        let message=Message(dic: dic)
                                        chatroom.latestMessage=message
                                        complition(chatroom)
                                    }
                                }
                            }
                        }
                    case .removed:
                        print("削除されました。")
                    }
                    
                })
        }
    }
    static func AlertToFirestore(myuid:String,targetuid:String,text:String,complition:@escaping ()->Void){
        
        let doc=[
            "myuid":myuid,
            "targetuid":targetuid,
            "message":text
        ]
        Firestore.firestore().collection("Alert").addDocument(data: doc){ _ in
            complition()
        }
    }
    static func addUser(uid:String){
        
        Firestore.firestore().collection("users").getDocuments { (snapshot, err) in
            if let err=err{
                print("失敗",err)
                return
            }
            
            let addement=snapshot?.documents.map({ (snapshot) -> String in
                return snapshot.documentID
            })
            
            guard var addelement=addement else {return}
            addelement.removeAll(where: {$0 == uid})
            
            snapshot?.documents.forEach({ (snapshot) in
                if uid == snapshot.documentID{
                    
                    Firestore.firestore().collection("users").document(uid).updateData(["match":addelement])
                    
                }else{
                    Firestore.firestore().collection("users").document(snapshot.documentID).updateData(["match":FieldValue.arrayUnion([uid])])
                }
                
            })
        }
    }
}

extension Storage{
    //　画像のURLを作成syutoku
    static func userImageToFiewstorageReturnUrl(uid:String,image:UIImage,complition:@escaping (String)->Void){
        
        guard let uploadImage=image.jpegData(compressionQuality: 0.3) else {return}
        let fileName=NSUUID().uuidString
        let storageRef=Storage.storage().reference().child("profile_image").child(fileName)

        storageRef.putData(uploadImage, metadata: nil) { (metadata, err) in
            if let err=err{
                print("保存失敗",err)
            }
            storageRef.downloadURL { (url, err) in
                if let err=err{
                    print("firestorageからのダウンロードに失敗しました。",err)
                    return
                }
                guard let urlString=url?.absoluteString else {return}
                complition(urlString)
            }
        }
        
    }
    


}
