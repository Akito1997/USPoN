//
//  ProfileLabel.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/15.
//

import UIKit

class ProfileLabel:UILabel{
    
    init(){
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: 45,weight:.bold)
        self.textColor = .black
    }
    
    init(title:String){
        super.init(frame: .zero)
        
        self.text=title
        self.textColor = .darkGray
        self.font = .systemFont(ofSize: 14)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
