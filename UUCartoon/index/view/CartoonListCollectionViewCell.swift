//
//  CartoonListCollectionViewCell.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/8.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import Kingfisher
class CartoonListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var topImg: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var authorLab: UILabel!
    
    func setData(cartoonModel:CartoonModel)->(){
        
        topImg.kf.setImage(with: URL.init(string: cartoonModel.imgUrl), placeholder: UIImage.init(named: "placeholder.jpg"))
        titleLab.text = cartoonModel.name
        authorLab.text = cartoonModel.author
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
