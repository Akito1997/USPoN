//
//  UIButton-Extension.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/11.
//

import UIKit

extension UIButton{
    
    func createCardInfoButton()->UIButton{
        let image = UIImage(named: "注意マークのフリーアイコン")
        setImage(image, for: .normal)
        tintColor = .white
        imageView?.contentMode = .scaleAspectFit
        return self
    }
    
    func createAboutButton()->UIButton{
        self.setTitle("こちら", for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 14)
        return self
    }
    
    func createProfileTopButton(title:String)->UIButton{
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 17)
        return self
    }
    
    func createProfileEditButton()->UIButton{
        let image=UIImage(systemName: "square.and.pencil")
        self.setImage(image, for: .normal)
        self.layer.cornerRadius=30
        self.tintColor = .darkGray
        self.imageView?.contentMode = .scaleAspectFill
        self.backgroundColor = .white
        return self
    }
    
    func createProfilecollectionviewButton(name:String)->UIButton{
        let image=UIImage(systemName: name)
        self.setImage(image, for: .normal)
        self.layer.cornerRadius=40
        self.tintColor = .darkGray
        self.imageView?.contentMode = .scaleAspectFit
        self.contentHorizontalAlignment = .fill
        self.contentVerticalAlignment = .fill
        self.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.tintColor = .black
        return self
    }

    func createDoneButton()->UIButton{
        self.setTitle("完了", for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 20)
        self.titleLabel?.textColor = .white
        self.backgroundColor = .rgb(red: 238, green: 238, blue: 238)
        self.isEnabled=false
        self.layer.cornerRadius=10
        return self
    }
    
    
    
}
