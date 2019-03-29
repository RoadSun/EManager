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
//        context.setLineWidth(0.5)
        context.strokePath()
    }
}
