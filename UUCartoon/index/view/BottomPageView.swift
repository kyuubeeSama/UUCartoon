//
//  BottomPageView.swift
//  UUCartoon
//
//  Created by Galaxy on 2022/4/24.
//  Copyright © 2022 qykj. All rights reserved.
//

import UIKit
import SnapKit
class BottomPageView: UIView {

    lazy var currentPageLab: UILabel = {
        let label = UILabel.init()
        addSubview(label)
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor.init(.dm, light: UIColor.color(hexString: "333333"), dark: UIColor.white)
        label.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(self)
            make.width.equalTo(50)
        }
        return label
    }()
    
    lazy var totalPageLab: UILabel = {
        let label = UILabel.init()
        addSubview(label)
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = UIColor.init(.dm, light: UIColor.color(hexString: "333333"), dark: UIColor.white)
        label.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(self)
            make.width.equalTo(50)
        }
        return label
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider.init()
        addSubview(slider)
        slider.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
            make.centerY.equalTo(self)
            make.height.equalTo(20)
        }
        slider.value = 0
        slider.minimumTrackTintColor = .green
        slider.thumbTintColor = .green
        return slider
    }()


}
