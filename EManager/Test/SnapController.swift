//
//  SnapController.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/6.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class SnapController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
//        let testView = UIView()
//        testView.backgroundColor = UIColor.cyan
//        testView.layer.cornerRadius = 3
//        testView.layer.borderWidth = 1
//        testView.layer.borderColor = UIColor.lightGray.cgColor
//        testView.layer.backgroundColor = UIColor.green.cgColor
//        view.addSubview(testView)
//        testView.snp.makeConstraints { (make) in
//            make.height.width.equalTo(100)        // 高为100
//            make.center.equalToSuperview()      // 位于当前视图的中心
//        }
//        let basicV = SSnapBasicView()
        let basicV = SSnapUpdateView()
        basicV.frame = CGRect(x: 10, y: 94, width: self.view.frame.size.width - 20, height: self.view.frame.size.height - 94 - 50)
        basicV.layer.borderColor = UIColor.gray.cgColor
        basicV.layer.borderWidth = 0.5
        self.view.addSubview(basicV)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
