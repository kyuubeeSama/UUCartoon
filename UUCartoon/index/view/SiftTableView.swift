//
//  SiftTableView.swift
//  UUCartoon
//
//  Created by Galaxy on 2021/5/10.
//  Copyright © 2021 qykj. All rights reserved.
//

import UIKit

class SiftTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    public var cellItemSelectedBlock:((_ indexPath:IndexPath)->())?
//    type:1.左侧列表，选中改变颜色。2：右侧列表，选中打√
    public var type:Int = 1
    // 被选中的行
    public var index:Int = 0
    public var listArr:[SiftCategoryModel] = []{
        didSet{
            reloadData()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        let model = listArr[indexPath.row]
        cell.textLabel?.text = model.name
        if type == 1 {
            //TODO:此处需要根据在暗黑模式下，调整颜色
            if model.is_choose {
                cell.contentView.backgroundColor = .white
            }else{
                cell.contentView.backgroundColor = UIColor.init(.dm, light: UIColor.color(hexString: "d9d9d9"), dark: .white)
            }
        }else{
            if model.is_choose {
                cell.textLabel?.textColor = .red
            }else{
                cell.textLabel?.textColor = .black
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        for model in listArr {
            model.is_choose = false
        }
        let model = listArr[indexPath.row]
        model.is_choose = true
        if (cellItemSelectedBlock != nil) {
            cellItemSelectedBlock!(indexPath)
        }
        reloadData()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
