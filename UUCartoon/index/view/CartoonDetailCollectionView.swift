//
//  CartoonDetailCollectionView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/8.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import ReactiveCocoa

class CartoonDetailCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var cellItemSelectedBlock:((_ indexPath:IndexPath)->())?
    // 开始阅读
    var readBlock:(()->())?
    // 添加订阅
    var subscribeBlock:(()->())?
    var model:CartoonModel?{
        didSet{
            self.reloadData()
        }
    }
    // 页面分为四个部分。第一部分为封面，标题等信息。第二部分为简介，简介根据内容高度，判断是否折叠。第三部分为剧集列表，剧集列表分区可能有多个。第四部分为推荐漫画，推荐漫画列表不一定有，根据情况判断。
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .systemBackground
        self.register(UINib.init(nibName: "CartoonListCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cartoonCell")
        self.register(UINib.init(nibName: "ChapterCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "chapterCell")
        self.register(UINib.init(nibName: "CartoonIntroCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "introCell")
        self.register(UINib.init(nibName: "CartoonInfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "infoCell")
        self.register(UINib.init(nibName: "CartoonInfoHeaderCollectionReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        self.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3+(model?.chapterArr.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }else if section == 2+(model?.chapterArr.count)!{
            return (self.model?.recommendArr.count)!
        }else{
            return (self.model?.chapterArr[section-2].data.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "infoCell", for: indexPath) as! CartoonInfoCollectionViewCell
            cell.titleLab.text = self.model?.name
            cell.timeLab.text = self.model?.time
            cell.categoryLab.text = self.model?.category
            cell.authorLab.text = self.model?.author
            cell.leftImg.kf.setImage(with: URL.init(string: self.model!.imgUrl), placeholder: UIImage.init(named: "placeholder.jpg"))
            cell.subscribeBtn.isHidden = true
            cell.subscribeBtn.reactive.controlEvents(.touchUpInside).observeValues { button in
                if self.subscribeBlock != nil{
                    self.subscribeBlock!()
                }
            }
            cell.readBtn.reactive.controlEvents(.touchUpInside).observeValues { button in
                if self.readBlock != nil{
                    self.readBlock!()
                }
            }
            return cell
        }else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "introCell", for: indexPath) as! CartoonIntroCollectionViewCell
            cell.titleLab.text = self.model?.desc
            return cell
        }else if indexPath.section == 2+(self.model?.chapterArr.count)!{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartoonCell", for: indexPath) as! CartoonListCollectionViewCell
            cell.setData(cartoonModel: (self.model?.recommendArr[indexPath.row])!)
            return cell
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chapterCell", for: indexPath) as! ChapterCollectionViewCell
            let chapterModel = self.model?.chapterArr[indexPath.section-2].data[indexPath.row]
            cell.titleLab.text = chapterModel?.name
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: screenW, height: 167)
        }else if indexPath.section == 1{
            let size = self.model?.desc.getStringSize(font: UIFont.systemFont(ofSize: 15), size: CGSize(width: screenW-30, height: CGFloat(MAXFLOAT)))
            return CGSize(width: screenW, height: CGFloat(ceilf(Float(size!.height)))+20)
        }else if indexPath.section == 2+(self.model?.chapterArr.count)!{
            return CGSize(width: screenW/3, height: screenW/3*91/56)
        }else{
            return CGSize(width: (screenW-50)/4, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section>1 && section<(2+(self.model?.chapterArr.count)!) {
            return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for chapter in self.model!.chapterArr {
            for var model in chapter.data {
                model.is_choose = false
            }
        }
        self.model?.chapterArr[indexPath.section].data[indexPath.row].is_choose = true
        self.reloadData()
        if self.cellItemSelectedBlock != nil {
            self.cellItemSelectedBlock!(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section>1 && section<(2+(self.model?.chapterArr.count)!) {
            return 10
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! CartoonInfoHeaderCollectionReusableView
            if indexPath.section > 1 {
                if indexPath.section == 2+(self.model?.chapterArr.count)! {
                    header.titleLab.text = "热门推荐"
                    header.leftImg.image = UIImage.init(named: "recommend_header")
                }else{
                    header.titleLab.text = self.model?.chapterArr[indexPath.section-2].name
                    header.leftImg.image = UIImage.init(named: "chapter_header")
                }
            }
            return header
        }else{
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer", for: indexPath)
            footer.backgroundColor = UIColor.init(named: "lineColor")
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section>1 {
            return CGSize(width: screenW, height: 40)
        }else{
            return CGSize(width: screenW, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        CGSize(width: screenW, height: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
