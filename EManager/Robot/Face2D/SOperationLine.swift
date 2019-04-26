//
//  SFaceOperation.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/3.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit



class SOperationLine: SOperationBase {
    
    // 滑动旋转角度
    var mAgl:CGFloat = 0
    
    // 滑块指向当前值
    @objc dynamic var currentValue:CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCurrentValue(0)
        _ = dataLabel
        
        isLineCap = false
        self.setObserverKey("currentValue")
    }
    
    override func listen(_ value: Any) {
        dataLabel.text = "\(value)"
        self.op_delegate.operation_outputValue!(value as! CGFloat)
    }

    /*
     * 滑动值的变化
     */
    func setCurrentValue(_ val:CGFloat) {
        currentValue = val
        operationMove = SOperationModel.omodel_movePoint(currentValue,
                                                         _OP.center,
                                                         mAgl,
                                                         _OP.radius)
        self.setNeedsDisplay()
    }
    
    /*
     * 转动角度
     */
    func setAgl(_ agl:CGFloat) {
        mAgl = agl
        // 外部给值同时给movePoint变化
        operationMove = SOperationModel.omodel_movePoint(currentValue,
                                                         _OP.center,
                                                         mAgl,
                                                         _OP.radius)
        
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        
        // 整体移动
        if SOperationModel.omodel_touchArea(_OP.center, point, 0, CGFloat.pi * 0.1, self.w / 2 - 20, 28) {
            mAgl = SOperationModel.omodel_body_angle(_OP.center, point)
            setAgl(mAgl)
            return
        }
        
        // 超过滑动点, 滑动失效
        if SOperationModel.r_between(operationMove, point) > 15 {
            return
        }
        
        // 计算拖动时候滑动点变化
        operationMove = SOperationModel.omodel_panPoint(point, _OP.center, _OP.radius,mAgl)
        
        // 计算拖动值变化
        currentValue = SOperationModel.calculateVal(operationMove, _OP.center, _OP.radius, mAgl)
        
        if SOperationModel.r_between(operationMove, _OP.center) <= _OP.radius {
            self.setNeedsDisplay()
        }
    }
    
    override func draw_canvas(_ rect: CGRect, _ context: CGContext) {
        super.draw_canvas(rect, context)
        // 中心点
        SFacePen.draw_circle(_OP.center, 5, .blue, context)
        // 整体转动
        SFacePen.omodel_fanRange(_OP.center, self.w/2 - 20, .gray, -CGFloat.pi*0.05 + mAgl,  CGFloat.pi*0.05 + mAgl, context, true, 30)
        // 尺度范围
        SFacePen.drawRulerOperationRange(_OP.center, mAgl, _OP.radius, 20,50, context)
        // 手动移动点
        SFacePen.draw_circle(operationMove, 15, .white, context)
        // 最小值
        SFacePen.drawText("0", .center, SOperationModel.omodel_textPosition(_OP.center, mAgl, _OP.radius).min, context)
        // 最大值
        SFacePen.drawText("180", .center, SOperationModel.omodel_textPosition(_OP.center, mAgl, _OP.radius).max, context)
        // 画轨迹
        SFacePen.omodel_dash(context)
        SFacePen.draw_circle(_OP.center, _OP.radius, .white, context, true, 1)
        SFacePen.omodel_dash(context,false)
        
        // 十字
        SFacePen.draw_cross(operationMove, val: 5, context)
    }
}
