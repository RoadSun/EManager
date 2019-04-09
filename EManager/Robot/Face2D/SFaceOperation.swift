//
//  SFaceOperation.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/3.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SFaceOperation: SFaceBase {
    var step = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        operationMove = CGPoint(x: self.w/2, y: self.h/2)
        
    }
    
    func setMove(_ point:CGPoint) {
        operationMove = point
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var operationMove:CGPoint!
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        if (pow((operationMove.x - point.x), 2) + pow((operationMove.y - point.y), 2)) >= 400 {
            return
        }
        
        if point.y <= 40 {
            operationMove.y = 40
        }else if (point.y >= self.h - 40) {
            operationMove.y = self.h - 40
        }else{
            operationMove.y = point.y
        }
        // 范围
        var k:CGFloat!
        if mAgl >= 0 && mAgl < CGFloat.pi / 2 {
            // 第一象限
            k = -fabs(tan(mAgl))
        } else if (mAgl >= CGFloat.pi / 2 && mAgl < CGFloat.pi) {
            // 第二象限
            k = fabs(tan(mAgl))
        } else if (mAgl >= CGFloat.pi && mAgl < CGFloat.pi * 1.5) {
            // 第三象限
            k = -fabs(tan(mAgl))
        } else if (mAgl >= CGFloat.pi * 1.5 && Float(mAgl) <= Float(CGFloat.pi * 2)) {
            // 第四象限
            k = fabs(tan(mAgl))
        }else{
            return
        }
        // swift 直线斜率公式
        let selfCenter = CGPoint(x: self.w/2, y: self.h/2)
        let b = selfCenter.y - k * selfCenter.x
        
        operationMove.y = point.y
        operationMove.x = (point.y - b) / tan(mAgl)
        
        let o_move_w:CGFloat = fabs(operationMove.x - selfCenter.x)
        let o_move_h:CGFloat = fabs(operationMove.y - selfCenter.y)
        
        // 开平方
        
        if pow(o_move_w, 2) + pow(o_move_h, 2) <= pow((self.h / 2 - 40),2) {
            valForSlider = 0
            self.setNeedsDisplay()
        }
    }
    
    var mPt:CGPoint = CGPoint(x: 0, y: 0)
    var mAgl:CGFloat = CGFloat.pi/2
    var valForSlider:CGFloat = 0
    func setPoint(_ pt:CGPoint) {
        mPt = pt
        self.setNeedsDisplay()
    }
    
    func setValForSlider(_ val:CGFloat) {
        valForSlider = val
        self.setNeedsDisplay()
    }
    
    func setAgl(_ agl:CGFloat) {
        mAgl = agl
        
        // 外部给值同时给movePoint变化
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()        
        SFacePen.operation_center(CGPoint(x: self.w/2, y: self.h/2), context!)
        SFacePen.drawRulerOperationRange(CGPoint(x: self.w/2, y: self.h/2), mAgl, self.w/2 - 40, 20,120, context!)
        SFacePen.operation_pointMove(valForSlider, CGPoint(x: self.w/2, y: self.h/2), mAgl, self.w/2 - 40, context!)
        //        SFacePen.operation_range(CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0), context!)
        //        SFacePen.drawText("左眼眉上", .center, CGRect(x: mPt.x, y: mPt.y, width: 120, height: 25), mAgl, context!)
        //        SFacePen.drawText("左眼眉上", .center, CGRect(x: mPt.x + 40, y: mPt.y + 40, width: 120, height: 25), mAgl, context!)
    }
}
