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
        self.delegate = self
        self.minimumZoomScale = 1
        self.maximumZoomScale = 3
        self.contentSize = CGSize(width: screenW, height: screenH)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
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
