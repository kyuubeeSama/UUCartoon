//
//  CollectViewController.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/29.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import UICollectionViewLeftAlignedLayout
import EmptyDataSet_Swift
class CollectViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "收藏列表"
        getListData()
    }
    
    func getListData(){
        mainCollect.listArr = SqlTool.init().getCollect()
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
            VC.deleteCollectBlock = {
                self.getListData()
            }
            self.navigationController?.pushViewController(VC, animated: true)
        }
        mainCollect.es.addInfiniteScrolling(animator: footer) {
            self.getListData()
        }
        mainCollect.es.addPullToRefresh(animator: header) {
            self.getListData()
        }
        mainCollect.emptyDataSetView { emptyView in
            emptyView.detailLabelString(NSAttributedString.init(string: "快去收藏喜欢的内容吧")).image(UIImage.init(named: "empty_img"))
        }
        return mainCollect
    }()


    

}
