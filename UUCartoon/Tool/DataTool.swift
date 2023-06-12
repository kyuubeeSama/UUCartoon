//
//  DataTool.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/4/29.
//  Copyright © 2021 qykj. All rights reserved.
//

import Foundation
import Ji
//import LZString

enum XPathError: Error {
    case getContentFail
}

class DataTool: NSObject {
    /// MARK: 获取最新更新漫画列表
    /// - Parameters:
    ///   - type: 站点类型
    ///   - pageNum: 页码
    ///   - success: 漫画抓取数组
    func getNewCartoonData(type: CartoonType, pageNum: Int, success: @escaping (_ listArr: [CartoonModel]) -> ()) {
        var array:[CartoonModel] = []
        switch type {
        case .ykmh:
            array=YouKuModel.init().getLatestList(pageNum: pageNum)
        case .wudi:
            array = WuDiModel.init().getLatestList(pageNum: pageNum)
        default:
            array = []
        }
        success(array)
    }
    
    /// MARK: 获取排行数据
    /// - Parameters:
    ///   - type: 站点类型
    ///   - pageNum: 当前页码
    ///   - rankType: 排序类型
    ///   - category: 排序筛选
    ///   - success: 漫画数组
    func getRankCartoonData(type: CartoonType, pageNum: Int, rankType: Int, timeType: Int = 0, category: Int = 0, success: @escaping (_ listArr: [CartoonModel]) -> ()) {
        var array:[CartoonModel] = []
        switch type {
        case .ykmh:
            array = YouKuModel.init().getRankList(pageNum: pageNum, rankType: rankType, timeType: timeType, category: category)
        case .wudi:
            array = WuDiModel.init().getRankList(pageNum: pageNum, rankType: rankType, timeType: timeType, category: category)
        default:
            array = []
        }
        success(array)
    }
    
    //MARK: 获取分类筛选信息
    /// - Parameters:
    ///   - type: 站点类型
    ///   - success: 返回筛选类型
    func getCategoryData(type: CartoonType, success: @escaping (_ listArr: [[CategoryModel]]) -> ()) {
        var array:[[CategoryModel]] = []
        switch type {
        case .ykmh:
            array = YouKuModel.init().getCategoryList()
        case .wudi:
            array = WuDiModel.init().getCategoryList()
        default:
            array = []
        }
        success(array)
    }
    
    //MARK: 获取类型筛选结果
    /// - Parameters:
    ///   - type: 网站类型
    ///   - detailUrl: 类型筛选拼接地址
    ///   - page: 页码
    ///   - success: 漫画列表
    func getCategorySiftResultListData(type: CartoonType, detailUrl: String, page: Int, success: @escaping (_ listArr: [CartoonModel]) -> ()) {
        var array:[CartoonModel] = []
        switch type {
        case .ykmh:
            array = YouKuModel.init().getCategorySiftList(detailUrl: detailUrl, pageNum: page)
        case .wudi:
            array = WuDiModel.init().getCategorySiftList(detailUrl: detailUrl, pageNum: page)
        default:
            array = []
        }
        success(array)
    }
    
    //MARK: 获取已完成漫画列表
    /// - Parameters:
    ///   - type: 网站类型
    ///   - page: 页码
    ///   - success: 漫画类表
    func getDoneCartoonData(type: CartoonType, page: Int, success: @escaping (_ listArr: [CartoonModel]) -> ()) {
        var array:[CartoonModel] = []
        switch type {
        case .ykmh:
            array = YouKuModel.init().getDoneList(pageNum: page)
        case .wudi:
            array = WuDiModel.init().getDoneList(pageNum: page)
        default:
            array = []
        }
        success(array)
    }
    
    //MARK: 获取漫画章节详情
    /// - Parameters:
    ///   - type: 网站类型
    ///   - detailUrl: 详情地址
    ///   - success: 详情model
    func getCartoonDetailData(type: CartoonType, detailUrl: String, success: @escaping (_ model: CartoonModel) -> ()) {
        var model = CartoonModel.init()
        switch type {
        case .ykmh:
            model = YouKuModel.init().getDetailData(urlStr: detailUrl)
        case .wudi:
            model = WuDiModel.init().getDetailData(urlStr: detailUrl)
        default:
            model = CartoonModel.init()
        }
        success(model)
    }
    
    //MARK: 获取搜索推荐数据
    /// - Parameters:
    ///   - type: 网站类型
    ///   - success: 推荐列表
    func getSearchRecommendData(type:CartoonType,success:@escaping (_ resultArr:[CartoonModel])->()){
        var array:[CartoonModel] = []
        switch type {
        case .ykmh:
            array = YouKuModel.init().getSearchRecommendList()
        default:
            array = []
        }
        success(array)
    }
    
    /// MARK: 搜索
    /// - Parameters:
    ///   - type: 网站类型
    ///   - keyword: 关键字
    ///   - page: 页码
    ///   - success: 搜索结果列表
    func getSearchResultData(type:CartoonType,keyword:String,page:Int,success:@escaping(_ resultArr:[CartoonModel])->()){
        var array:[CartoonModel] = []
        switch type {
        case .ykmh:
            array = YouKuModel.init().getSearchList(keyword: keyword, pageNum: page)
        default:
            array = []
        }
        success(array)
    }
    
    //MARK: 获取漫画详情
    /// - Parameters:
    ///   - type: 网站类型
    ///   - detailUrl: 漫画详情地址
    ///   - success: 图片列表
    func getCartoonDetailImgData(type:CartoonType,detailUrl:String,success: @escaping (_ imgArr:[CartoonImgModel]) -> ()){
        var array:[CartoonImgModel] = []
        switch type {
        case .ykmh:
            array = YouKuModel.init().getImageList(detailUrl: detailUrl)
        case .wudi:
            array = WuDiModel.init().getImageList(detailUrl: detailUrl)
        default:
            array = []
        }
        success(array)
    }
    
    func asciiBytesToString(bytes: [UInt8]) -> String{
        var str: String = ""
        for num in bytes {
            str.append(Character(UnicodeScalar(num)))
        }
        return str
    }
    
    // 判断是否有http，并拼接地址
    func checkUrl(urlStr: String, domainUrlStr: String) -> String {
        if urlStr.contains("http") || urlStr.contains("https") {
            return urlStr
        } else {
            return domainUrlStr + urlStr
        }
    }
    
    // 去除特殊字符
    func cleanChater(string:String) -> String{
        var str = string
        str = str.replacingOccurrences(of: "\r", with: "")
        str = str.replacingOccurrences(of: "\n", with: "")
        str = str.replacingOccurrences(of: " ", with: "")
        return str
    }
}

