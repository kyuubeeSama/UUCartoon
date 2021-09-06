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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "清空", style: .plain, target: self, action: #selector(cleanHistory))
        getHistoryData()
    }
    
    @objc func cleanHistory(){
        let alert = UIAlertController.init(title: "警告", message: "是否删除所有历史记录", preferredStyle: .alert)
        let sureAction = UIAlertAction.init(title: "删除", style: .default) { action in
            if SqlTool.init().cleanHistory() {
                self.mainCollect.listArr = []
            }
        }
        alert.addAction(sureAction)
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
            self.navigationController?.pushViewController(VC, animated: true)
        }
        return mainCollect
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
