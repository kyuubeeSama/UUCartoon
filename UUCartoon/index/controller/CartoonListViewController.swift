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
    public var type: CartoonType = .ykmh
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
    private var orderType: String = "/post"
    // 保存获取分类类表
    private var categoryArr: [[CategoryModel]] = [[], [], [], []]
    // 保存选中的分类信息
    private var categoryValue: [String] = ["", "", "", ""]
    private var listArr: [CartoonModel] = []
    private var sqlTool = SqlTool.init()
    private var leftArr = SiftCategoryModel.init().getCategoryLeftArr()
    private var rightArr = SiftCategoryModel.init().getCategoryRightArr()
    private var orderHeight = 0
    @objc func injected() {
        viewDidLoad()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if index == 1 {
            if type == .ykmh {
                makeOrderView()
            }
        } else if index == 2 {
            // 创建分类筛选界面
            makeCategoryView()
            getCategoryData()
        }
        getListData()
    }
    // 漫画排行的排序界面
    func makeOrderView() {
        let header = RankChooseView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: 50))
        view.addSubview(header)
        orderHeight = 50
        header.categoryBtnView.type = type
        header.categoryBtnView.categoryBtnBlock = { index in
            self.rankType = index
            let array = self.rankListArr[self.rankType]
            if array.isEmpty {
                self.getListData()
            } else {
                self.mainCollect.listArr = array
            }
        }
        header.siftBtn.rentBtnBlock = {
            if self.rankType != 2 {
                if self.is_show {
                    let siftView = self.view.viewWithTag(500)
                    siftView?.removeFromSuperview()
                } else {
                    // 点击展示类型筛选界面
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
    // 筛选界面
    func makeCategoryView() {
        let chooseView = CategoryChooseView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: 90))
        view.addSubview(chooseView)
        chooseView.btnClickBlock = { index in
            if index < 10 {
                let button: UIButton = chooseView.viewWithTag(150 + index) as! UIButton
                let array = self.categoryArr[index]
                if !array.isEmpty {
                    if button.isSelected {
                        for view in self.view.subviews {
                            if view.tag == 200 {
                                view.removeFromSuperview()
                            }
                        }
                        let backView = UIView.init()
                        backView.tag = 200
                        self.view.addSubview(backView)
                        backView.backgroundColor = UIColor.color(hexString: "333333", alpha: 0.3)
                        backView.snp.makeConstraints { make in
                            make.left.right.bottom.equalToSuperview()
                            make.top.equalTo(50)
                        }
                        let layout = UICollectionViewLeftAlignedLayout.init()
                        let categoryCollectionView = CartoonCategoryCollectionView.init(frame: .zero, collectionViewLayout: layout)
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
                            let categoryModel = array[indexPath.row]
                            if self.type == .ykmh || self.type == .wudi {
                                for model in array {
                                    model.ischoose = false
                                }
                            }
                            categoryModel.ischoose = true
                            self.categoryValue[index] = categoryModel.value
                            self.pageNum = 1
                            self.listArr = []
                            self.getListData()
                        }
                    } else {
                        for view in self.view.subviews {
                            if view.tag == 200 {
                                view.removeFromSuperview()
                            }
                        }
                    }
                } else {
                    self.view.makeToast("当前未获取分类信息")
                }
            } else {
                let valueArr: [[String]] = [["/post", "/update", "/click"], ["/-post", "/-update", "/-click"]]
                // 排序按钮
                let button = chooseView.viewWithTag(150 + index) as! UIButton
                self.orderType = valueArr[button.clickLevel - 1][index - 11]
                self.listArr = []
                self.pageNum = 1
                self.getListData()
            }
        }
    }
    // 保存漫画记录
    func saveCartoonList(list: [CartoonModel]) {
        for item in list {
            item.cartoon_id = sqlTool.insertCartoon(model: item)
        }
    }
    //MARK: 获取漫画列表
    func getListData() {
        beginProgress()
        DispatchQueue.global().async { [self] in
            if index == 0 {
                // 最新发布
                DataTool.init().getNewCartoonData(type: type, pageNum: pageNum) { resultArr in
                    DispatchQueue.main.async { [self] in
                        endProgress()
                        mainCollect.es.stopPullToRefresh()
                        if !resultArr.isEmpty {
                            pageNum += 1
                            mainCollect.es.stopLoadingMore()
                        } else {
                            mainCollect.es.noticeNoMoreData()
                        }
                        saveCartoonList(list: resultArr)
                        listArr.append(array: resultArr)
                        mainCollect.listArr = listArr
                    }
                }
            } else if index == 1 {
                // 漫画排行
                DataTool.init().getRankCartoonData(type: type, pageNum: pageNum, rankType: rankType, timeType: timeType, category: categoryType) { resultArr in
                    DispatchQueue.main.async { [self] in
                        endProgress()
                        mainCollect.es.stopPullToRefresh()
                        saveCartoonList(list: resultArr)
                        rankListArr[rankType] = resultArr
                        mainCollect.listArr = rankListArr[rankType]
                    }
                }
            } else if index == 2 {
                // 分类筛选
                var detailUrl = ""
                if type == .ykmh || type == .wudi {
                    detailUrl = categoryValue.joined(separator: "") + orderType
                }
                if detailUrl.isEmpty {
                    DispatchQueue.main.async { [self] in
                        endProgress()
                        view.makeToast("请选择筛选条件", duration: 3, position: .center)
                    }
                } else {
                    DataTool.init().getCategorySiftResultListData(type: type, detailUrl: detailUrl, page: pageNum, success: { resultArr in
                        DispatchQueue.main.async { [self] in
                            endProgress()
                            mainCollect.es.stopPullToRefresh()
                            if !resultArr.isEmpty {
                                pageNum += 1
                                mainCollect.es.stopLoadingMore()
                            } else {
                                mainCollect.es.noticeNoMoreData()
                            }
                            saveCartoonList(list: resultArr)
                            listArr.append(array: resultArr)
                            mainCollect.listArr = listArr
                        }
                    })
                }
            } else if index == 3 {
                // 已完结
                DataTool.init().getDoneCartoonData(type: type, page: pageNum) { resultArr in
                    DispatchQueue.main.async { [self] in
                        endProgress()
                        mainCollect.es.stopPullToRefresh()
                        if !resultArr.isEmpty {
                            pageNum += 1
                            mainCollect.es.stopLoadingMore()
                        } else {
                            mainCollect.es.noticeNoMoreData()
                        }
                        saveCartoonList(list: resultArr)
                        listArr.append(array: resultArr)
                        mainCollect.listArr = listArr
                    }
                }
            }
        }
    }
    // 获取分类数据
    func getCategoryData() {
        DispatchQueue.global().async {
            DataTool.init().getCategoryData(type: self.type, success: { resultArr in
                self.categoryArr = resultArr
            })
        }
    }
    // 漫画列表
    lazy var mainCollect: CartoonListCollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let mainCollect = CartoonListCollectionView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        self.view.addSubview(mainCollect)
        if self.index == 0 || self.index == 1 {
            mainCollect.cellType = .Table
        } else {
            mainCollect.cellType = .Collection
        }
        mainCollect.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            if index == 1 {
                make.top.equalToSuperview().offset(orderHeight + 10)
            } else if index == 2 {
                make.top.equalToSuperview().offset(90)
            } else {
                make.top.equalToSuperview()
            }
        }
        mainCollect.cellItemSelected = { indexPath in
            let model = mainCollect.listArr[indexPath.row]
            let VC = ChapterViewController.init()
            VC.type = self.type
            VC.cartoon_id = model.cartoon_id
            VC.detailUrl = model.detailUrl
            self.navigationController?.pushViewController(VC, animated: true)
        }
        mainCollect.es.addInfiniteScrolling(animator: footer) {
            if self.index == 1 {
                mainCollect.es.stopLoadingMore()
            } else {
                self.getListData()
            }
        }
        mainCollect.es.addPullToRefresh(animator: header) {
            self.mainCollect.es.resetNoMoreData()
            self.pageNum = 1
            self.listArr = []
            self.getListData()
        }
        return mainCollect
    }()
    func listView() -> UIView {
        view
    }
}
