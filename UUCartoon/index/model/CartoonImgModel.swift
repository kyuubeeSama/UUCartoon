//
//  CartoonImgModel.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/6/23.
//  Copyright © 2021 qykj. All rights reserved.
//

import Foundation
import CoreGraphics

struct CartoonImgModel {
    public var type:CartoonType = .ykmh
    public var imgUrl:String = ""
    public var width:CGFloat = screenW
    public var height:CGFloat = 0.00
    public var has_done:Bool = false
}
