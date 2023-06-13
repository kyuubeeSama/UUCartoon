//
// Created by Galaxy on 2023/6/12.
// Copyright (c) 2023 qykj. All rights reserved.
//
import Foundation
import Ji
class WuDiModel: WebsiteBaseModel,WebsiteProtocol {
    override init() {
        super.init()
        websiteName = "无敌漫画"
        webUrlStr = "https://m.55dmh.com/"
        websiteTitleArr = ["最新发布","漫画排行","分类筛选","已完结"]
        websiteIdArr = [0,1,2,3]
        type = .wudi
    }
    func getCategorySiftList(detailUrl: String, pageNum: Int) -> [CartoonModel] {
        var urlStr = webUrlStr + "list/" + detailUrl + "/?page=\(pageNum)"
        urlStr = urlStr.replacingOccurrences(of: "//", with: "/")
        urlStr = urlStr.replacingOccurrences(of: " ", with: "")
        let jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            return []
        } else {
            var resultArr: [CartoonModel] = []
            //            标题
            let titleXPath = "//*[@id=\"comic-items\"]/li/a[2]"
            //            详情
            let urlXPath = "//*[@id=\"comic-items\"]/li/a[2]/@href"
            // 作者
            let authorXPath = "//*[@id=\"comic-items\"]/li/span"
            // 图片
            let imgXPath = "//*[@id=\"comic-items\"]/li/a[1]/img/@src"
            let titleNodeArr = jiDoc?.xPath(titleXPath)
            let urlNodeArr = jiDoc?.xPath(urlXPath)
            let authorNodeArr = jiDoc?.xPath(authorXPath)
            let imgNodeArr = jiDoc?.xPath(imgXPath)
            // 数据不为空
            if !(urlNodeArr?.isEmpty)! {
                for (index, urlNode) in urlNodeArr!.enumerated() {
                    let cartoonModel = CartoonModel.init()
                    cartoonModel.is_rank = true
                    cartoonModel.name = titleNodeArr![index].content!
                    cartoonModel.detailUrl = urlNode.content!
                    cartoonModel.author = authorNodeArr![index].content!
                    cartoonModel.num = "0"
                    cartoonModel.imgUrl = imgNodeArr![index].content!
                    cartoonModel.type = .wudi
                    resultArr.append(cartoonModel)
                }
            }
            return resultArr
        }
    }

    func getImageList(detailUrl: String) -> [CartoonImgModel] {
        let jiDoc = Ji.init(htmlURL: URL.init(string: detailUrl.replacingOccurrences(of: "//", with: "/"))!)
        if jiDoc == nil {
            return []
        }else{
            return getDetailImageList(urlStr: detailUrl, page: 1, array: [])
        }
    }
    private func getDetailImageList(urlStr:String,page:Int,array:[CartoonImgModel])->[CartoonImgModel]{
        let detailUrl = urlStr.replacingOccurrences(of: ".html", with: "-\(page).html")
        let jiDoc = Ji.init(htmlURL: URL.init(string: detailUrl.replacingOccurrences(of: "//", with: "/"))!)
        if jiDoc == nil {
            return []
        }else{
            var imageArr:[CartoonImgModel] = array
            let imageXpath = "//*[@id=\"images\"]/div/img/@src"
            let imageNodeArr = jiDoc?.xPath(imageXpath)
            if imageNodeArr!.isEmpty {
                return imageArr
            }
            for item in imageNodeArr! {
                var imgModel = CartoonImgModel.init()
                imgModel.imgUrl = item.content!
                imgModel.type = .wudi
                imageArr.append(imgModel)
            }
            return getDetailImageList(urlStr: urlStr, page: page+1, array: imageArr)
        }
    }

    func getSearchList(keyword: String, pageNum: Int) -> [CartoonModel] {
        var urlStr = webUrlStr + "search/?keywords=\(keyword)&page=\(pageNum)"
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let  jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            return []
        } else {
            var resultArr: [CartoonModel] = []
            //            标题
            let titleXPath = "//*[@id=\"update_list\"]/div/div/div[2]/a"
            //            详情
            let urlXPath = "//*[@id=\"update_list\"]/div/div/div[2]/a/@href"
            // 作者
            let authorXPath = "//*[@id=\"update_list\"]/div/div/div[2]/p[1]/a"
            // 类型
            let categoryXPath = "//*[@id=\"update_list\"]/div/div/div[2]/p[2]/span[2]"
            // 时间
            let timeXPath = "//*[@id=\"update_list\"]/div/div/div[2]/p[3]/span[2]"
            // 图片
            let imgXPath = "//*[@id=\"update_list\"]/div/div/div[1]/a/img/@src"
            // 最新
            let numXPath = "//*[@id=\"update_list\"]/div/div/a"
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
                    let cartoonModel = CartoonModel.init()
                    cartoonModel.name = titleNodeArr![index].content!
                    cartoonModel.detailUrl = urlNode.content!
                    cartoonModel.author = authorNodeArr![index].content!
                    cartoonModel.type = .wudi
                    cartoonModel.category = categoryNodeArr![index].content!
                    cartoonModel.time = timeNodeArr![index].content!
                    let num = numNodeArr![index].content!
                    cartoonModel.num = num
                    cartoonModel.imgUrl = imgNodeArr![index].content!
                    resultArr.append(cartoonModel)
                }
            }
            return resultArr
        }
    }

    func getSearchRecommendList() -> [CartoonModel] {
        let urlStr = webUrlStr
        let jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            return []
        }else{
            var resultArr:[CartoonModel] = []
            let titleXpath = "//*[@id=\"w7\"]/li/a"
            let urlXpath = "//*[@id=\"w7\"]/li/a/@href"
            let titleNodeArr = jiDoc?.xPath(titleXpath)
            let urlNodeArr = jiDoc?.xPath(urlXpath)
            if !(titleNodeArr?.isEmpty)! {
                for (index,item) in titleNodeArr!.enumerated() {
                    let model = CartoonModel.init()
                    model.name = item.content!
                    model.detailUrl = urlNodeArr![index].content!
                    model.type = .wudi
                    resultArr.append(model)
                }
            }
            return resultArr
        }
    }

    func getDetailData(urlStr: String) -> CartoonModel {
        let jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            return CartoonModel.init()
        } else {
            let titleXpath = "//*[@id=\"comicName\"]"
            let imgXpath = "//*[@id=\"Cover\"]/img/@src"
            let authorXpath = "/html/body/div[1]/div/div[2]/div[2]/p[1]/a"
            let timeXpath = "/html/body/div[1]/div/div[2]/div[2]/p[4]/span[2]"
            let categoryXpath = "/html/body/div[1]/div/div[2]/div[2]/p[2]/a"
            let chapterNameXpath = "//*[@id=\"list_block\"]/div/div[1]/div[1]/span[2]"
            let descXpath = "//*[@id=\"full-des\"]"
            let recommendTitleXpath = "//*[@id=\"w0\"]/li/a[2]"
            let recommendUrlXpath = "//*[@id=\"w0\"]/li/a[2]/@href"
            let recommendImgXpath = "//*[@id=\"w0\"]/li/a[1]/img/@src"
            let recommendAuthorXpath = "//*[@id=\"w0\"]/li/span"
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
            let detailModel = CartoonModel.init()
            // 剧集数据
            if !(chapterNameNodeArr!.isEmpty){
                for (index,item) in chapterNameNodeArr!.enumerated() {
                    let chapterTitleListXpath = "/html/body/div[1]/div/div[4]/div[\(index+1)]/div[2]/div/ul/li/a/span"
                    let chapterUrlListXpath = "/html/body/div[1]/div/div[4]/div[\(index+1)]/div[2]/div/ul/li/a/@href"
                    let chapterTitleListNodeArr = jiDoc?.xPath(chapterTitleListXpath)
                    let chapterUrlListNodeArr = jiDoc?.xPath(chapterUrlListXpath)
                    var chapterArr:[ChapterModel] = []
                    for (k,chapterItem) in chapterTitleListNodeArr!.enumerated() {
                        let chapterModel = ChapterModel.init()
                        chapterModel.name = chapterItem.content!
                        chapterModel.detailUrl = chapterUrlListNodeArr![k].content!
                        chapterArr.append(chapterModel)
                    }
                    chapterArr = chapterArr.reversed()
                    let chapterData = (name:item.content!,data:chapterArr)
                    detailModel.chapterArr.append(chapterData)
                }
            }
            // 推荐漫画
            for (index,_) in recommendTitleNodeArr!.enumerated() {
                let cartoonModel = CartoonModel.init()
                cartoonModel.name = recommendTitleNodeArr![index].content!
                cartoonModel.author = recommendAuthorNodeArr![index].content!
                cartoonModel.imgUrl = recommendImgNodeArr![index].content!
                cartoonModel.detailUrl = Tool.checkUrl(urlStr: recommendUrlNodeArr![index].content!, domainUrlStr: webUrlStr)
                cartoonModel.type = .wudi
                detailModel.recommendArr.append(cartoonModel)
            }
            detailModel.name = titleNodeArr![0].content!
            detailModel.imgUrl = imgNodeArr![0].content!
            detailModel.author = authorNodeArr![0].content!
            detailModel.time = timeNodeArr![0].content!
            if !(categoryNodeArr!.isEmpty) {
                let category = categoryNodeArr![0].content!
                detailModel.category = Tool.cleanChater(string: category)
            }
            detailModel.desc = descNodeArr![0].content!
            return detailModel
        }
    }

    func getDoneList(pageNum: Int) -> [CartoonModel] {
        let urlStr = webUrlStr + "list/wanjie/post/?page=\(pageNum)"
        let jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            return []
        } else {
            var resultArr: [CartoonModel] = []
            //            标题
            let titleXPath = "//*[@id=\"comic-items\"]/li/a[2]"
            //            详情
            let urlXPath = "//*[@id=\"comic-items\"]/li/a[2]/@href"
            // 作者
            let authorXPath = "//*[@id=\"comic-items\"]/li/span"
            // 图片
            let imgXPath = "//*[@id=\"comic-items\"]/li/a[1]/img/@src"
            let titleNodeArr = jiDoc?.xPath(titleXPath)
            let urlNodeArr = jiDoc?.xPath(urlXPath)
            let authorNodeArr = jiDoc?.xPath(authorXPath)
            let imgNodeArr = jiDoc?.xPath(imgXPath)
            // 数据不为空
            if !(urlNodeArr?.isEmpty)! {
                for (index, urlNode) in urlNodeArr!.enumerated() {
                    let cartoonModel = CartoonModel.init()
                    cartoonModel.is_rank = true
                    cartoonModel.name = titleNodeArr![index].content!
                    cartoonModel.detailUrl = urlNode.content!
                    cartoonModel.author = authorNodeArr![index].content!
                    cartoonModel.num = "0"
                    cartoonModel.imgUrl = imgNodeArr![index].content!
                    cartoonModel.type = .wudi
                    resultArr.append(cartoonModel)
                }
            }
            return resultArr
        }
    }

    func getCategoryList() -> [[CategoryModel]] {
        let urlStr = webUrlStr + "list/"
        let jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            return []
        } else {
            var resultArr: [[CategoryModel]] = []
            var titleXpathArr: [String] = []
            for item in 1...4 {
                let titleXpath = "//*[@id=\"w0\"]/div[2]/div[\(item)]/ul/li/a"
                titleXpathArr.append(titleXpath)
            }
            for (index, item) in titleXpathArr.enumerated() {
                let titleNodeArr = jiDoc?.xPath(item)
                var array: [CategoryModel] = []
                if !(titleNodeArr?.isEmpty)! {
                    for node in titleNodeArr! {
                        let categoryModel = CategoryModel.init()
                        categoryModel.name = node.content!
                        if categoryModel.name == "全部" {
                            categoryModel.ischoose = true
                        } else {
                            if index != 0 {
                                categoryModel.value = "-" + categoryModel.name.chineseToPinyin()
                            } else {
                                categoryModel.value = categoryModel.name.chineseToPinyin()
                            }
                        }
                        array.append(categoryModel)
                    }
                }
                resultArr.append(array)
            }
            return resultArr
        }
    }

    func getRankList(pageNum: Int, rankType: Int, timeType: Int, category: Int) -> [CartoonModel] {
        // 域名后面的地址
        let urlStr = webUrlStr + "rank/"
        let jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            return []
        } else {
            var resultArr: [CartoonModel] = []
            //            标题
            let titleXPath = "//*[@id=\"topImgCon\"]/div/div/div[2]/a"
            //            详情
            let urlXPath = "//*[@id=\"topImgCon\"]/div/div/div[2]/a/@href"
            // 作者
            let authorXPath = "//*[@id=\"topImgCon\"]/div/div/div[2]/p[1]"
            // 类型
            let categoryXPath = "//*[@id=\"topImgCon\"]/div/div/div[2]/p[2]/span[2]"
            // 时间
            let timeXPath = "//*[@id=\"topImgCon\"]/div/div/div[2]/p[3]/span[2]"
            // 图片
            let imgXPath = "//*[@id=\"topImgCon\"]/div/div/div[1]/a/img/@src"
            let titleNodeArr = jiDoc?.xPath(titleXPath)
            let urlNodeArr = jiDoc?.xPath(urlXPath)
            let authorNodeArr = jiDoc?.xPath(authorXPath)
            let categoryNodeArr = jiDoc?.xPath(categoryXPath)
            let timeNodeArr = jiDoc?.xPath(timeXPath)
            let imgNodeArr = jiDoc?.xPath(imgXPath)
            // 数据不为空
            if !(urlNodeArr?.isEmpty)! {
                for (index, urlNode) in urlNodeArr!.enumerated() {
                    let cartoonModel = CartoonModel.init()
                    cartoonModel.is_rank = true
                    cartoonModel.name = titleNodeArr![index].content!
                    cartoonModel.detailUrl = urlNode.content!
                    cartoonModel.author = authorNodeArr![index].content!
                    cartoonModel.category = categoryNodeArr![index].content!
                    cartoonModel.time = timeNodeArr![index].content!
                    cartoonModel.imgUrl = imgNodeArr![index].content!
                    cartoonModel.type = .wudi
                    resultArr.append(cartoonModel)
                }
            }
            return resultArr
        }
    }

    func getLatestList(pageNum:Int) -> [CartoonModel] {
        let urlStr = webUrlStr + "update/?page=\(pageNum)"
        let  jiDoc = Ji.init(htmlURL: URL.init(string: urlStr)!)
        if jiDoc == nil {
            return []
        } else {
            var resultArr: [CartoonModel] = []
            //            标题
            let titleXPath = "//*[@id=\"update_list\"]/div/div/div[2]/a"
            //            详情
            let urlXPath = "//*[@id=\"update_list\"]/div/div/div[2]/a/@href"
            // 作者
            let authorXPath = "//*[@id=\"update_list\"]/div/div/div[2]/p[1]"
            // 类型
            let categoryXPath = "//*[@id=\"update_list\"]/div/div/div[2]/p[2]/span[2]"
            // 时间
            let timeXPath = "//*[@id=\"update_list\"]/div/div/div[2]/p[3]/span[2]"
            // 图片
            let imgXPath = "//*[@id=\"update_list\"]/div/div/div[1]/a/img/@src"
            // 最新
            let numXPath = "//*[@id=\"update_list\"]/div/div/a"
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
                    let cartoonModel = CartoonModel.init()
                    cartoonModel.name = titleNodeArr![index].content!
                    cartoonModel.detailUrl = urlNode.content!
                    cartoonModel.author = authorNodeArr![index].content!
                    if categoryNodeArr!.count > 0 {
                        cartoonModel.category = categoryNodeArr![index].content!
                    }
                    cartoonModel.time = timeNodeArr![index].content!
                    let num = numNodeArr![index].content!
                    cartoonModel.type = .wudi
                    cartoonModel.num = Tool.cleanChater(string: num)
                    cartoonModel.imgUrl = imgNodeArr![index].content!
                    resultArr.append(cartoonModel)
                }
            }
            return resultArr
        }
    }
}
