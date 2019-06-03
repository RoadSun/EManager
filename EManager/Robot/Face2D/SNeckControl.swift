//
//  SNeckControl.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/9.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SNeckControl: SFaceBase {

    var leftMothPoint:CGPoint! // 左轴移动
    var rightMothPoint:CGPoint! // 右轴移动
    var mothAngle:CGFloat = CGFloat.pi*0.5 // 轴合成角度
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = capturePoint
        _model.a = 25
        _model.xx = 100
        _model.yy = 180
        _model.initNeckArray()
        _model.initNeckFace()
        faceCenterPoint = _model.neckCrossArray[0][1].point
        
        self.backgroundColor = .lightGray
        
        // 计算晃脖子的初始角度
        for (index, obj) in _model.neckArray.enumerated() {
            if index > 2 && index < _model.neckArray.count - 3 {
                obj.angle = SOperationModel.omodel_angle(_model.centerSway.point, CGFloat.pi * 0.5, obj.point)
                _model.neckArray[index] = obj
            }
        }

        // 计算晃脖子表情的初始角度
        for (i,list) in _model.neckCrossArray.enumerated() {
            for (index,obj) in list.enumerated() {
                obj.angle = SOperationModel.omodel_angle(_model.centerSway.point, CGFloat.pi * 0.5, obj.point)
                _model.neckCrossArray[i][index] = list[index]
            }
        }
        
        self.neckAction(CGFloat.pi * 0.5)
        
        // 初始化左右轴点
        leftMothPoint = CGPoint(x: _model.neckCrossArrayBase[0][0].point.x-170, y: 380 + 75)
        rightMothPoint = CGPoint(x: _model.neckCrossArrayBase[0][0].point.x+170, y: 380 + 75)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     * 重写, 原函数就不会调用
     */
    override func capturePointClick(_ sender:UIButton) {
        self.isCapture = !self.isCapture
        if self.isCapture {
            sender.backgroundColor = UIColor.red
        }else{
            sender.backgroundColor = UIColor.gray
        }
    }
    
    /*
     * 设定值初始值 , 外部调用
     */
    func setCurrentValue(_ value:CGFloat) {
        self.neckAction(value)
        self.setNeedsDisplay()
    }
    
    var faceCenterPoint:CGPoint!
    var beginPoint:CGPoint! // 起始点
//    var pointerData = SPointerData()  // 上两个点
    var currentAngle:SAngle = SAngle()
    // 晃动当前角度
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        
        // 拖动左轴点
        if SOperationModel.r_between(leftMothPoint, point) < 20 {
            leftMothPoint.y = point.y
            if leftMothPoint.y < 380 {
                leftMothPoint.y = 380
            }
            
            if leftMothPoint.y > 380 + 150 {
                leftMothPoint.y = 380 + 150
            }
            
            // 赋予合成角度
            self.mothAngle = SOperationModel.omodel_body_angle(leftMothPoint, rightMothPoint, margin: CGFloat.pi*0.5)
            print("angle left ---- \(self.mothAngle / CGFloat.pi * 180)")
            self.neckAction(self.mothAngle + currentAngle.radian - CGFloat.pi*0.5)
            self.setNeedsDisplay()
            return
        }
        
        // 拖动右轴点
        if SOperationModel.r_between(rightMothPoint, point) < 20 {
            rightMothPoint.y = point.y
            if rightMothPoint.y < 380 {
                rightMothPoint.y = 380
            }
            
            if rightMothPoint.y > 380 + 150 {
                rightMothPoint.y = 380 + 150
            }
            
            // 赋予合成角度
            self.mothAngle = SOperationModel.omodel_body_angle(leftMothPoint, rightMothPoint, margin: CGFloat.pi*0.5)
            print("angle left ---- \(self.mothAngle / CGFloat.pi * 180)")
            self.neckAction(self.mothAngle + currentAngle.radian - CGFloat.pi*0.5)
            self.setNeedsDisplay()
            return
        }
        
        // 判定白色牵引圆点触控区域
        if SOperationModel.r_between(faceCenterPoint, point) > 20 {
            return
        }
        
        // 操作中心点
        faceCenterPoint = point
        if faceCenterPoint.x > _model.neckCrossArrayBase[0][0].point.x + 100 {
            faceCenterPoint.x = _model.neckCrossArrayBase[0][0].point.x + 100
        }
        if faceCenterPoint.x < _model.neckCrossArrayBase[0][0].point.x - 100 {
            faceCenterPoint.x = _model.neckCrossArrayBase[0][0].point.x - 100
        }
        // 中心控制点改变
        _model.neckCrossArray[0][1].point = faceCenterPoint
        _model.neckCrossArray[1][1].point = faceCenterPoint
        // 上下点变换
        _model.neckCrossArray[0][0].point = SOperationModel.omodel_neck(_model.neckCrossArray[0][0].point,_model.neckCrossArray[0][1].point, faceCenterPoint)
        _model.neckCrossArray[0][2].point = SOperationModel.omodel_neck(_model.neckCrossArray[0][2].point,_model.neckCrossArray[0][1].point, faceCenterPoint)
        // 左右点变换
        _model.neckCrossArray[1][0].point = SOperationModel.omodel_neck(_model.neckCrossArray[1][0].point,_model.neckCrossArray[1][1].point, faceCenterPoint)
        _model.neckCrossArray[1][2].point = SOperationModel.omodel_neck(_model.neckCrossArray[1][2].point,_model.neckCrossArray[1][1].point, faceCenterPoint)
        
        // 计算晃脖子表情的初始角度
        for (i,list) in _model.neckCrossArray.enumerated() {
            for (index,obj) in list.enumerated() {
                obj.angle = SOperationModel.omodel_angle(_model.centerSway.point, self.mothAngle, obj.point)
                _model.neckCrossArray[i][index] = list[index]
            }
        }
        _model.initNeckFace(true)
        
        self.setNeedsDisplay()
    }
    
    /*
     * 脖子动作
     */
    func neckAction(_ value:CGFloat,_ state:UIPanGestureRecognizer.State = .ended) {
        currentAngle.setVal(value)
        // 动作捕捉部分
        
        if self.isCapture {
            if state == .ended {
                if (self.mothAngle - CGFloat.pi / 2) < 0.1 {
                    currentAngle.pi(0.5)
                }
            }
        }
        
        // 头部跟着动
        for (index, obj) in _model.neckArray.enumerated() {
            if index > 2 && index < _model.neckArray.count - 3 {
                obj.point = SOperationModel.omodel_swas(_model.centerSway.point, obj.angle, self.mothAngle, obj.point)
                _model.neckArray[index] = obj
            }
        }
        _model.initNeckArray(true)
        
        // 脖子表情跟着动
        for (i,list) in _model.neckCrossArray.enumerated() {
            for (index,obj) in list.enumerated() {
                obj.point = SOperationModel.omodel_swas(_model.centerSway.point, obj.angle, self.mothAngle, obj.point)
                _model.neckCrossArray[i][index] = list[index]
            }
        }
        _model.initNeckFace(true)
        
        // 圆点跟着动
        faceCenterPoint = _model.neckCrossArray[0][1].point
        
        /*** 输出 ***/
        if self.delegate != nil {
            self.delegate.control_outputValue!(self.mothAngle, 20)
        }
    }
    
    /*
     * 重画
     */
    override func draw_canvas(_ rect: CGRect, _ context: CGContext) {
        super.draw_canvas(rect, context)
        
        // 画脖子表情
        context.move(to: _model.profileMidPointArray[0].point)
        for (index,_) in _model.profileMidPointArray.enumerated() {
            // 在点范围之内
            if index < _model.profileMidPointArray.count - 1 {
                context.addQuadCurve(to: _model.profileMidPointArray[index + 1].point, control: _model.neckArray[index + 1].point)
            }
        }
        SFacePen.draw_line(context)
        
        // 画脖子表情
        for (i,list) in _model.neckCrossMidArray.enumerated() {
            context.move(to: list[0].point)
            for index in 0..<(list.count - 1) {
                context.addQuadCurve(to: list[index + 1].point, control: _model.neckCrossArray[i][index + 1].point)
            }
        }
        SFacePen.draw_line(context,.blue)
        
        // 左轴
        SFacePen.draw_line(CGPoint(x: _model.neckCrossArrayBase[0][0].point.x-170, y: 380),
                           CGPoint(x: _model.neckCrossArrayBase[0][0].point.x-170, y: 380 + 150),
                           context, .purple, 3)
        
        SFacePen.draw_line(CGPoint(x: _model.neckCrossArrayBase[0][0].point.x-170-20, y: 380 + 75),
                           CGPoint(x: _model.neckCrossArrayBase[0][0].point.x-170+20, y: 380 + 75),
                           context, .purple, 3)
        // 右轴
        SFacePen.draw_line(CGPoint(x: _model.neckCrossArrayBase[0][0].point.x+170, y: 380),
                           CGPoint(x: _model.neckCrossArrayBase[0][0].point.x+170, y: 380 + 150),
                           context, .purple, 3)
        
        SFacePen.draw_line(CGPoint(x: _model.neckCrossArrayBase[0][0].point.x+170-20, y: 380 + 75),
                           CGPoint(x: _model.neckCrossArrayBase[0][0].point.x+170+20, y: 380 + 75),
                           context, .purple, 3)
        
        // 左右轴连接线
        SFacePen.draw_line(leftMothPoint, rightMothPoint, context)
        
        // 平衡点(两轴之间的牵引)
        let center_pt = SOperationModel.omodel_center_point(leftMothPoint,rightMothPoint)
        SFacePen.draw_circle(center_pt, 5, .yellow, context)
        
        // 垂直线
        SFacePen.draw_line(center_pt,
                           SOperationModel.omodel_point_to_point(center_pt, 80, self.mothAngle),
                           context, .green)
        
        // 左轴牵引点
        SFacePen.draw_circle(leftMothPoint, 15, .white, context)
        
        // 右轴牵引点
        SFacePen.draw_circle(rightMothPoint, 15, .white, context)
        
        // 面部牵引点 + 十字
        SFacePen.draw_circle(faceCenterPoint, 15, .white, context)
        SFacePen.draw_cross(faceCenterPoint, val: 5, context)
    }
}
