//
//  RankChooseView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/8.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class CategoryBtnView:UIView {
    var categoryBtnBlock:((_ index:Int)->())?

    var type:CartoonType = .ykmh {
        didSet{
            let titleArr = [["人气排行","点击排行","订阅排行"],["今日最热","最多人看","最受好评"]]
            for item in 0...2 {
                // 创建三个按钮，根据不同的type，显示不同的文字
                let categoryBtn = UIButton.init(type: .custom)
                addSubview(categoryBtn)
                categoryBtn.setTitle(titleArr[type.rawValue][item], for: .normal)
                if item == 0 {
                    categoryBtn.setTitleColor(.white, for: .normal)
                    categoryBtn.backgroundColor = UIColor.color(hexString: "0090ff")
                }else{
                    categoryBtn.setTitleColor(UIColor.init(.dm, light: .black, dark: .white), for: .normal)
                    categoryBtn.backgroundColor = UIColor.init(.dm, light: .white, dark: .black)
                }
                
                categoryBtn.tag = 700+item
                categoryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                categoryBtn.frame = CGRect(x: 70*item, y: 0, width: 69, height: 30)
                categoryBtn.reactive.controlEvents(.touchUpInside).observeValues { button in
    //                修改按钮，同时修改其他按钮为白色
                    for index in 0...2 {
                        let btn:UIButton = self.viewWithTag(700+index)! as! UIButton
                        btn.setTitleColor(UIColor.init(.dm, light: .black, dark: .white), for: .normal)
                        btn.backgroundColor = UIColor.init(.dm, light: .white, dark: .black)
                    }
                    
                    button.setTitleColor(.white, for: .normal)
                    button.backgroundColor = UIColor.color(hexString: "0090ff")
                    
                    if (self.categoryBtnBlock != nil) {
                        self.categoryBtnBlock!(item)
                    }
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        layer.cornerRadius = 3
        layer.borderWidth = 1
        layer.borderColor = UIColor.init(named: "lineColor")?.cgColor
        
        // 添加分割线
        for item in 1...2 {
            let lineLayer = CALayer.init()
            layer.addSublayer(lineLayer)
            lineLayer.frame = CGRect(x: 70*item-1, y: 0, width: 1, height: 30)
            lineLayer.backgroundColor = UIColor.init(named: "lineColor")?.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SiftBtn:UIButton {
    var rentBtnBlock:(()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("筛选", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor.color(hexString: "0090ff")
        layer.masksToBounds = true
        layer.cornerRadius = 4
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        reactive.controlEvents(.touchUpInside).observeValues { button in
            //TODO:添加筛选点击事件
            if self.rentBtnBlock != nil{
                self.rentBtnBlock!()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RankChooseView: UIView {
    // 左侧三个按钮
    lazy var categoryBtnView: CategoryBtnView = {
        let categoryBtnView = CategoryBtnView.init(frame: CGRect(x: 10, y: 10, width: 210, height: 30))
        self.addSubview(categoryBtnView)
        return categoryBtnView
    }()
    
    // 右侧一个按钮，右侧按钮可能不显示
    lazy var siftBtn: SiftBtn = {
        let siftBtn = SiftBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.addSubview(siftBtn)
        siftBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 60, height: 30))
            make.centerY.equalToSuperview()
        }
        return siftBtn
    }()
        
    
    
}
