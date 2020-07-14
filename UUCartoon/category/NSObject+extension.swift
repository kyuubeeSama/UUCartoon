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
    static func currentViewController() -> UIViewController {
        var VC:UIViewController = objc_getAssociatedObject(self, #function) as! UIViewController
        VC = UIApplication.topViewControllerWithRootViewController(rootViewController: UIApplication.shared.windows[0].rootViewController!)
        return VC
    }
    
    static func topViewControllerWithRootViewController(rootViewController:UIViewController) -> UIViewController{
        if rootViewController.isKind(of: UITabBarController.self) {
            let tabBarController:UITabBarController = rootViewController as! UITabBarController
            return self.topViewControllerWithRootViewController(rootViewController: tabBarController)
        }else if(rootViewController.isKind(of:UINavigationController.self)){
            let navigationController:UINavigationController = rootViewController as! UINavigationController
            return self.topViewControllerWithRootViewController(rootViewController: navigationController.presentedViewController!)
        }else if((rootViewController.presentedViewController) != nil){
            let presentedViewController:UIViewController = rootViewController.presentedViewController!
            return self.topViewControllerWithRootViewController(rootViewController: presentedViewController)
        }else{
            return rootViewController
        }
    }
}
