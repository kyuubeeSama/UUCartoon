//
//  Array+extension.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/18.
//  Copyright © 2021 qykj. All rights reserved.
//

import Foundation

extension Array {
    mutating func append(array:Array) {
        for item in array {
            self.append(item)
        }
    }
}
