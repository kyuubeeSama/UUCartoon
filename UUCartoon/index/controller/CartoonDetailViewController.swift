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

class CartoonDetailViewController: BaseViewController {
    
    public var cartoonModel:CartoonModel?
    public var model:ChapterModel?
    public var type:CartoonType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        getData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        // TODO:退出页面时，更新页码
        ImageCache.default.clearMemoryCache()
    }

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

    
    func saveHistory(){
//        cartoonModel?.page_index = mainScroll.currentPageIndex
//        cartoonModel?.chapter_name = model!.name
//        cartoonModel?.type = type!
//        SqlTool.init().saveHistory(model: cartoonModel!)
    }
    
    // TODO:进入页面时，保存历史记录
    func getData() {
        var detailUrl = model?.detailUrl
        if type == .ykmh {
            detailUrl = "http://wap.ykmh.com/"+model!.detailUrl
        }
        beginProgress()
        DispatchQueue.global().async {
            DataTool.init().getCartoonDetailImgData(type: self.type!, detailUrl: detailUrl!, success: { imgArr in
                DispatchQueue.main.async {
                    self.endProgress()
                    self.mainScroll.listArr = imgArr
                    self.bottomView.currentPageLab.text = 1;
                    self.bottomView.totalPageLab.text = imgArr.count
                    self.bottomView.slider.maximumValue = imgArr.count
                    self.bottomView.slider.minimumValue = 1
                }
            }, failure: { error in
                DispatchQueue.main.async {
                    self.endProgress()
                    self.view.makeToast("数据获取失败")
                }
            })
        }
    }
    
    lazy var mainScroll: CartoonViewScrollView = {
        let scrollView = CartoonViewScrollView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        self.view.addSubview(scrollView)
        scrollView.scrollLastPage = {
            let alert = UIAlertController.init(title: "提醒", message: "后面没有了", preferredStyle: .alert)
            let sureAction = UIAlertAction.init(title: "确定", style: .default) { action in
//                self.mainScroll.contentOffset = CGPoint(x: screenW, y: 0)
            }
            alert.addAction(sureAction)
            self.present(alert, animated: true, completion: nil)
        }
        scrollView.scrollFirstPage = {
            let alert = UIAlertController.init(title: "提醒", message: "前面没有了", preferredStyle: .alert)
            let sureAction = UIAlertAction.init(title: "确定", style: .default) { action in
//                self.mainScroll.contentOffset = CGPoint(x: screenW, y: 0)
            }
            alert.addAction(sureAction)
            self.present(alert, animated: true, completion: nil)
        }
        self.view.bringSubviewToFront(self.backBtn)
        return scrollView
    }()
    
    lazy var bottomView: BottomPageView = {
        let bottomView = BottomPageView.init()
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        bottomView.slider.reactive.controlEvents(.valueChanged).observeValues { slider in
            self.mainScroll.currentPageIndex = slider.value
        }
        return bottomView
    }()
    
    override func didReceiveMemoryWarning() {
        ImageCache.default.clearMemoryCache()
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
