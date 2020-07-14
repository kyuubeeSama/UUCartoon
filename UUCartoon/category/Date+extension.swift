//
//  NSDate+extension.swift
//  InsuranceDemo
//
//  Created by liuqingyuan on 2019/12/3.
//  Copyright © 2019 qykj. All rights reserved.
//

import UIKit
import Foundation

extension Date {
    static func timeIntervalChangeToTimeStr(timeInterval:Double, _ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String{
        if timeInterval > 0 {
            let date:Date = Date.init(timeIntervalSince1970: timeInterval)
            let formatter = DateFormatter.init()
            if dateFormat == nil {
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            }else{
                formatter.dateFormat = dateFormat
            }
            return formatter.string(from: date)
        }else{
            return ""
        }
    }
    
    static func getCurrentTimeInterval()->Int{
        //获取当前时间
        let now = Date()
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    
//    static func getNowTimeInterval(){
//        let newDate = Date.init()
////        NSDate *newDate = [NSDate date];
////        long int timeSp = (long)[newDate timeIntervalSince1970];
////        NSString *tempTime = [NSString stringWithFormat:@"%ld",timeSp];
////        return tempTime;
//    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
