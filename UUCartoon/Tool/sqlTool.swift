//
//  sqlTool.swift
//  UUCartoon
//
//  Created by kyuubee on 2020/7/15.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit
import SQLite

class sqlTool: NSObject {
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
            var sqlStr = "INSERT INTO '"+table+"' ("+column+") values ("+values+")"
            try db.execute(sqlStr)
            return true
        }catch let error{
            print(error)
            return false
        }
    }
}
