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
                // 创建站点表
                try db.execute(sql: """
                                    create table if not exists website(
                                    website_id integer primary key autoincrement,
                                    name varchar(200) not null unique,
                                    url varchar(200) not null,
                                    type integer not null,
                                    is_delete integer default(0)
                                    )
                                    """)
                // 创建漫画表
                try db.execute(sql: """
                                    create table if not exists cartoon(
                                    cartoon_id integer primary key autoincrement,
                                    website_type integer not null,
                                    name varchar(300) not null,
                                    detail_url varchar(300) not null unique,
                                    img_url varchar(300) not null,
                                    autor varchar(200),
                                    category varchar(200),
                                    create_time integer not null
                                    )
                                    """)
                // 创建章节表
                try db.execute(sql: """
                                    create table if not exists chapter(
                                    chapter_id integer primary key autoincrement,
                                    cartoon_id integer not null,
                                    name varchar(300) not null,
                                    detail_url varchar(300) not null unique,
                                    create_time integer not null
                                    )
                                    """)
                // 创建收藏表
                try db.execute(sql: """
                                    create table if not exists collect(
                                    collect_id integer primary key autoincrement,
                                    cartoon_id integer not null,
                                    create_time integer not null
                                    )
                                    """)
                // 创建历史记录表
                try db.execute(sql: """
                                    create table if not exists history(
                                    history_id integer primary key autoincrement,
                                    cartoon_id integer not null unique,
                                    chapter_id integer not null,
                                    page_index integer not null,
                                    create_time integer not null
                                    )
                                    """)
            })
        }
    }
    // 存入基础数据
    func insertDefaultData() {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            try dbQueue.write { db in
                try db.execute(sql: """
                                    replace into website ('name','url','type') values('优酷漫画','wap.ykmh.com',0)
                                    """)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    // 判断某个字段是否存在
    func findCoumExist(table: String, column: String) -> Bool {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            let row = try dbQueue.read({ db in
                try Row.fetchOne(db, sql: "select * from sqlite_master where name = '\(table)' and sql like '%\(column)%'")
            })
            if row != nil {
                return true
            }
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
    // 在表中添加某字段
    func addColum(table: String, column: String, type: Database.ColumnType, defalut: DatabaseValueConvertible) {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            try dbQueue.write({ db in
                try db.alter(table: table, body: { t in
                    t.add(column: column, type).defaults(to: defalut)
                })
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    // 添加收藏
    func saveCollect(model: CartoonModel) -> Bool {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            try dbQueue.write { db in
                //TODO: 替换relace为查找插入
                try db.execute(sql: """
                                        REPLACE INTO collect ('cartoon_id','create_time') VALUES(:cartoon_id,:create_time)
                                    """, arguments: [model.cartoon_id, Date.getCurrentTimeInterval()])
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    //TODO: 存入漫画数据
    func insertCartoon(model: CartoonModel) -> Int {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            try dbQueue.write { db in
                // TODO: 替换replace
                try db.execute(sql: """
                                    replace into cartoon ('website_type','name','detail_url','img_url','autor','category','create_time') values(:website_type,:name,:detail_url,:img_url,:autor,:category,:category_time)
                                    """, arguments: [model.type.rawValue, model.name, model.detailUrl, model.imgUrl, model.author, model.category, Date.getCurrentTimeInterval()])
            }
            let row = try dbQueue.read { db in
                try Row.fetchOne(db, sql: "select * from cartoon where detail_url = :detail_url", arguments: [model.detailUrl])
            }
            if (row != nil) {
                return row![Column("cartoon_id")]
            }else{
                return 0
            }
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    //TODO: 存入章节数据
    func insertChapter(model: ChapterModel) -> Int {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            try dbQueue.write { db in
                // TODO: 替换replace
                try db.execute(sql: """
                                    replace into chapter('cartoon_id','name','detail_url','create_time') values(:cartoon_id,:name,:detail_url,:create_time)
                                    """, arguments: [model.cartoonId,model.name,model.detailUrl,Date.getCurrentTimeInterval()])
            }
            let row = try dbQueue.read { db in
                try Row.fetchOne(db, sql: "select * from cartoon where detail_url = :detail_url", arguments: [model.detailUrl])
            }
            if (row != nil) {
                return row![Column("chapter_id")]
            }else{
                return 0
            }
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
    // 删除收藏
    func deleteCollect(model: CartoonModel) -> Bool {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            try dbQueue.write { db in
                try db.execute(sql: """
                                             delete from collect where cartoon_id = :cartoon_id
                                    """, arguments: [model.cartoon_id])
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
                try Row.fetchOne(db, sql: "select * from collect where cartoon_id = :cartoon_id", arguments: [model.cartoon_id])
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
        var listArr: [CartoonModel] = []
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            let rows = try dbQueue.read({ db in
                try Row.fetchAll(db, sql: "select cartoon.* from collect left join cartoon on cartoon.cartoon_id = collect.cartoon_id where 1=1 order by collect.create_time desc")
            })
            for item in rows {
                var model = CartoonModel.init()
                model.type = CartoonType.init(rawValue: item[Column("website_type")])!
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
                // TODO: 替换replace
                try db.execute(sql: """
                                        REPLACE INTO history ('cartoon_id','chapter_id',page_index,create_time) VALUES(:cartoon_id,:chapter_id,:page_index,:create_time)
                                    """, arguments: [model.cartoon_id, model.chapter_id,model.page_index, Date.getCurrentTimeInterval()])
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
    // 查找历史记录列表
    func getHistory() -> [CartoonModel] {
        var listArr: [CartoonModel] = []
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            let rows = try dbQueue.read({ db in
                try Row.fetchAll(db, sql: "select cartoon.*,history.chapter_id,history.page_index from history left join cartoon on cartoon.cartoon_id = history.cartoon_id where 1=1 order by history.create_time desc")
            })
            for items in rows {
                let model = CartoonModel.init()
                model.name = items[Column("name")]
                model.detailUrl = items[Column("detail_url")]
                model.imgUrl = items[Column("img_url")]
                model.type = CartoonType.init(rawValue: items[Column("website_type")])!
                model.chapter_id = items[Column("chapter_id")]
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
    func getHistory(detailUrl: String,is_page:Bool = false) -> Int {
        do {
            let dbQueue = try DatabaseQueue(path: databasePath)
            let row = try dbQueue.read({ db in
//                try Row.fetchAll(db, sql: "select * from history where detail_url = :detailUrl order by add_time desc", arguments: [detailUrl])
                try Row.fetchOne(db, sql: "select cartoon.*,history.chapter_id,history.page_index from history left join cartoon on cartoon.cartoon_id = history.cartoon_id where cartoon.detail_url=:detail_url",arguments: [detailUrl])
            })
            if row != nil {
                if is_page {
                    return row![Column("page_index")]
                }else{
                    return row![Column("chapter_id")]
                }
            }else{
                return 0
            }
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
}
