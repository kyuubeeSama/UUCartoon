//
//  NavView.swift
//  UUCartoon
//
//  Created by Galaxy on 2020/8/7.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit

class NavView: UIView {
    var backBtnBlock:(()->())?
    /// 返回按钮
    lazy var backBtn:UIButton = {
        let backBtn = UIButton.init(type: .custom)
        self.addSubview(backBtn)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        backBtn.setImage(UIImage.init(systemName: "chevron.left"), for: .normal)
        backBtn.setTitle("返回", for: .normal)
        backBtn.setTitleColor(.systemBlue, for: .normal)
        backBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 40))
            make.left.equalToSuperview().offset(20)
        }
        return backBtn
    }()
    
    @objc func backBtnClick(){
        if (self.backBtnBlock != nil) {
            self.backBtnBlock!()
        }
    }
    
    /// 标题
    lazy var titleLab:UILabel = {
        let titleLab = UILabel.init()
        self.addSubview(titleLab)
        titleLab.textAlignment = .center
        titleLab.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(60)
            make.left.equalTo(backBtn.snp.right).offset(10)
            make.right.equalToSuperview().offset(-60)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        return titleLab
    }()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
