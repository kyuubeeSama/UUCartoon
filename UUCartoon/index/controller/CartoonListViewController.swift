//
//  CartoonListViewController.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/6.
//  Copyright © 2021 qykj. All rights reserved.
//  漫画列表页面

import UIKit
import JXSegmentedView
import ESPullToRefresh

class CartoonListViewController: BaseViewController,JXSegmentedListContainerViewListDelegate {
    
    // 区分当前是那一列
    public var index:Int = 0
    public var type:CartoonType?
    public var pageNum:Int = 1
    // 当前选中是哪个排序
    private var rankType:Int = 0
    // 缓存排行数据
    private var rankListArr:[[CartoonModel]] = [[],[],[]]
    // 记录是否有弹窗
    private var is_show:Bool = false
    private var timeType:Int = 0
    private var categoryType:Int = 0
    // 区分当前是选择类型还是时间
    private var chooseType:Int = 0
    
    private var listArr:[CartoonModel] = []
    
    private var leftArr = SiftCategoryModel.init().getCategoryLeftArr()
    private var rightArr = SiftCategoryModel.init().getCategoryRightArr()
    
    @objc func injected(){
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if index == 1 {
            makeUI()
        }
        getListData()
    }

    func makeUI() {
        let header = RankChooseView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: 50))
        view.addSubview(header)
        header.categoryBtnView.type = type!
        header.categoryBtnView.categoryBtnBlock = { index in
            self.rankType = index
            let array = self.rankListArr[self.rankType]
            if array.isEmpty {
                self.getListData()
            }else{
                self.mainCollect.listArr = array
            }
        }
        if type == .ykmh{
            header.siftBtn.isHidden = false
        }
        header.siftBtn.rentBtnBlock = {
            if self.rankType != 2 {
                if self.is_show {
                    let siftView = self.view.viewWithTag(500)
                    siftView?.removeFromSuperview()
                }else{
                    // 点击展示类型筛选界面
                    //TODO:添加筛选界面
                    let siftView = SiftView.init(frame: CGRect(x: 0, y: 50, width: screenW, height: screenH))
                    siftView.tag = 500
                    self.view.addSubview(siftView)
                    siftView.type = self.rankType
                    siftView.leftTableView.listArr = self.leftArr[self.rankType]
                    siftView.rightTableView.listArr = self.rightArr[self.rankType][0]
                    siftView.leftTableView.cellItemSelectedBlock = { indexPath in
                        self.chooseType = indexPath.row
                        // 左侧选择表
                        // 刷新右侧表格数据
                        siftView.rightTableView.listArr = self.rightArr[self.rankType][indexPath.row]
                    }
                    siftView.rightTableView.cellItemSelectedBlock = { indexPath in
                        // 右侧选择表.选中直接刷新数据
                        if self.chooseType == 0 {
                            self.categoryType = indexPath.row
                        }else{
                            self.timeType = indexPath.row
                        }
                        siftView.removeFromSuperview()
                        self.is_show = false
                        self.getListData()
                    }
                }
                self.is_show = !self.is_show
            }
        }
    }

    func getListData() {
        beginProgress()
        DispatchQueue.global().async {
            if self.index == 0 {
                DataTool.init().getNewCartoonData(type: self.type!, pageNum: self.pageNum) { resultArr in
                    DispatchQueue.main.async {
                        self.endProgress()
                        if !resultArr.isEmpty{
                            self.pageNum += 1
                            self.mainCollect.es.stopLoadingMore()
                        }else{
                            self.mainCollect.es.noticeNoMoreData()
                        }
                        self.listArr.append(array: resultArr)
                        self.mainCollect.listArr = self.listArr
                    }
                } failure: { error in
                    print(error.localizedDescription)
                }
            }else if self.index == 1{
                DataTool.init().getRankCartoonData(type: self.type!, pageNum: self.pageNum, rankType: self.rankType, timeType: self.timeType, category: self.categoryType) { resultArr in
                    DispatchQueue.main.async {
                        self.endProgress()
                        self.rankListArr[self.rankType] = resultArr
                        self.mainCollect.listArr = self.rankListArr[self.rankType]
                    }
                } failure: { error in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    lazy var mainCollect:CartoonListCollectionView  = {
        let layout = UICollectionViewFlowLayout.init()
        let mainCollect = CartoonListCollectionView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        self.view.addSubview(mainCollect)
        mainCollect.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            if index == 1{
                make.top.equalToSuperview().offset(60)
            }else{
                make.top.equalToSuperview()
            }
        }
        mainCollect.cellItemSelected = { indexPath in
            let VC = ChapterViewController.init()
            self.navigationController?.pushViewController(VC, animated: true)
        }
        mainCollect.es.addInfiniteScrolling {
            if  self.index != 1{
                self.getListData()
            }
        }
        return mainCollect
    }()
    
    func listView() -> UIView {
        view
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
