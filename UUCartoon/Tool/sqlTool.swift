//
//  sqlTool.swift
//  UUCartoon
//
//  Created by kyuubee on 2020/7/15.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit
import SQLite

class sqlTool {
    static let shared = sqlTool()
    private init() {}
    // 将初始化方法设为私有访问级别，禁止外部使用
    let website_id = Expression<Int>("website_id")
    let name = Expression<String>("name")
    let url = Expression<String>("url")
    let status = Expression<Int>("status")
    let cartoon_id = Expression<Int>("cartoon_id")
    let category_id = Expression<Int>("category_id")
    let collect_id = Expression<Int>("collect_id")
    let pic_id = Expression<Int>("pic_id")
    let width = Expression<Float>("width")
    let height = Expression<Float>("height")

    let website = Table("website")
    let cartoon = Table("cartoon")
    let category = Table("category")
    let collect = Table("collect")
    let picture = Table("picture")
    //    创建数据库
    func createDb(dbname:String) -> Bool {
        FileTool.init().createFile(document: dbname, fileData: Data.init())
    }
    // 创建表
    func createTable(sqlStr:String)->Bool {
        let path = FileTool.init().getDocumentPath().appending("/cartoon.db")
        do {
            let db = try Connection(path)
            try db.execute(sqlStr)
            return true
        }catch let error{
            print(error)
            return false
        }
    }
    // 插入数据
    func insertInto(table:String,column:String,values:String) -> Bool{
        let path = FileTool.init().getDocumentPath().appending("/cartoon.db")
        do {
            let db = try Connection(path)
            let sqlStr = "INSERT  INTO '"+table+"' ("+column+") values ("+values+")"
            try db.execute(sqlStr)
            return true
        }catch let error{
            print(error)
            return false
        }
    }
    // 查询站点列表
    func selectWebSite()->[WebsiteModel]{
        var array:[WebsiteModel] = []
        let path = FileTool.init().getDocumentPath().appending("/cartoon.db")
        do{
            let db = try Connection(path)
            for row in try db.prepare(website){
                let model = WebsiteModel.init()
                print("id: \(row[website_id]), name: \(row[name]), url: \(row[url])")
                model.website_id = row[website_id]
                model.name = row[name]
                model.url = row[url]
                model.status = row[status]
                array.append(model)
            }
        }catch let error{
            print(error)
        }
        return array
    }
    
    
    
    // 查询数据
    func findData(tableStr:String,dataID:Int) -> [WebsiteModel]{
        let path = FileTool.init().getDocumentPath().appending("/cartoon.db")
        do {
            let db = try Connection(path)
            let table = Table(tableStr)
            let query = table.filter(website_id == dataID).limit(1)
            let website = try db.pluck(query)
            print(website?[name] as Any)
        }catch let error{
            print(error)
        }
        return []
    }
}
