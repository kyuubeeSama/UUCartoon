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
        backBtn.isHidden = false
        getData()
    }
    
    lazy var backBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        view.addSubview(btn)
//        btn.isHidden = true
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO:退出页面时，更新页码
        ImageCache.default.clearMemoryCache()
    }
    
    func saveHistory(){
        self.cartoonModel?.page_index = mainScroll.currentPageIndex
        self.cartoonModel?.chapter_name = self.model!.name
        self.cartoonModel?.type = self.type!
        SqlTool.init().saveHistory(model: self.cartoonModel!)
    }
    
    // TODO:进入页面时，保存历史记录
    func getData() {
        var detailUrl = model?.detailUrl
        if type == .ykmh {
            detailUrl = "http://wap.ykmh.com/"+model!.detailUrl
        }
        DataTool.init().getCartoonDetailImgData(type: self.type!, detailUrl: detailUrl!, success: { imgArr in
            self.mainScroll.listArr = imgArr
        }, failure: { error in
            print(error)
        })
    }
    
    lazy var mainScroll: CartoonViewScrollView = {
        let scrollView = CartoonViewScrollView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        self.view.addSubview(scrollView)
        scrollView.scrollLastPage = {
            let alert = UIAlertController.init(title: "提醒", message: "后面没有了", preferredStyle: .alert)
            let sureAction = UIAlertAction.init(title: "确定", style: .default) { action in
                self.mainScroll.contentOffset = CGPoint(x: screenW, y: 0)
            }
            alert.addAction(sureAction)
            self.present(alert, animated: true, completion: nil)
        }
        scrollView.scrollFirstPage = {
            let alert = UIAlertController.init(title: "提醒", message: "前面没有了", preferredStyle: .alert)
            let sureAction = UIAlertAction.init(title: "确定", style: .default) { action in
                self.mainScroll.contentOffset = CGPoint(x: screenW, y: 0)
            }
            alert.addAction(sureAction)
            self.present(alert, animated: true, completion: nil)
        }
        return scrollView
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
