//
//  SearchResultViewController.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/28.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit

class SearchResultViewController: BaseViewController {

    var type:CartoonType?
    var keyword:String = ""
    var pageNum = 1
    var listArr:[CartoonModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getListData()
    }

    func getListData(){
        beginProgress()
        DispatchQueue.global().async {
            DataTool.init().getSearchResultData(type: self.type!, keyword:self.keyword, page: self.pageNum) { resultArr in
                DispatchQueue.main.async {
                    self.endProgress()
                    if resultArr.isEmpty {
                        self.mainCollect.es.noticeNoMoreData()
                    }else{
                        self.pageNum += 1
                        self.mainCollect.es.stopLoadingMore()
                    }
                    self.listArr.append(array: resultArr)
                    self.mainCollect.listArr = self.listArr
                }
            } failure: { error in
                DispatchQueue.main.async {
                    self.endProgress()
                    self.view.makeToast("数据获取失败")
                }
            }
        }
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
            VC.type = self.type!
            VC.detailUrl = model.detailUrl
            self.navigationController?.pushViewController(VC, animated: true)
        }
        mainCollect.es.addInfiniteScrolling {
            self.getListData()
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
