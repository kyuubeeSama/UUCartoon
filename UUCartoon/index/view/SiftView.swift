//
//  SiftView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/10.
//  Copyright © 2021 qykj. All rights reserved.
// 排序筛选界面

import UIKit

class SiftView: UIView {
    
    public var type:Int = 0
    
    // 点击底部，关闭当前页面
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.color(hexString: "333333", alpha: 0.3)
    }
    
    lazy private var contentView: UIView = {
        let contentView = UIView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: 200))
        self.addSubview(contentView)
        return contentView
    }()
    
    //左侧一个tableview 右侧一个tableView
    lazy var leftTableView: SiftTableView = {
        let leftTableView = SiftTableView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 200), style: .plain)
        self.contentView.addSubview(leftTableView)
        leftTableView.type = 1
        let view = UIView.init()
        view.backgroundColor = UIColor.color(hexString: "d9d9d9")
        leftTableView.backgroundView = view
        return leftTableView
    }()
    
    lazy var rightTableView: SiftTableView = {
        let rightTableView = SiftTableView.init(frame: CGRect(x: 100, y: 0, width: screenW-100, height: 200), style: .plain)
        self.contentView.addSubview(rightTableView)
        rightTableView.type = 2
        return rightTableView
    }()
    
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
