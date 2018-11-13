//
//  RobotHandle.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/13.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit
struct AngleRange {
    // 初始角度 结束角度 初始弧度 结束弧度 象限 符号
    var start:CGFloat = 0
    var end:CGFloat = 180
    var x:CGFloat = 0
    var y:CGFloat = 0
    var angle:CGFloat = 0
    var quadrant:Int = 1
}
// coordinate
func adjustRange(_ start:CGFloat,_ end:CGFloat, moving m_point: CGPoint, fixed f_point: CGPoint) -> AngleRange {
    var range = AngleRange()
    range.start = start
    range.end = end
    
    let x = m_point.x - f_point.x
    let y = m_point.y - f_point.y
    
    let edge_c = sqrt(pow(x, 2.0) + pow(y, 2.0))
    var standard_x:CGFloat = 0.0
    var standard_y:CGFloat = 0.0
    let ratio = 100 / edge_c
    
    var int_angle:CGFloat = 0.0
    
    if x > 0 && y <= 0 {
        range.quadrant = 1
        int_angle = asin(abs(y)/edge_c)
    }else if (x <= 0 && y < 0) {
        range.quadrant = 2
        int_angle = acos(abs(y)/edge_c) + CGFloat.pi*0.5
    }else if (x < 0 && y >= 0) {
        range.quadrant = 3
        int_angle = asin(abs(y)/edge_c) + CGFloat.pi
    }else if (x >= 0 && y > 0) {
        range.quadrant = 4
        int_angle = acos(abs(y)/edge_c) + CGFloat.pi*1.5
    }
    
    range.angle = (180.0/CGFloat.pi)*int_angle
    
    print(range.angle)
    standard_x = CGFloat(x * ratio) + f_point.x
    standard_y = CGFloat(y * ratio) + f_point.y
    
    // 添加范围
    if range.angle < start {
        let sta = start.truncatingRemainder(dividingBy: 90)
        let sta2 = sta / 90 == 1 || sta == 0 ? 90 : sta
        let startY = 100 / sin((CGFloat.pi / 180)*sta2)
        standard_y = startY + f_point.y
    }
    
    if range.angle > end {
        let en = end.truncatingRemainder(dividingBy: 90)
        let en2 = en / 90 == 1 || en == 0 ? 90 : en
        let endY = 100 / sin((CGFloat.pi / 180)*en2)
        standard_y = endY + f_point.y
    }
    
    range.x = standard_x
    range.y = standard_y
    
    return range
}

class RobotHandle: NSObject {
    
}
