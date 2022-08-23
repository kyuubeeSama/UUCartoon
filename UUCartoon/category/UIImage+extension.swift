//
//  UIImage+extension.swift
//  InsuranceDemo
//
//  Created by liuqingyuan on 2019/12/26.
//  Copyright © 2019 qykj. All rights reserved.
//

import UIKit

extension UIImage{
    
    func compressImage(maxLength:CGFloat)->Data{
        var compression:CGFloat = 1
        //        let data = UIImage.jpegData(compression)
        var data = self.jpegData(compressionQuality: compression)
        var max:CGFloat = 1
        var min:CGFloat = 0
        for _ in 0...5{
            compression = (max+min)/2
            data = self.jpegData(compressionQuality: compression)
            if CGFloat(data!.count) < maxLength*0.9 {
                min = compression
            }else if CGFloat(data!.count) > maxLength{
                max = compression
            }else{
                break
            }
        }
        
        if CGFloat(data!.count) < maxLength {
            return data!
        }
        
        var fineImage = UIImage.init(data: data!)
        var lastDataLength:Int = 0
        while  CGFloat(data!.count) > maxLength && Int(data!.count) != lastDataLength {
            lastDataLength = data!.count
            let ratio = maxLength/CGFloat(data!.count)
            let size = CGSize(width:Int((fineImage?.size.width)! * CGFloat(sqrtf(Float(ratio)))), height:Int((fineImage?.size.height)! * CGFloat(sqrtf(Float(ratio)))))
            UIGraphicsBeginImageContext(size)
            fineImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            data = self.jpegData(compressionQuality: compression)
        }
        return data!
    }
    
    class func createImage(color:UIColor,size:CGSize)->UIImage{
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
