//
//  ViewController.swift
//  EManager
//
//  Created by EX DOLL on 2018/10/31.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit
import SnapKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let testView = UIView()
        testView.backgroundColor = UIColor.cyan
        testView.layer.cornerRadius = 3
        testView.layer.borderWidth = 1
        testView.layer.borderColor = UIColor.lightGray.cgColor
        testView.layer.backgroundColor = UIColor.green.cgColor
        view.addSubview(testView)
        testView.snp.makeConstraints { (make) in
            make.height.width.equalTo(100)        // 高为100
            make.center.equalToSuperview()      // 位于当前视图的中心
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension UIButton {
    
}

