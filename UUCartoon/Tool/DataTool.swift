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
//        http://wap.ykmh.com/update/?page=3
        var detailUrlStr = ""
        if type == .ykmh {
            detailUrlStr = "update/?page=\(pageNum)"
        } else {
            detailUrlStr = "/dfcomiclist_\(pageNum).htm"
        }
        let urlStr = urlArr[type.rawValue] + detailUrlStr
        var  jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if type == .ssoonn {
            var data = Data.init()
            do{
                data = try Data.init(contentsOf: URL.init(string: urlStr)!)
            }catch{
                failure(XPathError.getContentFail)
            }
            let contentStr = "<html><body>\(String.init(data: data, encoding: .utf8))))</body></html>"
            jiDoc = Ji.init(htmlString: contentStr.replacingOccurrences(of: "\\", with: ""))
        }
        if jiDoc == nil {
            failure(XPathError.getContentFail)
        } else {
            var resultArr: [CartoonModel] = []
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
            } else if type == .ssoonn {
                titleXPath = "/html/body/li/a[1]//div[1]/h3"
                urlXPath = "/html/body/li/a[1]/@href"
                authorXPath = "/html/body/li/a[1]/div/p[1]"
                categoryXPath = "/html/body/li/a[1]/div/p[2]"
                timeXPath = "/html/body/li/a[1]/div/p[4]/span"
                imgXPath = "/html/body/li/a[1]/img/@src"
                numXPath = "/html/body/li/a[2]/span[2]"
            }
            let titleNodeArr = jiDoc?.xPath(titleXPath)
            let urlNodeArr = jiDoc?.xPath(urlXPath)
            let authorNodeArr = jiDoc?.xPath(authorXPath)
            let categoryNodeArr = jiDoc?.xPath(categoryXPath)
            let timeNodeArr = jiDoc?.xPath(timeXPath)
            let numNodeArr = jiDoc?.xPath(numXPath)
            let imgNodeArr = jiDoc?.xPath(imgXPath)
            // 数据不为空
            if !(urlNodeArr?.isEmpty)! {
                for (index, urlNode) in urlNodeArr!.enumerated() {
                    var cartoonModel = CartoonModel.init()
                    cartoonModel.name = titleNodeArr![index].content!
                    let detailUrl = urlNode.content
                    print(detailUrl)
                    cartoonModel.detailUrl = urlNode.content!
                    cartoonModel.author = authorNodeArr![index].content!
                    cartoonModel.category = categoryNodeArr![index].content!
                    cartoonModel.time = timeNodeArr![index].content!
                    var num = numNodeArr![index].content!
                    if type == .ssoonn {
                        num.removeFirst()
                        num.removeLast()
                    }
                    cartoonModel.type = type
                    cartoonModel.num = num
                    cartoonModel.imgUrl = imgNodeArr![index].content!
                    resultArr.append(cartoonModel)
                }
            }
            success(resultArr)
        }
    }


    /// 获取排行数据
    /// - Parameters:
    ///   - type: 站点类型
    ///   - pageNum: 当前页码
    ///   - rankType: 排序类型
    ///   - category: 排序筛选
    ///   - success: 漫画数组
    ///   - failure: 失败
    /// - Returns: 空
    func getRankCartoonData(type: CartoonType, pageNum: Int, rankType: Int, timeType: Int = 0, category: Int = 0, success: @escaping (_ listArr: [CartoonModel]) -> (), failure: @escaping (_ error: Error) -> ()) {
        // 域名后面的地址
//        http://wap.ykmh.com/rank/shaonian_popularity-daily/
        var detailUrlStr = ""
        if type == .ykmh {
            let rankTypeArr = ["popularity", "click", "subscribe"]
            let timeTypeArr = ["", "-daily", "-weekly", "-monthly"]
            let categoryTypeArr = ["", "mofa_", "shaonian_", "shaonv_", "qingnian_", "gaoxiao_", "kehuan_", "rexue_", "maoxian_", "wanjie_"]
            detailUrlStr = "rank/" + categoryTypeArr[category] + rankTypeArr[rankType] + timeTypeArr[timeType] + "/"
        }else{
            let rankTypeArr = ["a-1.htm","b-1.htm","c-1.htm"]
            detailUrlStr = "/top/"+rankTypeArr[rankType]
        }
        let urlStr = urlArr[type.rawValue] + detailUrlStr
        print(urlStr)
        var jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if type == .ssoonn {
            var data = Data.init()
            do{
                data = try Data.init(contentsOf: URL.init(string: urlStr)!)
            }catch{
                failure(XPathError.getContentFail)
            }
            let contentStr = "<html><body>\(String.init(data: data, encoding: .utf8))))</body></html>"
            jiDoc = Ji.init(htmlString: contentStr.replacingOccurrences(of: "\\", with: ""))
        }
        if jiDoc == nil {
            failure(XPathError.getContentFail)
        } else {
            var resultArr: [CartoonModel] = []
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
            if type == .ykmh {
                titleXPath = "/html/body/div[3]/div/div[2]/div/div/div[2]/a"
                urlXPath = "/html/body/div[3]/div/div[2]/div/div/div[2]/a/@href"
                authorXPath = "//*[@id=\"topImgCon\"]/div/div/div[2]/p[1]/a"
                categoryXPath = "//*[@id=\"topImgCon\"]/div/div/div[2]/p[2]/span[2]"
                timeXPath = "//*[@id=\"topImgCon\"]/div/div/div[2]/p[3]/span[2]"
                imgXPath = "//*[@id=\"topImgCon\"]/div/div/div[1]/a/img/@src"
            } else if type == .ssoonn {
                titleXPath = "/html/body/li/a[1]//div[1]/h3"
                urlXPath = "/html/body/li/a[1]/@href"
                authorXPath = "/html/body/li/a[1]/div/p[1]"
                categoryXPath = "/html/body/li/a[1]/div/p[2]"
                timeXPath = "/html/body/li/a[1]/div/p[4]/span"
                imgXPath = "/html/body/li/a[1]/img/@src"
            }
            let titleNodeArr = jiDoc?.xPath(titleXPath)
            let urlNodeArr = jiDoc?.xPath(urlXPath)
            let authorNodeArr = jiDoc?.xPath(authorXPath)
            let categoryNodeArr = jiDoc?.xPath(categoryXPath)
            let timeNodeArr = jiDoc?.xPath(timeXPath)
            let imgNodeArr = jiDoc?.xPath(imgXPath)
            // 数据不为空
            if !(urlNodeArr?.isEmpty)! {
                for (index, urlNode) in urlNodeArr!.enumerated() {
                    var cartoonModel = CartoonModel.init()
                    cartoonModel.is_rank = true
                    cartoonModel.name = titleNodeArr![index].content!
                    cartoonModel.detailUrl = urlNode.content!
                    if type == .ykmh || (type == .ssoonn && rankType != 0){
                        cartoonModel.author = authorNodeArr![index].content!
                        cartoonModel.category = categoryNodeArr![index].content!
                        cartoonModel.time = timeNodeArr![index].content!
                    }
                    cartoonModel.imgUrl = imgNodeArr![index].content!
                    cartoonModel.type = type
                    resultArr.append(cartoonModel)
                }
            }
            success(resultArr)
        }
    }

    /// 获取分类筛选信息
    /// - Parameters:
    ///   - type: 站点类型
    ///   - success: 返回筛选类型
    ///   - failure: 失败
    /// - Returns: nil
    func getCategoryData(type: CartoonType, success: @escaping (_ listArr: [[CategoryModel]]) -> (), failure: @escaping (_ error: Error) -> ()) {
        var detailUrlStr = ""
        if type == .ykmh {
            detailUrlStr = "list/"
        }else{
            detailUrlStr = "comicsearch/"
        }
        let urlStr = urlArr[type.rawValue] + detailUrlStr
        let jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            failure(XPathError.getContentFail)
        } else {
            var resultArr: [[CategoryModel]] = []
            var titleXpathArr: [String] = []
            var valueXpathArr: [String] = []
            if type == .ykmh {
                for item in 1...4 {
                    let titleXpath = "//*[@id=\"w0\"]/div[2]/div[\(item)]/ul/li/a"
                    titleXpathArr.append(titleXpath)
                }
            }else{
                for item in 2...4 {
                    let titleXpath = "//*[@id=\"search_tags\"]/div[\(item)]/p/a/@title"
                    let valueXpath = "//*[@id=\"search_tags\"]/div[\(item)]/p/a/@href"
                    titleXpathArr.append(titleXpath)
                    valueXpathArr.append(valueXpath)
                }
            }
            for (index, item) in titleXpathArr.enumerated() {
                let titleNodeArr = jiDoc?.xPath(item)
                var valueNodeArr:[JiNode] = []
                if type == .ssoonn {
                    valueNodeArr = (jiDoc?.xPath(valueXpathArr[index]))!
                }
                var array: [CategoryModel] = []
                if !(titleNodeArr?.isEmpty)! {
                    for (i,node) in titleNodeArr!.enumerated() {
                        let categoryModel = CategoryModel.init()
                        categoryModel.name = node.content!
                        if type == .ykmh {
                            if categoryModel.name == "全部" {
                                categoryModel.ischoose = true
                            } else {
                                if index != 0 {
                                    categoryModel.value = "-" + categoryModel.name.chineseToPinyin()
                                } else {
                                    categoryModel.value = categoryModel.name.chineseToPinyin()
                                }
                            }
                        }else{
                            categoryModel.value = valueNodeArr[i].content!
                        }
                        array.append(categoryModel)
                    }
                }
                resultArr.append(array)
            }
            success(resultArr)
        }
    }

    /// 获取类型筛选结果
    /// - Parameters:
    ///   - type: 网站类型
    ///   - detailUrl: 类型筛选拼接地址
    ///   - page: 页码
    ///   - success: 漫画列表
    ///   - failure: error
    /// - Returns: nil
    func getCategorySiftResultListData(type: CartoonType, detailUrl: String, page: Int, success: @escaping (_ listArr: [CartoonModel]) -> (), failure: @escaping (_ error: Error) -> ()) {
        var detailUrlStr = ""
        if type == .ykmh {
//            http://wap.ykmh.com/list/aiqing-riben/?page=2
            detailUrlStr = "list/" + detailUrl + "/?page=\(page)"
        }else{
            detailUrlStr = "\(detailUrl)/\(page)"
        }
        var urlStr = urlArr[type.rawValue] + detailUrlStr
        urlStr = urlStr.replacingOccurrences(of: "//", with: "/")
        urlStr = urlStr.replacingOccurrences(of: " ", with: "")
        let jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            failure(XPathError.getContentFail)
        } else {
            var resultArr: [CartoonModel] = []
            //            标题
            var titleXPath = ""
            //            详情
            var urlXPath = ""
            // 作者
            var authorXPath = ""
            // 图片
            var imgXPath = ""
            if type == .ykmh {
                titleXPath = "//*[@id=\"comic-items\"]/li/a[2]"
                urlXPath = "//*[@id=\"comic-items\"]/li/a[2]/@href"
                authorXPath = "//*[@id=\"comic-items\"]/li/span/a"
                imgXPath = "//*[@id=\"comic-items\"]/li/a[1]/img/@src"
            } else if type == .ssoonn {
                titleXPath = "/html/body/div[3]/ul/li/a[1]/div/h3"
                urlXPath = "/html/body/div[3]/ul/li/a[1]/@href"
                authorXPath = "/html/body/div[3]/ul/li/a[1]/div/p[1]"
                imgXPath = "/html/body/div[3]/ul/li/a[1]/img/@src"
            }
            let titleNodeArr = jiDoc?.xPath(titleXPath)
            let urlNodeArr = jiDoc?.xPath(urlXPath)
            let authorNodeArr = jiDoc?.xPath(authorXPath)
            let imgNodeArr = jiDoc?.xPath(imgXPath)
            // 数据不为空
            if !(urlNodeArr?.isEmpty)! {
                for (index, urlNode) in urlNodeArr!.enumerated() {
                    var cartoonModel = CartoonModel.init()
                    cartoonModel.is_rank = true
                    cartoonModel.name = titleNodeArr![index].content!
                    cartoonModel.detailUrl = urlNode.content!
                    cartoonModel.author = authorNodeArr![index].content!
                    cartoonModel.num = "0"
                    cartoonModel.imgUrl = imgNodeArr![index].content!
                    cartoonModel.type = type
                    resultArr.append(cartoonModel)
                }
            }
            success(resultArr)
        }
    }


    /// 获取已完成漫画列表
    /// - Parameters:
    ///   - type: 网站类型
    ///   - page: 页码
    ///   - success: 漫画类表
    ///   - failure: error
    /// - Returns: nil
    func getDoneCartoonData(type: CartoonType, page: Int, success: @escaping (_ listArr: [CartoonModel]) -> (), failure: @escaping (_ error: Error) -> ()) {
        var detailUrlStr = ""
        if type == .ykmh {
            detailUrlStr = "list/wanjie/post/?page=\(page)"
        }else{
            detailUrlStr = "lianwan/\(page)/"
        }
        let urlStr = urlArr[type.rawValue] + detailUrlStr
        let jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            failure(XPathError.getContentFail)
        } else {
            var resultArr: [CartoonModel] = []
            //            标题
            var titleXPath = ""
            //            详情
            var urlXPath = ""
            // 作者
            var authorXPath = ""
            // 图片
            var imgXPath = ""
            if type == .ykmh {
                titleXPath = "//*[@id=\"comic-items\"]/li/a[2]"
                urlXPath = "//*[@id=\"comic-items\"]/li/a[2]/@href"
                authorXPath = "//*[@id=\"comic-items\"]/li/span/a"
                imgXPath = "//*[@id=\"comic-items\"]/li/a[1]/img/@src"
            } else if type == .ssoonn {
                titleXPath = "/html/body/div[3]/ul/li/a[1]/div/h3"
                urlXPath = "/html/body/div[3]/ul/li/a[1]/@href"
                authorXPath = "/html/body/div[3]/ul/li/a[1]/div/p[1]"
                imgXPath = "/html/body/div[3]/ul/li/a[1]/img/@src"
            }
            let titleNodeArr = jiDoc?.xPath(titleXPath)
            let urlNodeArr = jiDoc?.xPath(urlXPath)
            let authorNodeArr = jiDoc?.xPath(authorXPath)
            let imgNodeArr = jiDoc?.xPath(imgXPath)
            // 数据不为空
            if !(urlNodeArr?.isEmpty)! {
                for (index, urlNode) in urlNodeArr!.enumerated() {
                    var cartoonModel = CartoonModel.init()
                    cartoonModel.is_rank = true
                    cartoonModel.name = titleNodeArr![index].content!
                    cartoonModel.detailUrl = urlNode.content!
                    cartoonModel.author = authorNodeArr![index].content!
                    cartoonModel.num = "0"
                    cartoonModel.imgUrl = imgNodeArr![index].content!
                    cartoonModel.type = type
                    resultArr.append(cartoonModel)
                }
            }
            success(resultArr)
        }
    }
    
    /// 获取漫画章节详情
    /// - Parameters:
    ///   - type: 网站类型
    ///   - detailUrl: 详情地址
    ///   - success: 详情model
    ///   - failure: 失败
    /// - Returns: nil
    func getCartoonDetailData(type: CartoonType, detailUrl: String, success: @escaping (_ model: CartoonDetailModel) -> (), failure: @escaping (_ error: Error) -> ()) {
        let urlStr = detailUrl
        let jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            failure(XPathError.getContentFail)
        } else {
            var titleXpath = ""
            var imgXpath = ""
            var authorXpath = ""
            var timeXpath = ""
            var categoryXpath = ""
            var chapterNameXpath = ""
            var descXpath = ""
            var chapterTitleListXpath = ""
            var chapterUrlListXpath = ""
            var recommendTitleXpath = ""
            var recommendUrlXpath = ""
            var recommendImgXpath = ""
            var recommendAuthorXpath = ""
            if type == .ykmh {
                titleXpath = "//*[@id=\"comicName\"]"
                imgXpath = "//*[@id=\"Cover\"]/mip-img/@src"
                authorXpath = "//*[@id=\"header\"]/div/div[3]/div[2]/p[1]/a"
                timeXpath = "//*[@id=\"header\"]/div/div[3]/div[2]/p[4]/span[2]"
                categoryXpath = "//*[@id=\"header\"]/div/div[3]/div[2]/p[2]/a"
                chapterNameXpath = "//*[@id=\"list_block\"]/div/div[1]/div[1]/span[2]"
                descXpath = "//*[@id=\"showmore-des\"]"
                recommendTitleXpath = "//*[@id=\"w1\"]/li/a[2]"
                recommendUrlXpath = "//*[@id=\"w1\"]/li/a[2]/@href"
                recommendImgXpath = "//*[@id=\"w1\"]/li/a[1]/mip-img/@src"
                recommendAuthorXpath = "//*[@id=\"w1\"]/li/span/a"
            }else if type == .ssoonn{
                titleXpath = "/html/body/div[2]/div/div[1]/div/h3"
                imgXpath = "/html/body/div[2]/div/div[1]/img/@src"
                authorXpath = "/html/body/div[2]/div/div[1]/div/p[1]"
                timeXpath = "/html/body/div[2]/div/div[1]/div/p[5]"
                categoryXpath = "/html/body/div[2]/div/div[1]/div/p[2]/a"
                descXpath = "//*[@id=\"detail_block\"]/div/p"
            }
            let titleNodeArr = jiDoc?.xPath(titleXpath)
            let imgNodeArr = jiDoc?.xPath(imgXpath)
            let authorNodeArr = jiDoc?.xPath(authorXpath)
            let timeNodeArr = jiDoc?.xPath(timeXpath)
            let categoryNodeArr = jiDoc?.xPath(categoryXpath)
            let chapterNameNodeArr = jiDoc?.xPath(chapterNameXpath)
            let descNodeArr = jiDoc?.xPath(descXpath)
            let recommendTitleNodeArr = jiDoc?.xPath(recommendTitleXpath)
            let recommendUrlNodeArr = jiDoc?.xPath(recommendUrlXpath)
            let recommendImgNodeArr = jiDoc?.xPath(recommendImgXpath)
            let recommendAuthorNodeArr = jiDoc?.xPath(recommendAuthorXpath)
            var detailModel = CartoonDetailModel.init()
            // 剧集数据
            if !(chapterNameNodeArr!.isEmpty)  && type == .ykmh{
                for (index,item) in chapterNameNodeArr!.enumerated() {
                    chapterTitleListXpath = "/html/body/div[1]/div/div[4]/div[\(index+1)]/div[2]/div/mip-showmore/ul/li/a/span"
                    chapterUrlListXpath = "/html/body/div[1]/div/div[4]/div[\(index+1)]/div[2]/div/mip-showmore/ul/li/a/@href"
                    let chapterTitleListNodeArr = jiDoc?.xPath(chapterTitleListXpath)
                    let chapterUrlListNodeArr = jiDoc?.xPath(chapterUrlListXpath)
                    var chapterArr:[ChapterModel] = []
                    for (k,chapterItem) in chapterTitleListNodeArr!.enumerated() {
                        var chapterModel = ChapterModel.init()
                        chapterModel.name = chapterItem.content!
                        chapterModel.detailUrl = chapterUrlListNodeArr![k].content!
                        chapterArr.append(chapterModel)
                    }
                    let chapterData = (name:item.content!,data:chapterArr)
                    detailModel.chapterArr.append(chapterData)
                }
            }else{
                // 获取章节
                let chapterTitleListXpath = "//*[@id=\"sort_div_p\"]/a/@title"
                let chapterUrlListXpath = "//*[@id=\"sort_div_p\"]/a/@href"
                let chapterTitleListNodeArr = jiDoc?.xPath(chapterTitleListXpath)
                let chapterUrlListNodeArr = jiDoc?.xPath(chapterUrlListXpath)
                var chapterArr:[ChapterModel] = []
                for (k,chapterItem) in chapterTitleListNodeArr!.enumerated() {
                    var chapterModel = ChapterModel.init()
                    chapterModel.name = chapterItem.content!
                    chapterModel.detailUrl = chapterUrlListNodeArr![k].content!
                    chapterArr.append(chapterModel)
                }
                let chapterData = (name:"章节列表",data:chapterArr)
                detailModel.chapterArr.append(chapterData)
            }
            // 推荐漫画
            for (index,_) in recommendTitleNodeArr!.enumerated() {
                var cartoonModel = CartoonModel.init()
                cartoonModel.name = recommendTitleNodeArr![index].content!
                cartoonModel.author = recommendAuthorNodeArr![index].content!
                cartoonModel.imgUrl = recommendImgNodeArr![index].content!
                cartoonModel.detailUrl = self.checkUrl(urlStr: recommendUrlNodeArr![index].content!, domainUrlStr: urlArr[type.rawValue])
                cartoonModel.type = type
                detailModel.recommendArr.append(cartoonModel)
            }
            detailModel.title = titleNodeArr![0].content!
            detailModel.imgUrl = imgNodeArr![0].content!
            detailModel.author = authorNodeArr![0].content!
            detailModel.time = timeNodeArr![0].content!
            if !(categoryNodeArr!.isEmpty) {
                detailModel.category = categoryNodeArr![0].content!
            }
            detailModel.desc = descNodeArr![0].content!
            success(detailModel)
        }
    }
    
    /// 获取搜索推荐数据
    /// - Parameters:
    ///   - type: 网站类型
    ///   - success: 推荐列表
    ///   - failure: 失败
    /// - Returns: nil
    func getSearchRecommendData(type:CartoonType,success:@escaping (_ resultArr:[CartoonModel])->(),failure:@escaping (_ error:Error)->()){
        var detailUrlStr = ""
        if type == .ssoonn {
            detailUrlStr = "comicsearch/"
        }
        let urlStr = urlArr[type.rawValue] + detailUrlStr
        let jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            failure(XPathError.getContentFail)
        }else{
            var resultArr:[CartoonModel] = []
            var titleXpath = ""
            var urlXpath = ""
            if type == .ykmh {
                titleXpath = "//*[@id=\"w7\"]/li/a"
                urlXpath = "//*[@id=\"w7\"]/li/a/@href"
            }else if type == .ssoonn{
                titleXpath = "//*[@id=\"search_tags\"]/div[1]/p/a"
                urlXpath = "//*[@id=\"search_tags\"]/div[1]/p/a/@href"
            }
            let titleNodeArr = jiDoc?.xPath(titleXpath)
            let urlNodeArr = jiDoc?.xPath(urlXpath)
            if !(titleNodeArr?.isEmpty)! {
                for (index,item) in titleNodeArr!.enumerated() {
                    var model = CartoonModel.init()
                    model.name = item.content!
                    model.detailUrl = urlNodeArr![index].content!
                    model.type = type
                    resultArr.append(model)
                }
            }
            success(resultArr)
        }
    }
    
    func getSearchResultData(type:CartoonType,keyword:String,page:Int,success:@escaping(_ resultArr:[CartoonModel])->(),failure:@escaping(_ error:Error)->()){
        var detailUrlStr = ""
        if type == .ykmh {
//            http://wap.ykmh.com/search/?keywords=%E6%88%91&page=2
            detailUrlStr = "search/?keywords=\(keyword)&page=\(page)"
        }else{
//            http://ssoonn.com/comicsearch/s.aspx?s=%E6%B5%B7%E8%B4%BC%E7%8E%8B
            detailUrlStr = "comicsearch/s.aspx?s=\(keyword)"
        }
        var urlStr = urlArr[type.rawValue] + detailUrlStr
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        var  jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if type == .ssoonn {
            var data = Data.init()
            do{
                data = try Data.init(contentsOf: URL.init(string: urlStr)!)
            }catch{
                failure(XPathError.getContentFail)
            }
            let contentStr = "<html><body>\(String.init(data: data, encoding: .utf8))))</body></html>"
            jiDoc = Ji.init(htmlString: contentStr.replacingOccurrences(of: "\\", with: ""))
        }
        if jiDoc == nil {
            failure(XPathError.getContentFail)
        } else {
            var resultArr: [CartoonModel] = []
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
            } else if type == .ssoonn {
                titleXPath = "/html/body/div[2]/ul/li/a[1]/div/h3"
                urlXPath = "/html/body/div[2]/ul/li/a[1]/@href"
                authorXPath = "/html/body/div[2]/ul/li/a[1]/div/p[1]"
                categoryXPath = "/html/body/div[2]/ul/li/a[1]/div/p[2]"
                timeXPath = "/html/body/div[2]/ul/li/a[1]/div/p[4]/span"
                imgXPath = "/html/body/div[2]/ul/li/a[1]/img/@src"
                numXPath = "/html/body/div[2]/ul/li/a[2]/span[2]"
            }
            let titleNodeArr = jiDoc?.xPath(titleXPath)
            let urlNodeArr = jiDoc?.xPath(urlXPath)
            let authorNodeArr = jiDoc?.xPath(authorXPath)
            let categoryNodeArr = jiDoc?.xPath(categoryXPath)
            let timeNodeArr = jiDoc?.xPath(timeXPath)
            let numNodeArr = jiDoc?.xPath(numXPath)
            let imgNodeArr = jiDoc?.xPath(imgXPath)
            // 数据不为空
            if !(urlNodeArr?.isEmpty)! {
                for (index, urlNode) in urlNodeArr!.enumerated() {
                    var cartoonModel = CartoonModel.init()
                    cartoonModel.name = titleNodeArr![index].content!
                    let detailUrl = urlNode.content
                    print(detailUrl)
                    cartoonModel.detailUrl = urlNode.content!
                    cartoonModel.author = authorNodeArr![index].content!
                    cartoonModel.category = categoryNodeArr![index].content!
                    cartoonModel.time = timeNodeArr![index].content!
                    var num = numNodeArr![index].content!
                    if type == .ssoonn {
                        num.removeFirst()
                        num.removeLast()
                    }
                    cartoonModel.type = type
                    cartoonModel.num = num
                    cartoonModel.imgUrl = imgNodeArr![index].content!
                    resultArr.append(cartoonModel)
                }
            }
            success(resultArr)
        }
    }
    
    /// 获取漫画详情
    /// - Parameters:
    ///   - type: 网站类型
    ///   - detailUrl: 漫画详情地址
    ///   - success: 图片列表
    ///   - failure: 失败
    func getCartoonDetailImgData(type:CartoonType,detailUrl:String,success: @escaping (_ imgArr:[CartoonImgModel]) -> (), failure: @escaping (_ error: Error) -> ()){
        let jiDoc = Ji.init(htmlURL: URL.init(string: detailUrl.replacingOccurrences(of: "//", with: "/"))!)
        if jiDoc == nil {
            failure(XPathError.getContentFail)
        }else{
            if type == .ykmh {
                let jsXpath = "/html/body/script[1]/text()"
                let jsNodeArr = jiDoc?.xPath(jsXpath)
                let htmlContent = jsNodeArr![0].content
                var oneStr:String = String(htmlContent!.split(separator: ";")[0])
                oneStr = oneStr.replacingOccurrences(of: "]", with: "")
                oneStr = oneStr.replacingOccurrences(of: "var chapterImages = [", with: "")
                var array:[CartoonImgModel] = []
                for item in oneStr.split(separator: ",") {
                    var imgModel = CartoonImgModel.init()
                    imgModel.imgUrl = String(item.replacingOccurrences(of: "\"", with: ""))
                    imgModel.type = type
                    array.append(imgModel)
                }
                success(array)
            }else{
                let jsXpath = "/html/head/script[3]/text()"
                let jsNodeArr = jiDoc?.xPath(jsXpath)
                let htmlContent = jsNodeArr![0].content
                var oneStr:String = String(htmlContent!.split(separator: ";")[0])
                oneStr = oneStr.replacingOccurrences(of: "var sFiles=\"", with: "")
                oneStr = oneStr.replacingOccurrences(of: "\"", with: "")
                var string:NSString = oneStr as NSString
                let x = string.substring(from: string.length-1)
                let string1:NSString = "abcdefghijklmnopqrstuvwxyz"
                let xi = string1.range(of: x).location+1
                let sk:NSString = string.substring(with: NSRange(location: string.length-xi-12, length: 11)) as NSString
                string = string.substring(with: NSRange(location: 0, length: string.length-xi-12)) as NSString
                let k:NSString = sk.substring(with: NSRange(location: 0, length: sk.length-1)) as NSString
                let f = sk.substring(from: sk.length-1)
                for item in 0...k.length-1 {
                    string = string.replacingOccurrences(of:k.substring(with: NSRange(location: item, length: 1)) , with: "\(item)") as NSString
                }
                let ssStringArr = string.components(separatedBy: f)
                var ss:[UInt8] = []
                for item in ssStringArr{
                    ss.append(UInt8(item)!)
                }
                string = asciiBytesToString(bytes: ss) as NSString
                let imgArr = string.components(separatedBy: "|")
                var array:[CartoonImgModel] = []
                for item in imgArr {
                    var model = CartoonImgModel.init()
                    model.imgUrl = "http://19.125084.com/dm01/"+item
                    model.type = type
                    array.append(model)
                }
                success(array)
            }
        }
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
}

