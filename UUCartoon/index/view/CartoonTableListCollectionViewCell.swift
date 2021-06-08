//
//  CartoonTableListCollectionViewCell.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/7.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import Kingfisher
class CartoonTableListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var leftImg: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var authorLab: UILabel!
    @IBOutlet weak var categoryLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    // 最新更新
    @IBOutlet weak var numLab: UILabel!
    @IBOutlet weak var titleConstraintHeight: NSLayoutConstraint!
    // 在排序中，右侧按钮要隐藏
    @IBOutlet weak var rightImg: UIImageView!
    // 排序中，要显示，其他情况隐藏
    @IBOutlet weak var rankLab: UILabel!
    
    func setData(cartoonModel:CartoonModel) {
        let titleSize = cartoonModel.name.getStringSize(font: UIFont.systemFont(ofSize: 15), size: CGSize(width: screenW-116, height: CGFloat(MAXFLOAT)))
        titleLab.text = cartoonModel.name
        titleConstraintHeight.constant = CGFloat(ceilf(Float(titleSize.height)))
        leftImg.kf.setImage(with: URL.init(string: cartoonModel.imgUrl), placeholder: UIImage.init(named: "placeholder.jpg"), options: nil, completionHandler: nil)
        authorLab.text = cartoonModel.author
        categoryLab.text = cartoonModel.category
        timeLab.text = cartoonModel.time
        if cartoonModel.type == .ykmh {
            let numArr = cartoonModel.num.split(separator: " ")
            numLab.text = String(numArr[0])
        }else{
            numLab.text = cartoonModel.num
        }
        if cartoonModel.is_rank == true {
            rankLab.isHidden = false
            numLab.isHidden = true
            rightImg.isHidden = true
        }else{
            rankLab.isHidden = true
            numLab.isHidden = false
            rightImg.isHidden = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
