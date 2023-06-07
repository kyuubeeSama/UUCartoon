//
//  SearchViewController.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/16.
//  Copyright © 2021 qykj. All rights reserved.
//  搜索界面

import UIKit

class SearchViewController: BaseViewController,UISearchBarDelegate {

    var type:CartoonType = .ykmh
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeUI()
        getData()
    }
    
    func makeUI(){
        let searchView = UISearchBar.init()
        view.addSubview(searchView)
        searchView.delegate = self
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(50)
        }
        searchView.placeholder = "请输入搜索内容"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let VC = SearchResultViewController.init()
        VC.type = type
        VC.keyword = searchBar.text!
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func getData(){
        DispatchQueue.global().async {
            DataTool.init().getSearchRecommendData(type: self.type) { resultArr in
                DispatchQueue.main.async {
                    for item in resultArr {
                        item.cartoon_id = SqlTool.init().insertCartoon(model: item)
                    }
                    self.mainCollect.listArr = resultArr
                }
            }
        }
    }
    
    lazy var mainCollect: SearchCollectionView = {
        let layout = UICollectionViewLeftAlignedLayout.init()
        let mainCollect = SearchCollectionView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        self.view.addSubview(mainCollect)
        mainCollect.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(70)
        }
        mainCollect.cellItemBlock = { indexPath in
            let model = mainCollect.listArr![indexPath.row]
            let VC = ChapterViewController.init()
            VC.type = self.type
            VC.detailUrl = model.detailUrl
            VC.cartoon_id = model.cartoon_id
            self.navigationController?.pushViewController(VC, animated: true)
        }
        return mainCollect
    }()
    
    

}
