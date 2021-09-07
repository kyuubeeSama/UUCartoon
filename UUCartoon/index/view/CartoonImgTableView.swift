//
//  CartoonImgTableView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/8/4.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit
import Kingfisher

class CartoonImgTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var listArr:[CartoonImgModel] = []{
        didSet{
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.estimatedRowHeight = 0
        self.estimatedSectionFooterHeight = 0
        self.estimatedSectionHeaderHeight = 0
        self.delegate = self
        self.dataSource = self
        self .register(CartoonImgTableViewCell.self, forCellReuseIdentifier: "cell")
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CartoonImgTableViewCell
        var model = listArr[indexPath.row]
        var imgUrl = model.imgUrl
        if model.type == .ykmh {
            imgUrl = imgUrl.replacingOccurrences(of: "\\", with: "")
            imgUrl = "http://pic.w1fl.com\(imgUrl)"
        }
        let modifier = AnyModifier { request in
            var r = request
            r.setValue(urlArr[model.type.rawValue], forHTTPHeaderField: "Referer")
            return r
        }
        print(imgUrl)
        if model.has_done == .success || model.has_done == .prepare {
            cell.imgView.kf.setImage(with: URL.init(string: imgUrl), placeholder: ImgLoadingPlaceHolderView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH)), options: [.requestModifier(modifier)], progressBlock: { receivedSize, totalSize in
            }, completionHandler: { result in
                switch result {
                case .success(let value):
                    if model.has_done == .prepare {
                        model.height = value.image.size.height*screenW/value.image.size.width
                        model.has_done = .success
                        self.listArr[indexPath.row] = model
                        self.reloadRows(at: [indexPath], with: .none)
                    }
                case .failure(let error):
                    //TODO:图片加载失败的问题
                    print("图片加载失败， \(error.localizedDescription)")
                    model.height = 500
                    model.has_done = .fail
                    self.listArr[indexPath.row] = model
                    self.reloadRows(at: [indexPath], with: .none)
                }
            })
        }else{
            cell.imgView.image = UIImage.init(named: "placeholder.jpg")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = listArr[indexPath.row]
        if model.height == 0 {
            return screenH
        }else{
            return model.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model = listArr[indexPath.row]
        if model.has_done == .fail{
            let cell = tableView.cellForRow(at: indexPath) as! CartoonImgTableViewCell
            cell.imgView.image = UIImage.init()
            model.has_done = .prepare
            model.height = 0
            listArr[indexPath.row] = model
        }
        self.reloadRows(at: [indexPath], with: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
