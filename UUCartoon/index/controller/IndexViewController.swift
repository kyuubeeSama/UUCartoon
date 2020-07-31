//
//  IndexViewController.swift
//  UUCartoon
//
//  Created by kyuubee on 2020/7/15.
//  Copyright © 2020 qykj. All rights reserved.
//  漫画站点页面
//  漫画站点页面主要展示当前收录哪些漫画站点，点击进入具体的漫画站点页面。在该页面需要完成数据库初始化。创建库，创建数据库需要的表

import UIKit
import SnapKit
class IndexViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var listArr:[WebsiteModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .yellow
        print(FileTool.init().getDocumentPath())
        

        self.createDB()
        listArr = sqlTool.shared.selectWebSite()
        mainTable.reloadData()
    }
    
    lazy var mainTable:UITableView = {
        let table = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH), style: .plain)
        self.view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        table.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        return table
    }()
    
    func createDB(){
        if sqlTool.shared.createDb(dbname: "/cartoon.db") {
            //            创建所有数据表
            // 创建站点表
            if sqlTool.shared.createTable(sqlStr: "CREATE TABLE IF NOT EXISTS `website` (`website_id` integer NOT NULL primary key autoincrement,`name` NVARCHAR(100) NOT NULL,`url` VARCHAR(100) NOT NULL,'status' INT default (1))"){
                // 插入起始数据.插入数据时需要判断当前数据是否存在
                _ = sqlTool.shared.insertInto(table: "website",
                                          columns: "'name','url'",
                                          values: "'风之动漫','https://www.fzdm.com/'",
                                          whereStr: "SELECT * FROM website WHERE name='风之动漫' and url = 'https://www.fzdm.com/'")
            }
//            创建漫画分类表
            _ = sqlTool.shared.createTable(sqlStr: "CREATE TABLE IF NOT EXISTS 'category' (`category_id` integer NOT NULL primary key autoincrement,`website_id` integer NOT NULL,`name` NVARCHAR(100) NOT NULL,`url` VARCHAR(255) NOT NULL,'status' INT default(1))")
//            创建收藏表
            _ = sqlTool.shared.createTable(sqlStr: "CREATE TABLE IF NOT EXISTS 'collect' (`collect_id` integer NOT NULL primary key autoincrement,'cartoon_id' integer NOT NULL)")
//            创建漫画表
            _ = sqlTool.shared.createTable(sqlStr: "CREATE TABLE IF NOT EXISTS 'cartoon' (`cartoon_id` integer NOT NULL primary key autoincrement,'website_id' integer NOT NULL,`category_id` integer NOT NULL,`name` NVARCHAR(255) NOT NULL,`url` VARCHAR(255) NOT NULL,`pic` VARCHAR(255) NOT NULL,`content` TEXT,`status` INT default(1))")
            // 创建图片表
            _ = sqlTool.shared.createTable(sqlStr: "CREATE TABLE IF NOT EXISTS 'picture' (`pic_id` integer NOT NULL primary key autoincrement,'cartoon_id' integer NOT NULL,`url` VARCHAR(255) NOT NULL,`status` INT default(1),`width` FLOAT,'height' FLOAT)")
//            创建章节表
            _ = sqlTool.shared.createTable(sqlStr: "CREATE TABLE IF NOT EXISTS 'chapter' ('chapter_id' integer NOT NULL primary key autoincrement,'cartoon_id' integer NOT NULL,'name' NVARCHAR(255) NOT NULL,'url' VARCHAR(255) NOT NULL,'status' INT default(1))")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = listArr[indexPath.row]
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = listArr[indexPath.row]
        if model.name == "风之动漫" {
            // 进入风之动漫界面
            print("风之动漫")
            let VC = FzdmViewController.init()
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
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
