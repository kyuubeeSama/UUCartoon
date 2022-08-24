//
//  String+extengsion.swift
//  InsuranceDemo
//
//  Created by liuqingyuan on 2019/11/28.
//  Copyright © 2019 qykj. All rights reserved.
//

import Foundation
import UIKit
extension String {
    /// 判断字符串是否为空
    static func myStringIsNULL(string:String)->Bool{
        if (string == ""){
            return true
        }else if string.trimmingCharacters(in: .whitespaces).count == 0{
            return true
        }else if string == "(null)"||string == "<null>" || string == "null"{
            return true
        }else if string.isEmpty{
            return true
        }else{
            return false
        }
    }
    
    // 获取文字的大小
    func getStringSize(font:UIFont,size:CGSize) -> CGSize {
        let att = [NSAttributedString.Key.font:font]
        let text = self as NSString
        return text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: att, context: nil).size
    }
    
    private func isValidateByRegex(regex:String)->Bool{
        let pre:NSPredicate = NSPredicate.init(format: " SELF MATCHES %@", regex)
        return pre.evaluate(with: self)
    }

    func isMobilePhone()->Bool{
        let mobileNoRegex = "^1((3\\d|5[0-9]|8[0-9])\\d|7\\d[0-9]|9\\d[0-9])\\d{7}$"
        let phsRegex = "^0(10|2[0-57-9]|\\d{3})\\d{7,8}$"
        let ret:Bool = isValidateByRegex(regex: mobileNoRegex)
        let ret1:Bool = isValidateByRegex(regex: phsRegex)
        return (ret||ret1)
    }

//    汉字转拼音
    func chineseToPinyin()->String{
        let stringRef = NSMutableString(string: self) as CFMutableString
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false) // 转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false) // 去掉音标
        let pinyin = stringRef as String
        return pinyin
    }
}

