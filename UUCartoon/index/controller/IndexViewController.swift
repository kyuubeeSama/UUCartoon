//
//  IndexViewController.swift
//  UUCartoon
//
//  Created by kyuubee on 2020/7/15.
//  Copyright © 2020 qykj. All rights reserved.
//  漫画站点页面
//  漫画站点页面主要展示当前收录哪些漫画站点，点击进入具体的漫画站点页面。在该页面需要完成数据库初始化。创建库，创建数据库需要的表

import UIKit

class IndexViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .yellow
        print(FileTool.init().getDocumentPath())
        
//        QYRequestData.sharedInstance.getHtmlContent(urlStr: "https://www.fzdm.com/", params: nil, success: { (result) in
//            print(result)
//        }) { (error) in
//            print(error)
//        }
    self.createDB()
    }
    func createDB(){
        if sqlTool.init().createDb(dbname: "/cartoon.db") {
            //            创建所有数据表
           if sqlTool.init().createTable(sqlStr: "CREATE TABLE IF NOT EXISTS `website` (`website_id` integer NOT NULL primary key autoincrement,`name` VARCHAR(255) NOT NULL,`url` VARCHAR(255) NOT NULL,'status' INT default (1))"){
               // 插入起始数据
               sqlTool.init().insertInto(table: "website", column: "'name','url'", values: "'风之动漫','https://www.fzdm.com/'")
           }
            sqlTool.init().createTable(sqlStr: "CREATE TABLE IF NOT EXISTS 'category' (`category_id` integer NOT NULL primary key autoincrement,`cartoon_id` integer NOT NULL,`name` VARCHAR(255) NOT NULL,`url` VARCHAR(255) NOT NULL,'status' INT default(1))")
            sqlTool.init().createTable(sqlStr: "CREATE TABLE IF NOT EXISTS 'collect' (`collect_id` integer NOT NULL primary key autoincrement,'cartoon_id' integer NOT NULL)")
            sqlTool.init().createTable(sqlStr: "CREATE TABLE IF NOT EXISTS 'cartoon' (`cartoon_id` integer NOT NULL primary key autoincrement,'website_id' integer NOT NULL,`category_id` integer NOT NULL,`name` VARCHAR(255) NOT NULL,`url`  VARCHAR(255) NOT NULL,'status' INT default(1))")
            sqlTool.init().createTable(sqlStr: "CREATE TABLE IF NOT EXISTS 'picture' (`pic_id` integer NOT NULL primary key autoincrement,'cartoon_id' integer NOT NULL,`url` VARCHAR(255) NOT NULL,`status` INT default(1),`width` FLOAT,'height' FLOAT)")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
