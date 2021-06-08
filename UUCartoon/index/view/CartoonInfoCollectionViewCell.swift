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
        self.leftImg.layer.masksToBounds = true
        self.leftImg.layer.cornerRadius = 3
        self.leftImg.layer.borderColor = UIColor.white.cgColor
        self.leftImg.layer.borderWidth = 2
        
        self.subscribeBtn.layer.masksToBounds = true
        self.subscribeBtn.layer.cornerRadius = 3
        self.subscribeBtn.layer.borderColor = UIColor.white.cgColor
        self.subscribeBtn.layer.borderWidth = 1
        
        self.readBtn.layer.masksToBounds = true
        self.readBtn.layer.cornerRadius = 3
        self.readBtn.layer.borderColor = UIColor.white.cgColor
        self.readBtn.layer.borderWidth = 1
    }
    
}
