//
//  CardInfoLabel.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/11.
//

import UIKit

class CardInfoLabel:UILabel{
    //NOPEかHOPEのラベル
    init(labelText:String,labelColor:UIColor) {
        super.init(frame: .zero)
        
        font = .boldSystemFont(ofSize: 45)
        self.text=labelText
        layer.cornerRadius=10
        self.textColor = labelColor
        
        layer.borderWidth=3
        layer.borderColor=labelColor.cgColor
        //            UIColor.rgb(red: 222, green: 110, blue: 110).cgColor
        
        textAlignment = .center
        alpha=0
        
    }
    
    //その他の白のラベル
    init(labelText:String,labelFont:UIFont) {
        super.init(frame: .zero)
        font=labelFont
        textColor = .white
        text=labelText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
