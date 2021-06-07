//
//  CommentTableVIew.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/17.
//

import UIKit

class CommentTableView:UITableView{
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        
        separatorEffect = .none
        tableFooterView=UIView()

        register(ChatListTableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
