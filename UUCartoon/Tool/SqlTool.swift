//
//  SqlTool.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/4/29.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import GRDB

class SqlTool: NSObject {
    let databasePath = FileTool.init().getDocumentPath() + "/database.db"
    
    // 创建数据库
    func createTable() {
        let result = FileTool.init().createFile(document: "/.database.db", fileData: Data.init())
        if result {
            let dbQueue = try? DatabaseQueue(path: databasePath)
            try? dbQueue?.write({ (db) in
                //                创建浏览历史表
                try? db.execute(sql: """
                                         CREATE TABLE IF NOT EXISTS history(
                                         history_id integer PRIMARY KEY AUTOINCREMENT,
                                         name varchar(200) NOT NULL,
                                         detail_url varchar(200) NOT NULL UNIQUE,
                                         img_url varchar(300) NOT NULL,
                                         type integer NOT NULL,
                                         chapter_area integer DEFAULT(0),
                                         chapter_name varchar(200) NOT NULL,
                                         page_index integer DEFAULT(0),
                                         add_time integer NOT NULL,
                                         author varchar(200),
                                         category varchar(200)
                                         )
                                         """)
                //                创建收藏表
                try? db.execute(sql: """
                                         CREATE TABLE IF NOT EXISTS collect(
                                         collect_id integer PRIMARY KEY AUTOINCREMENT,
                                         name varchar(200) NOT NULL,
                                         img_url varchar(300) NOT NULL,
                                         detail_url varchar(200) NOT NULL UNIQUE,
                                         type integer NOT NULL,
                                         add_time integer NOT NULL,
                                         author varchar(200),
                                         category varchar(200)
                                         )
                                         """)
            })
        }
    }
    
    // 判断某个字段是否存在
    func findCoumExist(table:String,column:String) -> Bool{
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            let row = try dbQueue.read({ db in
                try Row.fetchOne(db, sql: "select * from sqlite_master where name = '\(table)' and sql like '%\(column)%'")
            })
            if row != nil {
                return true
            }
        }catch {
            print(error.localizedDescription)
        }
        return false
    }
    
    // 在表中添加某字段
    func addColum(table:String,column:String,type:Database.ColumnType,defalut:DatabaseValueConvertible){
        do{
            let dbQueue = try DatabaseQueue(path: databasePath)
            try dbQueue.write({ db in
                try db.alter(table: table, body: { t in
                    t.add(column: column, type).defaults(to: defalut)
                })
            })
        }catch {
            print(error.localizedDescription)
        }
    }
    
    // 添加收藏
    func saveCollect(model: CartoonModel) -> Bool {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            try dbQueue.write { db in
                try db.execute(sql: """
                                            REPLACE INTO collect ('name','detail_url','img_url',add_time,type,'author','category') VALUES(:name,:detail_url,:img_url,:add_time,:type,:author,:category)
                                        """, arguments: [model.name, model.detailUrl,  model.imgUrl, Date.getCurrentTimeInterval(), model.type.rawValue,model.author,model.category])
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    // 删除收藏
    func deleteCollect(model: CartoonModel) -> Bool {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            try dbQueue.write { db in
                try db.execute(sql: """
                                                 delete from collect where detail_url = :url
                                        """, arguments: [model.detailUrl])
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    // 是否收藏
    func isCollect(model: CartoonModel) -> Bool {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            let rows = try dbQueue.read({ db in
                try Row.fetchOne(db, sql: "select * from collect where detail_url = :url", arguments: [model.detailUrl])
            })
            if (rows != nil) {
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    // 获取收藏列表
    func getCollect() -> [CartoonModel] {
        var listArr:[CartoonModel] = []
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            let rows = try dbQueue.read({ db in
                try Row.fetchAll(db, sql: "select * from collect where 1=1 order by add_time desc")
            })
            for item in rows {
                var model = CartoonModel.init()
                model.type = CartoonType.init(rawValue: item[Column("type")])!
                model.name = item[Column("name")]
                model.detailUrl = item[Column("detail_url")]
                model.imgUrl = item[Column("img_url")]
                model.author = item[Column("author")]
                model.category = item[Column("category")]
                model.is_collect = true
                listArr.append(model)
            }
        } catch {
            print(error.localizedDescription)
        }
        return listArr
    }
    // 添加历史记录
    func saveHistory(model: CartoonModel) {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            try dbQueue.write { db in
                try db.execute(sql: """
                                            REPLACE INTO history ('name','detail_url','img_url',add_time,type,chapter_area,chapter_name,page_index,'author','category') VALUES(:name,:detail_url,:img_url,:add_time,:type,:chapter_area,:chapter_name,:page_index,:author,:category)
                                        """, arguments: [model.name, model.detailUrl, model.imgUrl,  Date.getCurrentTimeInterval(), model.type.rawValue, model.chapter_area, model.chapter_name,model.page_index,model.author,model.category])
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    // 删除历史记录
    func cleanHistory() -> Bool {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            try dbQueue.write { db in
                try db.execute(sql: "delete from history where 1=1")
            }
        } catch {
            print(error.localizedDescription)
        }
        return true
    }
    // 查找历史记录
    func getHistory() -> [CartoonModel] {
        var listArr:[CartoonModel] = []
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            let rows = try dbQueue.read({ db in
                try Row.fetchAll(db, sql: "select * from history where 1=1 order by add_time desc")
            })
            for items in rows {
                var model = CartoonModel.init()
                model.name = items[Column("name")]
                model.detailUrl = items[Column("detail_url")]
                model.imgUrl = items[Column("img_url")]
                model.type = CartoonType.init(rawValue:items[Column("type")])!
                model.chapter_area = items[Column("chapter_area")]
                model.chapter_name = items[Column("chapter_name")]
                model.page_index = items[Column("page_index")]
                model.author = items[Column("author")]
                model.category = items[Column("category")]
                model.is_history = true
                listArr.append(model)
            }
        } catch {
            print(error.localizedDescription)
        }
        return listArr
    }
    // 查找某个历史记录
    func getHistory(detailUrl:String)->CartoonModel{
        var model = CartoonModel.init()
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            let rows = try dbQueue.read({ db in
                try Row.fetchAll(db, sql: "select * from history where detail_url = :detailUrl order by add_time desc",arguments: [detailUrl])
            })
            for items in rows {
                model.name = items[Column("name")]
                model.chapter_area = items[Column("chapter_area")]
                model.chapter_name = items[Column("chapter_name")]
                model.page_index = items[Column("page_index")]
            }
        } catch {
            print(error.localizedDescription)
        }
        return model
    }
}
