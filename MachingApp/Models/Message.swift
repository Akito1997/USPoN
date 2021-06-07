//
//  Message.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/29.
//

import Foundation
import FirebaseFirestore

class Message{
    
    let name:String
    let message:String
    let uid:String
    let createdAt:Timestamp
    
    var partnerUser:User?
    var timeflag=false
    
    init(dic:[String:Any]) {
        self.name = dic["name"] as? String ?? ""
        self.message = dic["message"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
