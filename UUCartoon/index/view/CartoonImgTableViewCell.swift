//
//  CartoonImgTableViewCell.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/8/4.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit

class CartoonImgTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    lazy var imgView: UIImageView = {
        let imgView = UIImageView.init()
        self.contentView.addSubview(imgView)
        imgView.contentMode = .scaleAspectFill
        imgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        return imgView
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
