//
//  SOperationCircle.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/12.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit



class SOperationCircle: SOperationBase {

    override init(frame: CGRect) {
        super.init(frame: frame)
        operationMove = CGPoint(x: _OP.center.x + self.w/2 - 55, y: _OP.center.y)
        standardPoint = CGPoint(x: _OP.center.x + _OP.radius, y: _OP.center.y)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var currentAngle:SAngle = SAngle()
    var totalAngle:CGFloat = 0 // 整体转动角度
    var standardPoint:CGPoint = CGPoint.zero
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        
        if SOperationModel.omodel_touchArea(_OP.center, point, 0, CGFloat.pi * 0.1, self.w / 2 - 20, 28) {
            totalAngle = SOperationModel.omodel_body_angle(_OP.center, point)
            standardPoint = SOperationModel.omodel_point_to_point(_OP.center, _OP.radius, totalAngle)
            let pt = SOperationModel.omodel_point_to_point(_OP.center, _OP.radius, totalAngle + currentAngle.radian)
            operationMove = SOperationModel.omodel_body_moveRange(pt, _OP.center, self.w/2 - 55)
            self.setNeedsDisplay()
            return
        }
        
        if (pow((operationMove.x - point.x), 2) + pow((operationMove.y - point.y), 2)) >= 900 {
            return
        }
        
        self.op_delegate.operation_outputStruct!(currentAngle)
        
        // 计算逆时针
        operationMove = SOperationModel.omodel_body_moveRange(point, _OP.center, self.w/2 - 55)
        
        currentAngle.setVal(SOperationModel.omodel_body_angle(_OP.center, point) - totalAngle)
        self.setNeedsDisplay()
    }
    
    // swift 直线斜率公式
    var mPt:CGPoint = CGPoint(x: 0, y: 0)
    var mAgl:CGFloat = 0
    var valForSlider:CGFloat = 0
    
    /*
     * 滑动值的变化
     */
    func setCurrentValue(_ val:CGFloat) {
        currentAngle.setVal(val)
        let pt = SOperationModel.omodel_point_to_point(_OP.center, _OP.radius, totalAngle + currentAngle.radian)
        operationMove = SOperationModel.omodel_body_moveRange(pt, _OP.center, self.w/2 - 55)
        self.setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()

        // 表盘
        SFacePen.omodel_dash(context!)
        SFacePen.draw_circle(_OP.center, self.w/2 - 40, .white, context!, true, 3)
        SFacePen.omodel_dash(context!, false)
        
        // 安全范围
        SFacePen.omodel_fanRange(_OP.center, self.w/2 - 41.5, .gray, CGFloat.pi*0.25 + totalAngle,  CGFloat.pi*0.75 + totalAngle, context!)
        
        // 整体转动
        SFacePen.omodel_fanRange(_OP.center, self.w/2 - 20, .gray, -CGFloat.pi*0.05 + totalAngle,  CGFloat.pi*0.05 + totalAngle, context!, true, 30)
        
        // 标准定线
        SFacePen.draw_line(_OP.center, standardPoint, context!, .green, 1.5)
        
        // 刻度
        for _ in 0..<8 {

        }
        
        // 动线
        SFacePen.draw_line(_OP.center, SOperationModel.omodel_body_moveRange(operationMove, _OP.center, self.w/2 - 10), context!)
        
        // 手动移动点
        SFacePen.draw_circle(operationMove, 15, .white, context!)
        
        // 十字线
        SFacePen.draw_cross(operationMove, val: 5, context!)
        
        // 圆心定点
        SFacePen.draw_circle(_OP.center, 10, .blue, context!)
        
        // 文字显示
        SFacePen.drawText("\(currentAngle.angle)", .center, CGRect(x: 0, y: 5, width: 60, height: 30), context!)
    }
}
