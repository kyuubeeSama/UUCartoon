//
//  FzdmPadViewController.swift
//  UUCartoon
//
//  Created by liuqingyuan on 2020/8/3.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit
import FluentDarkModeKit

class FzdmPadViewController: BaseViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var CartoonArr:[CartoonModel] = []
    var ChapterArr:[ChapterModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getData()
        print("屏幕宽 \(screenW) 屏幕高是\(screenH)")
    }
    
    //获取数据
    func getData(){
        self.beginProgress()
        QYRequestData.shared.getHtmlContent(urlStr: "https://manhua.fzdm.com", params: nil, success: { (result) in
            self.endProgress()
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
            self.mainTable.reloadData()
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
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    lazy var mainTable:UITableView = {
        let mainTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        mainTable.delegate = self
        mainTable.dataSource = self
        self.view.addSubview(mainTable)
        mainTable.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(200)
        }
        return mainTable
    }()

    lazy var mainCollection:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH), collectionViewLayout: layout)
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UINib.init(nibName: "ChapterCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "chapterCell")
        collectionView.register(UINib.init(nibName: "CartoonCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cartoonCell")
        collectionView.register(UINib.init(nibName: "HeaderCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
//        collectionView.backgroundColor = UIColor.init(.dm, light: .white, dark: .black)
        collectionView.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(self.mainTable.snp.right)
        }
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CartoonArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let model = CartoonArr[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartoonCell", for: indexPath) as! CartoonCollectionViewCell
            cell.titleLab.text = model.name
            cell.topImg.kf.setImage(with: URL.init(string: model.pic!), placeholder: UIImage.init(named: ""))
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 100, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // 点击进入漫画介绍页面
            let model = self.CartoonArr[indexPath.row]
            let VC = CartoonDetailViewController.init()
            VC.model = model
            self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenW, height: 40)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChapterArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = ChapterArr[indexPath.row]
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = model.name
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:ChapterModel = self.ChapterArr[indexPath.row]
        let VC = ChapterViewController.init()
        model.url = "https://manhua.fzdm.com/"+model.url!
        VC.model = model
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
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
