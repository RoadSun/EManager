//
//  SOperationModel.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/9.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SOperationModel: NSObject {
    class func omodel_movePoint(_ val:CGFloat,
                                _ center:CGPoint,
                                _ angle:CGFloat,
                                _ r:CGFloat,
                                _ isRotation:Bool = false) -> CGPoint{
        // 计算旋转时候圆点的位置
        let r0 = val * r / 90.0
        let cos_fabs = fabs(cos(angle))
        let sin_fabs = fabs(sin(angle))
        let x = r * cos_fabs
        let y = r * sin_fabs
        var point0:CGPoint!
        // 计算后的点x
        var p_x:CGFloat!
        // 计算后的点y
        var p_y:CGFloat!
        // 计算滑动时值变化
        if angle >= 0 && angle < CGFloat.pi / 2 {
            // 第一象限
            point0 = CGPoint(x: center.x + x , y: center.y - y)
            p_x = point0.x - cos_fabs * r0
            p_y = point0.y + sin_fabs * r0
        } else if (angle >= CGFloat.pi / 2 && angle < CGFloat.pi) {
            // 第二象限
            point0 = CGPoint(x: center.x - x , y: center.y - y)
            p_x = point0.x + cos_fabs * r0
            p_y = point0.y + sin_fabs * r0
        } else if (angle >= CGFloat.pi && angle < CGFloat.pi * 1.5) {
            // 第三象限
            point0 = CGPoint(x: center.x - x , y: center.y + y)
            p_x = point0.x + cos_fabs * r0
            p_y = point0.y - sin_fabs * r0
        } else if (angle >= CGFloat.pi * 1.5 && Float(angle) <= Float(CGFloat.pi * 2)) {
            // 第四象限
            point0 = CGPoint(x: center.x + x , y: center.y + y)
            p_x = point0.x - cos_fabs * r0
            p_y = point0.y - sin_fabs * r0
        }else{
            return CGPoint.zero
        }
        return CGPoint(x: p_x, y: p_y)
    }
    
    class func setLineK(_ center:CGPoint,_ r:CGFloat, _ angle:CGFloat) ->CGFloat {
        var point0:CGPoint!
        let cos_fabs = fabs(cos(angle))
        let sin_fabs = fabs(sin(angle))
        let x = r * cos_fabs
        let y = r * sin_fabs
        var k:CGFloat!
        // 计算滑动时值变化
        if angle >= 0 && angle < CGFloat.pi / 2 {
            // 第一象限
            point0 = CGPoint(x: center.x + x, y: center.y - y)
            k = fabs(point0.y - center.y) / fabs(center.x - center.x)
            print(1)
        } else if (angle >= CGFloat.pi / 2 && angle < CGFloat.pi) {
            // 第二象限
            point0 = CGPoint(x: center.x - x, y: center.y - y)
            k = -fabs(point0.y - center.y) / fabs(center.x - center.x)
            print(2)
        } else if (angle >= CGFloat.pi && angle < CGFloat.pi * 1.5) {
            // 第三象限
            point0 = CGPoint(x: center.x - x, y: center.y + y)
            k = fabs(point0.y - center.y) / fabs(center.x - center.x)
            print(3)
        } else if (angle >= CGFloat.pi * 1.5 && Float(angle) <= Float(CGFloat.pi * 2)) {
            // 第四象限
            point0 = CGPoint(x: center.x + x, y: center.y + y)
            k = -fabs(point0.y - center.y) / fabs(center.x - center.x)
            print(4)
        }else{
            return 0
        }
        print(k)
        return k
    }
    
    // 拖动点
    class func omodel_panPoint(_ point:CGPoint, _ center:CGPoint,_ r:CGFloat, _ angle:CGFloat) -> CGPoint{
        var newPoint:CGPoint = CGPoint.zero
        let cos_fabs = fabs(cos(angle))
        let sin_fabs = fabs(sin(angle))
        let x = r * cos_fabs
        let y = r * sin_fabs
        var point0:CGPoint!
        var point1:CGPoint!
        var k:CGFloat!
        
        // 计算滑动时值变化
        if angle >= 0 && angle < CGFloat.pi / 2 {
            // 第一象限
            point0 = CGPoint(x: center.x + x, y: center.y - y)
            point1 = CGPoint(x: center.x - x, y: center.y + y)
            k = fabs(point0.y - center.y) / fabs(point0.x - center.x)
            
        } else if (angle >= CGFloat.pi / 2 && angle < CGFloat.pi) {
            // 第二象限
            point0 = CGPoint(x: center.x - x, y: center.y - y)
            point1 = CGPoint(x: center.x + x, y: center.y + y)
            k = -fabs(point0.y - center.y) / fabs(point0.x - center.x)
        } else if (angle >= CGFloat.pi && angle < CGFloat.pi * 1.5) {
            // 第三象限
            point0 = CGPoint(x: center.x - x, y: center.y + y)
            point1 = CGPoint(x: center.x + x, y: center.y - y)
            k = fabs(point0.y - center.y) / fabs(point0.x - center.x)
        } else if (angle >= CGFloat.pi * 1.5 && Float(angle) <= Float(CGFloat.pi * 2)) {
            // 第四象限
            point0 = CGPoint(x: center.x + x, y: center.y + y)
            point1 = CGPoint(x: center.x - x, y: center.y - y)
            k = -fabs(point0.y - center.y) / fabs(point0.x - center.x)
        }else{
            return CGPoint.zero
        }
        
        if angle >= 0 && angle < CGFloat.pi / 2 {
            // 第一象限
            if k >= 1 {
                newPoint.y = point.y
                newPoint.x = -fabs(point0.y - point.y) / k + point0.x
                
                // 最小值判断, 防止超出移动界限 π/4 ~ π/2
                if point.y < point0.y {
                    return point0
                }else if (point.y > point1.y) {
                    // 最大值判断, 防止超出边界
                    return point1
                }

            }else{
                newPoint.x = point.x
                newPoint.y = point0.y + k * fabs(point0.x - point.x)
                
                // 最小值判断, 防止超出移动界限 0 ~ π/4
                if point.x > point0.x {
                    return point0
                }else if (point.x < point1.x) {
                    // 最大值判断, 防止超出边界
                    return point1
                }
            }
        } else if (angle >= CGFloat.pi / 2 && angle < CGFloat.pi) {
            // 第二象限
            
            if k <= -1 {
                newPoint.y = point.y
                newPoint.x = -fabs(point0.y - point.y) / k + point0.x
                
                // 最小值判断, 防止超出移动界限 π/2 ~ π3/4
                if point.y < point0.y {
                    return point0
                }else if (point.y > point1.y) {
                    // 最大值判断, 防止超出边界
                    return point1
                }
            }else{
                newPoint.x = point.x
                newPoint.y = point0.y - k * fabs(point0.x - point.x)
                
                // 最小值判断, 防止超出移动界限 π3/4 ~ π
                if point.x < point0.x {
                    return point0
                }else if (point.x >= point1.x) {
                    // 最大值判断, 防止超出边界
                    return point1
                }
            }
        } else if (angle >= CGFloat.pi && angle < CGFloat.pi * 1.5) {
            // 第三象限
            if k >= 1 {
                newPoint.y = point.y
                newPoint.x = fabs(point0.y - point.y) / k + point0.x
                
                // 最小值判断, 防止超出移动界限 π5/4 ~ π3/2
                if point.y > point0.y {
                    return point0
                }else if (point.y < point1.y) {
                    // 最大值判断, 防止超出边界
                    return point1
                }
            }else{
                newPoint.x = point.x
                newPoint.y = point0.y - k * fabs(point0.x - point.x)
                
                // 最小值判断, 防止超出移动界限 π ~ π5/4
                if point.x < point0.x {
                    return point0
                }else if (point.x > point1.x) {
                    // 最大值判断, 防止超出边界
                    return point1
                }
            }
        } else if (angle >= CGFloat.pi * 1.5 && Float(angle) <= Float(CGFloat.pi * 2)) {
            // 第四象限
            if k <= -1 {
                newPoint.y = point.y
                newPoint.x = fabs(point0.y - point.y) / k + point0.x
                
                // 最小值判断, 防止超出移动界限 π3/2 ~ π7/4
                if point.y > point0.y {
                    return point0
                }else if (point.y < point1.y) {
                    // 最大值判断, 防止超出边界
                    return point1
                }
            }else{
                newPoint.x = point.x
                newPoint.y = point0.y + k * fabs(point0.x - point.x)
                
                // 最小值判断, 防止超出移动界限 π7/4 ~ 2π
                if point.x > point0.x {
                    return point0
                }else if (point.x < point1.x) {
                    // 最大值判断, 防止超出边界
                    return point1
                }
            }
        }else{
            return CGPoint.zero
        }
        
        return newPoint
    }
    
    class func omodel_textPosition(_ point:CGPoint,
                                   _ angle:CGFloat,
                                   _ r:CGFloat) -> (min:CGRect,max:CGRect,c:CGRect,d:CGRect){
        let cos_fabs = fabs(cos(angle))
        let sin_fabs = fabs(sin(angle))
        let x = r * cos_fabs
        let y = r * sin_fabs
        var point0:CGPoint!
        var point1:CGPoint!
        let text_w:CGFloat = 70
        let text_h:CGFloat = 24
        
        let maxH:CGFloat = 30
        
        var pointMax:CGRect!
        var pointMin:CGRect!
        
        if angle >= 0 && angle < CGFloat.pi / 2 {
            // 第一象限
            point0 = CGPoint(x: point.x + x, y: point.y - y)
            point1 = CGPoint(x: point.x - x, y: point.y + y)
        } else if (angle >= CGFloat.pi / 2 && angle < CGFloat.pi) {
            // 第二象限
            point0 = CGPoint(x: point.x - x, y: point.y - y)
            point1 = CGPoint(x: point.x + x, y: point.y + y)
        } else if (angle >= CGFloat.pi && angle < CGFloat.pi * 1.5) {
            // 第三象限
            point0 = CGPoint(x: point.x - x, y: point.y + y)
            point1 = CGPoint(x: point.x + x, y: point.y - y)
        } else if (angle >= CGFloat.pi * 1.5 && Float(angle) <= Float(CGFloat.pi * 2)) {
            // 第四象限
            point0 = CGPoint(x: point.x + x, y: point.y + y)
            point1 = CGPoint(x: point.x - x, y: point.y - y)
        }
        
        if angle >= 0 && angle < CGFloat.pi / 2 {
            // 第一象限
            pointMax = CGRect(x: point1.x - maxH * cos_fabs - text_w/2.0, y: point1.y + maxH * sin_fabs - text_h/2.0, width: text_w, height: text_h)
            pointMin = CGRect(x: point0.x + maxH * cos_fabs - text_w/2.0, y: point0.y - maxH * sin_fabs - text_h/2.0, width: text_w, height: text_h)
        } else if (angle >= CGFloat.pi / 2 && angle < CGFloat.pi) {
            // 第二象限
            pointMax = CGRect(x: point1.x + maxH * cos_fabs - text_w/2.0, y: point1.y + maxH * sin_fabs - text_h/2.0, width: text_w, height: text_h)
            pointMin = CGRect(x: point0.x - maxH * cos_fabs - text_w/2.0, y: point0.y - maxH * sin_fabs - text_h/2.0, width: text_w, height: text_h)
        } else if (angle >= CGFloat.pi && angle < CGFloat.pi * 1.5) {
            // 第三象限
            pointMax = CGRect(x: point1.x + maxH * cos_fabs - text_w/2.0, y: point1.y - maxH * sin_fabs - text_h/2.0, width: text_w, height: text_h)
            pointMin = CGRect(x: point0.x - maxH * cos_fabs - text_w/2.0, y: point0.y + maxH * sin_fabs - text_h/2.0, width: text_w, height: text_h)
        } else if (angle >= CGFloat.pi * 1.5 && Float(angle) <= Float(CGFloat.pi * 2)) {
            // 第四象限
            pointMax = CGRect(x: point1.x - maxH * cos_fabs - text_w/2.0, y: point1.y - maxH * sin_fabs - text_h/2.0, width: text_w, height: text_h)
            pointMin = CGRect(x: point0.x + maxH * cos_fabs - text_w/2.0, y: point0.y + maxH * sin_fabs - text_h/2.0, width: text_w, height: text_h)
        }
        
        return (min: pointMin,max: pointMax,c:CGRect.zero,d:CGRect.zero)
    }
    
    // 计算val值
    class func calculateVal(_ point:CGPoint,_ center:CGPoint,_ r:CGFloat, _ angle:CGFloat) ->CGFloat {
        let cos_fabs = fabs(cos(angle))
        let sin_fabs = fabs(sin(angle))
        let x = r * cos_fabs
        let y = r * sin_fabs
        var point0:CGPoint!
        
        // 计算滑动时值变化
        if angle >= 0 && angle < CGFloat.pi / 2 {
            // 第一象限
            point0 = CGPoint(x: center.x + x , y: center.y - y)
            
        } else if (angle >= CGFloat.pi / 2 && angle < CGFloat.pi) {
            // 第二象限
            point0 = CGPoint(x: center.x - x , y: center.y - y)
            
        } else if (angle >= CGFloat.pi && angle < CGFloat.pi * 1.5) {
            // 第三象限
            point0 = CGPoint(x: center.x - x , y: center.y + y)
            
        } else if (angle >= CGFloat.pi * 1.5 && Float(angle) <= Float(CGFloat.pi * 2)) {
            // 第四象限
            point0 = CGPoint(x: center.x + x , y: center.y + y)
            
        }
        var val = sqrt(pow(fabs(point.y - point0.y), 2) + pow(fabs(point.x - point0.x), 2)) * 90 / r
        if val < 0 {
            val = 0
        }else if (val > 180) {
            val = 180
        }
        return val
    }
}