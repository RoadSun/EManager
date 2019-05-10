
//
//  SPt.swift
//  EManager
//
//  Created by EX DOLL on 2019/3/28.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
//state 0 不主动动作 1 单点动作 2 向后一个点动作 -2 向前一个点动作 3 轴点 4控制点(贝塞尔使用) 5 十字线 6 重合点

enum SPtState:Int {
    case `default` = 0
    case single = 1
    case front = 2
    case back = -2
    case o = 3
    case control = 4
}

class SPt: NSObject {
    var point = CGPoint.zero
    var state = 0
    var range = 0
    var min = 0
    var max = 0
    var No = 0
    var angle = CGFloat.pi / 2
    var type:SOperationType = .none
    var d = 0 // 方向
    var servoNo:Int = -1
    var servoNoArray:[Int] = [Int]()
    // 0 定点 1 动点
    func servoNo(_ no:Int) ->SPt {
        self.servoNo = no
        return self
    }
    convenience init(point:CGPoint,state:Int,No:Int,Min:Int,Max:Int,Angle:CGFloat = CGFloat.pi / 2,type:SOperationType = .none){
        self.init()
        self.point = point
        self.state = state
        self.min = Min
        self.max = Max
        self.range = Max - Min
        self.No = No
        self.angle = Angle
        self.type = type
    }
}

struct SAngle {
    var angle:CGFloat = 0
    var accurate:CGFloat = 0
    var radian:CGFloat = 0
    var radian_int:CGFloat = 0
    // 转化成弧度
    mutating func setVal(_ val:CGFloat,_ transToRadian:Bool = true){
        if transToRadian {
            var value = val
            if value < 0 {
                value = CGFloat.pi * 2 + val
            }
            // 弧度
            radian = value
            radian_int = CGFloat(Int(value))
            accurate = value * 180.0 / CGFloat.pi
            angle = CGFloat(Int(value * 180.0 / CGFloat.pi))
        }else{
            // 角度
            var value = val
            if value < 0 {
                value = 360.0 + val
            }
            accurate = value
            angle = CGFloat(Int(value))
            radian = value * CGFloat.pi / 180.0
            radian_int = CGFloat(value * CGFloat.pi / 180.0 )
        }
    }
    
    mutating func pi(_ percentage:CGFloat) {
        let val = percentage * CGFloat.pi
        setVal(val)
    }
}
