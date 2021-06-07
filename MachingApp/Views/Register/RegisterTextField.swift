//
//  RegisterTextField.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/11.
//

import UIKit

class RegisterTextField:UITextField{
    
    init(placeHolder:String) {
        super.init(frame:.zero)
        
        attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 200, green: 200, blue: 200),NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])

        borderStyle = .roundedRect
        font = .systemFont(ofSize: 14)
        
        textColor = .black
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
