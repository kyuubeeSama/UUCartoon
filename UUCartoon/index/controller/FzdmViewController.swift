//
//  FzdmViewController.swift
//  UUCartoon
//
//  Created by kyuubee on 2020/7/17.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit
import Kingfisher
class FzdmViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var CartoonArr:[CartoonModel] = []
    var ChapterArr:[ChapterModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setNav()
        self .getData()
    }
    
    func setNav(){
        self.title = "风之动漫"
        self.addBackBtn()
    }
    //获取数据
    func getData(){
        QYRequestData.sharedInstance.getHtmlContent(urlStr: "https://manhua.fzdm.com", params: nil, success: { (result) in
//            print(result)
            // 从截取的数据中获取两个数组
            // 最新更新  chapterArr
            //获取更新的div
            //            mhnew"([\s\S]+?)<\/ul>
            let mhnew:[String] = Tool.init().getRegularData(regularExpress: "mhnew\"([\\s\\S]+?)<\\/ul>", content: result)
            //获取具体的一行
            //            li([\s\S]+?)<\/li>
            let chapterStrArr:[String] = Tool.init().getRegularData(regularExpress: "li([\\s\\S]+?)<\\/li>", content: mhnew[0])
            
            for row in chapterStrArr{
                let model = ChapterModel.init()
                //            标题
                //            ">([\s\S]+?)<\/a>
                var title = Tool.init().getRegularData(regularExpress: "\">([\\s\\S]+?)<\\/a>", content: row)[0]
                title = title.replacingOccurrences(of: "\">", with: "")
                title = title.replacingOccurrences(of: "</a>", with: "")
                model.name = title
                //            详情地址
                //            href="([\s\S]+?)"
                var url = Tool.init().getRegularData(regularExpress: "href=\"([\\s\\S]+?)\"", content: row)[0]
                url = url.replacingOccurrences(of: "href=\"", with: "")
                url = url.replacingOccurrences(of: "\"", with: "")
                model.url = url
                self.ChapterArr.append(model)
            }
            // 所有漫画列表  cartoonArr
            //            mhmain"([\s\S]+?)<\/ul>
            let mhmain:[String] = Tool.init().getRegularData(regularExpress: "mhmain\"([\\s\\S]+?)<\\/ul>", content: result)
            //            round"([\s\S]+?)<\/div>
            let cartoonStrArr:[String] = Tool.init().getRegularData(regularExpress: "round\"([\\s\\S]+?)<\\/div>", content: mhmain[0])
            for row in cartoonStrArr {
                //            标题
                //            title="([\s\S]+?)"
                let model = CartoonModel.init()
                var titleStr = Tool.init().getRegularData(regularExpress: "title=\"([\\s\\S]+?)\"", content: row)[0]
                titleStr = titleStr.replacingOccurrences(of: "title=\"", with: "")
                titleStr = titleStr.replacingOccurrences(of: "\"", with: "")
                model.name = titleStr
                //            封面地址
                //            src="([\s\S]+?)"
                var picStr = Tool.init().getRegularData(regularExpress: "src=\"([\\s\\S]+?)\"", content: row)[0]
                picStr = picStr.replacingOccurrences(of: "src=\"", with: "")
                picStr = picStr.replacingOccurrences(of: "\"", with: "")
                model.pic = picStr
                //            详情地址
                //            href="([\s\S]+?)"
                var urlStr = Tool.init().getRegularData(regularExpress: "href=\"([\\s\\S]+?)\"", content: row)[0]
                urlStr = urlStr.replacingOccurrences(of: "href=\"", with: "")
                urlStr = urlStr.replacingOccurrences(of: "\"", with: "")
                model.url = urlStr
                self.CartoonArr.append(model)
            }
            self.mainCollection.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    lazy var mainCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH), collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "ChapterCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "chapterCell")
        collectionView.register(UINib.init(nibName: "CartoonCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cartoonCell")
        collectionView.register(UINib.init(nibName: "HeaderCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.backgroundColor = .white
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        return collectionView
    }()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            print(ChapterArr.count)
            return ChapterArr.count
        }else{
            print(CartoonArr.count)
            return CartoonArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let model = ChapterArr[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chapterCell", for: indexPath) as! ChapterCollectionViewCell
            cell.titleLab.text = model.name
            return cell
        }else{
            let model = CartoonArr[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartoonCell", for: indexPath) as! CartoonCollectionViewCell
            cell.titleLab.text = model.name
            cell.topImg.kf.setImage(with: URL.init(string: model.pic!), placeholder: UIImage.init(named: ""))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: screenW, height: 40)
        }else{
            return CGSize(width: 100, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // 点击直接进入漫画阅读
        }else{
            // 点击进入漫画介绍页面
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerView:HeaderCollectionReusableView!
        if kind == UICollectionView.elementKindSectionHeader {
            headerView = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! HeaderCollectionReusableView)
            if indexPath.section == 0 {
                headerView.titleLab.text = "最新更新"
            }else{
                headerView.titleLab.text = "在线漫画"
            }
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenW, height: 40)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        0.0
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
