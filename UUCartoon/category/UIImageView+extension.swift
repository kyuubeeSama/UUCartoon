//
// Created by Galaxy on 2021/8/5.
// Copyright (c) 2021 qykj. All rights reserved.
//

import UIKit

extension UIImageView{
    func showGifImage(imagePath:String){
        let gifData = NSData.init(contentsOfFile: imagePath)
        let source = CGImageSourceCreateWithData(gifData!, nil)
        let count = CGImageSourceGetCount(source!)
        var imgArr:[UIImage] = []
        for item in 1...count {
            let imageRef = CGImageSourceCreateImageAtIndex(source!, item-1, nil)
            let image = UIImage.init(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: .up)
            imgArr.append(image)
        }
        animationImages = imgArr
        animationDuration = TimeInterval(imgArr.count)*0.1
        startAnimating()
    }
}
