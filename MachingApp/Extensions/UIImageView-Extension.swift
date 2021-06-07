//
//  UIImageView-Extension.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/18.
//

import UIKit

extension UIImageView{
    
    func createUserImageView()->UIImageView{
        image=UIImage(named: "no-image")
        contentMode = .scaleAspectFill
        layer.cornerRadius=40
        clipsToBounds=true
        return self
    }
    
    
    func createProfileImageView()->UIImageView{
        frame.size=CGSize(width: 355, height: 535)
        drawDashedLine(color: .lightGray, lineWidth: 7, lineSize: 10, spaceSize: 15, type: .All)
        clipsToBounds=true
        contentMode = .scaleAspectFill
        return self
    }
    
}
