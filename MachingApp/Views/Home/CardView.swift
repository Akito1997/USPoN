//
//  CardView.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/10.
//

import UIKit
import Firebase

class CardView:UIView{
    
    weak var delegate:HomeViewController!
    var user:User?
    
    private let gradientlayer=CAGradientLayer()
    //MARK:-UIVIew
    let cardImageView=CardImageView(frame: .zero)
    let alertButton=UIButton(type: .custom).createCardInfoButton()
    
    let nameLabel:UILabel=CardInfoLabel(labelText: "Taro", labelFont: .systemFont(ofSize: 40,weight: .heavy))
    let hobbyLabel=CardInfoLabel(labelText: "ランニング", labelFont: .systemFont(ofSize: 20,weight: .regular))
    let introductionLabel=CardInfoLabel(labelText: "走り回るのが大好きです", labelFont: .systemFont(ofSize: 20,weight: .regular))

    let goodLabel=CardInfoLabel(labelText: "HOPE", labelColor: UIColor.rgb(red: 137, green: 223, blue: 86))
    let nopeLabel:UILabel=CardInfoLabel(labelText: "NOPE", labelColor: UIColor.rgb(red: 222, green: 110, blue: 110))
    
    
    init(user:User) {
        super.init(frame: .zero)
        setUpLayout(user:user)
        self.user=user
        setuoGradientLayer()
        let panGesture=UIPanGestureRecognizer(target: self, action: #selector(panCardView))
        alertButton.addTarget(self, action: #selector(moveToalert), for: .touchUpInside)
        self.addGestureRecognizer(panGesture)
        
    }
    private func setuoGradientLayer(){
        gradientlayer.colors=[UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientlayer.locations=[0.3,1.1]
        cardImageView.layer.addSublayer(gradientlayer)
    }
    
    override func layoutSubviews() {
        gradientlayer.frame=self.bounds
    }
    @objc private func moveToalert(){
        guard let user = user else {return}
        guard let uid=Auth.auth().currentUser?.uid else {return}
        
        let alertView = UIAlertController.createAlert(myuid: uid,
                                                      targetuid: user.myuid,
                                                      name:user.name,complition: delegate.showThank)
    
        delegate?.AlertToView(view:alertView)
    }
    
    @objc private func panCardView(gestrue:UIPanGestureRecognizer){
        let translation=gestrue.translation(in: self)
      
        if gestrue.state == .changed{
    
            handlePanchange(translation: translation)
            
        }else if gestrue.state == .ended{
            handlePanEnded(translation:translation)
        }
    }
    private func handlePanchange(translation:CGPoint){
        
        let degree=translation.x/20
        let angle=degree*CGFloat.pi/100
        
        let rotateTranslation=CGAffineTransform(rotationAngle: angle)
        self.transform=rotateTranslation.translatedBy(x: translation.x, y: translation.y)
        
        let ratio:CGFloat=1/100
        let ratioVlaue=ratio*translation.x
        
        if translation.x>0{
            goodLabel.alpha=ratioVlaue
        }else if translation.x<0{
            nopeLabel.alpha = -ratioVlaue
        }
    }
    
    private func handlePanEnded(translation:CGPoint){
        
        if translation.x <= -120{
            self.removeCardViewAnimation(x: -600)
            self.delegate?.setLikeandNotLike(like: false)
        }else if translation.x >= 120{
            
            self.removeCardViewAnimation(x:600)
            self.delegate?.setLikeandNotLike(like: true)
            
        }else{
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
                self.transform = .identity
                self.layoutIfNeeded()
                self.goodLabel.alpha=0
                self.nopeLabel.alpha=0
            }
        }
    }
    
    private func setUpLayout(user:User){
        let infoVerticalStackView=UIStackView(arrangedSubviews: [hobbyLabel,introductionLabel])
        infoVerticalStackView.axis = .vertical
        
        let baseStackView=UIStackView(arrangedSubviews: [infoVerticalStackView,alertButton])
        baseStackView.axis = .horizontal
        
        //viewの配置を作成
        addSubview(cardImageView)
        addSubview(nameLabel)
        addSubview(baseStackView)
        addSubview(goodLabel)
        addSubview(nopeLabel)
        
        cardImageView.anchor(top:topAnchor,bottom:bottomAnchor,left:leftAnchor,right: rightAnchor,leftpadding: 10,rightpadding: 10)
        baseStackView.anchor(bottom:cardImageView.bottomAnchor,left: cardImageView.leftAnchor,right: cardImageView.rightAnchor,bottompadding: 20,leftpadding: 20,rightpadding: 20)
        alertButton.anchor(width:40,height: 60)
        nameLabel.anchor(bottom:baseStackView.topAnchor,left: cardImageView.leftAnchor,bottompadding: 10,leftpadding: 20)
        goodLabel.anchor(top:cardImageView.topAnchor,left: cardImageView.leftAnchor,width: 140,height: 55,toppadding: 25,leftpadding: 25)
        nopeLabel.anchor(top:cardImageView.topAnchor,right: cardImageView.rightAnchor,width: 140,height: 55,toppadding: 25,rightpadding:25)
        
        //ユーザー情報をviewに反映
        nameLabel.text=user.name
        hobbyLabel.text="趣味："+user.hobby
        introductionLabel.text=user.introduction

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
