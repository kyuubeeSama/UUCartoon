//
//  ViewController+extension.swift
//  UUCartoon
//
//  Created by Galaxy on 2022/8/19.
//  Copyright © 2022 qykj. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
    func setNavColor(navColor:UIColor,titleColor:UIColor,barStyle:UIBarStyle) {
//        navigationController?.isNavigationBarHidden = false
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.barStyle = barStyle
//        navigationController?.navigationBar.barTintColor = navColor
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:titleColor]
//        navigationController?.navigationBar.tintColor = titleColor
//            let statusBarView = UIView(frame: view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
//            statusBarView.backgroundColor = navColor
//            view.addSubview(statusBarView)
        
//        UINavigationBarAppearance *barApp = [[UINavigationBarAppearance alloc]init];
//        [barApp configureWithOpaqueBackground];
//        barApp.backgroundColor = navColor;
//        barApp.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};
//        [barApp setShadowImage:[UIImage createImageColor:[UIColor clearColor] size:CGSizeMake(screenW, 1)]];
//        [barApp setBackgroundImage:[UIImage createImageColor:[UIColor clearColor] size:CGSizeMake(screenW, 1)]];
//        self.navigationController.navigationBar.standardAppearance = barApp;
//        self.navigationController.navigationBar.scrollEdgeAppearance = barApp;
        
        let barApp = UINavigationBarAppearance.init()
        barApp.configureWithOpaqueBackground()
        barApp.backgroundColor = navColor
        barApp.titleTextAttributes = [NSMutableAttributedString.Key.foregroundColor:titleColor]
        barApp.shadowImage = UIImage.createImage(color: .clear, size: CGSize(width: screenW, height: 1))
        barApp.backgroundImage = UIImage.createImage(color: .clear, size: CGSize(width: screenW, height: 1))
        navigationController?.navigationBar.standardAppearance = barApp
        navigationController?.navigationBar.scrollEdgeAppearance = barApp
        
    }
}
