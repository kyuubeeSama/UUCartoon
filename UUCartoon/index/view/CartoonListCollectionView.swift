//
//  CartoonListCollectionView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/7.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit

enum CollectionViewCellType:Int {
    case Table = 0
    case Collection = 1
}

class CartoonListCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    public var cellType:CollectionViewCellType = .Table
    
    var listArr:[CartoonModel]?{
        didSet{
            reloadData()
        }
    }
    var cellItemSelected:((_ indexPath:IndexPath)->())?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        self.register(UINib.init(nibName: "CartoonTableListCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "tableCell")
        self.register(UINib.init(nibName: "CartoonListCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "collectionCell")
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listArr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellType == .Table {
            let cell:CartoonTableListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableCell", for: indexPath) as! CartoonTableListCollectionViewCell
            let model = listArr![indexPath.row]
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
        }else{
            let cell:CartoonListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CartoonListCollectionViewCell
            cell.setData(cartoonModel: listArr![indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (cellItemSelected != nil) {
            cellItemSelected!(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellType == .Table {
            if Tool.init().isPhone() {
                // 手机上，单行显示
                return CGSize(width: screenW, height: 135)
            }else{
                return CGSize(width: 375, height: 135)
            }
        }else{
            if Tool.init().isPhone() {
                return CGSize(width: screenW/3, height: screenW/3*91/56)
            }else{
                return CGSize(width: 125, height: 203)
            }
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
}
