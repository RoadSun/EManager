//
//  SControl.swift
//  EManager
//
//  Created by EX DOLL on 2019/3/29.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

struct SCrossData {
    var angle:CGFloat = CGFloat.pi / 2
    var R:CGFloat = 50
    var pt:CGPoint = CGPoint(x: -200, y: -200)
    var tanV:CGFloat = 0
    var sinV:CGFloat = 0
    var cosV:CGFloat = 0
    var angleTan:CGFloat = 0
    var angleSin:CGFloat = 0
    var angleCos:CGFloat = 0
    var angleRange:CGFloat = 180
    var value = 90
    mutating func setVal(_ a:CGFloat = CGFloat.pi / 2,_ r:CGFloat = 50) {
        angle = a
        R = r
        self.tanV = r*tan(a)
        self.sinV = r*(sin(a) < 0 ? -sin(a) : sin(a))
        self.cosV = r*cos(a)
        // 纯角度值
        self.angleTan = tan(a)
        self.angleSin = sin(a)
        self.angleCos = cos(a)
    }
}

class SFaceControl: SFaceBase {
    // 选中的动点
    var moveB:CGPoint = CGPoint(x: -200, y: -200)
    // 滑动杆滑动范围
    var crossData = SCrossData()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _model.a = 40
        _model.initArray()
    }
    var pointT = CGPoint.zero
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func panEvent(_ sender:UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        // 先判断可移动点位置, 如果不在范围内, 不让进行移动
        if sender.state == .began {
            if (pow((moveB.x - point.x), 2) + pow((moveB.y - point.y), 2)) >= 400 {
                return
            }
        }

        if sender.state == .changed {
            if SOperationModel.r_between(moveB, point) <= 20 {
                self.face_valueChange(point)
                let val = SOperationModel.calculateVal(moveB, teamCurrentPoint.bpt.point, crossData.R, teamCurrentPoint.bpt.angle)
                self.delegate.control_outputValue!(val, 0)
            }
        }
        
        self.setNeedsDisplay()
    }
    
    func face_valueChange(_ point:CGPoint) {
        if teamCurrentPoint.i0 < 0 {
            return
        }
        moveB.y = point.y
        let dif = moveB.y - teamCurrentPoint.bpt.point.y
        for (index, obj) in _model.baseArray[teamCurrentPoint.i0].enumerated() {
            
            if index >= 7 {
                break
            }
            
            // 左右眼眉
            if teamCurrentPoint.i0 == 0 || teamCurrentPoint.i0 == 3 {
                if teamCurrentPoint.i1 == 1 {
                    // 左眼眉上
                    let part_dif = [1.5,1.0,0.5,0,-0.5][index] * dif
                    let pt = CGPoint(x: obj.point.x, y: obj.point.y + CGFloat(part_dif))
                    _model.teamArray[teamCurrentPoint.i0][index].point = pt
                }else if (teamCurrentPoint.i1 == 3) {
                    // 左眼眉下
                    let part_dif = [-0.5,0,0.5,1,1.5][index] * dif
                    let pt = CGPoint(x: obj.point.x, y: obj.point.y + CGFloat(part_dif))
                    _model.teamArray[teamCurrentPoint.i0][index].point = pt
                }
            }
            
            // 左右眼
            if teamCurrentPoint.i0 == 1 || teamCurrentPoint.i0 == 2 || teamCurrentPoint.i0 == 4 || teamCurrentPoint.i0 == 5 {
                _model.teamArray[teamCurrentPoint.i0][2].point = moveB
            }
            
            // 嘴
            if teamCurrentPoint.i0 == 6 {
                _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1].point = moveB
            }
        }
    }
    
    override func tapEvent(_ sender:UITapGestureRecognizer) {
        var hide = true
        let point = sender.location(in: self)
        
        for (index, arr) in _model.teamArray.enumerated() {
            // 先判断选中点是否在响应动点范围内, 如果在范围内, 把动点赋予可移动点
            for (subIndex, pt) in arr.enumerated() {
                
                if ((pt.point.x - point.x)*(pt.point.x - point.x) + (pt.point.y - point.y)*(pt.point.y - point.y)) < 400 {
                    moveB = pt.point
                    teamCurrentPoint.bpt.point = _model.baseArray[index][subIndex].point
                    teamCurrentPoint.pt = pt
                    teamCurrentPoint.i0 = index
                    teamCurrentPoint.i1 = subIndex
                    teamCurrentPoint.bpt.type = pt.type
                    teamCurrentPoint.subLevel = pt.state
                    hide = false
                    break
                }
            }
        }
        
        // 点击的同时把当前值赋给操作器
        let val = SOperationModel.calculateVal(moveB, teamCurrentPoint.bpt.point, crossData.R, teamCurrentPoint.bpt.angle)
        self.delegate.control_outputValue!(val, 0)
        self.delegate.control_pointData!(teamCurrentPoint.bpt)
        
        if hide {
            moveB.x = -200
            moveB.y = -200
        }
        
        self.setNeedsDisplay()
    }
    
    func face_other(_ value:CGFloat) {
        let point = SOperationModel.omodel_movePoint(value,
                                                     teamCurrentPoint.bpt.point,
                                                     teamCurrentPoint.bpt.angle,
                                                     crossData.R)
        self.face_valueChange(point)
        self.setNeedsDisplay()
    }
    
    /*
     * 只眼睛动
     */
    func face_eyeMove(_ v:CGFloat, _ h:CGFloat) {
        if teamCurrentPoint.i0 == 11 || teamCurrentPoint.i0 == 12 {
            moveB = SValueTrans.trans_toPoint(v, h, teamCurrentPoint.bpt.point, 40)
            teamCurrentPoint.pt.point = moveB
            _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1].point = moveB
            self.setNeedsDisplay()
        }
    }
    
    /*
     * 嘴角移动
     */
    func face_mouthCornerMmove(_ h:CGFloat, _ v:CGFloat) {
        print("\(v) --- \(h)")
        if teamCurrentPoint.i0 == 6 {
            moveB = SValueTrans.trans_toPoint_cross(v, h, teamCurrentPoint.bpt.point, 40)
            _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1].point = moveB
            self.setNeedsDisplay()
        }
    }
    
    override func draw_canvas(_ rect: CGRect, _ context: CGContext) {
        super.draw_canvas(rect, context)

        for (index, list) in _model.teamArray.enumerated() {
            
            if index >= 7 && index < 10{
                continue
            }
            
            if index == 0 || index == 3 {
                SFacePen.draw_bezier(list, [], context, true)
            }else if (index == 1 || index == 2 || index == 4 || index == 5) {
                context.move(to: list[0].point)
                context.addQuadCurve(to: list[1].point, control: list[2].point)
                SFacePen.draw_line(context)
            }else if index == 6{
                SFacePen.draw_bezier(list, [], context, true, true)
            }else if index == 11 {
                SFacePen.draw_circle((list.first?.point)!, 15, .white, context, true)
            }else if index == 12{
                SFacePen.draw_circle((list.first?.point)!, 15, .white, context, true)
            }
            
            for (_,pt) in list.enumerated() {
                // 根据状态显示高亮点
                if pt.state == 2 || pt.state == -2 {
                    SFacePen.draw_circle(pt.point, 6, .yellow, context)
                }else if (pt.state == 4) {
                    SFacePen.draw_circle(pt.point, 6, .green, context)
                }else if (pt.state == 5){
                    SFacePen.draw_circle(pt.point, 6, .purple, context)
                }else{
                    SFacePen.draw_circle(pt.point, 3, .red, context)
                }
            }
        }

        // 画头型
        SFacePen.draw_bezier(_model.profileArray, _model.profileMidPointArray, context)
        
        // 画移动轨迹
        if moveB.x != -200 {
            if teamCurrentPoint.i0 == 6 && (teamCurrentPoint.i1 == 0 || teamCurrentPoint.i1 == 3) {
                // 嘴角动点
                SFacePen.draw_square_area(teamCurrentPoint.bpt.point, 45, .white, context, false, 1)
            }else{
                SFacePen.drawRuler(teamCurrentPoint.bpt.point, crossData.angle, crossData.R, context)
            }
        }
        
        // 眼睛动区域
        if teamCurrentPoint.i0 == 11 || teamCurrentPoint.i0 == 12 {
            SFacePen.draw_circle_area(teamCurrentPoint.bpt.point, 60, .red, context)
        }
        
        // 移动的点
        SFacePen.draw_circle(moveB, 10, .white, context, true)
    }
}
