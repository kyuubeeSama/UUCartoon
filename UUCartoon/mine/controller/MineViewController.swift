//
//  MineViewController.swift
//  UUCartoon
//
//  Created by kyuubee on 2020/7/15.
//  Copyright © 2020 qykj. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController,UITableViewDataSource, UITableViewDelegate {
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.makeUI()
    }
    
    func makeUI() {
        let maintable = UITableView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH), style: .plain)
        maintable.delegate = self
        maintable.dataSource = self
        self.view.addSubview(maintable)
    }
    
    lazy var listArr:[String] = {
        let listArr = ["我的收藏","清理缓存"]
        return listArr
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.listArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
