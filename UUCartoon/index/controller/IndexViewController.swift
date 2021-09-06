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
    
    @objc func injected(){
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainTable.listArr = ["优酷漫画","ssoonn","收藏列表","历史记录"]
    }
    
    lazy var mainTable: LabelTableView = {
        let mainTable = LabelTableView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        self.view.addSubview(mainTable)
        mainTable.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        mainTable.cellItemBlock = { indexPath in
            if indexPath.row == 2{
                let VC = CollectViewController.init()
                self.navigationController?.pushViewController(VC, animated: true)
            }else if indexPath.row == 3{
                let VC = HistoryViewController.init()
                self.navigationController?.pushViewController(VC, animated: true)
            }else{
                let VC = CartoonViewController.init()
                VC.type = CartoonType(rawValue: indexPath.row)
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        return mainTable
    }()
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
