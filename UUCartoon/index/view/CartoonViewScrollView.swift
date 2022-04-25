//
//  ImageViewScrollView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/11/22.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import Kingfisher
class CartoonViewScrollView: UIScrollView,UIScrollViewDelegate {
    // 当前位置
    var currentPageIndex:Int = 0
    // 单页面宽
    var itemWidth:Double = screenW
    // TODO:添加方法，当漫画滚动到最后一页和滚动到第一页时，提示
    var scrollLastPage:(()->())?
    var scrollFirstPage:(()->())?
    // 当有页面滚动时
    var scrollDidScrollBlock:((_ currentIndex:Int)->())?
    var listArr:[CartoonImgModel] = []{
        didSet{
            self.contentSize = CGSize(width: itemWidth*3, height: frame.size.height)
            // 预加载图片
            var urlArr:[URL] = []
            for item in listArr {
                urlArr.append(URL.init(string: item.imgUrl)!)
            }
            let prefetcher = ImagePrefetcher.init(urls: urlArr)
            prefetcher.start()
            reloadData()
        }
    }
    
    // 设置当前页面
    public func setCurrentPage(index:Int){
        self.currentPageIndex = index
        self.reloadData()
    }
    
    private lazy var leftView: ImageViewScrollView = {
        let imageView = ImageViewScrollView.init()
        self.addSubview(imageView)
        imageView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        return imageView
    }()
    
    private lazy var middleView: ImageViewScrollView = {
        let imageView = ImageViewScrollView.init()
        self.addSubview(imageView)
        imageView.frame = CGRect(x: screenW, y: 0, width: screenW, height: screenH)
        return imageView
    }()
    
    private lazy var rightView: ImageViewScrollView = {
        let imageView = ImageViewScrollView.init()
        self.addSubview(imageView)
        imageView.frame = CGRect(x: screenW*2, y: 0, width: screenW, height: screenH)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.minimumZoomScale = 1
        self.maximumZoomScale = 3
        self.contentInsetAdjustmentBehavior = .never
        itemWidth = frame.size.width
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
    }

    func reloadData(){
        if (listArr.count != 0){
            var leftModel = CartoonImgModel.init()
            var middleModel = CartoonImgModel.init()
            var rightModel = CartoonImgModel.init()
            if currentPageIndex == 0{
                // 最左边
                //TODO:如果是第一页，左边不能读取最后一页，提示到页尾
                leftModel = listArr.first!
                middleModel = listArr[1]
                rightModel = listArr[2]
            }else if currentPageIndex == listArr.count-1 {
                // 最右边
                leftModel = listArr[currentPageIndex-2]
                middleModel = listArr[currentPageIndex-1]
                rightModel = listArr[currentPageIndex]
            }else{
                leftModel = listArr[currentPageIndex-1]
                middleModel = listArr[currentPageIndex]
                rightModel = listArr[currentPageIndex+1]
            }
            // 设置图片Referer
            let modifier = AnyModifier { request in
                var r = request
                r.setValue(urlArr[leftModel.type.rawValue], forHTTPHeaderField: "Referer")
                return r
            }
            leftView.imageView.kf.setImage(with: URL.init(string: leftModel.imgUrl), placeholder: UIImage.init(named: "placeholder.jpg"), options: [.requestModifier(modifier)], completionHandler: nil)
            rightView.imageView.kf.setImage(with: URL.init(string: rightModel.imgUrl), placeholder: UIImage.init(named: "placeholder.jpg"), options: [.requestModifier(modifier)], completionHandler: nil)
            middleView.imageView.kf.setImage(with: URL.init(string: middleModel.imgUrl), placeholder: UIImage.init(named: "placeholder.jpg"), options: [.requestModifier(modifier)], completionHandler: nil)
            if currentPageIndex == 0 {
                self.contentOffset = CGPoint(x: 0, y: 0)
            }else if currentPageIndex == self.listArr.count-1 {
                self.contentOffset = CGPoint(x: itemWidth*2, y: 0)
            }else{
                self.contentOffset = CGPoint(x: itemWidth, y: 0)
            }
            if self.scrollDidScrollBlock != nil {
                self.scrollDidScrollBlock!(currentPageIndex)
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
//        判断是左移还是右移，如果是左移-1，右移+1,当currentindex小于0或者大于数组长度时，重置数据
        let offsetX = scrollView.contentOffset.x
        if currentPageIndex == self.listArr.count-1 && offsetX<screenW/2*3{
            currentPageIndex -= 1
        }else if offsetX<screenW/2{
            // 左移
            currentPageIndex -= 1
        }else if currentPageIndex == 0 && offsetX > screenW/2 {
            currentPageIndex += 1
        }else if offsetX > screenW/2*3{
//            右移
            currentPageIndex += 1
        }
        if currentPageIndex < 0{
            currentPageIndex = 0
            self.scrollFirstPage!()
        }else if currentPageIndex >= listArr.count{
            currentPageIndex = listArr.count-1
            self.scrollLastPage!()
        }else{
            reloadData()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
