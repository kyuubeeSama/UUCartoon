//
//  HistoryViewController.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/29.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit

class HistoryViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "历史记录"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "清空", style: .plain, target: self, action: #selector(cleanHistory))
        getHistoryData()
    }
    
    @objc func cleanHistory(){
        Tool.makeAlertController(title: "警告", message: "是否删除所有历史记录") {
            if SqlTool.init().cleanHistory() {
                self.mainCollect.listArr = []
            }
        }
    }
    
    func getHistoryData(){
        mainCollect.listArr = SqlTool.init().getHistory()
    }
    
    lazy var mainCollect: SearchResultCollectionView = {
        let layout = UICollectionViewLeftAlignedLayout.init()
        let mainCollect = SearchResultCollectionView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        self.view.addSubview(mainCollect)
        mainCollect.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        mainCollect.cellItemSelected = { indexPath in
            let model = mainCollect.listArr[indexPath.row]
            let VC = ChapterViewController.init()
            VC.type = model.type
            VC.detailUrl = model.detailUrl
            VC.cartoon_id = model.cartoon_id
            self.navigationController?.pushViewController(VC, animated: true)
        }
        mainCollect.es.addInfiniteScrolling(animator: footer) {
            self.getHistoryData()
        }
        mainCollect.es.addPullToRefresh(animator: header) {
            self.getHistoryData()
        }
        return mainCollect
    }()
}
