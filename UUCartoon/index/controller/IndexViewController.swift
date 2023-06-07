//
//  IndexViewController.swift
//  UUCartoon
//
//  Created by kyuubee on 2020/7/15.
//  Copyright © 2020 qykj. All rights reserved.
//  漫画站点页面
// 在当前页面选择跳转到哪个站点

import UIKit
import SnapKit

class IndexViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainTable.listArr = indexArr
        title = "悠悠漫画"
    }
    
    lazy var mainTable: LabelTableView = {
        let mainTable = LabelTableView.init(frame: .zero, style: .insetGrouped)
        self.view.addSubview(mainTable)
        mainTable.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainTable.cellItemBlock = { indexPath in
            if indexPath.section == 0 {
                let VC = CartoonViewController.init()
                VC.indexModel = indexArr[indexPath.section].list[indexPath.row]
                self.navigationController?.pushViewController(VC, animated: true)
            }else{
                if indexPath.row == 0{
                    let VC = CollectViewController.init()
                    self.navigationController?.pushViewController(VC, animated: true)
                }else if indexPath.row == 1{
                    let VC = HistoryViewController.init()
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            }
        }
        return mainTable
    }()
    
    
}
