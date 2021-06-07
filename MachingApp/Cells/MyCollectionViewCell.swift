//
//  MyCollectionViewCell.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/19.
//

import UIKit
import Nuke

class MyCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var imageView:UIImageView!
    
    weak var delegate:funcdelegate?
    
    var user:User?{
        didSet{
            if let user=user{
                guard let url = URL(string: user.profile_imageurl)
                else {return}
                Nuke.loadImage(with: url , into: imageView)
                imageView.contentMode = .scaleAspectFill
            }
        }
    }
    
    let savebutton=UIButton(type: .system).createProfilecollectionviewButton(name: "plus")
    let deletebutton=UIButton(type: .system).createProfilecollectionviewButton(name: "multiply")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        frame.size=CGSize(width: 120, height: 170)
        drawDashedLine(color: .gray, lineWidth: 5, lineSize: 8, spaceSize: 9, type: .All)
        backgroundColor = UIColor.rgb(red: 238, green: 238, blue: 238)
        
        addSubview(savebutton)
        addSubview(deletebutton)
        savebutton.layer.cornerRadius=15
        deletebutton.layer.cornerRadius=15
        savebutton.imageEdgeInsets=UIEdgeInsets(top: 7, left: 8, bottom: 7, right: 8)
        deletebutton.imageEdgeInsets=UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        savebutton.anchor(bottom:bottomAnchor,right: rightAnchor,width: 30, height: 30, bottompadding: -6,rightpadding: -6)
        deletebutton.anchor(bottom:bottomAnchor,left: leftAnchor,width: 30, height: 30, bottompadding: -6,leftpadding: -6)
        
        deletebutton.addTarget(self, action: #selector(tappeddelete), for: .touchUpInside)
        savebutton.addTarget(self, action: #selector(tappedTalkuser), for: .touchUpInside)
        savebutton.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        deletebutton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        clipsToBounds=false
    }
    @objc func tappeddelete(){
        imageView.image=nil
        delegate?.dontLike(tag: tag)
    }
    @objc func tappedTalkuser(){
        imageView.image=nil
        delegate?.setTalkuser(tag: tag)
    }
    
    static func nib()->UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }
    deinit {
        print("Mycellが消えた")
    }
}
