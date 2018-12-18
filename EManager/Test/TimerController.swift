//
//  TimerController.swift
//  EManager
//
//  Created by EX DOLL on 2018/12/18.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class TimerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setTimer() {
        var second = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            second = second + 1
            let hh:String = String(format: "%02d", (second / (60 * 60)) % (60 * 60))
            let mm:String = String(format: "%02d", (second / 60) % 60)
            let ss:String = String(format: "%02d", second % 60)
            print("\(hh) : \(mm) : \(ss)")
            }.fire()
        
    }

}
