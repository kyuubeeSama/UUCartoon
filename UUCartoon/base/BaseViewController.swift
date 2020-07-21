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
        self.view.backgroundColor = .white
    }
    
    func setNavColor(navColor:UIColor,titleColor:UIColor,barStyle:UIBarStyle) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = barStyle
        self.navigationController?.navigationBar.barTintColor = navColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:titleColor]
        self.navigationController?.navigationBar.tintColor = titleColor
            let statusBarView = UIView(frame: view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBarView.backgroundColor = navColor
            view.addSubview(statusBarView)
    }
    // 提示消息
    func showAlert(title:String){
        self.view.makeToast(title)
    }
    // 加载中
    func beginProgress(){
        self.view.makeToastActivity(.center)
    }
    // 加载结束
    func endProgress(){
        self.view.hideAllToasts()
        self.view.hideToastActivity()
    }
//    TODO:自定义返回按钮
    func addBackBtn(){
        let navigationBtnItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(backBtnClick(button:)))
            self.navigationItem.leftBarButtonItem = navigationBtnItem
    }
    
    @objc func backBtnClick(button:UIButton?){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
