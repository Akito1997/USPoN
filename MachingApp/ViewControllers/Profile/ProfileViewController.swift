//
//  ProfileViewController.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/14.
//
import UIKit
import Firebase
import Nuke
import FirebaseFirestore
import GoogleMobileAds
import FirebaseAuth

class ProfileViewController:UIViewController{
    
    var user:User?
    
    private let cellId="cellId"
    
    static var editTextfieldTag:Int?
    
    static var firstflag=false
    
    //MARK:UIViews
    let saveButton=UIButton(type: .system).createProfileTopButton(title: "保存")
    let logoutButoon=UIButton(type: .system).createProfileTopButton(title: "ログアウト")
    let profileImageView=ProfileImageView()
    
    let profileEditButton=UIButton(type: .system).createProfileEditButton()
    
    var bannerView:GADBannerView={
        let bannerView=GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID="ca-app-pub-9380908879322595/7125048451"
       
        return bannerView
    }()
    
    lazy var infoCollectionView:UICollectionView={
        let layout=UICollectionViewFlowLayout()
        layout.estimatedItemSize=UICollectionViewFlowLayout.automaticSize
        let cv=UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate=self
        cv.dataSource=self
        cv.register(InfoCollectionViewcell.self, forCellWithReuseIdentifier: cellId)
        cv.backgroundColor = .white
        return cv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.rootViewController=self
        bannerView.load(GADRequest())
        view.backgroundColor = .white
        setupLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let tag = ProfileViewController.editTextfieldTag else {return}
        if (!checkall()){
            tabClose()
        }
        if (tag==3 || tag==4 || tag==5){
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= (keyboardSize.height-80)
                }
            }
        }else if tag==2{
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 130
            }
        }
    }
    @objc func keyboardWillHide(notification:NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    
    static var backToimage=false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !ProfileViewController.backToimage{
            fetchUsers()
            ProfileViewController.backToimage=false
        }
        if !checkall(){
            tabClose()
        }
    }
    
    func fetchUsers(){
        guard var dic=UserDefaults.standard.dictionary(forKey: "User") else {return}
        guard let image_url=UserDefaults.standard.string(forKey: "profile_imageurl") else {return}
        dic["profile_imageurl"]=image_url
        self.user=User(dic: dic)
        guard let user=self.user else {return}
        settextFieldandimage(user: user)
    }
    
    private func settextFieldandimage(user:User){
        guard let stackViews=infoCollectionView.subviews[0].subviews[0].subviews as? [UIStackView] else {return}
        guard let image_url=URL(string: user.profile_imageurl) else {return}
        Nuke.loadImage(with: image_url, into: profileImageView)
        for view in stackViews{
            guard let label=view.arrangedSubviews[0] as? UILabel else {return}
            guard let labeltext=label.text else {return}
            guard let textField=view.arrangedSubviews[1] as? UITextField else {return}            
            if (labeltext=="ニックネーム"){
                textField.text=user.name
            }else if(labeltext=="年齢"){
                textField.text=String(user.age)
            }else if(labeltext=="自分の性別"){
                textField.text=user.mygender
            }else if(labeltext=="相手の性別"){
                textField.text=user.targetgender
            }else if(labeltext=="趣味"){
                textField.text=user.hobby
            }else if(labeltext=="自己紹介"){
                textField.text=user.introduction
            }
        }
    }

    private func setupLayout(){
        //viewの配置を作成
        profileImageView.backgroundColor = .black
        view.addSubview(saveButton)
        view.addSubview(logoutButoon)
        view.addSubview(profileImageView)
        view.addSubview(profileEditButton)
        view.addSubview(infoCollectionView)
        view.addSubview(bannerView)
        
        saveButton.anchor(top:view.topAnchor,left: view.leftAnchor,width: 60,height: 30,toppadding: 110,leftpadding: 15)
        logoutButoon.anchor(top:view.topAnchor,right: view.rightAnchor,toppadding: 110,rightpadding: 15)
        profileImageView.anchor(top:view.topAnchor,centerX: view.centerXAnchor,width: 180,height: 180,toppadding: 150)
        profileEditButton.anchor(top:profileImageView.topAnchor,right: profileImageView.rightAnchor,width: 60,height: 60)
        infoCollectionView.anchor(top:profileImageView.bottomAnchor,bottom: view.safeAreaLayoutGuide.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,toppadding: 20)
        bannerView.anchor(top:view.safeAreaLayoutGuide.topAnchor,centerX: view.centerXAnchor)
        //ボタンに機能を追加
        saveButton.addTarget(self, action:#selector(closeview(_:)), for: .touchUpInside)
        profileEditButton.addTarget(self, action: #selector(moveToCollectionView(_:)), for: .touchUpInside)
        logoutButoon.addTarget(self, action: #selector(logoutAlert(_:)), for: .touchUpInside)
    }
    
    @objc func logoutAlert(_ button:UIButton){
        let alert: UIAlertController = UIAlertController(title: "退出許可", message:  "ログアウトしてもよろしいですか？", preferredStyle:  UIAlertController.Style.alert)
        // 確定ボタンの処理
        let confirmAction: UIAlertAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default, handler:{
            // 確定ボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
            do{
                try? Auth.auth().signOut()
//                UserDefaults.standard.removeAll()
                self.tabBarController?.selectedIndex=0
            }
        })
        // キャンセルボタンの処理
        let cancelAction: UIAlertAction = UIAlertAction(title: "いいえ", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in
            //実際の処理
        })
        //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        //実際にAlertを表示する
        present(alert, animated: true, completion: nil)
    }
    
    @objc func moveToCollectionView(_ button:UIButton){
        tabClose()
        let vc=ProfileImageViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        vc.backImageView=self.profileImageView
        vc.imageView.image=profileImageView.image ?? UIImage()
        vc.imageView.contentMode = .scaleAspectFill
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func closeview(_ button:UIButton){
        if checkall(){
            tabOpen()
            setData()
        }
    }
    
    private func tabClose(){
        tabBarController?.tabBar.items?[0].isEnabled=false
        tabBarController?.tabBar.items?[1].isEnabled=false
        tabBarController?.tabBar.items?[2].isEnabled=false
    }
    
    private func tabOpen(){
        tabBarController?.tabBar.items?[0].isEnabled=true
        tabBarController?.tabBar.items?[1].isEnabled=true
        tabBarController?.tabBar.items?[2].isEnabled=true
    }
    
    private func checkall()->Bool{
        
        var flags=Array<Bool>(repeating: false, count: 7)
        guard let stackViews=infoCollectionView.subviews[0].subviews[0].subviews as? [UIStackView] else {return false}
        for (index,view) in stackViews.enumerated(){
            guard let label=view.arrangedSubviews[0] as? UILabel else {return false}
            guard label.text != nil else {return false}
            guard let textField=view.arrangedSubviews[1] as? UITextField else {return false}
            guard let text=textField.text else {return false}
            let note=UILabel()
            note.textColor = .red
            note.font = .systemFont(ofSize: 14)
            note.frame.size=label.frame.size
            if(index==2 || index==3){
                if(text=="男" || text=="女"){
                    flags[index]=true
                    if (view.subviews.count==3){
                        view.subviews[2].removeFromSuperview()
                    }
                }else{
                    if (view.subviews.count==2){
                        note.text="　※男か女を入力してください"
                        note.frame.origin.x=90
                        note.center.y=label.center.y
                        view.addSubview(note)
                        flags[index]=false
                    }
                }
            }else if(index==1){
                if let num=text.applyingTransform(.fullwidthToHalfwidth, reverse: false){
                    if let num=Int(num){
                        textField.text=String(num)
                        flags[index]=true
                        if (view.subviews.count==3){
                            view.subviews[2].removeFromSuperview()
                        }
                    }else{
                        
                        if (view.subviews.count==2){
                            note.text="　※数値を入力してください"
                            note.frame.origin.x=90
                            note.center.y=label.center.y
                            view.addSubview(note)
                            flags[index]=false
                        }
                    }
                }
            }else{
                if(text.count > 0 && text.count<=15){
                    
                    flags[index]=true
                    if (view.subviews.count==3){
                        view.subviews[2].removeFromSuperview()
                    }
                }else{
                    if (view.subviews.count==2){
                        note.text="　※15字以下で入力してください"
                        note.frame.origin.x=90
                        note.center.y=label.center.y
                        view.addSubview(note)
                        flags[index]=false
                    }
                }
            }
        }
        if profileImageView.image != UIImage(named: "no-image"){
            flags[6]=true
        }
        return flags.allSatisfy{$0==true}
    }
}

//データのセット
extension ProfileViewController{
    
    private func setData(){
        
        guard let stackViews=infoCollectionView.subviews[0].subviews[0].subviews as? [UIStackView] else {return}
        guard let uid=Auth.auth().currentUser?.uid else {return}
        guard let email=Auth.auth().currentUser?.email else {return}
        guard let image_url=UserDefaults.standard.string(forKey: "profile_imageurl") else {return}
        
        var dic=[
            "name":String(),
            "email":email,
            "age":Int(),
            "mygender":String(),
            "targetgender":String(),
            "profile_imageurl":[String](),
            "hobby":String(),
            "introduction":String(),
            "myuid":uid,
        ]  as [String : Any]
        dic["profile_imageurl"]=image_url
        
        if ProfileViewController.firstflag{
            dic["match"]=[String]()
            dic["liked"]=[String]()
        }
        
        for view in stackViews{
            guard let label=view.arrangedSubviews[0] as? UILabel else {return}
            guard let labeltext=label.text else {return}
            guard let textField=view.arrangedSubviews[1] as? UITextField else {return}
            guard let text=textField.text else {return}
            
            if (labeltext=="ニックネーム"){
                dic["name"]=text
            }else if(labeltext=="年齢"){
                dic["age"] = Int(text)
            }else if(labeltext=="自分の性別"){
                dic["mygender"] = text
            }else if(labeltext=="相手の性別"){
                dic["targetgender"] = text
            }else if(labeltext=="趣味"){
                dic["hobby"] = text
            }else if(labeltext=="自己紹介"){
                dic["introduction"] = text
            }
        }
        UserDefaults.standard.set(dic, forKey: "User")
        if ProfileViewController.firstflag{
            Firestore.setUserDateToFirestore(document: dic, uid:uid) { (sucess) in
                if sucess{
                    Firestore.addUser(uid: uid)
                    self.showSave()
                }
            }
            ProfileViewController.firstflag=false
        }else{
            Firestore.upDateUserToFirestore(document: dic, uid: uid) { (finish) in
                self.showSave()
            }
        }
    }
    
    func showSave(){
        
        let label_1=UILabel()
        label_1.text = "保存に成功しました"
        label_1.backgroundColor = .clear
        label_1.font = .boldSystemFont(ofSize: 23)
        label_1.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        label_1.textAlignment = .center
        
        let baseView=UIView()
        baseView.backgroundColor =  #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        baseView.addSubview(label_1)
        
        self.view.addSubview(baseView)
        baseView.alpha=0
        baseView.layer.cornerRadius = 15
        baseView.clipsToBounds=true

        UIView.animate(withDuration: 1) {
            baseView.alpha=1
        } completion: { (finish) in
            UIView.animate(withDuration: 1) {
                baseView.alpha=0
            }completion: { (f) in
                baseView.removeFromSuperview()
            }
        }
        label_1.anchor(centerY:baseView.centerYAnchor,centerX: baseView.centerXAnchor)
        baseView.anchor(centerY: view.centerYAnchor, centerX:view.centerXAnchor,width: 250,height: 70)
    }
}
extension ProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        if let cell = cell as? InfoCollectionViewcell{
            cell.user = self.user
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
}
