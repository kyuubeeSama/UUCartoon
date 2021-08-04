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
    
    public var cartoonModel:CartoonModel?
    public var model:ChapterModel?
    public var type:CartoonType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getData()
    }
    
    // 保存历史记录
    func getData() {
        var detailUrl = model?.detailUrl
        if type == .ykmh {
            detailUrl = "http://wap.ykmh.com/"+model!.detailUrl
        }
        DataTool.init().getCartoonDetailImgData(type: self.type!, detailUrl: detailUrl!, success: { imgArr in
            self.mainTable.listArr = imgArr
        }, failure: { error in
            print(error)
        })
    }
    
    lazy var mainTable: CartoonImgTableView = {
        let mainTable = CartoonImgTableView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        self.view.addSubview(mainTable)
        mainTable.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        return mainTable
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
