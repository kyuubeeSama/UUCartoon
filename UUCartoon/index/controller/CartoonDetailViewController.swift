//
//  CartoonDetailViewController.swift
//  UUCartoon
//
//  Created by liuqingyuan on 2020/7/30.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit

class CartoonDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var model:CartoonModel?
    
    var listArr:[ChapterModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getChapterData()
    }
    
    func getChapterData() {
        QYRequestData.shared.getHtmlContent(urlStr: "https://manhua.fzdm.com/"+(model?.url)!, params: nil) { (html) in
            print(html)
            // 获取列表
//            <li class="pure-u-1-2([\s\S]+?)\/li>
            let cartoonStrArr:[String] = Tool.init().getRegularData(regularExpress: "<li class=\"pure-u-1-2([\\s\\S]+?)\\/li>", content: html)
            for row in cartoonStrArr{
                // 获取标题
    //            title="([\s\S]+?)"
                var title:String = Tool.init().getRegularData(regularExpress: "title=\"([\\s\\S]+?)\"", content: row)[0]
                title = title.replacingOccurrences(of: "title=\"", with: "")
                title = title.replacingOccurrences(of: "\"", with: "")
                //            获取详情
                //            href="([\s\S]+?)"
                var href:String = Tool.init().getRegularData(regularExpress: "href=\"([\\s\\S]+?)\"", content: row)[0]
                href = href.replacingOccurrences(of: "href=\"", with: "")
                href = href.replacingOccurrences(of: "\"", with: "")
                let model = ChapterModel.init()
                model.name = title
                model.url = href
                self.listArr.append(model)
            }
            self.mainTable.reloadData()
        } failure: { (error) in
            
        }

    }
    
    lazy var mainTable:UITableView = {
        let mainTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH), style: .plain)
        mainTable.delegate = self
        mainTable.dataSource = self
        self.view.addSubview(mainTable)
        return mainTable
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        let model:ChapterModel = listArr[indexPath.row]
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:ChapterModel = self.listArr[indexPath.row]
        let VC = ChapterViewController.init()
        model.url = "https://manhua.fzdm.com/"+(self.model?.url)!+model.url!
        VC.model = model
        self.navigationController?.pushViewController(VC, animated: true)
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
