//
//  SBodyControl.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/11.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SBodyControl: SFaceBase {

    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = capturePoint
        _model.a = 60
        _model.xx = -30
        _model.yy = 50
        _model.initBodyArray()

        self.backgroundColor = .lightGray
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
    
    // 晃动当前角度
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        // 判定白色牵引圆点触控区域
        if (pow((teamCurrentPoint.pt.point.x - point.x), 2) + pow((teamCurrentPoint.pt.point.y - point.y), 2)) >= 400 {
            return
        }
        
        if sender.state == .began {
            
        }else if (sender.state == .changed) {
            // 在肢体长度范围内
            teamCurrentPoint.pt.point = SOperationModel.omodel_body_moveRange(point, teamCurrentPoint.last.point, _model.bodyLength)
            _model.bodyArray[teamCurrentPoint.i0][teamCurrentPoint.i1].point = teamCurrentPoint.pt.point
            
            // 计算当前动点差值
            let curAgl = SOperationModel.omodel_body_angle(teamCurrentPoint.last.point, teamCurrentPoint.pt.point)
            let dif_angle = curAgl - _model.bodyArray[teamCurrentPoint.i0][teamCurrentPoint.i1].angle

            // 牵连的关节点
            for index in 0..<teamCurrentPoint.subLevel {
                let curPt = _model.bodyArray[teamCurrentPoint.i0][teamCurrentPoint.i1 + index + 1]
                let newPt = SOperationModel.omodel_body_subPointMoveRange(curPt.point, teamCurrentPoint.last.point, curPt.angle, dif_angle)
                _model.bodyArray[teamCurrentPoint.i0][teamCurrentPoint.i1 + index + 1].point = newPt
            }
        }
        self.setNeedsDisplay()
    }
    
    override func tapEvent(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        for (index,list) in _model.bodyArray.enumerated() {
            for (subIndex,obj) in list.enumerated() {
                let pt = obj.point
                if (pow((pt.x - point.x), 2) + pow((pt.y - point.y), 2)) <= 400 {
                    teamCurrentPoint.bpt = _model.bodyArrayBase[index][subIndex]
                    teamCurrentPoint.last = _model.bodyArray[index][subIndex - 1]
                    teamCurrentPoint.pt = obj
                    teamCurrentPoint.pt.angle = SOperationModel.omodel_body_angle(teamCurrentPoint.last.point, obj.point)
                    teamCurrentPoint.i0 = index
                    teamCurrentPoint.i1 = subIndex
                    // 计算向下的层级
                    let difference = list.count - 1 - subIndex
                    if difference > 0 {
                        teamCurrentPoint.subLevel = difference
                    }else{
                        teamCurrentPoint.subLevel = 0
                    }
                    print("向下层级 : \(teamCurrentPoint.subLevel)")

                    for index in 0..<teamCurrentPoint.subLevel {
                        let curPt = _model.bodyArray[teamCurrentPoint.i0][teamCurrentPoint.i1 + index + 1]
                        curPt.angle = SOperationModel.omodel_body_angle(teamCurrentPoint.last.point, curPt.point)
                    }
                    break
                }
            }
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
        var pointList = [CGPoint]()
        for (_,list) in _model.bodyArray.enumerated() {
            context?.move(to: list[0].point)
            for obj in list {
                context?.addLine(to: obj.point)
                pointList.append(obj.point)
            }
            SFacePen.draw_line(context!)
        }

        // 画关节点
        SPen.drawCirclePoint(pointList, context!)
        
        // 选中点
        if teamCurrentPoint.pt.point != CGPoint.zero {
            SFacePen.draw_circle(teamCurrentPoint.pt.point, 15, .white, context!)
        }
    }
}
