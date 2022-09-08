//
//  CartoonModel.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/7.
//  Copyright © 2021 qykj. All rights reserved.
//  漫画类

import Foundation

class CartoonModel {
    // id
    var cartoon_id = 0
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
    // 简介
    var desc:String = ""
    // 章节
    var chapterArr:[(name:String,data:[ChapterModel])] = []
    // 推荐漫画
    var recommendArr:[CartoonModel] = []
    // 阅读记录相关的
    // 阅读的章节所在分区
    var chapter_area:Int = 0
    // 第几章节
    var chapter_name:String = ""
     var chapter_id:Int = 0
    // 第几页
    var page_index:Int = 0
    //是否是收藏列表
    var is_collect:Bool = false
    // 是否是历史记录列表
    var is_history:Bool = false
}
