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
    var operationPoint:CGPoint!
    
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
            // 区域内滑动
            if SOperationModel.r_between(moveB, point) <= 20 {
                if teamCurrentPoint.i0 != 6 {
                    self.face_valueChange(point)
                    let val = SOperationModel.calculateVal(moveB, teamCurrentPoint.bpt.point, crossData.R, teamCurrentPoint.bpt.angle)
                    self.delegate.control_outputValue!(val, 0)
                }
            }
            
            // 嘴部移动(方形区域)
            if teamCurrentPoint.i0 == 6 {
                
                if teamCurrentPoint.bpt.type == .line {
                    // 线性移动
                    moveB.y = point.y
                }else if teamCurrentPoint.bpt.type == .cross{
                    // 方形区域移动
                    moveB = point
                    
                    if point.x - teamCurrentPoint.bpt.point.x > 40 {
                        moveB.x = teamCurrentPoint.bpt.point.x + 40
                    }else if point.x - teamCurrentPoint.bpt.point.x < -40 {
                        moveB.x = teamCurrentPoint.bpt.point.x - 40
                    }
                    
                    if point.y - teamCurrentPoint.bpt.point.y > 40 {
                        moveB.y = teamCurrentPoint.bpt.point.y + 40
                    }else if point.y - teamCurrentPoint.bpt.point.y < -40 {
                        moveB.y = teamCurrentPoint.bpt.point.y - 40
                    }
                }
                _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1].point = moveB
                // 下嘴唇上
                if teamCurrentPoint.i1 == 3 {
                    
                    _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1].point = moveB
                    let next_pt = CGPoint(x: moveB.x, y: moveB.y+0.5*_model.a)
                    _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1+1].point = next_pt
                }
                // 下嘴唇下
                if teamCurrentPoint.i1 == 4 {
                    _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1].point = moveB
                    let next_pt = CGPoint(x: moveB.x, y: moveB.y-0.5*_model.a)
                    _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1-1].point = next_pt
                }
                
                // 上嘴唇下
                if teamCurrentPoint.i1 == 5 {
                    _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1].point = moveB
                    let next_pt = CGPoint(x: moveB.x, y: moveB.y+0.5*_model.a)
                    _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1-4].point = next_pt
                }
                
                // 上嘴唇上
                if teamCurrentPoint.i1 == 1 {
                    _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1].point = moveB
                    let next_pt = CGPoint(x: moveB.x, y: moveB.y-0.5*_model.a)
                    _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1+4].point = next_pt
                }
            }
            
            // 眼睛活动区域
            if teamCurrentPoint.i0 == 11 || teamCurrentPoint.i0 == 12{
                moveB = point
                _model.teamArray[teamCurrentPoint.i0][0].point = moveB
                self.delegate.control_outputObj!(["eye.h":moveB.x - teamCurrentPoint.bpt.point.x,"eye.v":moveB.y - teamCurrentPoint.bpt.point.y], 5) // 眼部移动
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
        }
    }
    
    override func tapEvent(_ sender:UITapGestureRecognizer) {
        let point = sender.location(in: self)
        
        for (index, arr) in _model.teamArray.enumerated() {
            // 先判断选中点是否在响应动点范围内, 如果在范围内, 把动点赋予可移动点
            for (subIndex, pt) in arr.enumerated() {
                
                if ((pt.point.x - point.x)*(pt.point.x - point.x) + (pt.point.y - point.y)*(pt.point.y - point.y)) < 400 {
                    if pt.type == .none {
                        continue
                    }
                    moveB = pt.point
                    teamCurrentPoint.bpt.point = _model.baseArray[index][subIndex].point
                    teamCurrentPoint.pt = pt
                    teamCurrentPoint.i0 = index
                    teamCurrentPoint.i1 = subIndex
                    teamCurrentPoint.bpt.type = pt.type
                    teamCurrentPoint.subLevel = pt.state
                    break
                }
            }
        }
        
        // 点击的同时把当前值赋给操作器
        let val = SOperationModel.calculateVal(moveB, teamCurrentPoint.bpt.point, crossData.R, teamCurrentPoint.bpt.angle)
        self.delegate.control_outputValue!(val, teamCurrentPoint.i1)
        self.delegate.control_pointData!(teamCurrentPoint.bpt)
        
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
            
            // 计算点 60 是活动半径
            let n_v = v * 60
            let n_h = h * 60
            
            moveB = CGPoint(x: teamCurrentPoint.bpt.point.x + n_v, y: teamCurrentPoint.bpt.point.y + n_h)
            teamCurrentPoint.pt.point = moveB
            _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1].point = moveB
            self.setNeedsDisplay()
        }
    }
    
    /*
     * 嘴角移动
     */
    func face_mouthCornerMove(_ h:CGFloat, _ v:CGFloat) {
        self.face_mouthCornerMove_base(h,
                                       v,
                                       teamCurrentPoint.bpt,
                                       teamCurrentPoint.i0,
                                       teamCurrentPoint.i1)
    }
    
    func face_mouthCornerMove_base(_ h:CGFloat, _ v:CGFloat, _ spt:SPt, _ i0:Int, _ i1:Int) {
        //        print("\(v) --- \(h)")
        if i0 == 6 {
            moveB = SValueTrans.trans_toPoint_cross_d(v, h, spt.point, 40, v_d: spt.d, h_d: spt.d_s)
            _model.teamArray[i0][i1].point = moveB
            self.setNeedsDisplay()
        }
    }
    
    /*
     * 面部表情与数据结合
     */
    func face_data(_ list:[Int]) {
        
        // 眼球动, 左眼
        var n_h:CGFloat = 0
        var n_v:CGFloat = 0
        
        // 水平----基础方向
        if _model.baseArray[11][0].debugD == 1 {
            n_h = -(CGFloat(list[3 - 1]) - 90.0) / 180 * 60
        }else{
            n_h = (CGFloat(list[3 - 1]) - 90.0) / 180 * 60
        }
        
        // 水平方向
        if _model.baseArray[11][0].d == 1 {
            n_h = -n_h
        }
        
        // 垂直----基础方向
        if _model.baseArray[11][0].debugD_S == 1 {
            n_h = -(CGFloat(list[5 - 1]) - 90.0) / 180 * 60
        }else{
            n_h = (CGFloat(list[5 - 1]) - 90.0) / 180 * 60
        }
        
        // 垂直方向
        if _model.baseArray[11][0].d_s == 1 {
            n_v = -(CGFloat(list[5 - 1]) - 90.0) / 180 * 60
        }
        
        _model.teamArray[11][0].point = CGPoint(x: _model.baseArray[11][0].point.x + n_h, y: _model.baseArray[11][0].point.y + n_v)
        
        // 眼球动, 右眼
        var n_h_right:CGFloat = 0
        var n_v_right:CGFloat = 0
        
        // 水平----基础方向
        if _model.baseArray[12][0].debugD == 1 {
            n_h_right = -(CGFloat(list[4 - 1]) - 90.0) / 180 * 60
        }else{
            n_h_right = (CGFloat(list[4 - 1]) - 90.0) / 180 * 60
        }
        
        // 水平方向
        if _model.baseArray[12][0].d == 1 {
            n_h_right = -n_h_right
        }
        
        // 垂直----基础方向
        if _model.baseArray[12][0].debugD_S == 1 {
            n_v_right = -(CGFloat(list[6 - 1]) - 90.0) / 180 * 60
        }else{
            n_v_right = (CGFloat(list[6 - 1]) - 90.0) / 180 * 60
        }
        
        // 垂直方向
        if _model.baseArray[12][0].d_s == 1 {
            n_v_right = -n_v_right
        }
        
        _model.teamArray[12][0].point = CGPoint(x: _model.baseArray[12][0].point.x + n_h_right, y: _model.baseArray[12][0].point.y + n_v_right)
        
        /*** 嘴角移动 ***/
        var mouth_h_left:CGFloat = 0
        var mouth_v_left:CGFloat = 0
        
        // 水平----基础方向
        if _model.baseArray[6][0].debugD_S == 1 {
            mouth_h_left = -(CGFloat(list[13 - 1]) - 90.0) / 180 * 60
        }else{
            mouth_h_left = (CGFloat(list[13 - 1]) - 90.0) / 180 * 60
        }
        
        // 水平方向
        if _model.baseArray[6][0].d_s == 1 {
            mouth_h_left = -mouth_h_left
        }
        
        // 垂直----基础方向
        if _model.baseArray[6][0].debugD == 1 {
            mouth_v_left = -(CGFloat(list[11 - 1]) - 90.0) / 180 * 60
        }else{
            mouth_v_left = (CGFloat(list[11 - 1]) - 90.0) / 180 * 60
        }
        
        // 垂直方向
        if _model.baseArray[6][0].d == 1 {
            mouth_v_left = -mouth_v_left
        }
        
        _model.teamArray[6][0].point = CGPoint(x: _model.baseArray[6][0].point.x + mouth_h_left, y: _model.baseArray[6][0].point.y + mouth_v_left)

        var mouth_h_right:CGFloat = 0
        var mouth_v_right:CGFloat = 0
        
        // 水平----基础方向
        if _model.baseArray[6][2].debugD_S == 1 {
            mouth_h_right = -(CGFloat(list[14 - 1]) - 90.0) / 180 * 60
        }else{
            mouth_h_right = (CGFloat(list[14 - 1]) - 90.0) / 180 * 60
        }
        
        // 水平方向
        if _model.baseArray[6][2].d_s == 1 {
            mouth_h_right = -mouth_h_right
        }
        
        // 垂直----基础方向
        if _model.baseArray[6][2].debugD == 1 {
            mouth_v_right = -(CGFloat(list[12 - 1]) - 90.0) / 180 * 60
        }else{
            mouth_v_right = (CGFloat(list[12 - 1]) - 90.0) / 180 * 60
        }
        
        // 垂直方向
        if _model.baseArray[6][2].d == 1 {
            mouth_v_right = -mouth_v_right
        }
        
        _model.teamArray[6][2].point = CGPoint(x: _model.baseArray[6][2].point.x + mouth_h_right, y: _model.baseArray[6][2].point.y + mouth_v_right)
        self.face_mouth_move(CGFloat(list[15 - 1]))
        
        /***************/
        
        /*** 左眼皮 ***/
        
        var eyelid_v_left_up:CGFloat = 0
        // 左眼皮上
        if _model.baseArray[1][2].debugD == 1 {
            eyelid_v_left_up = -(CGFloat(list[7 - 1]) - 90.0) / 180 * 60
        }else{
            eyelid_v_left_up = (CGFloat(list[7 - 1]) - 90.0) / 180 * 60
        }
        
        // 垂直方向
        if _model.baseArray[1][2].d == 1 {
            eyelid_v_left_up = -eyelid_v_left_up
        }
        
        _model.teamArray[1][2].point = CGPoint(x: _model.baseArray[1][2].point.x, y: _model.baseArray[1][2].point.y + eyelid_v_left_up)
        
        
        var eyelid_v_left_down:CGFloat = 0
        // 左眼皮上
        if _model.baseArray[2][2].debugD == 1 {
            eyelid_v_left_down = -(CGFloat(list[9 - 1]) - 90.0) / 180 * 60
        }else{
            eyelid_v_left_down = (CGFloat(list[9 - 1]) - 90.0) / 180 * 60
        }
        
        // 垂直方向
        if _model.baseArray[2][2].d == 1 {
            eyelid_v_left_down = -eyelid_v_left_down
        }
        
        _model.teamArray[2][2].point = CGPoint(x: _model.baseArray[2][2].point.x, y: _model.baseArray[2][2].point.y + eyelid_v_left_down)
        /***************/
        
        /*** 右眼皮 ***/
        
        var eyelid_v_right_up:CGFloat = 0
        // 右眼皮上
        if _model.baseArray[4][2].debugD == 1 {
            eyelid_v_right_up = -(CGFloat(list[8 - 1]) - 90.0) / 180 * 60
        }else{
            eyelid_v_right_up = (CGFloat(list[8 - 1]) - 90.0) / 180 * 60
        }
        
        // 垂直方向
        if _model.baseArray[4][2].d == 1 {
            eyelid_v_right_up = -eyelid_v_right_up
        }
        
        _model.teamArray[4][2].point = CGPoint(x: _model.baseArray[4][2].point.x, y: _model.baseArray[4][2].point.y + eyelid_v_right_up)
        
        var eyelid_v_right_down:CGFloat = 0
        // 右眼皮上
        if _model.baseArray[5][2].debugD == 1 {
            eyelid_v_right_down = -(CGFloat(list[10 - 1]) - 90.0) / 180 * 60
        }else{
            eyelid_v_right_down = (CGFloat(list[10 - 1]) - 90.0) / 180 * 60
        }
        
        // 垂直方向
        if _model.baseArray[5][2].d == 1 {
            eyelid_v_right_down = -eyelid_v_right_down
        }
        
        _model.teamArray[5][2].point = CGPoint(x: _model.baseArray[5][2].point.x, y: _model.baseArray[5][2].point.y + eyelid_v_right_down)
        /***************/
        self.setNeedsDisplay()
        for (index_i0,array) in _model.baseArray.enumerated() {
            for (index_i1, obj) in array.enumerated() {
                
                if obj.servoNo == -1 {continue}
                let point = SOperationModel.omodel_movePoint(CGFloat(list[obj.servoNo]),
                                                             obj.point,
                                                             obj.angle,
                                                             crossData.R,
                                                             obj.d)
                self.face_data_trans(point, obj, i0: index_i0, i1: index_i1)
                
                self.setNeedsDisplay()
            }
        }
    }
    
    // 嘴部移动
    func face_mouth_move(_ val:CGFloat) {
        moveB.y = (val - 40) / 180 * 60 + _model.baseArray[6][3].point.y
        moveB.x = _model.baseArray[6][3].point.x
        _model.teamArray[6][3].point = moveB
        let next_pt = CGPoint(x: moveB.x, y: moveB.y+0.5*_model.a)
        _model.teamArray[6][4].point = next_pt
    }
    
    func face_data_trans(_ point:CGPoint, _ bpt:SPt, i0:Int, i1:Int) {
        let _moveB = point
        let dif = _moveB.y - bpt.point.y
        for (index, obj) in _model.baseArray[i0].enumerated() {
            
            if index >= 7 {
                break
            }
            
            // 左右眼眉
            if i0 == 0 || i0 == 3 {
                if i1 == 1 {
                    // 左眼眉上
                    let part_dif = [1.5,1.0,0.5,0,-0.5][index] * dif
                    let pt = CGPoint(x: obj.point.x, y: obj.point.y + CGFloat(part_dif))
                    _model.teamArray[i0][index].point = pt
                }else if (i1 == 3) {
                    // 左眼眉下
                    let part_dif = [-0.5,0,0.5,1,1.5][index] * dif
                    let pt = CGPoint(x: obj.point.x, y: obj.point.y + CGFloat(part_dif))
                    _model.teamArray[i0][index].point = pt
                }
            }

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
                
                // 嘴
                context.move(to: list[0].point)
                context.addQuadCurve(to: list[2].point, control: list[5].point)
                context.strokePath()
                context.move(to: list[0].point)
                context.addQuadCurve(to: list[2].point, control: list[1].point)
                context.strokePath()
                context.move(to: list[0].point)
                context.addQuadCurve(to: list[2].point, control: list[3].point)
                context.strokePath()
                context.move(to: list[0].point)
                context.addQuadCurve(to: list[2].point, control: list[4].point)
                context.strokePath()
            }else if index == 11 {
                SFacePen.draw_circle((list.first?.point)!, 15, .white, context, true)
            }else if index == 12{
                SFacePen.draw_circle((list.first?.point)!, 15, .white, context, true)
            }
            
            for (sub_index,pt) in list.enumerated() {
                // 根据状态显示高亮点
                if pt.state == 2 || pt.state == -2 {
                    // 不是嘴巴
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
        
        
        // 嘴巴
        for (index,pt) in _model.teamArray[6].enumerated() {
            if teamCurrentPoint.i0 == 6 && (teamCurrentPoint.i1 == 5 || teamCurrentPoint.i1 == 4) {
                if index == 1 || index == 3 {
                    
                }else{
                    SFacePen.draw_circle(pt.point, 6, .yellow, context)
                }
            }
        }
        
        // 画头型
        SFacePen.draw_bezier(_model.profileArray, _model.profileMidPointArray, context)
        
        // 画移动轨迹
        if moveB.x != -200 {
            if teamCurrentPoint.i0 == 6 && (teamCurrentPoint.i1 == 0 || teamCurrentPoint.i1 == 2) {
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
