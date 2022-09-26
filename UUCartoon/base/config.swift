//
//  config.swift
//  InsuranceDemo
//
//  Created by liuqingyuan on 2019/11/28.
//  Copyright © 2019 qykj. All rights reserved.
//

import Foundation
import UIKit

let screenW = UIScreen.main.bounds.size.width
let screenH = UIScreen.main.bounds.size.height
let statusbar_height = CGFloat((UIApplication.shared.connectedScenes.map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height)!)
let top_height = CGFloat(statusbar_height+44)
let NavColor = "196EE5"
let ButtonBackColor = "CD3C3E"
let isIphoneX = UIScreen.main.bounds.size.height >= 812 ? true : false
let urlArr = ["http://wap.ykmh.com/","https://www.maofly.com/"]

enum downloadStatus : Int {
    case prepare = 0
    case fail = 1
    case success = 2
}

