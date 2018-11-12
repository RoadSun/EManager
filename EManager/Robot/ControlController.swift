//
//  ControlController.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/12.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class ControlController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
//        let boy = BodyView(frame: self.view.bounds)
        let boy = CirclePan(frame: self.view.bounds)
        self.view.addSubview(boy)
//        boy.snp.makeConstraints { (make) in
//            make.edges.equalTo(self.view)
//        }
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
