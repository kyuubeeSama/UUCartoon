//
//  SearchViewController.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/16.
//  Copyright © 2021 qykj. All rights reserved.
//  搜索界面

import UIKit

class SearchViewController: BaseViewController,UISearchBarDelegate {

    var type:CartoonType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.makeUI()
        self.getData()
    }
    
    func makeUI(){
        let searchView = UISearchBar.init()
        self.view.addSubview(searchView)
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
        VC.type = self.type
        VC.keyword = searchBar.text!
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func getData(){
        DispatchQueue.global().async {
            DataTool.init().getSearchRecommendData(type: self.type!) { resultArr in
                DispatchQueue.main.async {
                    self.mainCollect.listArr = resultArr
                }
            } failure: { error in
                print(error)
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
