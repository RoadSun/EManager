//
//  SOperationCircle.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/12.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SOperationCircle: SFaceBase {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setMove(CGPoint(x: selfCenter.x + self.w/2 - 55, y: selfCenter.y))
        
    }
    
    func setMove(_ point:CGPoint) {
        operationMove = point
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var operationMove:CGPoint!
    var currentAngle:CGFloat = 0
    var totalAngle:CGFloat = 0 // 整体转动角度
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        
        if SOperationModel.omodel_touchArea(selfCenter, point, 0, CGFloat.pi * 0.1, self.w / 2 - 20, 28) {
            totalAngle = SOperationModel.omodel_body_angle(selfCenter, point)
            self.setNeedsDisplay()
            return
        }
        
        if (pow((operationMove.x - point.x), 2) + pow((operationMove.y - point.y), 2)) >= 900 {
            return
        }
        // 计算逆时针
        // 计算拖动时候值变化
        operationMove = SOperationModel.omodel_body_moveRange(point, selfCenter, self.w/2 - 55)
        currentAngle = SOperationModel.π_Angle(SOperationModel.omodel_body_angle(selfCenter, point))
        self.setNeedsDisplay()
    }
    
    // swift 直线斜率公式
    var selfCenter = CGPoint(x: 200, y: 200)
    var mPt:CGPoint = CGPoint(x: 0, y: 0)
    var mAgl:CGFloat = 0
    var valForSlider:CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()

        // 表盘
        SFacePen.draw_circle(selfCenter, self.w/2 - 40, .white, context!)
        
        // 安全范围
        SFacePen.omodel_fanRange(selfCenter, self.w/2 - 40, .gray, CGFloat.pi/3,  CGFloat.pi*0.9, context!)
        
        // 整体转动
        SFacePen.omodel_fanRange(selfCenter, self.w/2 - 20, .gray, -CGFloat.pi*0.05 + totalAngle,  CGFloat.pi*0.05 + totalAngle, context!, true, 30)
        
        // 标准定线
        SFacePen.draw_line(selfCenter, CGPoint(x: selfCenter.x + self.w/2 - 40, y: selfCenter.y), context!, .gray, 3)
        
        // 刻度
        for _ in 0..<8 {

        }
        
        // 动线
        SFacePen.draw_line(selfCenter, SOperationModel.omodel_body_moveRange(operationMove, selfCenter, self.w/2 - 10), context!)
        
        // 手动移动点
        SFacePen.draw_circle(operationMove, 15, .gray, context!)
        
        // 圆心定点
        SFacePen.draw_circle(selfCenter, 10, .blue, context!)
        
        // 文字显示
        SFacePen.drawText("\(currentAngle)", .center, CGRect(x: 0, y: 5, width: 60, height: 30), context!)
    }
}
