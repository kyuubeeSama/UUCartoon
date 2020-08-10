//
//  UIColor+extension.swift
//  InsuranceDemo
//
//  Created by liuqingyuan on 2019/11/28.
//  Copyright © 2019 qykj. All rights reserved.
//

import Foundation
import UIKit
import FluentDarkModeKit

extension UIColor{
    // 设置rgb颜色和透明度
    class func colorWithHexString(hexString:String,alpha:CGFloat) -> UIColor {
       if hexString.isEmpty {
            return UIColor.clear
        }
        var cString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if cString.count == 0 {
            return UIColor.clear
        }
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if cString.count < 6 && cString.count != 6 {
            return UIColor.clear
        }
        let value = "0x\(cString)"
        let scanner = Scanner(string:value)
        var hexValue : UInt64 = 0
        //查找16进制是否存在
        if scanner.scanHexInt64(&hexValue) {
            let redValue = CGFloat((hexValue & 0xFF0000) >> 16)/255.0
              let greenValue = CGFloat((hexValue & 0xFF00) >> 8)/255.0
              let blueValue = CGFloat(hexValue & 0xFF)/255.0
              return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
        }else{
            return UIColor.clear
        }
    }

    // 设置颜色
    class func colorWithHexString(hexString:String) -> UIColor {
        if hexString.isEmpty {
            return UIColor.clear
        }
        var cString = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if cString.count == 0 {
            return UIColor.clear
        }
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if cString.count < 6 && cString.count != 6 {
            return UIColor.clear
        }
        let value = "0x\(cString)"
        let scanner = Scanner(string:value)
        var hexValue : UInt64 = 0
        //查找16进制是否存在
        if scanner.scanHexInt64(&hexValue) {
            let redValue = CGFloat((hexValue & 0xFF0000) >> 16)/255.0
            let greenValue = CGFloat((hexValue & 0xFF00) >> 8)/255.0
            let blueValue = CGFloat(hexValue & 0xFF)/255.0
            return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1)
        }else{
            return UIColor.clear
        }
    }
}
