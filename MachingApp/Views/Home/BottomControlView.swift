//
//  BottomControlView.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/02/17.
//

import UIKit

class BottomControlView:UIView{
    
    let reloadView=BottomButtonView(frame: .zero, width: 60, imageName: "reload")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let baseStackView=UIStackView(arrangedSubviews: [reloadView])
        baseStackView.axis = .horizontal
        baseStackView.distribution = .fillEqually
        baseStackView.spacing=10
        baseStackView.translatesAutoresizingMaskIntoConstraints=false
        
        addSubview(baseStackView)
        
        [baseStackView.topAnchor.constraint(equalTo: topAnchor),
         baseStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
         baseStackView.leftAnchor.constraint(equalTo: leftAnchor,constant: 10),
         baseStackView.rightAnchor.constraint(equalTo: rightAnchor,constant: -10),
        ].forEach {$0.isActive=true}
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BottomButtonView:UIView{
    
    
    var button:BottomButton?
    
    weak var homedelegate:HomeViewController!
    
    init(frame: CGRect,width:CGFloat,imageName:String) {
        super.init(frame: frame)
        
        button=BottomButton(type: .custom)
        button?.translatesAutoresizingMaskIntoConstraints=false
    button?.setImage(UIImage(named: imageName)?.resize(size: .init(width: width*0.4, height: width*0.4)), for: .normal)
        button?.backgroundColor = .white
        button?.layer.cornerRadius=width/2
        
        button?.layer.shadowOffset = .init(width:1.5,height:2)
        button?.layer.shadowColor=UIColor.black.cgColor
        button?.layer.shadowOpacity=0.3
        button?.layer.shadowRadius=6
        
        addSubview(button!)
        button?.addTarget(self, action:#selector(tappedButton(_ :)), for: .touchUpInside)
        button?.anchor(centerY:centerYAnchor,centerX: centerXAnchor,width: width,height: width)
    }
    
    @objc func tappedButton(_ button:UIButton){
        homedelegate.FirebaseFromUser()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class BottomButton:UIButton{
    
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
                    self.transform = .init(scaleX: 0.8, y: 0.8)
                    self.layoutIfNeeded()
                }
            }else{
                self.transform = .identity
                self.layoutIfNeeded()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
