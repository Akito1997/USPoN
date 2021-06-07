//
//  UIAlertController-Extension.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/05/12.
//

import UIKit
import FirebaseFirestore


extension UIAlertController{
    
    static func createAlert(myuid:String,targetuid:String,name:String,complition:@escaping ()->Void)->UIAlertController{
        
        let alert=UIAlertController(title: "報告する", message:"\(name)さんには、知らされません.\n\n報告する理由を教えてください。\n\n\n\n\n\n", preferredStyle: .alert)
        
        let textView=UITextView()
        textView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 15
        
        let label=UILabel()
        label.backgroundColor = .red
        
                

        let confirmAction: UIAlertAction = UIAlertAction(title: "送信", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            guard let text=textView.text else {return}
            Firestore.AlertToFirestore(myuid: myuid, targetuid: targetuid, text: text){
                complition()
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in

        })
        alert.view.addSubview(textView)
        //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

        textView.anchor(top:alert.view.topAnchor,bottom: alert.view.bottomAnchor,left:alert.view.leftAnchor,right: alert.view.rightAnchor,toppadding: 108,bottompadding: 46,leftpadding: 10,rightpadding: 10)
        
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 15
        
        return alert
    }
}
