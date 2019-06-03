

//
//  SOperationHandle.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/18.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
import OpenGLES
import GLKit

class SOperationHandle: SOperationBase {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setMove(_OP.center)
        
    }
    
    func setMove(_ point:CGPoint) {
        eyeMove = point
        eyeEndPoint = point
        eyeSize = CGSize(width: 120, height: 120)
        eyeSubSize = CGSize(width: 30, height: 30)
        eyecross = _OP.center
        eye__y = -60
        eye__sub__y = -15
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var eyeBeginPoint:CGPoint!
    var eyeEndPoint:CGPoint!
    var eyeMove:CGPoint!
    var eyeSubMove:CGPoint!
    var eyeSize:CGSize!
    var eye__y:CGFloat!
    var eyeSubSize:CGSize!
    var eye__sub__y:CGFloat!
    var eyecross:CGPoint!
    var currentAngle:CGFloat = 0
    
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        
        if sender.state == .began {
            eyeBeginPoint = point
        }else if (sender.state == .changed) {
            
            // 起始差值
            let begin_dif_x = point.x - eyeBeginPoint.x
            let begin_dif_y = point.y - eyeBeginPoint.y
            
            eyeMove.x = eyeEndPoint.x + begin_dif_x
            eyeMove.y = eyeEndPoint.y + begin_dif_y
            
            // 画睫状体
            let val_y_h = SOperationModel.omodel_new_point_two(_OP.center, eyeMove, asin(60.0/_OP.radius), _OP.radius)
            eyeSize.height = val_y_h.h
            eye__y = val_y_h.y
            
            // 画瞳孔
            let val_y_h_sub = SOperationModel.omodel_new_point_two(_OP.center, eyeMove, asin(15.0/_OP.radius), _OP.radius)
            eyeSubSize.height = val_y_h_sub.h
            eye__sub__y = val_y_h_sub.y
            
            // 超出边界失效
            if SOperationModel.r_between(eyeMove, _OP.center) > (_OP.radius) {
                let angle = SOperationModel.omodel_body_angle(_OP.center, eyeMove)
                let pt = SOperationModel.omodel_point_to_point(_OP.center, _OP.radius, angle)
                eyeMove = pt
            }
            
            if self.op_delegate != nil && SOperationModel.r_between(eyeMove, _OP.center) <= (_OP.radius - 60) {
                let h_val = SValueTrans.trans_toAngle(0,
                                                      180,
                                                      _OP.center.x - (_OP.radius - 60),
                                                      _OP.center.x + (_OP.radius - 60),
                                                      eyeMove.x - _OP.center.x + (_OP.radius - 60))
                
                let v_val = SValueTrans.trans_toAngle(0,
                                                      180,
                                                      _OP.center.y + (_OP.radius - 60),
                                                      _OP.center.y - (_OP.radius - 60),
                                                      eyeMove.y - (_OP.center.y + (_OP.radius - 60)))
                
                self.op_delegate.operation_outputObj!(["hval":h_val,"vval":v_val], 0)
            }
        }else if (sender.state == .ended) {
            
            if SOperationModel.r_between(eyeMove, _OP.center) <= (_OP.radius - 60) {
                eyeEndPoint = eyeMove
            }else{
                let angle = SOperationModel.omodel_body_angle(_OP.center, eyeMove)
                let pt = SOperationModel.omodel_point_to_point(_OP.center, _OP.radius - 60, angle)
                eyeEndPoint = pt
                eyeMove = pt
            }
        }
        
        self.setNeedsDisplay()
    }
    
    // swift 直线斜率公式
    var selfSize = CGSize(width: 120, height: 120)
    
    override func draw_canvas(_ rect: CGRect, _ context: CGContext) {
        super.draw_canvas(rect, context)
        // 眼白
        SFacePen.draw_circle(_OP.center, _OP.radius, .white, context)

        // 睫状体 eye__y - self.w/2
        SFacePen.draw_ellipse_rect(_OP.center, eye__y - self.w/2, eyeSize, .gray, context, CGFloat.pi*1.5 - SOperationModel.omodel_body_angle(_OP.center, eyeMove), false, 0, true)
        
        // 瞳孔
        SFacePen.draw_ellipse_rect(_OP.center, eye__sub__y - self.w/2, eyeSubSize, .black, context, CGFloat.pi*1.5 - SOperationModel.omodel_body_angle(_OP.center, eyeMove))
        
        // 十字
        SFacePen.draw_cross(CGPoint(x: eyeMove.x - self.w/2, y: eyeMove.y - self.w/2), val: 5, context)
    }
}
