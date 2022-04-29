//
//  ChapterViewController.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/6.
//  Copyright © 2021 qykj. All rights reserved.
//  章节页面

import UIKit

class ChapterViewController: BaseViewController {
    
    public var type:CartoonType?
    public var detailUrl:String?
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
            DataTool.init().getCartoonDetailData(type: self.type!, detailUrl: self.detailUrl!, success: { detailModel in
                DispatchQueue.main.async {
                    self.endProgress()
                    self.model = detailModel
                    self.model.detailUrl = self.detailUrl!
                    self.mainCollect.model = detailModel
                    self.getHistoryData()
                    self.addCollectItem(cartoonModel: self.model)
                }
            }, failure: { error in
                print(error)
                DispatchQueue.main.async {
                    self.endProgress()
                    self.view.makeToast("加载失败")
                }
            })
        }
    }
    
    //TODO:查找历史记录
    func getHistoryData(){
        let historyModel = SqlTool.init().getHistory(detailUrl: self.model.detailUrl)
        if !historyModel.name.isEmpty {
            for (index,item) in model.chapterArr.enumerated() {
                for (j,var chapterModel) in item.data.enumerated() {
                    if chapterModel.name == historyModel.chapter_name {
                        chapterModel.is_choose = true
                        model.chapterArr[index].data[j] = chapterModel
                        model.page_index = historyModel.page_index
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
        let layout = UICollectionViewFlowLayout.init()
        let mainCollect = CartoonDetailCollectionView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        view.addSubview(mainCollect)
        mainCollect.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self.view)
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
                VC.cartoonModel?.chapter_area = indexPath.section-2
                VC.type = self.type
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        mainCollect.readBlock = {
            // 阅读
            let model = self.model.chapterArr[0].data.last
            let VC = CartoonDetailViewController.init()
            VC.model = model!
            VC.cartoonModel = self.model
            VC.cartoonModel?.chapter_area = 0
            VC.type = self.type!
            self.navigationController?.pushViewController(VC, animated: true)
        }
        mainCollect.subscribeBlock = {
            // 订阅
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
