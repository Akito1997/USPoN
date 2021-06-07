//
//  UIView-Extension.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/04/10.
//

import UIKit

extension UIView{
    
    
    func anchor(top:NSLayoutYAxisAnchor?=nil,
                bottom:NSLayoutYAxisAnchor?=nil,
                left:NSLayoutXAxisAnchor?=nil,
                right:NSLayoutXAxisAnchor?=nil,
                centerY:NSLayoutYAxisAnchor?=nil,
                centerX:NSLayoutXAxisAnchor?=nil,
                width:CGFloat?=nil,
                height:CGFloat?=nil,
                toppadding:CGFloat=0,
                bottompadding:CGFloat=0,
                leftpadding:CGFloat=0,
                rightpadding:CGFloat=0)
    {
        self.translatesAutoresizingMaskIntoConstraints=false
        
        if let top=top{
            self.topAnchor.constraint(equalTo: top, constant: toppadding).isActive=true
        }
        if let bottom=bottom{
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottompadding).isActive=true
        }
        if let left=left{
            self.leftAnchor.constraint(equalTo: left, constant: leftpadding).isActive=true
        }
        if let right=right{
            self.rightAnchor.constraint(equalTo: right, constant: -rightpadding).isActive=true
        }
        if let centerY=centerY{
            self.centerYAnchor.constraint(equalTo: centerY,constant: toppadding).isActive=true
        }
        if let centerX=centerX{
            self.centerXAnchor.constraint(equalTo: centerX).isActive=true
        }
        if let width=width{
            self.widthAnchor.constraint(equalToConstant: width).isActive=true
        }
        if let height=height{
            self.heightAnchor.constraint(equalToConstant: height).isActive=true
        }
        
        
    }

}
extension UIView{
    
    func removeCardViewAnimation(x:CGFloat){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: []) {
            
            
            let degree:CGFloat = x/40
            let angle=degree*CGFloat.pi/180
            
            let rotateTranslation=CGAffineTransform(rotationAngle: angle)
            self.transform=rotateTranslation.translatedBy(x: x, y: 100)
            self.layoutIfNeeded()
        } completion: { (_) in
            self.removeFromSuperview()
        }

       
    }
}
enum DashedLineType {
    case All,Top,Down,Right,Left
}
extension UIView {
    // 点線・破線を描くメソッド
    func drawDashedLine(color: UIColor, lineWidth: CGFloat, lineSize: NSNumber, spaceSize: NSNumber, type: DashedLineType) {
        let dashedLineLayer: CAShapeLayer = CAShapeLayer()
        dashedLineLayer.frame = self.bounds
        dashedLineLayer.strokeColor = color.cgColor
        dashedLineLayer.lineWidth = lineWidth
        dashedLineLayer.lineDashPattern = [lineSize, spaceSize]
        let path: CGMutablePath = CGMutablePath()
 
        switch type {
 
        case .All:
            dashedLineLayer.fillColor = nil
            dashedLineLayer.path = UIBezierPath(rect: dashedLineLayer.frame).cgPath
        case .Top:
            path.move(to: CGPoint(x: 0.0, y: 0.0))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: 0.0))
            dashedLineLayer.path = path
        case .Down:
            path.move(to: CGPoint(x: 0.0, y: self.frame.size.height))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            dashedLineLayer.path = path
        case .Right:
            path.move(to: CGPoint(x: self.frame.size.width, y: 0.0))
            path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
            dashedLineLayer.path = path
        case .Left:
            path.move(to: CGPoint(x: 0.0, y: 0.0))
            path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
            dashedLineLayer.path = path
        }
        self.layer.addSublayer(dashedLineLayer)
    }
}
