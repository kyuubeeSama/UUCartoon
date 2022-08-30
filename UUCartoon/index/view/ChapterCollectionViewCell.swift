//
//  ChapterCollectionViewCell.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/8.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit

class ChapterCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var titleLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLab.layer.masksToBounds = true
        titleLab.layer.cornerRadius = 3
        titleLab.layer.borderWidth = 1
        titleLab.layer.borderColor = UIColor.init(named: "lineColor")?.cgColor
    }

}
