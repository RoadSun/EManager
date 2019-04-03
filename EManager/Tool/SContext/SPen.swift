//
//  SPen.swift
//  DSRobotEditorPad
//
//  Created by Sunlu on 2019/1/21.
//  Copyright © 2019 EX DOLL. All rights reserved.
//  画笔

import UIKit

enum SPointType {
    case start
    case body
    case end
    case `default`
}

struct SPoint {
    var x = 0
    var y = 0
    var type:SPointType = .default
}

class SPen: NSObject {
    class func drawFill(rect: CGRect,_ holeRect:CGRect,context:CGContext) -> Void {
        alphaArea(rect, holeRect, context)
        drawRightAngle(holeRect, val: 20, context)
    }
    
    class func alphaArea(_ rect: CGRect,_ holeRect:CGRect, _ context:CGContext){
        UIColor.gray.setFill()
        //半透明区域
        UIRectFill(rect);
        //透明的区域
        let holeInterSection = holeRect.intersection(rect)
        UIColor.clear.setFill()
        UIRectFill(holeInterSection)
    }
    
    /*
     * 画框
     */
    class func drawRightAngle(_ rect:CGRect, val:CGFloat, _ context:CGContext) {
        // 线条颜色
        context.setStrokeColor(UIColor.white.cgColor)
        // 设置线条平滑，不需要两边像素宽
        context.setShouldAntialias(false)
        // 设置线条宽度
        context.setLineWidth(2.0)
        // 设置线条起点
        
        let x = rect.origin.x - 1
        let y = rect.origin.y - 1
        let x_w = rect.origin.x + rect.size.width + 1
        let y_h = rect.origin.y + rect.size.height + 1
        
        context.move(to: CGPoint(x: x, y: y + val))
        context.addLine(to: CGPoint(x: x, y: y))
        context.addLine(to: CGPoint(x: x + val, y: y))
        
        context.move(to: CGPoint(x: x_w - val, y: y))
        context.addLine(to: CGPoint(x: x_w, y: y))
        context.addLine(to: CGPoint(x: x_w, y: y + val))
        
        context.move(to: CGPoint(x: x_w, y: y_h - val))
        context.addLine(to: CGPoint(x: x_w, y: y_h))
        context.addLine(to: CGPoint(x: x_w - val, y: y_h))
        
        context.move(to: CGPoint(x: x + val, y: y_h))
        context.addLine(to: CGPoint(x: x, y: y_h))
        context.addLine(to: CGPoint(x: x, y: y_h - val))
        
        context.strokePath()
        
        // 开始画线
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(0.5)
        
        let lx = rect.origin.x - 0.25
        let ly = rect.origin.y - 0.25
        let lx_w = rect.size.width + 0.5
        let ly_h = rect.size.height + 0.5
        
        context.addRect(CGRect(x: lx, y: ly, width: lx_w, height: ly_h))
        context.strokePath()
    }
    
    // 十字线
    class func drawCross(_ point:CGPoint, val:CGFloat, _ context:CGContext) {
        // 线条颜色
        context.setStrokeColor(UIColor.gray.cgColor)
        // 设置线条平滑，不需要两边像素宽
        context.setShouldAntialias(false)
        // 设置线条宽度
        context.setLineWidth(2.0)
        // 设置线条起点
        
        let x = point.x - val
        let y = point.y - val
        let x_w = point.x + val
        let y_h = point.y + val

        
        context.move(to: CGPoint(x: x, y: point.y))
        context.addLine(to: CGPoint(x: x_w, y: point.y))
        
        context.move(to: CGPoint(x: point.x, y: y))
        context.addLine(to: CGPoint(x: point.x, y: y_h))

        context.strokePath()
        
        // 开始画线
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(3)
        context.strokePath()
    }
    
    /*
     * 画圆
     */
    class func drawCircle(_ rects:[CGRect],_ context:CGContext, _ color:UIColor = .green) {
        // 画圆
        for obj in rects {
            context.addEllipse(in: obj)
        }
        // 线宽
        context.setLineWidth(3)
        // 画笔颜色
        context.setStrokeColor(UIColor.white.cgColor)
        // 关闭路径
        context.strokePath()
    }
    
    /*
     * 画圆
     */
    class func drawCirclePoint(_ pts:[CGPoint],_ context:CGContext, _ color:UIColor = .green) {
        // 画圆
        for obj in pts {
            let rect = CGRect(origin: CGPoint(x: obj.x-4.5, y: obj.y-4.5), size: CGSize(width: 9, height: 9))
            context.addEllipse(in: rect)
        }
        // 线宽
        context.setLineWidth(3)
        // 画笔颜色
        context.setStrokeColor(UIColor.yellow.cgColor)
        // 关闭路径
        context.strokePath()
    }
    
    
    /*
     * 手绘
     */
    class func drawBoard(_ points:[[CGPoint]], _ context:CGContext) {
        for obj in points {
            for (index,point) in obj.enumerated() {
                if index == 0 {
                    context.move(to: CGPoint(x: point.x, y: point.y))
                }
                context.addLine(to: CGPoint(x: point.x, y: point.y))
            }
        }
        
        context.setLineWidth(3)
        // 画笔颜色
        context.setStrokeColor(UIColor.green.cgColor)
        // 关闭路径
        context.strokePath()
    }
    
    /*
     * 添加文本
     */
    class func drawTxt(_ content:String,_ point:CGPoint,_ context:CGContext) {
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: 100)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: 100, height: 20))
        
        let path1 = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 100, height: 20),
                                 cornerRadius: CGRect(x: 0, y: 0, width: 100, height: 20).size.width/2).cgPath
        let str = "123"
        let mutableAttrStr = NSMutableAttributedString(string: str)
        mutableAttrStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 20),NSAttributedString.Key.foregroundColor:UIColor.white], range: NSMakeRange(0, 10))
        mutableAttrStr.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),NSAttributedString.Key.underlineStyle:1], range: NSMakeRange(10, 10))
        //设置行间距
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        mutableAttrStr.addAttributes([NSAttributedString.Key.paragraphStyle:style], range: NSMakeRange(0, mutableAttrStr.length))
        let frameSetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, mutableAttrStr.length), path1, nil)
        
        //5绘制
        CTFrameDraw(frame, context)
    }
}
/** union: 并集
 CGRect CGRectUnion(CGRect r1, CGRect r2)
 返回并集部分rect
 */

/** Intersection: 交集
 CGRect CGRectIntersection(CGRect r1, CGRect r2)
 返回交集部分rect
 */
