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

class CartoonListViewController: BaseViewController, JXSegmentedListContainerViewListDelegate {

    // 区分当前是那一列
    public var index: Int = 0
    public var type: CartoonType?
    public var pageNum: Int = 1
    // 当前选中是哪个排序
    private var rankType: Int = 0
    // 缓存排行数据
    private var rankListArr: [[CartoonModel]] = [[], [], []]
    // 记录是否有弹窗
    private var is_show: Bool = false
    // 排序时候用的时间和类型
    private var timeType: Int = 0
    private var categoryType: Int = 0
    // 区分当前是选择类型还是时间
    private var chooseType: Int = 0
    // 保存排序方式
    private var orderType:String = "/post"
    // 保存获取分类类表
    private var categoryArr:[[CategoryModel]] = [[],[],[],[]]
    // 保存选中的分类信息
    private var categoryValue:[String] = ["","","",""]
    private var listArr: [CartoonModel] = []

    private var leftArr = SiftCategoryModel.init().getCategoryLeftArr()
    private var rightArr = SiftCategoryModel.init().getCategoryRightArr()

    @objc func injected() {
        viewDidLoad()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if index == 1 {
            makeOrderView()
        } else if index == 2 {
            // 创建分类筛选界面
            makeCategoryView()
            getCategoryData()
        }
        getListData()
    }

    func makeOrderView() {
        let header = RankChooseView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: 50))
        view.addSubview(header)
        header.categoryBtnView.type = type!
        header.categoryBtnView.categoryBtnBlock = { index in
            self.rankType = index
            let array = self.rankListArr[self.rankType]
            if array.isEmpty {
                self.getListData()
            } else {
                self.mainCollect.listArr = array
            }
        }
        if type == .ykmh {
            header.siftBtn.isHidden = false
        }
        header.siftBtn.rentBtnBlock = {
            if self.rankType != 2 {
                if self.is_show {
                    let siftView = self.view.viewWithTag(500)
                    siftView?.removeFromSuperview()
                } else {
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
                        } else {
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

    func makeCategoryView() {
        let chooseView = CategoryChooseView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: 90))
        view.addSubview(chooseView)
        chooseView.btnClickBlock = { index in
            if index<10 {
                let array = self.categoryArr[index]
                if !array.isEmpty {
                    let button:UIButton = chooseView.viewWithTag(150+index) as! UIButton
                    if button.isSelected {
                        let backView = UIView.init()
                        backView.tag = 200
                        self.view.addSubview(backView)
                        backView.backgroundColor = UIColor.colorWithHexString(hexString: "333333", alpha: 0.3)
                        backView.snp.makeConstraints { make in
                            make.left.right.bottom.equalToSuperview()
                            make.top.equalTo(chooseView.snp.bottom).offset(-50)
                        }
                        let layout = UICollectionViewLeftAlignedLayout.init()
                        let categoryCollectionView = CartoonCategoryCollectionView.init(frame: CGRect.init(), collectionViewLayout: layout)
                        backView.addSubview(categoryCollectionView)
                        categoryCollectionView.snp.makeConstraints { make in
                            make.left.right.top.equalToSuperview()
                            make.bottom.equalToSuperview().offset(-100)
                        }
                        categoryCollectionView.listArr = array
                        categoryCollectionView.cellItemSelectedBlock = { indexPath in
                            button.isSelected = false
                            button.setImage(UIImage.init(named: "category_row_close"), for: .normal)
                            button.setTitleColor(UIColor.init(named: "333333"), for: .normal)
                            backView.removeFromSuperview()
                            //                    赋值，并刷新列表
                            var categoryModel = array[indexPath.row]
                            for var model in array {
                                model.ischoose = false
                            }
                            categoryModel.ischoose = true
                            self.categoryValue[index] = categoryModel.value
                            self.pageNum = 1
                            self.listArr = []
                            self.getListData()
                        }
                    }else{
                        for view in self.view.subviews {
                            if view.tag == 200 {
                                view.removeFromSuperview()
                            }
                        }
                    }
                }else{
                    self.view.makeToast("当前未获取分类信息")
                }
            }else{
                let valueArr:[[String]] = [["/post","/update","/click"],["/-post","/-update","/-click"]]
                // 排序按钮
                let button = chooseView.viewWithTag(150+index) as! UIButton
                self.orderType = valueArr[button.clickLevel-1][index-11]
                self.listArr = []
                self.pageNum = 1
                self.getListData()
            }
        }
    }

    // 获取漫画列表
    func getListData() {
        beginProgress()
        DispatchQueue.global().async {
            if self.index == 0 {
                DataTool.init().getNewCartoonData(type: self.type!, pageNum: self.pageNum) { resultArr in
                    DispatchQueue.main.async {
                        self.endProgress()
                        if !resultArr.isEmpty {
                            self.pageNum += 1
                            self.mainCollect.es.stopLoadingMore()
                        } else {
                            self.mainCollect.es.noticeNoMoreData()
                        }
                        self.listArr.append(array: resultArr)
                        self.mainCollect.listArr = self.listArr
                    }
                } failure: { error in
                    print(error.localizedDescription)
                }
            } else if self.index == 1 {
                DataTool.init().getRankCartoonData(type: self.type!, pageNum: self.pageNum, rankType: self.rankType, timeType: self.timeType, category: self.categoryType) { resultArr in
                    DispatchQueue.main.async {
                        self.endProgress()
                        self.rankListArr[self.rankType] = resultArr
                        self.mainCollect.listArr = self.rankListArr[self.rankType]
                    }
                } failure: { error in
                    print(error.localizedDescription)
                }
            }else if self.index == 2{
                let detailUrl = self.categoryValue.joined(separator: "")+self.orderType
                DataTool.init().getCategorySiftResultListData(type: self.type!, detailUrl: detailUrl, page: self.pageNum, success: { resultArr in
                    DispatchQueue.main.async {
                        self.endProgress()
                        if !resultArr.isEmpty {
                            self.pageNum += 1
                            self.mainCollect.es.stopLoadingMore()
                        } else {
                            self.mainCollect.es.noticeNoMoreData()
                        }
                        self.listArr.append(array: resultArr)
                        self.mainCollect.listArr = self.listArr
                    }
                }, failure: { errer in
                    DispatchQueue.main.async {
                        self.endProgress()
                        self.view.makeToast("获取数据失败")
                    }
                })
            }else if self.index == 3{
                DataTool.init().getDoneCartoonData(type: self.type!, page: self.pageNum) { resultArr in
                    DispatchQueue.main.async {
                        self.endProgress()
                        if !resultArr.isEmpty {
                            self.pageNum += 1
                            self.mainCollect.es.stopLoadingMore()
                        } else {
                            self.mainCollect.es.noticeNoMoreData()
                        }
                        self.listArr.append(array: resultArr)
                        self.mainCollect.listArr = self.listArr
                    }
                } failure: { Error in
                    DispatchQueue.main.async {
                        self.endProgress()
                        self.view.makeToast("获取数据失败")
                    }
                }
            }
        }
    }

    // 获取分类数据
    func getCategoryData() {
        DispatchQueue.global().async {
            DataTool.init().getCategoryData(type: self.type!, success: { resultArr in
                self.categoryArr = resultArr
            }, failure: { error in
                DispatchQueue.main.async {
                    self.view.makeToast("获取漫画分类失败")
                }
            })
        }
    }

    lazy var mainCollect: CartoonListCollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let mainCollect = CartoonListCollectionView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        self.view.addSubview(mainCollect)
        if self.index == 0 || self.index == 1 {
            mainCollect.cellType = .Table
        }else{
            mainCollect.cellType = .Collection
        }
        mainCollect.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            if index == 1 {
                make.top.equalToSuperview().offset(60)
            } else if index == 2 {
                make.top.equalToSuperview().offset(90)
            } else {
                make.top.equalToSuperview()
            }
        }
        mainCollect.cellItemSelected = { indexPath in
            let VC = ChapterViewController.init()
            self.navigationController?.pushViewController(VC, animated: true)
        }
        mainCollect.es.addInfiniteScrolling {
            if self.index != 1 {
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
