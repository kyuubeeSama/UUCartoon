//
//  CartoonImgCollectionView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/22.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import Kingfisher

class CartoonImgCollectionView: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        self.register(CartoonImgCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        isPagingEnabled = true
    }

    public var listArr:[CartoonImgModel] = []{
        didSet{
            reloadData()
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CartoonImgCollectionViewCell
        var model = listArr[indexPath.row]
        let imgUrl = model.imgUrl
        let modifier = AnyModifier { request in
            var r = request
            r.setValue(urlArr[model.type.rawValue], forHTTPHeaderField: "Referer")
            return r
        }
        cell.cartoonImage.kf.setImage(with: URL.init(string: imgUrl), placeholder: UIImage.init(named: "placeholder"), options: [.requestModifier(modifier)], progressBlock: { receivedSize, totalSize in
            
        }, completionHandler: { result in
            switch result {
            case .success(let value):
                if model.has_done == .prepare{
                    model.height = value.image.size.height*screenW/value.image.size.width
                    model.has_done = .success
                    print("图片高度是\(model.height)")
                    self.listArr[indexPath.row] = model
                    collectionView.reloadItems(at: [indexPath])
                }
            case .failure(let error):
                //TODO:图片加载失败的问题
                model.has_done = .fail
                print("Job failed: \(error.localizedDescription)")
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: screenW, height: screenH)
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
