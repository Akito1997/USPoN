//
//  Userdefault-Extension.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/05/08.
//
import UIKit

extension UserDefaults {
    
    func removeAll() {
        dictionaryRepresentation().forEach { removeObject(forKey: $0.key) }
    }
    
}
