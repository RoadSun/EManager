
//
//  VController.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/14.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class VController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false

        let slider = RBSlider(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40)) { (val) in
            print(val)
        }
        self.view.addSubview(slider)
        
        let sliderv = RBSlider(frame: CGRect(x: 5, y: 50, width: 40, height: self.view.frame.size.height - 200), v: 1) { (val) in
            print(val)
        }
        self.view.addSubview(sliderv)
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
