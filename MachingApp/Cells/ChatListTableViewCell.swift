//
//  ChatListTableViewCell.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/18.
//

import UIKit
import Nuke

class ChatListTableViewCell:UITableViewCell{
    
    

    var chatroom: ChatRoom?{
        didSet{
            if let chatroom=chatroom{
                usernameLabel.text=chatroom.partnerUser?.name
                guard let url=URL(string: chatroom.partnerUser?.profile_imageurl ?? "") else {return}
                Nuke.loadImage(with: url, into: userImageView)
                if let message=chatroom.latestMessage {
                    latestMessageLabel.text=message.message
                    dateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue() )
                }else{
                    latestMessageLabel.text=""
                    dateLabel.text = ""
                }
            }
        }
    }
    
    let userImageView=UIImageView().createUserImageView()
    
    let usernameLabel:UILabel={
        let label=UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    let latestMessageLabel:UILabel={
        let label=UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return label
    }()
    
    let dateLabel:UILabel={
        let label=UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
       
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        backgroundColor = .white
        
        addSubview(userImageView)
        addSubview(usernameLabel)
        addSubview(latestMessageLabel)
        addSubview(dateLabel)
        userImageView.anchor(left:leftAnchor,centerY: centerYAnchor,width: 80, height: 80, leftpadding: 15)
        usernameLabel.anchor(top:topAnchor, left:userImageView.rightAnchor,width: 200, height: 30, toppadding: 15, leftpadding: 20)
        latestMessageLabel.anchor(top:usernameLabel.bottomAnchor,left: userImageView.rightAnchor,width:200,height: 20,toppadding: 20,leftpadding: 20)
        dateLabel.anchor(top:topAnchor,right: rightAnchor,width: 90,height: 30,toppadding: 15,rightpadding: 10)
        
    }
    
    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
}
