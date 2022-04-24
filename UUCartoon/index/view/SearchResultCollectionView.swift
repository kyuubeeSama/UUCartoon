//
//  SearchResultCollectionView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/28.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import Kingfisher

class SearchResultCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var cellItemSelected:((_ indexPath:IndexPath)->())?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = .systemBackground
        self.register(UINib.init(nibName: "CartoonTableListCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "tableCell")
    }

    var listArr:[CartoonModel] = []{
        didSet{
            reloadData()
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.listArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CartoonTableListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableCell", for: indexPath) as! CartoonTableListCollectionViewCell
        let model = listArr[indexPath.row]
        cell.setData(cartoonModel: model)
        if model.is_rank {
            cell.rankLab.text = "\(indexPath.row+1)"
            cell.rankView.addRound(radio: 40, corners: UIRectCorner.bottomLeft)
            let colorArr = ["ff4b4b","ff8004","ffc000","dfdfdf"]
            if indexPath.row < 3{
                cell.rankView.backgroundColor = UIColor.color(hexString: colorArr[indexPath.row])
            }else{
                cell.rankView.backgroundColor = UIColor.color(hexString: colorArr[3])
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Tool.init().isPhone() {
            // 手机上，单行显示
            return CGSize(width: screenW, height: 135)
        }else{
            return CGSize(width: 375, height: 135)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (cellItemSelected != nil) {
            cellItemSelected!(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
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
