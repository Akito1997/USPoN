//
//  ChatRoomTableViewCell.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/18.
//

import UIKit
import Firebase
import Nuke

class ChatRoomTableViewCell:UITableViewCell{
    
    
    var message:Message?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var partnerMessagetextView: UITextView!
    @IBOutlet weak var myMessageTextView: UITextView!
    @IBOutlet weak var partnerDataLabel: UILabel!
    @IBOutlet weak var myDateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var messageTextViewWidthConstraints: NSLayoutConstraint!
    @IBOutlet weak var mymessageTextVuewwithConstraints: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        
        userImageView.layer.cornerRadius=25
        partnerMessagetextView.layer.cornerRadius=15
        myMessageTextView.layer.cornerRadius=15
        timeLabel.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkwhichUsermessage()
    }

    private func checkwhichUsermessage(){
        guard let uid=Auth.auth().currentUser?.uid else {return}
     
        if uid == message?.uid{
            partnerMessagetextView.isHidden=true
            partnerDataLabel.isHidden=true
            userImageView.isHidden=true
            
            myMessageTextView.isHidden=false
            myDateLabel.isHidden=false
            if let message=message{
                myMessageTextView.text=message.message
                let width=estimateFrameForTextView(text: message.message).width+20
                mymessageTextVuewwithConstraints.constant=width
                myDateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue(),dataStyle: .none,timeStyle: .short)
            }
        }else{
            partnerMessagetextView.isHidden=false
            partnerDataLabel.isHidden=false
            userImageView.isHidden=false
            
            myMessageTextView.isHidden=true
            myDateLabel.isHidden=true
            if let urlString = message?.partnerUser?.profile_imageurl,
               let url=URL(string: urlString){
                Nuke.loadImage(with: url, into: userImageView)
            }

            if let message=message{
                partnerMessagetextView.text=message.message
                let width=estimateFrameForTextView(text: message.message).width+20
                messageTextViewWidthConstraints.constant=width
                partnerDataLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue(),dataStyle: .none,timeStyle:  .short)
            }
        }
    }
    
    private func estimateFrameForTextView(text:String)->CGRect{
        let size=CGSize(width: 200, height: 1000)
        let options=NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
     func dateFormatterForDateLabel(date: Date,dataStyle: DateFormatter.Style,timeStyle:DateFormatter.Style) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dataStyle
        formatter.timeStyle = timeStyle
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
}
