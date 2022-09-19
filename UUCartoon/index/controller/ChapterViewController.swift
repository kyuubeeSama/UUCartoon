//
//  ChapterViewController.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/6.
//  Copyright © 2021 qykj. All rights reserved.
//  章节页面

import UIKit

class ChapterViewController: BaseViewController {
    
    public var type:CartoonType = .ykmh
    public var detailUrl:String = ""
    public var cartoon_id:Int = 0
    private var model:CartoonModel = CartoonModel.init()
    private let collectBtn = UIButton.init(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setNavColor(navColor: UIColor.init(.dm,light: .white,dark: .black), titleColor: .white, barStyle: .default)
        getData()
    }
    
    func getData(){
        beginProgress()
        DispatchQueue.global().async {
            DataTool.init().getCartoonDetailData(type: self.type, detailUrl: self.detailUrl, success: { detailModel in
                DispatchQueue.main.async {
                    //保存数据到数据库中
                    self.endProgress()
                    self.model = detailModel
                    self.model.cartoon_id = self.cartoon_id
                    self.model.detailUrl = self.detailUrl
                    self.mainCollect.model = detailModel
                    for item in  detailModel.chapterArr {
                        for item1 in item.data {
                            item1.cartoonId = self.cartoon_id
                            item1.chapterId = SqlTool.init().insertChapter(model: item1)
                        }
                    }
                    self.getHistoryData()
                    self.addCollectItem(cartoonModel: self.model)
                }
            }, failure: { error in
                print(error)
                DispatchQueue.main.async {
                    self.endProgress()
                    Tool.makeAlertController(title: "提示", message: "数据加载失败") {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }
    }
    
    //查找历史记录
    func getHistoryData(){
        //更新为新的数据类型
        let chapter_id = SqlTool.init().getHistory(detailUrl: model.detailUrl)
        if chapter_id != 0 {
            for (index,item) in model.chapterArr.enumerated() {
                for (j, chapterModel) in item.data.enumerated() {
                    if chapterModel.chapterId == chapter_id {
                        chapterModel.is_choose = true
                        model.chapterArr[index].data[j] = chapterModel
                    }
                }
            }
            mainCollect.model = model
        }
    }
    
    func addCollectItem(cartoonModel: CartoonModel) {
        // 判断用户是否收藏该视频
        var imageName = "heart"
        if SqlTool.init().isCollect(model: cartoonModel) {
            imageName = "heart.fill"
        }
        collectBtn.tag = 500
        collectBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        collectBtn.setImage(UIImage.init(systemName: imageName), for: .normal)
        collectBtn.addTarget(self, action: #selector(collectClick), for: .touchUpInside)
        let rightBtnItem = UIBarButtonItem.init(customView: collectBtn)
        navigationItem.rightBarButtonItem = rightBtnItem
    }
    
    @objc func collectClick() {
        if SqlTool.init().isCollect(model: model) {
            // 删除收藏
            if SqlTool.init().deleteCollect(model: model) {
                collectBtn.setImage(UIImage.init(systemName: "heart"), for: .normal)
            } else {
                view.makeToast("操作失败")
            }
        } else {
            // 添加收藏
            if SqlTool.init().saveCollect(model: model) {
                // 修改bar按钮
                collectBtn.setImage(UIImage.init(systemName: "heart.fill"), for: .normal)
            } else {
                view.makeToast("操作成功")
            }
        }
    }
    
    lazy var mainCollect: CartoonDetailCollectionView = {
        let layout = UICollectionViewLeftAlignedLayout()
        let mainCollect = CartoonDetailCollectionView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        view.addSubview(mainCollect)
        mainCollect.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainCollect.cellItemSelectedBlock = { indexPath in
            if(indexPath.section == 2+self.model.chapterArr.count){
                // 推荐漫画
                let model = self.model.recommendArr[indexPath.row]
                let VC = ChapterViewController.init()
                VC.detailUrl = model.detailUrl
                VC.type = self.type
                self.navigationController?.pushViewController(VC, animated: true)
            }else if indexPath.section != 0 && indexPath.section != 1 {
                // 章节
                let model = self.model.chapterArr[indexPath.section-2].data[indexPath.row]
                let VC = CartoonDetailViewController.init()
                VC.model = model
                VC.cartoonModel = self.model
                VC.cartoonModel.chapter_area = indexPath.section-2
                VC.index = indexPath.row
                VC.type = self.type
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        mainCollect.readBlock = {
            // 阅读
            // 如果有记录，就继续记录，如果没有，就读最新的
            var chapterModel = self.model.chapterArr[0].data.last
            for item in self.model.chapterArr {
                for item1 in item.data {
                    if item1.is_choose == true {
                        chapterModel = item1
                    }
                }
            }
            let VC = CartoonDetailViewController.init()
            VC.model = chapterModel!
            VC.cartoonModel = self.model
            VC.cartoonModel.chapter_area = 0
            VC.type = self.type
            self.navigationController?.pushViewController(VC, animated: true)
        }
        mainCollect.subscribeBlock = {
            // 订阅
        }
        return mainCollect
    }()
    
    
    
}
