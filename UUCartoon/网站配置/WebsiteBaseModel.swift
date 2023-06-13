//
//  WebsiteBaseModel.swift
//  UUCartoon
//
//  Created by Galaxy on 2023/6/7.
//  Copyright © 2023 qykj. All rights reserved.
//

import UIKit

class WebsiteBaseModel: NSObject {
    // 站点网址
    public var webUrlStr = ""
    // 站点名字
    public var websiteName = ""
    // 站点标题
    public var websiteTitleArr:[String] = []
    // 站点对应的类型
    public var websiteIdArr:[Int] = []
    // 站点类型
    public var type:CartoonType = .ykmh
}

// 站点需要实现的方法
protocol WebsiteProtocol {
    //最新漫画列表
    func getLatestList(pageNum:Int)->[CartoonModel]
    // 漫画排行
    func getRankList(pageNum: Int, rankType: Int, timeType: Int, category: Int)->[CartoonModel]
    // 分类筛选数据
    func getCategoryList()->[[CategoryModel]]
    // 分类筛选结果
    func getCategorySiftList(detailUrl: String, pageNum: Int)->[CartoonModel]
    // 已完成漫画列表
    func getDoneList(pageNum:Int)->[CartoonModel]
    // 漫画章节
    func getDetailData(urlStr:String)->CartoonModel
    // 搜索推荐数据
    func getSearchRecommendList()->[CartoonModel]
    // 搜索
    func getSearchList(keyword:String,pageNum:Int)->[CartoonModel]
    // 漫画详情
    func getImageList(detailUrl:String)->[CartoonImgModel]
}
