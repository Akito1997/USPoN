//
//  TopControlView.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/02/21.
//

import UIKit
import RxCocoa
import RxSwift

class TopControlView: UIView{
    
    private let disposeBag=DisposeBag()
    
    let tinderButton=createTopButton(imageName: "宝石の無料アイコン", unselectedimageName: "猫のシルエットのコピー")
    let goodButton=createTopButton(imageName: "星アイコン", unselectedimageName: "星アイコンのコピー")
    let commentButton=createTopButton(imageName: "吹き出しのアイコン", unselectedimageName: "吹き出しのアイコンのコピー")
    let profileButton=createTopButton(imageName: "人物のアイコン素材のコピー", unselectedimageName: "人物のアイコン素材")

    static private func createTopButton(imageName:String,unselectedimageName:String) -> UIButton{
        
        let button=UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .selected)
        button.setImage(UIImage(named: unselectedimageName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupBindings()
        
    }
    
    private func setupLayout(){
        let baseStackView=UIStackView(arrangedSubviews: [tinderButton,goodButton,commentButton,profileButton])
        baseStackView.axis = .horizontal
        baseStackView.distribution = .fillEqually
        baseStackView.spacing=50
        baseStackView.translatesAutoresizingMaskIntoConstraints=false
        
        addSubview(baseStackView)
        
        baseStackView.anchor(top:topAnchor,bottom: bottomAnchor,left:leftAnchor, right: rightAnchor,leftpadding: 40,rightpadding: 40)
        
    }
    
    private func setupBindings(){
        
        tinderButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self=self else {return}
                self.handleSelectedButton(selectedButton: self.tinderButton)
            })
            .disposed(by: disposeBag)
        
        goodButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self=self else {return}
                self.handleSelectedButton(selectedButton: self.goodButton)
            })
            .disposed(by: disposeBag)
        
        
        
        commentButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self=self else {return}
                self.handleSelectedButton(selectedButton: self.commentButton)
            })
            .disposed(by: disposeBag)
        
        
        profileButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self=self else {return}
                self.handleSelectedButton(selectedButton: self.profileButton)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func handleSelectedButton(selectedButton:UIButton){
        let button=[tinderButton,goodButton,commentButton,profileButton]
        
        button.forEach { (button) in
            if button == selectedButton{
                button.isSelected=true
            }else{
                button.isSelected=false
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
