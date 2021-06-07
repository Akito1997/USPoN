//
//  CardImageView.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/11.
//

import UIKit

class CardImageView:UIImageView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius=10
        clipsToBounds=true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
