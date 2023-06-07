//
//  Tool.swift
//  UUCartoon
//
//  Created by kyuubee on 2020/7/14.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit

class Tool: NSObject {
    func getRegularData(regularExpress:String,content:String)->[String]{
        var array:[String] = []
        do{
            let reg = try NSRegularExpression.init(pattern: regularExpress, options: [.caseInsensitive,.dotMatchesLineSeparators])
            let matches = reg.matches(in: content, options: [], range: NSMakeRange(0, content.count))
            for match:NSTextCheckingResult in matches {
                let range = match.range
                let article:String = String(content[Range.init(range, in: content)!])
                array.append(article)
            }
        }catch let error{
            print(error)
        }
        return array;
    }
    
    // 弹窗
    static func makeAlertController(title:String,message:String,success:@escaping ()->()){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        let cancelBtn = UIAlertAction.init(title: "取消", style: .cancel)
        alert.addAction(cancelBtn)
        let sureBtn = UIAlertAction.init(title: "确定", style: .default){_ in
            success()
        }
        alert.addAction(sureBtn)
        Tool().currentViewController().present(alert, animated: true)
    }
    
    func isIpad()->Bool{
        if UIDevice.current.userInterfaceIdiom == .pad{
            return true
        }else{
            return false
        }
    }
    
    func isMac()->Bool{
        if #available(iOS 14.0, *) {
            if UIDevice.current.userInterfaceIdiom == .mac {
                return true
            }else{
                return false
            }
        } else {
            // Fallback on earlier versions
            return false
        }
    }
    
    func isPhone()->Bool{
        if UIDevice.current.userInterfaceIdiom == .phone {
            return true
        }else{
            return false
        }
    }
    
    static func asciiBytesToString(bytes: [UInt8]) -> String{
        var str: String = ""
        for num in bytes {
            str.append(Character(UnicodeScalar(num)))
        }
        return str
    }
    
    // 判断是否有http，并拼接地址
    static func checkUrl(urlStr: String, domainUrlStr: String) -> String {
        if urlStr.contains("http") || urlStr.contains("https") {
            return urlStr
        } else {
            return domainUrlStr + urlStr
        }
    }
    
    // 去除特殊字符
    static func cleanChater(string:String) -> String{
        var str = string
        str = str.replacingOccurrences(of: "\r", with: "")
        str = str.replacingOccurrences(of: "\n", with: "")
        str = str.replacingOccurrences(of: " ", with: "")
        return str
    }
}

