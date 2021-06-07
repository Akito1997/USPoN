//
//  User.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/13.
//

import Foundation
import Firebase

class User{
    
    var name:String
    var email:String
    var age:Int
    var mygender:String
    var targetgender:String
    var live:String
    var hobby:String
    var introduction:String
    var profile_imageurl:String
    var createdAt:Timestamp
    var myuid:String
    
    init(dic:[String:Any]) {
        self.name=dic["name"] as? String ?? ""
        self.email=dic["email"] as? String ?? ""
        self.age=dic["age"] as? Int ?? 0
        self.mygender=dic["mygender"] as? String ?? ""
        self.targetgender=dic["targetgender"] as? String ?? ""
        self.live=dic["live"] as? String ?? ""
        self.hobby=dic["hobby"] as? String ?? ""
        self.introduction=dic["introduction"] as? String ?? ""
        self.profile_imageurl=dic["profile_imageurl"] as? String ?? ""
        self.myuid=dic["myuid"] as? String ?? ""
        self.createdAt=dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
