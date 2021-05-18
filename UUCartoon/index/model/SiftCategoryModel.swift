//
//  SiftCategoryModel.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/18.
//  Copyright © 2021 qykj. All rights reserved.
//  筛选的model类型

import UIKit

class SiftCategoryModel: NSObject {
    var name:String = ""
    var is_choose:Bool = false
    
    // 获取左侧表数据
    func getCategoryLeftArr() -> [[SiftCategoryModel]] {
        let leftArr = [["分类","时间"],["时间"]]
        var resultArr:[[SiftCategoryModel]]=[]
        for itemArr in leftArr {
            var array:[SiftCategoryModel] = []
            for (index,itemStr) in itemArr.enumerated() {
                let model = SiftCategoryModel.init()
                model.name = itemStr
                if index == 0 {
                    model.is_choose = true
                }
                array.append(model)
            }
            resultArr.append(array)
        }
        return resultArr
    }
    
    // 获取右侧表数据
    func getCategoryRightArr() -> [[[SiftCategoryModel]]] {
        let rightArr = [[["全部","魔法漫画","少年漫画","少女漫画","青年漫画","搞笑漫画","科幻漫画","热血漫画","冒险漫画","完结漫画"],["总","日","周","月"]],[["总","日","周","月"]]]
        var resultArr:[[[SiftCategoryModel]]]=[]
        for itemArr in rightArr {
            var array1:[[SiftCategoryModel]] = []
            for itemArr1 in itemArr {
                var array:[SiftCategoryModel] = []
                for (index,itemStr) in itemArr1.enumerated() {
                    let model = SiftCategoryModel.init()
                    model.name = itemStr
                    if index == 0 {
                        model.is_choose = true
                    }
                    array.append(model)
                }
                array1.append(array)
            }
            resultArr.append(array1)
        }
        return resultArr
    }
    
}
