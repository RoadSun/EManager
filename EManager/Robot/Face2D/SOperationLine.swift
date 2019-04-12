//
//  SFaceOperation.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/3.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SOperationLine: SFaceBase {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setMove(CGPoint(x: self.w - 40, y: self.h/2))
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
        
        // 计算拖动时候值变化
        operationMove = SOperationModel.omodel_panPoint(point, selfCenter, self.w/2 - 40,mAgl)
        
        valForSlider = SOperationModel.calculateVal(operationMove, selfCenter, self.w/2 - 40, mAgl)
        print(valForSlider)
        let o_move_w:CGFloat = fabs(operationMove.x - selfCenter.x)
        let o_move_h:CGFloat = fabs(operationMove.y - selfCenter.y)
        
        if pow(o_move_w, 2) + pow(o_move_h, 2) <= pow((self.h / 2 - 40),2) {
            self.setNeedsDisplay()
        }
    }
    
    // swift 直线斜率公式
    var selfCenter = CGPoint(x: 200, y: 200)
    var mPt:CGPoint = CGPoint(x: 0, y: 0)
    var mAgl:CGFloat = 0
    var valForSlider:CGFloat = 0
    func setPoint(_ pt:CGPoint) {
        mPt = pt
        self.setNeedsDisplay()
    }
    
    // 滑动值的变化
    func setValForSlider(_ val:CGFloat) {
        valForSlider = val
        operationMove = SOperationModel.omodel_movePoint(valForSlider,
                                                         CGPoint(x: self.w/2, y: self.h/2),
                                                         mAgl,
                                                         self.w/2 - 40)
        self.setNeedsDisplay()
    }
    
    func setAgl(_ agl:CGFloat) {
        mAgl = agl
        // 外部给值同时给movePoint变化
        operationMove = SOperationModel.omodel_movePoint(valForSlider,
                                                         selfCenter,
                                                         mAgl,
                                                         self.w/2 - 40)
        
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        // 中心点
        SFacePen.operation_center(CGPoint(x: self.w/2, y: self.h/2), context!)
        // 尺度范围
        SFacePen.drawRulerOperationRange(CGPoint(x: self.w/2, y: self.h/2), mAgl, self.w/2 - 40, 20,120, context!)
        // 手动移动点
        SFacePen.draw_circle(operationMove, 15, .white, context!)
        // 最小值
        SFacePen.drawText("0", .center, SOperationModel.omodel_textPosition(selfCenter, mAgl, self.w/2 - 40).min, context!)
        // 最大值
        SFacePen.drawText("180", .center, SOperationModel.omodel_textPosition(selfCenter, mAgl, self.w/2 - 40).max, context!)
    }
}
