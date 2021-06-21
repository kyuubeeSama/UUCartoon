//
//  UIView+extension.swift
//  InsuranceDemo
//
//  Created by liuqingyuan on 2019/12/25.
//  Copyright © 2019 qykj. All rights reserved.
//

import UIKit

enum QYBorderPosition {
    case All
    case Top
    case Left
    case Right
    case Bottom
}

extension UIView{
    
    func addBorderLine(position:Array<QYBorderPosition>, borderColor:UIColor, borderWidth:CGFloat){
        
        for item in position{
            if item == .All {
                self.layer.borderWidth = borderWidth
                self.layer.borderColor = borderColor.cgColor
            }
            print(self.frame.size.width,self.frame.size.height)
            if item == .Left{
                self.layer.addSublayer(self.addLine(originPoint: CGPoint(x: 0, y: 0), toPoint: CGPoint(x: 0, y: self.frame.size.height), color: borderColor, borderWidth: borderWidth))
            }
            
            if item == .Right{
                self.layer.addSublayer(self.addLine(originPoint: CGPoint(x: self.frame.size.width, y: 0), toPoint: CGPoint(x: self.frame.size.width, y: self.frame.size.height), color: borderColor, borderWidth: borderWidth))
            }
            
            if item == .Top{
                self.layer.addSublayer(self.addLine(originPoint: CGPoint(x: 0, y: 0), toPoint: CGPoint(x: self.frame.size.width, y: 0), color: borderColor, borderWidth: borderWidth))
            }
            
            if item == .Bottom{
                self.layer.addSublayer(self.addLine(originPoint: CGPoint(x: 0, y: self.frame.size.height), toPoint: CGPoint(x: self.frame.size.width, y: self.frame.size.height), color: borderColor, borderWidth: borderWidth))
            }
        }
        
        
    }
    
    func addLine(originPoint:CGPoint,toPoint:CGPoint,color:UIColor,borderWidth:CGFloat)->CAShapeLayer{
        let bezierPath = UIBezierPath.init()
        bezierPath.move(to: originPoint)
        bezierPath.addLine(to: toPoint)
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.lineWidth = borderWidth
        return shapeLayer
    }
    
    // 切圆角
    func addRound(radio:Float,corners:UIRectCorner){
        let size = CGSize(width: CGFloat(radio), height: CGFloat(radio))
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: size)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
