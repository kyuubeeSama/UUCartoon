//
//  ImageViewScrollView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/11/23.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit

class ImageViewScrollView: UIScrollView,UIScrollViewDelegate {
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        minimumZoomScale = 1
        maximumZoomScale = 3
        contentSize = CGSize(width: screenW, height: screenH)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
