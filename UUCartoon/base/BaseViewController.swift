//
//  BaseViewController.swift
//  swiftdemo
//
//  Created by liuqingyuan on 2018/11/12.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

import UIKit
import Toast_Swift

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        NotificationCenter.default.reactive.notifications(forName: UIApplication.willResignActiveNotification).observeValues { notification in
           let effect = UIBlurEffect.init(style: .extraLight)
            let effectView = UIVisualEffectView.init(effect: effect)
            effectView.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
            effectView.tag = 1990
            effectView.alpha = 0.8
            let window = UIApplication.shared.windows[0]
            window.addSubview(effectView)
        }
        NotificationCenter.default.reactive.notifications(forName: UIApplication.didBecomeActiveNotification).observeValues { notification in
            let window = UIApplication.shared.windows[0]
            if var effectView = window.viewWithTag(1990){
                effectView = effectView as! UIVisualEffectView
                effectView.removeFromSuperview()
            }
        }
    }
    
    func setNavColor(navColor:UIColor,titleColor:UIColor,barStyle:UIBarStyle) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = barStyle
        navigationController?.navigationBar.barTintColor = navColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:titleColor]
        navigationController?.navigationBar.tintColor = titleColor
            let statusBarView = UIView(frame: view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBarView.backgroundColor = navColor
            view.addSubview(statusBarView)
    }
    // 提示消息
    func showAlert(title:String){
        view.makeToast(title)
    }
    // 加载中
    func beginProgress(){
        view.makeToastActivity(.center)
    }
    // 加载结束
    func endProgress(){
        view.hideAllToasts()
        view.hideToastActivity()
    }
//    TODO:自定义返回按钮
    func addBackBtn(){
        let navigationBtnItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(backBtnClick(button:)))
            navigationItem.leftBarButtonItem = navigationBtnItem
    }
    
    @objc func backBtnClick(button:UIButton?){
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
