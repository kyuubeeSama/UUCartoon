//
//  Dictionary+extension.swift
//  InsuranceDemo
//
//  Created by liuqingyuan on 2019/12/12.
//  Copyright © 2019 qykj. All rights reserved.
//

import UIKit
import Foundation

extension Dictionary {
    // 向字典中加入新字典
    mutating func addKeyValue(dictionary:Dictionary) {
        for (key,value) in dictionary {
            self.updateValue(value, forKey: key)
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}
