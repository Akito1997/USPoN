//
//  InfoCollectionViewcell.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/15.
//


import UIKit

class InfoCollectionViewcell:UICollectionViewCell{
    
    var user:User?{
        didSet{
            nameTextField.text=user?.name
        }
    }
    
    let nameLabel=ProfileLabel(title: "ニックネーム")
    let nameTextField=ProfileTextField(placeholder: "ニックネーム")
    
    let mygenderLabel=ProfileLabel(title: "自分の性別")
    let mygenderTextField=ProfileTextField(placeholder: "自分の性別")

    let targetgenderLabel=ProfileLabel(title: "相手の性別")
    let targetgenderTextField=ProfileTextField(placeholder: "相手の性別")
    
    let ageLabel=ProfileLabel(title: "年齢")
    let ageTextField=ProfileTextField(placeholder: "年齢")
        
    let hobbyLabel=ProfileLabel(title: "趣味")
    let hobbyTextField=ProfileTextField(placeholder: "趣味")
    
    let introductionLabel=ProfileLabel(title: "自己紹介")
    let introductionTextField=ProfileTextField(placeholder: "自己紹介")
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let taxtFields=[nameTextField,ageTextField,mygenderTextField,targetgenderTextField,hobbyTextField,introductionTextField]
        for (i,field) in taxtFields.enumerated(){
            field.tag=i
            field.delegate=self
        }
        
        let views=[[nameLabel,nameTextField],[ageLabel,ageTextField],[mygenderLabel,mygenderTextField],[targetgenderLabel,targetgenderTextField],[hobbyLabel,hobbyTextField],[introductionLabel,introductionTextField]]
        
        
        let stackView=views.map { (views)-> UIStackView in
            
            guard let label=views.first as? UILabel
                  ,let textField=views.last as? UITextField else {return UIStackView()}
            
            let stackView=UIStackView(arrangedSubviews: [label,textField])
            stackView.axis = .vertical
            stackView.spacing=5
            textField.anchor(height:50)
            return stackView
        }
        
        let baseStackView=UIStackView(arrangedSubviews: stackView)
        baseStackView.axis = .vertical
        baseStackView.spacing=15
        
        addSubview(baseStackView)
        nameTextField.anchor(width: UIScreen.main.bounds.width-40, height:50)
        baseStackView.anchor(top:topAnchor,bottom: bottomAnchor,left:leftAnchor,right: rightAnchor,toppadding: 10,leftpadding: 20, rightpadding: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension InfoCollectionViewcell:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ProfileViewController.editTextfieldTag=textField.tag
    }
}
