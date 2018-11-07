//
//  ViewController.swift
//  EManager
//
//  Created by EX DOLL on 2018/10/31.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit
import SnapKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return FilePages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilePages[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identify)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identify)
            cell?.selectionStyle = .none
        }
        cell?.textLabel?.text = FilePages[indexPath.section][indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"]as!String
        let vcClass = NSClassFromString(namespace+"."+FilePagesNames[FilePages[indexPath.section][indexPath.row]]!)!as!UIViewController.Type
        self.navigationController?.pushViewController(vcClass.init(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = self.list
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    lazy var list:UITableView = {
        let table = UITableView(frame: self.view.frame, style: .grouped)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        return table
    }()
}
extension UIButton {
    
}

