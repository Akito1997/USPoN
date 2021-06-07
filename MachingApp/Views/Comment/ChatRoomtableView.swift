//
//  ChatRoomtableView.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/18.
//

import UIKit

class ChatRoomtableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        allowsSelection=false
        separatorStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
