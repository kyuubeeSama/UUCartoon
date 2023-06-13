//
//  CartoonViewController.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/6.
//  Copyright © 2021 qykj. All rights reserved.
//  漫画页面

import UIKit
import SnapKit
import JXSegmentedView

class CartoonViewController: BaseViewController,JXSegmentedViewDelegate,JXSegmentedListContainerViewDataSource {
    
    public var type:CartoonType = .ykmh
    public var indexModel:IndexModel = IndexModel.init()
    
    @objc func injected(){
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 搜索按钮
        let rightItem = UIBarButtonItem.init(image: UIImage.init(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchView))
        navigationItem.rightBarButtonItem = rightItem
        navigationItem.title = indexModel.title
        segmentedView.dataSource = segmentedDataSource
        segmentedView.listContainer = listContainerView
    }
    
    override func setNav() {
        setNavColor(navColor: UIColor(.dm, light: .white, dark: .black), titleColor: UIColor(.dm, light: .black, dark: .white), barStyle: .default)
    }
        
    @objc func searchView(){
        let VC = SearchViewController.init()
        VC.type = type
        navigationController?.pushViewController(VC, animated: true)
    }
    
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segmentedDataSource = JXSegmentedTitleDataSource.init()
        segmentedDataSource.titles = indexModel.webModel.websiteTitleArr
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.titleNormalColor = UIColor.init(.dm, light: .black, dark: .white)
        return segmentedDataSource
    }()
    
    lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView.init()
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(40)
        }
        
        let indicator = JXSegmentedIndicatorLineView.init()
        segmentedView.indicators = [indicator]
        return segmentedView
    }()
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let listContainerView = JXSegmentedListContainerView.init(dataSource: self)
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
        }
        return listContainerView
    }()
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        indexModel.webModel.websiteTitleArr.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let VC = CartoonListViewController.init()
        VC.index = indexModel.webModel.websiteIdArr[index]
        VC.websiteModel = indexModel.webModel
        return VC
    }
}
