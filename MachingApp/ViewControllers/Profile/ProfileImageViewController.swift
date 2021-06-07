//
//  ProfileImageViewController.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/19.
//

import UIKit
import Firebase
import Nuke

class ProfileImageViewController:UIViewController{
    
    weak var backImageView:UIImageView?
    
    let imageView=UIImageView().createProfileImageView()
    let button=BottomButton(type: .custom).createProfilecollectionviewButton(name: "plus")
    let DoneButton=BottomButton(type: .custom).createDoneButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
     }
    
    private func setupLayout(){
        
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(button)
        view.addSubview(DoneButton)
        button.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        imageView.anchor(centerY:view.centerYAnchor, centerX:view.centerXAnchor,width: 355,height: 535)
        button.anchor(bottom: imageView.bottomAnchor, right:imageView.rightAnchor,width: 80, height: 80, bottompadding: -13, rightpadding: -5)
        DoneButton.anchor(top:view.topAnchor,right:view.rightAnchor,width: 80, height: 40, toppadding: 80,rightpadding: 30)
        
        //functionの設定
        DoneButton.addTarget(self, action: #selector(backToView(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(setImage(_:)), for: .touchUpInside)
    }
    @objc func setImage(_ button:UIButton){
        
        let imagePikerController=UIImagePickerController()
        imagePikerController.delegate=self
        imagePikerController.modalPresentationStyle = .fullScreen
        imagePikerController.allowsEditing=true
        present(imagePikerController, animated: true, completion: nil)
    }
    
    @objc func backToView(_ button:UIButton){
        if backImageView?.image != imageView.image{
            guard let uid=Auth.auth().currentUser?.uid else {return}
            guard let image=imageView.image else {return}
            Storage.userImageToFiewstorageReturnUrl(uid: uid, image: image) { (url) in
                UserDefaults.standard.setValue(url, forKey: "profile_imageurl")
            }
        }
        backImageView?.image=imageView.image
        ProfileViewController.backToimage=true
        dismiss(animated: true)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if imageView.image != nil{
            DoneButton.isEnabled=true
            DoneButton.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        }
    }
}

extension ProfileImageViewController:UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let editImage=info[.editedImage] as? UIImage{
            imageView.image=editImage
        }else if let origiinalImage=info[.originalImage] as? UIImage{
            imageView.image=origiinalImage
        }
        
        imageView.contentMode = .scaleAspectFill
        dismiss(animated: true)
    }
}
