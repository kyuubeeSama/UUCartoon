//
//  NSObject+Tool.swift
//  QYAudio
//
//  Created by liuqingyuan on 2020/5/12.
//  Copyright © 2020 qykj. All rights reserved.
//

import Foundation
import UIKit

extension NSObject{
    func currentViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base!
    }
}
   
