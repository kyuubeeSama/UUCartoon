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
let statusbar_height = CGFloat((UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height)!)
let top_height = CGFloat(statusbar_height + 44)
let NavColor = "196EE5"
let ButtonBackColor = "CD3C3E"
let isIphoneX = UIScreen.main.bounds.size.height >= 812 ? true : false
let urlArr = [YouKuModel.init().webUrlStr,"",WuDiModel.init().webUrlStr]
enum downloadStatus: Int {
    case prepare = 0
    case fail = 1
    case success = 2
}
// 首页标题
var indexArr: [(title: String, list: [IndexModel])] {
    [
        (title: "漫画站", list: [
            IndexModel.init(title: YouKuModel.init().websiteName, type: 1, webType: .ykmh, webModel: YouKuModel.init()),
            IndexModel.init(title: WuDiModel.init().websiteName, type: 1, webType: .wudi, webModel: WuDiModel.init())
        ]),
        (title: "个人中心", list: [
            IndexModel.init(title: "我的收藏"),
            IndexModel.init(title: "历史记录")
        ])]
}
// 站点枚举
enum CartoonType: Int {
    case ykmh = 0
    case mao = 1
    case wudi = 2
}
