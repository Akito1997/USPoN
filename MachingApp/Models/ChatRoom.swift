//
//  ChatRoom.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/29.
//

import Foundation
import FirebaseFirestore

class ChatRoom{
    
    let latestMessageId:String
    let members:[String]
    let createdAt:Timestamp
    
    var latestMessage:Message?
    
    var partnerUser:User?
    var documentId:String?
    
    init(dic:[String:Any]) {
        self.latestMessageId = dic["latestMessageId"] as? String ?? ""
        self.members = dic["members"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
