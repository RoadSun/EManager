//
//  SNeckControl.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/9.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit



struct SPointerData {
    var points = [CGPoint]()
    var sign:Bool = true
    mutating func setPoint(_ point:CGPoint) {
        points.append(point)
        if points.count > 4 {
            points.removeFirst()
        }else if(points.count < 3){
            return
        }
        let s0 = points[1].x - points[0].x
        let s1 = points[2].x - points[1].x
        if (s0 >= 0 && s1 >= 0) || (s0 <= 0 && s1 <= 0) {
            sign = true
        }else{
            sign = false
        }
    }
}

class SNeckControl: SFaceBase {

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
                obj.angle = SOperationModel.omodel_angle(_model.centerSway.point, CGFloat.pi / 2, obj.point)
                _model.neckArray[index] = obj
            }
        }
        
        // 计算晃脖子表情的初始角度
        for (i,list) in _model.neckCrossArray.enumerated() {
            for (index,obj) in list.enumerated() {
                obj.angle = SOperationModel.omodel_angle(_model.centerSway.point, CGFloat.pi / 2, obj.point)
                _model.neckCrossArray[i][index] = list[index]
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 重写, 原函数就不会调用
    override func capturePointClick(_ sender:UIButton) {
        self.isCapture = !self.isCapture
        if self.isCapture {
            sender.backgroundColor = UIColor.red
        }else{
            sender.backgroundColor = UIColor.gray
        }
    }
    
    var faceCenterPoint:CGPoint!
    var beginPoint:CGPoint! // 起始点
    var pointerData = SPointerData(points: [], sign: true)  // 上两个点
    var currentAngle:CGFloat = CGFloat.pi / 2
    // 晃动当前角度
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        // 先判断可移动点位置, 如果不在范围内, 不让进行移动
        if point.x >= 80 && point.x <= 480 && point.y >= 550 && point.y <= 630 {
            if sender.state == .began {
                beginPoint = point
            }else{
                let val = beginPoint.x - point.x
                pointerData.setPoint(point)
                if pointerData.sign == false {
                    beginPoint = pointerData.points[1]
                }
                currentAngle = val * CGFloat.pi / 6400.0 + currentAngle
                // 设定范围
                if currentAngle > CGFloat.pi * 0.75 {
                    currentAngle = CGFloat.pi * 0.75
                }else if (currentAngle < CGFloat.pi * 0.25) {
                    currentAngle = CGFloat.pi * 0.25
                }
                
                // 动作捕捉部分
                
                if self.isCapture {
                    if sender.state == .ended {
                        if (currentAngle - CGFloat.pi / 2) < 0.1 {
                            currentAngle = CGFloat.pi / 2
                        }
                    }
                }
                
                // 头部跟着动
                for (index, obj) in _model.neckArray.enumerated() {
                    if index > 2 && index < _model.neckArray.count - 3 {
                        obj.point = SOperationModel.omodel_swas(_model.centerSway.point, obj.angle, currentAngle, obj.point)
                        _model.neckArray[index] = obj
                    }
                }
                _model.initNeckArray(true)
                
                // 脖子表情跟着动
                for (i,list) in _model.neckCrossArray.enumerated() {
                    for (index,obj) in list.enumerated() {
                        obj.point = SOperationModel.omodel_swas(_model.centerSway.point, obj.angle, currentAngle, obj.point)
                        _model.neckCrossArray[i][index] = list[index]
                    }
                }
                _model.initNeckFace(true)
                
                // 圆点跟着动
                faceCenterPoint = _model.neckCrossArray[0][1].point
                
                /*** 输出 ***/
                if self.delegate != nil {
                    self.delegate.control_outputValue!((currentAngle * 180.0) / CGFloat.pi, 20)
                }
                self.setNeedsDisplay()
            }
            return
        }
        
        // 判定白色牵引圆点触控区域
        if (pow((faceCenterPoint.x - point.x), 2) + pow((faceCenterPoint.y - point.y), 2)) >= 400 {
            return
        }
        
        // 操作中心点
        faceCenterPoint = point
        // 中心控制点改变
        _model.neckCrossArray[0][1].point = point
        _model.neckCrossArray[1][1].point = point
        // 上下点变换
        _model.neckCrossArray[0][0].point = SOperationModel.omodel_neck(_model.neckCrossArrayBase[0][0].point,_model.neckCrossArrayBase[0][1].point, faceCenterPoint)
        _model.neckCrossArray[0][2].point = SOperationModel.omodel_neck(_model.neckCrossArrayBase[0][2].point,_model.neckCrossArrayBase[0][1].point, faceCenterPoint)
        // 左右点变换
        _model.neckCrossArray[1][0].point = SOperationModel.omodel_neck(_model.neckCrossArrayBase[1][0].point,_model.neckCrossArrayBase[1][1].point, faceCenterPoint)
        _model.neckCrossArray[1][2].point = SOperationModel.omodel_neck(_model.neckCrossArrayBase[1][2].point,_model.neckCrossArrayBase[1][1].point, faceCenterPoint)
        
        // 计算晃脖子表情的初始角度
        for (i,list) in _model.neckCrossArray.enumerated() {
            for (index,obj) in list.enumerated() {
                obj.angle = SOperationModel.omodel_angle(_model.centerSway.point, currentAngle, obj.point)
                _model.neckCrossArray[i][index] = list[index]
            }
        }
        
        _model.initNeckFace(true)
        
        self.setNeedsDisplay()
    }
    
    override func tapEvent(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        let angle_1:CGFloat = CGFloat.pi / 180.0
        // 左偏
        if point.x >= 80 && point.x < 280 && point.y >= 550 && point.y <= 630 {
            currentAngle += angle_1
        }
        // 右偏
        if point.x >= 280 && point.x <= 480 && point.y >= 550 && point.y <= 630 {
            currentAngle -= angle_1
        }
        
        if currentAngle > CGFloat.pi * 0.75 {
            currentAngle = CGFloat.pi * 0.75
        }else if (currentAngle < CGFloat.pi * 0.25) {
            currentAngle = CGFloat.pi * 0.25
        }

        // 头部跟着动
        for (index, obj) in _model.neckArray.enumerated() {
            if index > 2 && index < _model.neckArray.count - 3 {
                obj.point = SOperationModel.omodel_swas(_model.centerSway.point, obj.angle, currentAngle, obj.point)
                _model.neckArray[index] = obj
            }
        }
        _model.initNeckArray(true)
        
        // 脖子表情跟着动
        for (i,list) in _model.neckCrossArray.enumerated() {
            for (index,obj) in list.enumerated() {
                obj.point = SOperationModel.omodel_swas(_model.centerSway.point, obj.angle, currentAngle, obj.point)
                _model.neckCrossArray[i][index] = list[index]
            }
        }
        _model.initNeckFace(true)
        
        // 圆点跟着动
        faceCenterPoint = _model.neckCrossArray[0][1].point
        
        /*** 输出 ***/
        if self.delegate != nil {
            self.delegate.control_outputValue!((currentAngle * 180.0) / CGFloat.pi, 20)
        }
        self.setNeedsDisplay()
    }
    
    /*
     * 重画
     */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        
        // 画脖子表情
        context?.move(to: _model.profileMidPointArray[0].point)
        for (index,_) in _model.profileMidPointArray.enumerated() {
            // 在点范围之内
            if index < _model.profileMidPointArray.count - 1 {
                context?.addQuadCurve(to: _model.profileMidPointArray[index + 1].point, control: _model.neckArray[index + 1].point)
            }
        }
        SFacePen.draw_line(context!)
        
        // 画脖子表情
        for (i,list) in _model.neckCrossMidArray.enumerated() {
            context?.move(to: list[0].point)
            for index in 0..<(list.count - 1) {
                context?.addQuadCurve(to: list[index + 1].point, control: _model.neckCrossArray[i][index + 1].point)
            }
        }
        SFacePen.draw_line(context!,.blue)
        
        /* 画触控区域
         * [CGRect(x: 10, y: 200, width: 80, height: 200),CGRect(x: 465, y: 200, width: 80, height: 200),
         */
        SFacePen.operation_touchArea([CGRect(x: 80, y: 550, width: 400, height: 80)], context!)
        
        // 牵引点
        SFacePen.draw_circle(faceCenterPoint, 15, .white, context!)
        
        // 摇头基础点
        SFacePen.operation_pointer(_model.centerSway.point, currentAngle, context!)
    }
}
