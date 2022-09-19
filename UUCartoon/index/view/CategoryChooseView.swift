//
//  CategoryChooseView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/7.
//  Copyright © 2021 qykj. All rights reserved.
//  分类选择的view，主要实现切换作用

import UIKit
import ReactiveCocoa

class CategoryChooseView: UIView {

    var btnClickBlock:((_ index:Int)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.color(hexString: "e9e9e9")
        backgroundColor = UIColor(.dm,light: UIColor.color(hexString: "e9e9e9"),dark: UIColor.color(hexString: "696969"))
        let titleArr = ["题材","读者","进度","地域"];
        for item in 0...3 {
//            四个按钮，按钮旁边加箭头图片，并根据选中与否修改图片
            let button = UIButton.init(type: .custom)
            addSubview(button)
//            1296db  选中颜色
            button.setTitle(titleArr[item], for: .normal)
            button.setTitleColor(UIColor.init(named: "333333"), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setImage(UIImage.init(named: "category_row_close"), for: .normal)
            button.backgroundColor = .systemBackground
            button.frame = CGRect(x: screenW/4*CGFloat(item), y: 0, width: screenW/4, height: 40)
            button.layoutButton(style: .Right, imageTitleSpace: 10)
            button.tag = 150+item;
            button.reactive.controlEvents(.touchUpInside).observeValues { (button: UIButton) in
                // 将当前按钮之外的其他按钮颜色和选中状态都修改为默认
                for i in 150...153{
                    let btn = self.viewWithTag(i) as! UIButton
                    if 150+item != i {
                        btn.isSelected = false
                        btn.setImage(UIImage.init(named: "category_row_close"), for: .normal)
                        btn.setTitleColor(UIColor.init(named: "333333"), for: .normal)
                    }
                }
                button.isSelected = !button.isSelected
                if button.isSelected {
                    button.setImage(UIImage.init(named: "category_row_open"), for: .normal)
                    button.setTitleColor(UIColor.color(hexString: "1296db"), for: .normal)
                }else{
                    button.setImage(UIImage.init(named: "category_row_close"), for: .normal)
                    button.setTitleColor(UIColor.init(named: "333333"), for: .normal)
                }
                if self.btnClickBlock != nil {
                    self.btnClickBlock!(item)
                }
            }
        }

        let titleView = UIView.init()
        addSubview(titleView)
        titleView.backgroundColor = .systemBackground
        titleView.frame = CGRect(x: 0, y: 50, width: screenW, height: 40)

        let titleLab = UILabel.init()
        titleView.addSubview(titleLab)
        titleLab.text = "筛选结果"
        titleLab.font = UIFont.systemFont(ofSize: 15)
        titleLab.textColor = UIColor.init(named: "333333")
        titleLab.frame = CGRect(x: 10, y: 10, width: 150, height: 20)

//        此处按钮为倒序安装
        let btnTitleArr = ["发布","更新","点击"]
        for item in 1...3 {
            let button = UIButton.init(type: .custom)
            titleView.addSubview(button)
            button.setTitle(btnTitleArr[item-1], for: .normal)
            if item == 1 {
                button.clickLevel = 1;
                button.setTitleColor(UIColor.color(hexString: "1296db"), for: .normal)
            }else{
                button.clickLevel = 0;
                button.setTitleColor(UIColor.init(named: "333333"), for: .normal)
            }
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setImage(UIImage.init(named: "category_order_down"), for: .normal)
            button.frame = CGRect(x: Int(screenW)-10-60*item, y: 0, width: 60, height: 40)
            button.layoutButton(style: .Right, imageTitleSpace: 5)
            button.tag = 160+item
            button.reactive.controlEvents(.touchUpInside).observeValues { (button: UIButton) in
                for i in 161...163{
                    let btn = self.viewWithTag(i) as! UIButton
                    if 160+item != i {
                        btn.clickLevel = 0;
                        btn.isSelected = false
                        button.setImage(UIImage.init(named: "category_order_down"), for: .normal)
                        btn.setTitleColor(UIColor.init(named: "333333"), for: .normal)
                    }
                }
                button.setTitleColor(UIColor.color(hexString: "1296db"), for: .normal)
                if button.clickLevel == 0 || button.clickLevel == 2{
                    button.clickLevel = 1;
                    button.setImage(UIImage.init(named: "category_order_down"), for: .normal)
                }else if button.clickLevel == 1{
                    button.clickLevel = 2;
                    button.setImage(UIImage.init(named: "category_order_up"), for: .normal)
                }
                if self.btnClickBlock != nil {
                    self.btnClickBlock!(10+item)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
