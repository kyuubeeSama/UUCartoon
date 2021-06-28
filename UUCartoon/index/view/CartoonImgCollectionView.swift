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
        self.delegate = self
        self.dataSource = self
        self.register(CartoonImgCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    public var listArr:[CartoonImgModel] = []{
        didSet{
            self.reloadData()
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.listArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CartoonImgCollectionViewCell
        var model = self.listArr[indexPath.row]
        var imgUrl = model.imgUrl
        if model.type == .ykmh {
            imgUrl = imgUrl.replacingOccurrences(of: "\\", with: "")
            imgUrl = "http://pic.w1fl.com/\(imgUrl)"
        }
        let modifier = AnyModifier { request in
            var r = request
            r.setValue(urlArr[model.type.rawValue], forHTTPHeaderField: "Referer")
            return r
        }
        cell.cartoonImage.kf.setImage(with: URL.init(string: imgUrl), placeholder: UIImage.init(named: "placeholder.jpg"), options: [.requestModifier(modifier)], progressBlock: { receivedSize, totalSize in
            
        }, completionHandler: { result in
            switch result {
            case .success(let value):
                if !model.has_done{
                    model.height = value.image.size.height*screenW/value.image.size.width
                    cell.scrollView.frame = CGRect(x: 0, y: 0, width: model.width, height: model.height)
                    cell.scrollView.contentSize = CGSize(width: model.width, height: model.height)
                    cell.cartoonImage.frame = CGRect(x: 0, y: 0, width: model.width, height: model.height)
                    model.has_done = true
                    print("图片高度是\(model.height)")
                    self.listArr[indexPath.row] = model
                    collectionView.reloadItems(at: [indexPath])
                }
            case .failure(let error):
                //TODO:图片加载失败的问题
                print("Job failed: \(error.localizedDescription)")
            }
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.listArr[indexPath.row]
        if model.width == 0 {
            return CGSize(width: screenW, height: screenH)
        }else{
            return CGSize(width: model.width, height: model.height)
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
