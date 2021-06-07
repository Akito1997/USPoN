//
//  LoginViewController.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/13.
//

import UIKit
import RxSwift
import FirebaseAuth
import PKHUD


class LoginViewController:UIViewController{
    
    private let disposeBag=DisposeBag()
    
    private let titleLabel=RegisterTitleLabel(text: "Login")
    private let emailTextField=RegisterTextField(placeHolder: "学生メール")
    private let passwordTextField=RegisterTextField(placeHolder: "パスワード")
    private let loginButton=RegisterButton(text: "ログイン")
    private let dontHaveAccount:UIStackView={
        let label=UILabel()
        let alreadyHaveAccountButton=UIButton(type: .system).createAboutButton()
        label.font = .systemFont(ofSize: 14)
        label.text="アカウントをお持ちでない方は"
        let view=UIStackView(arrangedSubviews: [label,alreadyHaveAccountButton])
        view.axis = .horizontal
        return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
        setupBindings()
    }
    private func setupLayout(){
        
        passwordTextField.isSecureTextEntry=true
        let backImage=UIImage(named: "biwako")
        
        let imageViewBackground=UIImageView(image: backImage)
        imageViewBackground.alpha=0.3
        imageViewBackground.contentMode = .scaleAspectFill
        
        loginButton.isEnabled=false
        loginButton.backgroundColor = .init(white:0.7,alpha:1)
        
        emailTextField.tag=0
        passwordTextField.tag=1
        
        emailTextField.delegate=self
        passwordTextField.delegate=self
                
        let baseStackView=UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton])
        baseStackView.axis = .vertical
        baseStackView.distribution = .fillEqually
        baseStackView.spacing=20
        view.addSubview(imageViewBackground)
        view.addSubview(baseStackView)
        view.addSubview(titleLabel)
        view.addSubview(dontHaveAccount)
        
        emailTextField.anchor(height:45)
        baseStackView.anchor(left:view.leftAnchor,right:view.rightAnchor,centerY: view.centerYAnchor,leftpadding: 40,rightpadding: 40)
        titleLabel.anchor(bottom:baseStackView.topAnchor,centerX: view.centerXAnchor,bottompadding: 80)
        dontHaveAccount.anchor(top:baseStackView.bottomAnchor,centerX: view.centerXAnchor,toppadding: 20)
        imageViewBackground.anchor(top:view.topAnchor,bottom: view.bottomAnchor,left:view.leftAnchor, right: view.rightAnchor,toppadding: 200,bottompadding: 200, leftpadding: 50, rightpadding: 50)
    }
    private func setupGradientLayer(){
        let layer=CAGradientLayer()
        let startColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor
        let endColor = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1).cgColor

        
        layer.colors=[startColor,endColor]
        layer.locations=[0.0,1,3]
        layer.frame=view.bounds
        view.layer.addSublayer(layer)
    }
    
    private func setupBindings(){
        guard let dontHaveAccountButoon=dontHaveAccount.subviews[1] as? UIButton else {return}
        
        dontHaveAccountButoon.rx.tap
            .asDriver()
            .drive{[weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by:disposeBag)
        
        loginButton.addTarget(self, action:#selector(loginwithFirebase), for: .touchUpInside)
    }
    
    @objc private func loginwithFirebase(){
        guard let email=emailTextField.text else {return}
        guard let password=passwordTextField.text else {return}
        HUD.show(.progress)
        Auth.loginwithFirebase(email: email, password: password) { [weak self](success) in
            if success{
                HUD.hide{(_) in
                    HUD.flash(.success,onView: self?.view,delay: 1){(_) in
                        HomeViewController.registerflag=true
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var flag_1=false
    var flag_2=false
    
}
extension LoginViewController:UITextFieldDelegate{
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text=textField.text else {return}
        
        switch textField.tag {
        case 0:
            if (text.contains("@ec.usp.ac.jp") || text.contains("@st.shiga-u.ac.jp")) {
                flag_1=true
            }else{
                flag_1=false
            }
        case 1:
            if text.count>0{
                flag_2=true
            }else{
                flag_2=false
            }
        default:
            break
        }
        if flag_1 && flag_2{
            loginButton.backgroundColor = .rgb(red: 227, green: 48, blue: 78)
            loginButton.isEnabled=true
        }else{
            loginButton.backgroundColor = .init(white:0.7,alpha:1)
            loginButton.isEnabled=false
        }
    }
}
