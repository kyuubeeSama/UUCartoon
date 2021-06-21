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
    private var model:CartoonDetailModel = CartoonDetailModel.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getData()
    }

    func getData(){
        self.beginProgress()
        DispatchQueue.global().async {
            DataTool.init().getCartoonDetailData(type: self.type!, detailUrl: self.detailUrl!, success: { detailModel in
                DispatchQueue.main.async {
                    self.endProgress()
                    self.model = detailModel
                    self.mainCollect.model = detailModel
                }
            }, failure: { error in
                print(error)
            })
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
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        mainCollect.readBlock = {
            // 阅读
            let model = self.model.chapterArr[0].data.last
            let VC = CartoonDetailViewController.init()
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
