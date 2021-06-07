//
//  ProfileImageView.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/14.
//

import UIKit

class ProfileImageView:UIImageView{
    init() {
        super.init(frame: .zero)
        
        self.image=UIImage(named: "no-image")
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius=90
        self.clipsToBounds=true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
