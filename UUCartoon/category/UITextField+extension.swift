//
//  UITextField+extension.swift
//  InsuranceDemo
//
//  Created by liuqingyuan on 2019/12/20.
//  Copyright © 2019 qykj. All rights reserved.
//

import UIKit

extension UITextField {
    func setAttributePlaceHolder(placeHolder:String,color:UIColor){
        let placeAttribute = NSAttributedString.init(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor:color])
        attributedPlaceholder = placeAttribute
    }
}

