//
//  CartoonImgCollectionViewCell.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/22.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import SnapKit
class CartoonImgCollectionViewCell: UICollectionViewCell {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init()
        self.contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return scrollView
    }()
    
    lazy var cartoonImage: UIImageView = {
        let imageView = UIImageView.init()
        self.scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
