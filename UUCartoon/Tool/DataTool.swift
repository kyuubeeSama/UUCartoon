//
//  DataTool.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/4/29.
//  Copyright © 2021 qykj. All rights reserved.
//

import Foundation
import Ji

enum CartoonType: Int {
    case ykmh = 0
    case ssoonn = 1
}

enum XPathError: Error {
    case getContentFail
}

class DataTool: NSObject {
    /// 获取最新更新漫画列表
    /// - Parameters:
    ///   - type: 站点类型
    ///   - pageNum: 页码
    ///   - success: 漫画数组
    ///   - failure: 失败
    /// - Returns: 空
    func getNewCartoonData(type: CartoonType, pageNum: Int, success: @escaping (_ listArr: [CartoonModel]) -> (), failure: @escaping (_ error: Error) -> ()) {
        let urlArr = ["http://wap.ykmh.com", "http://ssoonn.com/"]
//        http://wap.ykmh.com/update/?page=3
        let urlStr = urlArr[type.rawValue] + "/update/?page=\(pageNum)"
        let jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil{
            failure(XPathError.getContentFail)
        }else{
            var resultArr:[CartoonModel] = []
//            标题
            var titleXPath = ""
//            详情
            var urlXPath = ""
            // 作者
            var authorXPath = ""
            // 类型
            var categoryXPath = ""
            // 时间
            var timeXPath = ""
            // 图片
            var imgXPath = ""
            // 最新
            var numXPath = ""
            if type == .ykmh {
                titleXPath = "//*[@id=\"update_list\"]/div/div/div[2]/a"
                urlXPath = "//*[@id=\"update_list\"]/div/div/div[2]/a/@href"
                authorXPath = "//*[@id=\"update_list\"]/div/div/div[2]/p[1]/a"
                categoryXPath = "//*[@id=\"update_list\"]/div/div/div[2]/p[2]/span[2]"
                timeXPath = "//*[@id=\"update_list\"]/div/div/div[2]/p[3]/span[2]"
                imgXPath = "//*[@id=\"update_list\"]/div/div/div[1]/a/img/@src"
                numXPath = "//*[@id=\"update_list\"]/div/div/a"
            }else if type == .ssoonn {

            }
            let titleNodeArr = jiDoc?.xPath(titleXPath)
            let urlNodeArr = jiDoc?.xPath(urlXPath)
            let authorNodeArr = jiDoc?.xPath(authorXPath)
            let categoryNodeArr = jiDoc?.xPath(categoryXPath)
            let timeNodeArr = jiDoc?.xPath(timeXPath)
            let numNodeArr = jiDoc?.xPath(numXPath)
            let imgNodeArr = jiDoc?.xPath(imgXPath)
            // 数据不为空
            if !(urlNodeArr?.isEmpty)!{
                for (index,urlNode) in urlNodeArr!.enumerated() {
                    var cartoonModel = CartoonModel.init()
                    cartoonModel.name = titleNodeArr![index].content!
                    cartoonModel.detailUrl = urlNode.content!
                    cartoonModel.author = authorNodeArr![index].content!
                    cartoonModel.category = categoryNodeArr![index].content!
                    cartoonModel.time = timeNodeArr![index].content!
                    cartoonModel.num = numNodeArr![index].content!
                    cartoonModel.imgUrl = imgNodeArr![index].content!
                    cartoonModel.type = type
                    resultArr.append(cartoonModel)
                }
            }
            success(resultArr)
        }
    }
}
