//
//  CartoonDetailViewController.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/6.
//  Copyright © 2021 qykj. All rights reserved.
//  漫画详情界面

import UIKit
import ESPullToRefresh
import Kingfisher
import ReactiveCocoa
import SnapKit
import ProgressHUD

class CartoonDetailViewController: BaseViewController {
    // 漫画model
    public var cartoonModel: CartoonModel = CartoonModel.init()
    // 当前章节model
    public var model: ChapterModel = ChapterModel.init()
    // 当前章节
    public var type: CartoonType = .ykmh
    // 当前章节在数组中的位置
    public var index: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
        getData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        // 退出页面时，更新数据库历史记录的页码
        if !mainScroll.listArr.isEmpty {
            saveHistory(pageIndex: mainScroll.currentPageIndex)
        }
        ImageCache.default.clearMemoryCache()
    }
    // 返回按钮
    lazy var backBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        btn.setImage(UIImage.init(systemName: "chevron.backward"), for: .normal)
        btn.reactive.controlEvents(.touchUpInside).observeValues { button in
            self.navigationController?.popViewController(animated: true)
        }
        return btn
    }()
    // 保存历史记录
    func saveHistory(pageIndex: Int) {
        cartoonModel.page_index = pageIndex
        cartoonModel.chapter_name = model.name
        cartoonModel.chapter_id = model.chapterId
        cartoonModel.type = type
        SqlTool.init().saveHistory(model: cartoonModel)
    }
    // 获取数据时，保存历史记录
    func getData() {
        var detailUrl = model.detailUrl
        if type == .ykmh {
            detailUrl = "http://wap.ykmh.com/" + model.detailUrl
        }
        beginProgress()
        DispatchQueue.global().async {
            DataTool.init().getCartoonDetailImgData(type: self.type, detailUrl: detailUrl, success: { imgArr in
                DispatchQueue.main.async {
                    // TODO: 通过历史记录进来的，按照历史记录的页码
                    self.endProgress()
                    self.mainScroll.listArr = imgArr
                    self.bottomView.totalPageLab.text = "\(imgArr.count)"
                    self.bottomView.slider.maximumValue = Float(imgArr.count)
                    self.bottomView.slider.minimumValue = 1
                    // 读取当前章节是否存在历史记录
                    let page = SqlTool.init().getHistory(detailUrl: self.model.detailUrl, is_page: true)
                    if page == 0 {
                        // 不存在历史记录，从头开始
                        self.saveHistory(pageIndex: 0)
                        self.bottomView.currentPageLab.text = "1";
                    }else{
                        // 存在记录，从记录点开始
                        self.saveHistory(pageIndex: page)
                        self.mainScroll.setCurrentPage(index: page)
                        self.bottomView.currentPageLab.text = "\(page+1)"
                    }
                }
            }, failure: { error in
                DispatchQueue.main.async {
                    self.endProgress()
                    Tool.makeAlertController(title: "提示", message: "数据加载失败") {
                        self.navigationController?.popViewController(animated: true)
                    }
                    self.view.makeToast("数据获取失败")
                }
            })
        }
    }
    lazy var mainScroll: CartoonViewScrollView = {
        let scrollView = CartoonViewScrollView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        self.view.addSubview(scrollView)
        scrollView.scrollLastPage = {
            let listArr = self.cartoonModel.chapterArr[self.cartoonModel.chapter_area]
            if self.index == 0 {
                // 到头了
                Tool.makeAlertController(title: "提醒", message: "前面没有了") {
                }
            } else {
                // 加载下一章
                self.index -= 1
                self.model = listArr.data[self.index]
                self.getData()
            }
        }
        scrollView.scrollFirstPage = {
            let listArr = self.cartoonModel.chapterArr[self.cartoonModel.chapter_area]
            if self.index == listArr.data.count - 1 {
                Tool.makeAlertController(title: "提醒", message: "后面没有了") {
                }
            } else {
                self.index += 1
                self.model = listArr.data[self.index]
                self.getData()
            }
        }
        scrollView.scrollDidScrollBlock = { currentIndex in
            self.bottomView.currentPageLab.text = "\(currentIndex + 1)"
            self.bottomView.slider.value = Float(currentIndex + 1)
        }
        self.view.bringSubviewToFront(self.backBtn)
        return scrollView
    }()
    // 底部进度指示器
    lazy var bottomView: BottomPageView = {
        let bottomView = BottomPageView.init()
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        bottomView.slider.reactive.controlEvents(.valueChanged).observeValues { slider in
            self.mainScroll.setCurrentPage(index: Int(slider.value) - 1)
        }
        return bottomView
    }()
    override func didReceiveMemoryWarning() {
        ImageCache.default.clearMemoryCache()
    }
}
