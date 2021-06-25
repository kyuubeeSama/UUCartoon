//
//  CartoonDetailViewController.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/6.
//  Copyright © 2021 qykj. All rights reserved.
//  漫画详情界面

import UIKit
import ESPullToRefresh

class CartoonDetailViewController: BaseViewController {
    
    public var model:ChapterModel?
    public var type:CartoonType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getData()
    }
    
    func getData() {
        var detailUrl = ""
        if type == .ykmh {
            detailUrl = "http://wap.ykmh.com/"+model!.detailUrl
        }
        DataTool.init().getCartoonDetailImgData(type: .ykmh, detailUrl: detailUrl, success: { imgArr in
            self.mainCollect.listArr = imgArr
        }, failure: { error in
            print(error)
        })
    }
    
    lazy var mainCollect: CartoonImgCollectionView = {
        let collectionView = CartoonImgCollectionView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewFlowLayout.init())
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(self.view)
        }
        collectionView.es.addInfiniteScrolling {
            // TODO:进入下一话
        }
        return collectionView
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
