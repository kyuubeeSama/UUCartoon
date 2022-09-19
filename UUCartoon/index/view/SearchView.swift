//
//  SearchView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/16.
//  Copyright © 2021 qykj. All rights reserved.
//  搜索框

import UIKit

class SearchView: UIView {
    lazy var textField: UITextField = {
        let textField = UITextField.init()
        self .addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().offset(-10)
        }
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.init(named: "lineColor")?.cgColor
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 4
        let leftView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftView.image = UIImage.init(systemName: "magnifyingglass")
        textField.leftView = leftView
        textField.leftViewMode = .always
        return textField
    }()

}
