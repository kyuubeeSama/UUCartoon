//
//  CartoonListCollectionView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/7.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit

class CartoonListCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
        self.register(UINib.init(nibName: "CartoonListCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listArr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CartoonListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CartoonListCollectionViewCell
        cell.setData(cartoonModel: listArr![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (cellItemSelected != nil) {
            cellItemSelected!(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Tool.init().isPhone() {
            // 手机上，单行显示
            return CGSize(width: screenW, height: 135)
        }else{
            return CGSize(width: 375, height: 135)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
