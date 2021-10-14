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

class CartoonDetailViewController: BaseViewController {
    
    public var cartoonModel:CartoonModel?
    public var model:ChapterModel?
    public var type:CartoonType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNavColor(navColor: .systemBackground, titleColor: UIColor.init(.dm, light: .black, dark: .white), barStyle: .default)
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO:退出页面时，更新页码
        self.saveHistory()
        ImageCache.default.clearMemoryCache()
    }
    
    func saveHistory(){
        let visible = mainTable.indexPathsForVisibleRows
        let indexPath = visible![0]
        self.cartoonModel?.page_index = indexPath.row
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
            self.mainTable.listArr = imgArr
            self.mainTable.scrollToRow(at: IndexPath.init(row: self.cartoonModel!.page_index, section: 0), at: .top, animated: false)
            self.saveHistory()
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
