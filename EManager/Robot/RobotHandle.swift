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

class RobotHandle: NSObject {
    /*
     * 触控范围
     * m_point 动点
     * center  指定标准点
     * range   触控范围
     * @return 大于 触控范围触控失效
     */
    class func isEnable( moving m_point: CGPoint,current center:CGPoint,max range:CGFloat) -> Bool {
        if sqrt(pow(m_point.x - center.x, 2.0) + pow(m_point.y - center.y, 2.0)) < range {
            return true
        }
        return false
    }
    
    /*
     * 滑动范围
     * start    起始角度
     * end      终角度
     * m_point  动点
     * f_point  定点
     * f_length 定长
     * @return  返回滑动范围
     */
    class func adjustRange(_ start:CGFloat,_ end:CGFloat, moving m_point: CGPoint, fixed f_point: CGPoint, length f_length : CGFloat) -> AngleRange {
        
        var range = AngleRange()
        range.start = start
        range.end = end
        
        let x = m_point.x - f_point.x
        let y = m_point.y - f_point.y
        
        let edge_c = sqrt(pow(x, 2.0) + pow(y, 2.0))
        var standard_x:CGFloat = 0.0
        var standard_y:CGFloat = 0.0
        let ratio = f_length / edge_c
        
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
        
        standard_x = CGFloat(x * ratio) + f_point.x
        standard_y = CGFloat(y * ratio) + f_point.y
        
        // 添加范围
        if range.angle < start {
            let startPoint = self.valueForAngle(start, length: f_length)
            standard_y = startPoint.y + f_point.y
            standard_x = startPoint.x + f_point.x
        }
        
        if range.angle > end {
            let endPoint = self.valueForAngle(end, length: f_length)
            standard_y = endPoint.y + f_point.y
            standard_x = endPoint.x + f_point.x
        }
        
        range.x = standard_x
        range.y = standard_y
        
        return range
    }
    
    class func valueForAngle(_ angle:CGFloat, length f_length:CGFloat)->CGPoint {
        let current_quadrant = Int(angle / 90)
        let en = angle.truncatingRemainder(dividingBy: 90)
        var y = f_length * sin((CGFloat.pi / 180)*en)
        var x = f_length * cos((CGFloat.pi / 180)*en)
        if current_quadrant == 0 {
            y = (-1)*y
        }
        if current_quadrant == 1 {
            y = f_length * sin((CGFloat.pi / 180)*(90-en))
            y = (-1)*y
            x = f_length * cos((CGFloat.pi / 180)*(90-en))
            x = (-1)*x
        }
        if current_quadrant == 2 {
            x = (-1)*x
        }
        if current_quadrant == 3 {
            y = f_length * sin((CGFloat.pi / 180)*(90-en))
            x = f_length * cos((CGFloat.pi / 180)*(90-en))
        }
        return CGPoint(x: x, y: y)
    }
}
