//
//  BaseViewController.swift
//  swiftdemo
//
//  Created by liuqingyuan on 2018/11/12.
//  Copyright © 2018 liuqingyuan. All rights reserved.
//

import UIKit
import Toast_Swift
import ESPullToRefresh

class BaseViewController: UIViewController {
    var header: ESRefreshHeaderAnimator {
        get {
            let h = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
            h.pullToRefreshDescription = "下拉刷新"
            h.releaseToRefreshDescription = "松开获取最新数据"
            h.loadingDescription = "下拉刷新..."
            return h
        }
    }
    var footer: ESRefreshFooterAnimator {
        get {
            let f = ESRefreshFooterAnimator.init(frame: CGRect.zero)
            f.loadingMoreDescription = "上拉加载更多"
            f.noMoreDataDescription = "数据已加载完"
            f.loadingDescription = "加载更多..."
            return f
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNav()
    }
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
            if var effectView = window.viewWithTag(1990) {
                effectView = effectView as! UIVisualEffectView
                effectView.removeFromSuperview()
            }
        }
    }
    func setNav() {
    }
    // 提示消息
    func showAlert(title: String) {
        view.makeToast(title, position: .center)
    }
    // 加载中
    func beginProgress() {
        view.makeToastActivity(.center)
    }
    // 加载结束
    func endProgress() {
        view.hideAllToasts()
        view.hideToastActivity()
    }
    //    TODO:自定义返回按钮
    func addBackBtn() {
        let navigationBtnItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(backBtnClick(button:)))
        navigationItem.leftBarButtonItem = navigationBtnItem
    }
    @objc func backBtnClick(button: UIButton?) {
        navigationController?.popViewController(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
