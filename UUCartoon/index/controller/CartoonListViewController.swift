//
//  CartoonListViewController.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/6.
//  Copyright © 2021 qykj. All rights reserved.
//  漫画列表页面

import UIKit
import JXSegmentedView

class CartoonListViewController: BaseViewController,JXSegmentedListContainerViewListDelegate {
    
    
    // 区分当前是那一列
    public var index:Int = 0
    public var type:CartoonType?
    public var pageNum:Int = 1
    
    @objc func injected(){
        viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if index == 1 {
            makeUI()
        }
        getData()
    }

    func makeUI() {
        let header = RankChooseView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: 50))
        view.addSubview(header)
        header.categoryBtnView.type = type!
        header.categoryBtnView.categoryBtnBlock = { index in

        }
        if type == .ykmh{
            header.siftBtn.rentBtnBlock = {

            }
        }
    }

    func getData() {
        beginProgress()
        DispatchQueue.global().async {
            if self.index == 0 {
                DataTool.init().getNewCartoonData(type: self.type!, pageNum: self.pageNum) { [self] resultArr in
                    DispatchQueue.main.async {
                        self.endProgress()
                        self.mainCollect.listArr = resultArr
                    }
                } failure: { error in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    lazy var mainCollect:CartoonListCollectionView  = {
        let layout = UICollectionViewFlowLayout.init()
        let mainCollect = CartoonListCollectionView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        self.view.addSubview(mainCollect)
        mainCollect.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            if index == 1{
                make.top.equalToSuperview().offset(60)
            }else{
                make.top.equalToSuperview()
            }
        }
        mainCollect.cellItemSelected = { indexPath in
            let VC = ChapterViewController.init()
            self.navigationController?.pushViewController(VC, animated: true)
        }
        return mainCollect
    }()
    
    func listView() -> UIView {
        view
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
