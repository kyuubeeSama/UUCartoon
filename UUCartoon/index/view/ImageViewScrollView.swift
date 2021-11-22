//
//  ImageViewScrollView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/11/22.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import Kingfisher
class ImageViewScrollView: UIScrollView,UIScrollViewDelegate {
    var currentPageIndex:Int = 0
    var itemWidth:Double = screenW
    private var leftView:UIImageView = UIImageView.init()
    private var middleView:UIImageView = UIImageView.init()
    private var rightView:UIImageView = UIImageView.init()
    // TODO:添加方法，当漫画滚动到最后一页和滚动到第一页时，提示
    var scrollLastPage:(()->())?
    var scrollFirstPage:(()->())?
    var listArr:[CartoonImgModel] = []{
        didSet{
            self.contentSize = CGSize(width: itemWidth*3, height: frame.size.height)
            print("screenH= \(screenH) ,contentsize height = \(self.contentSize.height)")
            reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        setSonViewFrame()
        self.contentInsetAdjustmentBehavior = .never
        itemWidth = frame.size.width
        leftView.contentMode = .scaleAspectFit
        middleView.contentMode = .scaleAspectFit
        middleView.backgroundColor = .yellow
        rightView.contentMode = .scaleAspectFit
        self.addSubview(leftView)
        self.addSubview(middleView)
        self.addSubview(rightView)
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
    }
    
    func setSonViewFrame(){
        itemWidth = frame.size.width
        let height = frame.size.height
        print(screenH)
        leftView.frame = CGRect(x: 0, y: 0, width: itemWidth, height: height)
        middleView.frame = CGRect(x: itemWidth, y: 0, width: itemWidth, height: height)
        rightView.frame = CGRect(x: itemWidth*2, y: 0, width: itemWidth, height: height)
    }

    func reloadData(){
        if (listArr.count != 0){
            var leftModel = CartoonImgModel.init()
            var middleModel = CartoonImgModel.init()
            var rightModel = CartoonImgModel.init()
            if currentPageIndex == 0{
                // 第一位
                //TODO:如果是第一页，左边不能读取最后一页，应该禁止左滑，或者提示到页尾
//                leftModel = listArr.last!
                middleModel = listArr.first!
                rightModel = listArr[1]
            }else if currentPageIndex == listArr.count-1 {
                // 最后一位
                leftModel = listArr[currentPageIndex-1]
                middleModel = listArr[currentPageIndex]
//                rightModel = listArr.first!
            }else{
                leftModel = listArr[currentPageIndex-1]
                middleModel = listArr[currentPageIndex]
                rightModel = listArr[currentPageIndex+1]
            }
            let modifier = AnyModifier { request in
                var r = request
                r.setValue(urlArr[leftModel.type.rawValue], forHTTPHeaderField: "Referer")
                return r
            }
            if !leftModel.imgUrl.isEmpty{
                leftView.kf.setImage(with: URL.init(string: leftModel.imgUrl), placeholder: UIImage.init(named: ""), options: [.requestModifier(modifier)], completionHandler: nil)
            }
            if !rightModel.imgUrl.isEmpty{
                rightView.kf.setImage(with: URL.init(string: rightModel.imgUrl), placeholder: UIImage.init(named: ""), options: [.requestModifier(modifier)], completionHandler: nil)
            }
            middleView.kf.setImage(with: URL.init(string: middleModel.imgUrl), placeholder: UIImage.init(named: ""), options: [.requestModifier(modifier)], completionHandler: nil)
            self.contentOffset = CGPoint(x: itemWidth, y: 0)
        }
    }
    //TODO:判断此处不对
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
//        判断是左移还是右移，如果是左移-1，右移+1,当currentindex小于0或者大于数组长度时，重置数据
        let offsetX = scrollView.contentOffset.x
        if offsetX<screenW{
            // 左移
            currentPageIndex -= 1
        }else if offsetX > screenW{
//            右移
            currentPageIndex += 1
        }
        if currentPageIndex < 0{
            self.scrollFirstPage!()
        }else if currentPageIndex >= listArr.count{
            self.scrollLastPage!()
        }else{
            reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
