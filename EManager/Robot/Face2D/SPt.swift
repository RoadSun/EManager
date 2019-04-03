
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
    var min = 0
    var max = 0
    var No = 0
    var angle = CGFloat.pi / 2
    // 0 定点 1 动点
    
    convenience init(point:CGPoint,state:Int,No:Int,Min:Int,Max:Int,Angle:CGFloat = CGFloat.pi / 2){
        self.init()
        self.point = point
        self.state = state
        self.min = Min
        self.max = Max
        self.range = Max - Min
        self.No = No
        self.angle = Angle
    }
}
