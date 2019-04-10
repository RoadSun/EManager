//
//  SFacePen.swift
//  EManager
//
//  Created by EX DOLL on 2019/3/29.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SFacePen: NSObject {
    // 中心点 角度 半径 画师
    class func drawRuler(_ point:CGPoint, _ angle:CGFloat, _ r:CGFloat, _ context:CGContext) {
        let x = r * cos(angle)
        let y = r * sin(angle)
        let point0 = CGPoint(x: point.x + x, y: point.y + y)
        let point1 = CGPoint(x: point.x - x, y: point.y - y)
        
        // 线条颜色
        context.setStrokeColor(UIColor.gray.cgColor)
        // 设置线条平滑，不需要两边像素宽
        context.setShouldAntialias(false)
        // 设置线条宽度
        context.setLineWidth(1)
        // 设置线条起点
        
        context.move(to: point0)
        context.addLine(to: point1)
        
        context.strokePath()
        // 开始画线
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokePath()
    }
    
    // 能动范围
    class func drawRulerOperationRange(_ center:CGPoint, _ angle:CGFloat, _ r:CGFloat,_ minVal:CGFloat, _ maxVal:CGFloat, _ context:CGContext) {
        let cos_fabs = fabs(cos(angle))
        let sin_fabs = fabs(sin(angle))
        let x = r * cos_fabs
        let y = r * sin_fabs
        var point0:CGPoint!
        var point1:CGPoint!

        if angle >= 0 && angle < CGFloat.pi / 2 {
            // 第一象限
            point0 = CGPoint(x: center.x + x, y: center.y - y)
            point1 = CGPoint(x: center.x - x, y: center.y + y)
        } else if (angle >= CGFloat.pi / 2 && angle < CGFloat.pi) {
            // 第二象限
            point0 = CGPoint(x: center.x - x, y: center.y - y)
            point1 = CGPoint(x: center.x + x, y: center.y + y)
        } else if (angle >= CGFloat.pi && angle < CGFloat.pi * 1.5) {
            // 第三象限
            point0 = CGPoint(x: center.x - x, y: center.y + y)
            point1 = CGPoint(x: center.x + x, y: center.y - y)
        } else if (angle >= CGFloat.pi * 1.5 && Float(angle) <= Float(CGFloat.pi * 2)) {
            // 第四象限
            point0 = CGPoint(x: center.x + x, y: center.y + y)
            point1 = CGPoint(x: center.x - x, y: center.y - y)
        }else{
            return
        }

        // 线条颜色
        context.setStrokeColor(UIColor.gray.cgColor)
        // 设置线条平滑，不需要两边像素宽
        context.setShouldAntialias(false)
        // 设置线条宽度
        context.setLineWidth(3)
        // 设置线条起点
        
        context.move(to: point0)
        context.addLine(to: point1)
        
        context.strokePath()
        // 开始画线
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokePath()
        
        // 画两头的限制尺度
        context.setStrokeColor(UIColor.darkGray.cgColor)
        context.setLineWidth(40)
        let maxH:CGFloat = 3
        var pointMax:CGPoint!
        var pointMin:CGPoint!
        if angle >= 0 && angle < CGFloat.pi / 2 {
            // 第一象限
            pointMax = CGPoint(x: point0.x + maxH * cos_fabs, y: point0.y - maxH * sin_fabs)
            pointMin = CGPoint(x: point1.x - maxH * cos_fabs, y: point1.y + maxH * sin_fabs)
        } else if (angle >= CGFloat.pi / 2 && angle < CGFloat.pi) {
            // 第二象限
            pointMax = CGPoint(x: point0.x - maxH * cos_fabs, y: point0.y - maxH * sin_fabs)
            pointMin = CGPoint(x: point1.x + maxH * cos_fabs, y: point1.y + maxH * sin_fabs)
        } else if (angle >= CGFloat.pi && angle < CGFloat.pi * 1.5) {
            // 第三象限
            pointMax = CGPoint(x: point0.x - maxH * cos_fabs, y: point0.y + maxH * sin_fabs)
            pointMin = CGPoint(x: point1.x + maxH * cos_fabs, y: point1.y - maxH * sin_fabs)
        } else if (angle >= CGFloat.pi * 1.5 && Float(angle) <= Float(CGFloat.pi * 2)) {
            // 第四象限
            pointMax = CGPoint(x: point0.x + maxH * cos_fabs, y: point0.y + maxH * sin_fabs)
            pointMin = CGPoint(x: point1.x - maxH * cos_fabs, y: point1.y - maxH * sin_fabs)
        }else{
            return
        }

        context.move(to: point0)
        context.addLine(to: pointMax)
        
        context.move(to: point1)
        context.addLine(to: pointMin)
        context.strokePath()

        // 画小红线
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(35)
        context.move(to: CGPoint(x: center.x, y: center.y - 1))
        context.addLine(to: CGPoint(x: center.x, y: center.y + 1))
        context.strokePath()

        // 画能动范围 范围最小值
        let min_val_r = minVal * 2 * r / 180
        let max_val_r = maxVal * 2 * r / 180
        var minFromPoint:CGPoint!
        var maxFromPoint:CGPoint!
        
        if angle >= 0 && angle < CGFloat.pi / 2 {
            // 第一象限
            minFromPoint = CGPoint(x: point0.x - min_val_r * cos_fabs, y: point0.y + min_val_r * sin_fabs)
            maxFromPoint = CGPoint(x: point0.x - max_val_r * cos_fabs, y: point0.y + max_val_r * sin_fabs)
        } else if (angle >= CGFloat.pi / 2 && angle < CGFloat.pi) {
            // 第二象限
            minFromPoint = CGPoint(x: point0.x + min_val_r * cos_fabs, y: point0.y + min_val_r * sin_fabs)
            maxFromPoint = CGPoint(x: point0.x + max_val_r * cos_fabs, y: point0.y + max_val_r * sin_fabs)
        } else if (angle >= CGFloat.pi && angle < CGFloat.pi * 1.5) {
            // 第三象限
            minFromPoint = CGPoint(x: point0.x + min_val_r * cos_fabs, y: point0.y - min_val_r * sin_fabs)
            maxFromPoint = CGPoint(x: point0.x + max_val_r * cos_fabs, y: point0.y - max_val_r * sin_fabs)
        } else if (angle >= CGFloat.pi * 1.5 && Float(angle) <= Float(CGFloat.pi * 2)) {
            // 第四象限
            minFromPoint = CGPoint(x: point0.x - min_val_r * cos_fabs, y: point0.y - min_val_r * sin_fabs)
            maxFromPoint = CGPoint(x: point0.x - max_val_r * cos_fabs, y: point0.y - max_val_r * sin_fabs)
        }else{
            return
        }
        
        context.setStrokeColor(UIColor.green.cgColor)
        context.setLineWidth(5)
        context.move(to: minFromPoint)
        context.addLine(to: maxFromPoint)
        context.strokePath()
    }
    
    /*
     * 小圆点, 手动操控
     */
    class func operation_pointMove(_ point:CGPoint, _ context:CGContext) {
        context.addArc(center: point, radius: 6, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        context.setLineWidth(12)
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokePath()
    }
    
    /*
     * 小圆点, 手动操控
     */
    class func operation_pointer(_ center:CGPoint, _ angle:CGFloat, _ context:CGContext) {
        
        let r:CGFloat = 450
        
        let cos_fabs = fabs(cos(angle))
        let sin_fabs = fabs(sin(angle))
        let x = r * cos_fabs
        let y = r * sin_fabs
        var point0:CGPoint = CGPoint.zero
        
        if angle >= 0 && angle < CGFloat.pi / 2 {
            // 第一象限
            point0 = CGPoint(x: center.x + x, y: center.y - y)
        } else if (angle >= CGFloat.pi / 2 && angle < CGFloat.pi) {
            // 第二象限
            point0 = CGPoint(x: center.x - x, y: center.y - y)
        }
        
        context.move(to: center)
        context.addLine(to: point0)
        context.setLineWidth(0.5)
        context.setStrokeColor(UIColor.red.cgColor)
        context.strokePath()
        
        context.addArc(center: center, radius: 6, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        context.setLineWidth(12)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.strokePath()
    }
    
    /*
     * 原点, 手动操控
     */
    class func operation_center(_ point:CGPoint, _ context:CGContext) {
        context.addArc(center: point, radius: 6, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        context.setLineWidth(18)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.strokePath()
    }
    
    /*
     * 文字位置
     */
    class func  drawText(_ content:String, _ alignment:NSTextAlignment = .center,_ rect:CGRect,_ context:CGContext) {
        let str = content
        //文字样式属性
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20),
                          NSAttributedStringKey.foregroundColor: UIColor.orange,
                          NSAttributedStringKey.paragraphStyle: style]
        //绘制在指定区域
//        context.translateBy(x: rect.origin.x, y: rect.origin.y) // 旋转锚点
//        context.rotate(by: val) // 135 * CGFloat.pi/180.0 // 旋转角度
//        context.concatenate(CGAffineTransform.init(rotationAngle: -CGFloat.pi / 3)) // 旋转角度
        context.setFillColor(UIColor.green.cgColor)
        context.strokePath()
        (str as NSString).draw(in: rect, withAttributes: attributes)
    }
    
    /*
     * 触摸区域
     */
    class func operation_touchArea(_ rects:[CGRect], _ context:CGContext) {
        context.addRects(rects)
        context.setLineWidth(3)
        context.setStrokeColor(UIColor.yellow.cgColor)
        context.setLineCap(.round)
        context.strokePath()
    }
}
