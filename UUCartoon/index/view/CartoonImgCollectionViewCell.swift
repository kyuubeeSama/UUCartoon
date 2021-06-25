//
//  CartoonImgCollectionViewCell.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/22.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit

class CartoonImgCollectionViewCell: UICollectionViewCell {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init()
        self.contentView.addSubview(scrollView)
        scrollView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        scrollView.contentSize = CGSize(width: screenW, height: screenH)
        return scrollView
    }()
    
    lazy var cartoonImage: UIImageView = {
        let imageView = UIImageView.init()
        self.scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
