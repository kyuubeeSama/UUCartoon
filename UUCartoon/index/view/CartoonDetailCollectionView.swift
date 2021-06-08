//
//  CartoonDetailCollectionView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/8.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit

class CartoonDetailCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var cellItemSelectedBlock:((_ indexPath:IndexPath)->())?
    // 页面分为四个部分。第一部分为封面，标题等信息。第二部分为简介，简介根据内容高度，判断是否折叠。第三部分为剧集列表，剧集列表分区可能有多个。第四部分为推荐漫画，推荐漫画列表不一定有，根据情况判断。
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.delegate = self
        self.dataSource = self
        self.register(UINib.init(nibName: "CartoonListCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cartoonCell")
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartoonCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.cellItemSelectedBlock != nil {
            self.cellItemSelectedBlock!(indexPath)
        }
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
