//
//  SHandControl.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/11.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

struct SMoveDis {
    var dis:CGFloat = 0
    mutating func ratio(_ val:CGFloat, _ isFront:Bool = true) ->CGFloat{
        var newVal:CGFloat = 0
        if isFront {
            newVal = 1 + (1-val/dis)
        }else{
            newVal = 0.5 + val/dis*0.5
        }
        return newVal
    }
}

class SHandControl: SFaceBase {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        rangeData.dis = SOperationModel.r_between(CGPoint(x: 300, y: 200), CGPoint(x: self.w/2, y: self.h/2 + 100))
        movePoint = CGPoint(x: 300, y: 200)
        movePointArray.append(CGPoint(x: 300, y: 200))
        movePointArray.append(CGPoint(x: self.w/2, y: self.h/2 + 100))
        movePointArray.append(CGPoint(x: self.w/2, y: self.h/2 + 300))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var targetPoint = CGPoint.zero //定点
    var movePoint = CGPoint.zero // 动点
    var subMovePoint = CGPoint.zero // 二级动点
    
    var movePointArray = [CGPoint]()
    var angleArray:[CGFloat] = [0.0,0.0,0.0]
    var rangeData = SMoveDis() // 移动范围
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)

        if (pow((teamCurrentPoint.pt.point.x - point.x), 2) + pow((teamCurrentPoint.pt.point.y - point.y), 2)) <= 900 {
            movePoint = point
            teamCurrentPoint.pt.point = point
            movePointArray[teamCurrentPoint.i0] = teamCurrentPoint.pt.point
            
            // 计算当前动点差值
            let curAgl = SOperationModel.omodel_body_angle(teamCurrentPoint.last.point, teamCurrentPoint.pt.point)
            let dif_angle = curAgl - angleArray[teamCurrentPoint.i0]
            
            // 牵连的关节点
            for index in 0..<teamCurrentPoint.subLevel {
                let curPt = movePointArray[teamCurrentPoint.i0 + index + 1]
                let newPt = SOperationModel.omodel_body_subPointMoveRange(curPt, teamCurrentPoint.last.point, angleArray[teamCurrentPoint.i0 + index + 1], dif_angle)
                movePointArray[teamCurrentPoint.i0 + index + 1] = newPt
            }
        }
        for index in 0..<teamCurrentPoint.subLevel {
            let curPt = movePointArray[teamCurrentPoint.i0 + index + 1]
            angleArray[index] = SOperationModel.omodel_body_angle(teamCurrentPoint.last.point, curPt)
        }
        self.setNeedsDisplay()
    }
    
    override func tapEvent(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        for (index,pt) in movePointArray.enumerated() {
            if (pow((pt.x - point.x), 2) + pow((pt.y - point.y), 2)) <= 900 {
                teamCurrentPoint.pt.point = pt
                teamCurrentPoint.i0 = index
                let difference = movePointArray.count - 1 - index
                if difference > 0 {
                    teamCurrentPoint.subLevel = difference
                }else{
                    teamCurrentPoint.subLevel = 0
                }
                movePoint = pt
                for index in 0..<teamCurrentPoint.subLevel {
                    let curPt = movePointArray[teamCurrentPoint.i0 + index + 1]
                    angleArray[index] = SOperationModel.omodel_body_angle(teamCurrentPoint.last.point, curPt)
                }
                break
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        for index in 0..<(movePointArray.count - 1) {
            if teamCurrentPoint.i0 == index {
                SFacePen.draw_circle(movePoint, 40, UIColor.green, context!)
                SFacePen.draw_limb(movePoint, movePointArray[index+1], rangeData.ratio(SOperationModel.r_between(movePoint, movePointArray[index+1])), context!)
            }else{
                SFacePen.draw_limb(movePointArray[index], movePointArray[index+1], rangeData.ratio(SOperationModel.r_between(movePointArray[index], movePointArray[index+1])), context!)
            }
        }
    }
}
