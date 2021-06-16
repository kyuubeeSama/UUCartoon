//
//  CartoonDetailModel.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/15.
//  Copyright © 2021 qykj. All rights reserved.
//

import Foundation

struct CartoonDetailModel {
    var title:String = ""
    var imgUrl:String = ""
    var author:String = ""
    var time:String = ""
    var category:String = ""
    var desc:String = ""
    var chapterArr:[(name:String,data:[ChapterModel])] = []
    var recommendArr:[CartoonModel] = []
}
