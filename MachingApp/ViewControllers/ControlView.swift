//
//  ControlView.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/17.
//

import UIKit
import Firebase
import  Nuke

class ControlView:UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTab()
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.barTintColor = .white
        tabBar.barStyle = .black
    }
    
    private func setupTab() {
        
        let a:CGFloat=110
        let b:CGFloat=3
        let firstViewController = HomeViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "四葉のクローバーのフリーアイコンのコピー"), selectedImage: UIImage(named: "四葉のクローバーのフリーアイコン")?.withRenderingMode(.alwaysTemplate))
        firstViewController.tabBarItem.imageInsets=UIEdgeInsets(top: a, left: a+b+10, bottom:a-10, right: a+b-10)
        
        let secondViewController = LikedViewController()
        secondViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "いいねの手のアイコンのコピー"), selectedImage: UIImage(named: "いいねの手のアイコン")?.withRenderingMode(.alwaysTemplate))
        secondViewController.tabBarItem.imageInsets=UIEdgeInsets(top: a, left: a+b, bottom: a-10, right: a+b)
        
        let thirdViewController=CommentViewController()
        
        thirdViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "吹き出しのアイコンのコピー"), selectedImage: UIImage(named: "吹き出しのアイコン")?.withRenderingMode(.alwaysTemplate))
        thirdViewController.tabBarItem.imageInsets=UIEdgeInsets(top: a+3, left: a, bottom: a-7, right: a)
        let nav=UINavigationController(rootViewController: thirdViewController)
        
        let forthViewController=ProfileViewController()
        forthViewController.tabBarItem=UITabBarItem(title: "", image: UIImage(named: "人物のアイコン素材"), selectedImage: UIImage(named: "人物のアイコン素材")?.withRenderingMode(.alwaysTemplate))
        forthViewController.tabBarItem.imageInsets=UIEdgeInsets(top: a+3, left: a+b-10, bottom: a-7, right: a+b+10)
        
        viewControllers = [firstViewController, secondViewController,nav,forthViewController]

        tabBar.tintColor = .rgb(red: 103, green: 190, blue: 141)
    }
}


