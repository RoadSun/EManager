
//
//  SPt.swift
//  EManager
//
//  Created by EX DOLL on 2019/3/28.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SPt: NSObject {
    var point = CGPoint(x: 0, y: 0)
    var state = 0
    var range = 0
    var No = 0
    // 0 定点 1 动点
    convenience init(point:CGPoint,state:Int,No:Int) {
        self.init()
        self.point = point
        self.state = state
        self.No = No
    }
    
}
