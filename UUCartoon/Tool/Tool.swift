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
}
