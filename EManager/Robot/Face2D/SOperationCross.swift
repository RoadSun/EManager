//
//  SOperationCross.swift
//  EManager
//
//  Created by EX DOLL on 2019/5/6.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SOperationCross: SOperationBase {

    override init(frame: CGRect) {
        super.init(frame: frame)
        operationMove = _OP.center
    }
    
    func setValue(_ point:CGPoint) {
        operationMove = point
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        
        if SOperationModel.r_between(point, operationMove) <= 15{
            if valueGetStatue == 1 {
                operationMove.y = point.y
            } else if (valueGetStatue == 2) {
                operationMove.x = point.x
            }else{
                operationMove = point
            }
        }
        
        if point.x < 55 {
            operationMove.x = 55
        }
        
        if point.x > (self.w - 55) {
            operationMove.x = (self.w - 55)
        }
        
        if point.y < 55 {
            operationMove.y = 55
        }
        
        if point.y > (self.h - 55) {
            operationMove.y = (self.h - 55)
        }
        
        
        let _x = SValueTrans.trans_toAngle_cross(0, 180, 55, self.w - 55, operationMove.x)
        let val_x = (valueGetStatue == 1) ? "--":"\(_x)"
        let _y = SValueTrans.trans_toAngle_cross(0, 180, 55, self.h - 55, operationMove.y)
        let val_y = (valueGetStatue == 2) ? "--":"\(_y)"
        dataLabel.text = "x: \(val_x) y:\(val_y)"
        if self.op_delegate != nil {
            self.op_delegate.operation_outputObj!(["crossx":_x,"crossy":_y], 3)
        }
        self.setNeedsDisplay()
    }
    
    // 轻怕状态, 0 cross 1 v 2 h
    var valueGetStatue:Int = 0
    override func tapEvent(_ sender: UITapGestureRecognizer) {
        if sender.numberOfTapsRequired == 2 {
            valueGetStatue+=1
            if valueGetStatue > 2 {
                valueGetStatue = 0
            }
        }
        self.setNeedsDisplay()
    }
   
    override func draw_canvas(_ rect: CGRect, _ context: CGContext) {
        super.draw_canvas(rect, context)
        // 画移动区域
        SFacePen.draw_square(CGPoint(x: 40, y: 40), CGSize(width: self.w - 80, height: self.w - 80), context)
        
        // 画移动区域2
        SFacePen.omodel_dash(context)
        SFacePen.draw_square(CGPoint(x: 40+15, y: 40+15), CGSize(width: self.w - 80 - 30, height: self.w - 80 - 30), context)
        SFacePen.omodel_dash(context, false)
        
        // 画线
        SFacePen.draw_dynamicLine(operationMove,
                                  CGRect(origin: CGPoint(x: 40, y: 40), size: CGSize(width: self.w - 80, height: self.w - 80)),
                                  context, valueGetStatue)
        // 手动移动点
        SFacePen.draw_circle(operationMove, 15, .white, context)
        
        // 中心点
        SFacePen.draw_cross(operationMove, val: 5, context)
    }

}
