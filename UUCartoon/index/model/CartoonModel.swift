//
//  CartoonModel.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/7.
//  Copyright © 2021 qykj. All rights reserved.
//  漫画类

import Foundation

struct CartoonModel {
    // 标题
    var name: String = ""
    // 详情
    var detailUrl: String = ""
    // 作者
    var author: String = ""
    // 类型
    var category: String = ""
    // 时间
    var time: String = ""
    // 图片
    var imgUrl: String = ""
    // 更新
    var num: String = ""
    // 类型
    var type:CartoonType = .ykmh
    // 是否是排序
    var is_rank:Bool = false
}
