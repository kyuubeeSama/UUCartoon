//
//  ChapterViewController.swift
//  UUCartoon
//
//  Created by liuqingyuan on 2020/7/31.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit

class ChapterViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout/*,UIScrollViewDelegate*/ {
    var model:ChapterModel?
    var listArr:[PictureModel] = []
    var pageNum = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getData()
    }
    
    func getData(){
        self.beginProgress()
        let urlStr = (model?.url)!+"index_\(pageNum).html"
//        let urlStr = "https://manhua.fzdm.com/144/22/index_21.html"
        QYRequestData.init().getHtmlContent(urlStr: urlStr, params:nil) { [self] (html) in
            self.endProgress()
            print(html)
//            mhurl=([\s\S]+?)"
            var imgStr:String = Tool.init().getRegularData(regularExpress: "mhurl=\"([\\s\\S]+?)\"", content: html)[0]
            imgStr = imgStr.replacingOccurrences(of: "mhurl=\"", with: "")
            imgStr = imgStr.replacingOccurrences(of: "\"", with: "")
            let model = PictureModel.init()
            model.url = "http://p1.manhuapan.com/"+imgStr
            model.width = 0
            model.height = 0
            // 获取是否有下一页
            if html.contains("下一页"){
                // 有下一页
                // 更新页码
                self.pageNum += 1
                self.listArr.append(model)
                self.listArr.append(PictureModel.init())
                self.mainCollection.reloadData()
            }else if html.contains("下一话吧"){
                // 没有下一页
                // 获取下一章地址，重置页码
//                最后一页了([\s\S]+?)<\/a>
                let lastStr:String = Tool.init().getRegularData(regularExpress: "最后一页了([\\s\\S]+?)<\\/a>", content: html)[0]
                //                href="([\s\S]+?)"
                var nextUrlStr:String = Tool.init().getRegularData(regularExpress: "href=\"([\\s\\S]+?)\"", content: lastStr)[0]
                nextUrlStr = nextUrlStr.replacingOccurrences(of: "href=\"", with: "")
                nextUrlStr = nextUrlStr.replacingOccurrences(of: "\"", with: "")
                nextUrlStr = nextUrlStr.replacingOccurrences(of: "..", with: "")
                self.model?.url = nextUrlStr
                self.pageNum = 0
                self.listArr.append(model)
                self.listArr.append(PictureModel.init())
                self.mainCollection.reloadData()
            }else{
//                最新一话  提示到头了
                self.listArr.append(model)
                self.mainCollection.reloadData()
            }
        } failure: { (error) in
            
        };
    }
    
    lazy var mainCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        // 设置滚动方向  设置水平滚动
        layout.scrollDirection = .horizontal
        let collection = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH), collectionViewLayout: layout)
        collection.register(UINib.init(nibName: "ChapterDetailCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        self.view.addSubview(collection)
        collection.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        return collection
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChapterDetailCollectionViewCell
        let picModel = self.listArr[indexPath.row]
        cell.imgView.kf.indicatorType = .activity
        if picModel.url != nil && (picModel.url)!.count > 0 {
            cell.imgView.kf.setImage(with: URL.init(string: picModel.url!), placeholder: UIImage.init(named: ""), options: .none) { (receivedSize, totalSize) in
                
            } completionHandler: { (result) in
                switch result{
                case .success(let image):
                    print("width:\(image.image.size.width),height:\(image.image.size.height)")
                case .failure(let error):
                    print(error.localizedDescription)
                
                }
            }
        }else{
            self.listArr.removeLast()
            self.getData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Int(screenW), height: Int(screenH-(top_height)))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
//        if translatedPoint.x<0 {
//            print("right")
//        }else{
//            print("left")
//        }
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
