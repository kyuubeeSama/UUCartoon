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
//let top_height = UIApplication.shared.statusBarFrame.size.height+44
let statusbar_height = CGFloat((UIApplication.shared.connectedScenes.map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height)!)
//let top_height = (UIApplication.shared.connectedScenes.map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height)!+44
let top_height = CGFloat(statusbar_height+44)
let NavColor = "196EE5"
let ButtonBackColor = "CD3C3E"
let BaseUrl = "http://wxyf.hzbx365.com/"
let FileUrl = "http://wxyf.hzbx365.com/files/"
let isIphoneX = UIScreen.main.bounds.size.height >= 812 ? true : false
