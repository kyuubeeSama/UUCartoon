//
//  ImgLoadingPlaceHolderView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/8/5.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import Kingfisher

class ImgLoadingPlaceHolderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let image = UIImageView.init()
        addSubview(image)
        image.showGifImage(imagePath: Bundle.main.path(forResource: "placeholder", ofType: "gif")!)
        image.center = center
        image.bounds = CGRect(x: 0, y: 0, width: 346, height: 367)
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
extension ImgLoadingPlaceHolderView : Placeholder{

}
