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
    
    public var type:CartoonType?
    
    @objc func injected(){
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = ["优酷漫画","ssoonn"][type!.rawValue]
        segmentedView.dataSource = segmentedDataSource
        segmentedView.listContainer = listContainerView
    }
    
    lazy var segmentedDataSource: JXSegmentedTitleDataSource = {
        let segmentedDataSource = JXSegmentedTitleDataSource.init()
        segmentedDataSource.titles = ["最新发布","漫画排行","分类筛选","已完结"]
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
        4
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let VC = CartoonListViewController.init()
        VC.index = index
        VC.type = type
        return VC
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
