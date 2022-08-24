//
//  CartoonInfoCollectionViewCell.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/8.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit

class CartoonInfoCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var leftImg: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var authorLab: UILabel!
    @IBOutlet weak var categoryLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var readBtn: UIButton!
    @IBOutlet weak var subscribeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        leftImg.layer.masksToBounds = true
        leftImg.layer.cornerRadius = 3
        leftImg.layer.borderColor = UIColor.white.cgColor
        leftImg.layer.borderWidth = 2
        
        subscribeBtn.layer.masksToBounds = true
        subscribeBtn.layer.cornerRadius = 3
        subscribeBtn.layer.borderColor = UIColor.white.cgColor
        subscribeBtn.layer.borderWidth = 1
        
        readBtn.layer.masksToBounds = true
        readBtn.layer.cornerRadius = 3
        readBtn.layer.borderColor = UIColor.white.cgColor
        readBtn.layer.borderWidth = 1
    }
    
}
