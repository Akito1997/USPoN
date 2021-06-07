//
//  UICollectionView-extension.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/05/08.
//
import UIKit

extension UICollectionView{
    func centerPosition(cell: UICollectionViewCell) -> CGPoint{
        let point = CGPoint(x: cell.center.x - self.contentOffset.x, y: cell.center.y - self.contentOffset.y)
        return point
    }
}
