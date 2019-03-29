//
//  SControl.swift
//  EManager
//
//  Created by EX DOLL on 2019/3/29.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

protocol SControlDelegate {
    func control_outputValue(_ value:CGFloat)
}

struct SControlOutputData {
    var x:CGFloat = 0
    var xMin:CGFloat = 0
    var xMax:CGFloat = 0
    var y:CGFloat {
        get {
            return x
        }
        set {
            current = y
        }
    }
    var yMin:CGFloat = 0
    var yMax:CGFloat = 0
    var current:CGFloat {
        get {
            return y
        }
        set {
            
        }
    }
    var baseMin:CGFloat = 0
    var baseMax:CGFloat = 180
    var baseRange:CGFloat = 180
    var min:CGFloat = 60
    var max:CGFloat = 120
    var range:CGFloat = 60
    init() {
        range = max - min
        baseRange = baseMax - baseMin
    }
}

struct SCrossData {
    var angle:CGFloat = CGFloat.pi / 2
    var R:CGFloat = 50
    var pt:CGPoint = CGPoint(x: -100, y: -100)
    var tanV:CGFloat = 0
    var sinV:CGFloat = 0
    var cosV:CGFloat = 0
    mutating func setVal(_ a:CGFloat = CGFloat.pi / 2,_ r:CGFloat = 50) {
        angle = a
        R = r
        self.tanV = r*tan(a)
        self.sinV = r*sin(a)
        self.cosV = r*cos(a)
    }
}

class SControl: UIView {
    // 基础数据
    var _model = SPointModel()
    // 选中的动点
    var moveB:CGPoint = CGPoint(x: -100, y: -100)
    // 滑动杆滑动范围
    var crossData = SCrossData()
    // 输出控制计算
    var valueData = SControlOutputData()
    var delegate:SControlDelegate!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        self.addGestureRecognizer(pan)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchEvent(_:)))
        self.addGestureRecognizer(pinch)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressEvent(_:)))
        self.addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent(_:)))
        self.addGestureRecognizer(tap)
        _model.a = 70
        _model.initArray()
        crossData.setVal(CGFloat.pi / 6, 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panEvent(_ sender:UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        // 先判断可移动点位置, 如果不在范围内, 不让进行移动
        if sender.state == .began {
            if (pow((moveB.x - point.x), 2) + pow((moveB.y - point.y), 2)) >= 400 {
                return
            }
        }
        
        if sender.state == .changed {
            
            // 上下范围控制
            if point.y < teamCurrentPoint.bpt.point.y - crossData.sinV {
                moveB.y = teamCurrentPoint.bpt.point.y - crossData.sinV
                moveB.x = (moveB.y - teamCurrentPoint.bpt.point.y) / crossData.tanV + teamCurrentPoint.bpt.point.x
            }else if (point.y > teamCurrentPoint.bpt.point.y + crossData.sinV) {
                moveB.y = teamCurrentPoint.bpt.point.y + crossData.sinV
                moveB.x = (moveB.y - teamCurrentPoint.bpt.point.y) / crossData.tanV + teamCurrentPoint.bpt.point.x
            }else{
                moveB.y = point.y
                moveB.x = (moveB.y - teamCurrentPoint.bpt.point.y) / crossData.tanV + teamCurrentPoint.bpt.point.x
            }
            
            //            let val = 90 - (moveB.y - teamCurrentPoint.bpt.point.y) * 90 / crossData.sinV
            //            self.delegate.control_outputValue(val)
            teamCurrentPoint.pt.point = moveB
            _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1] = teamCurrentPoint.pt
        }
        
        self.setNeedsDisplay()
    }
    
    @objc func pinchEvent(_ sender:UIPinchGestureRecognizer) {
        
    }
    
    @objc func longPressEvent(_ sender:UILongPressGestureRecognizer) {
        
    }
    
    var teamCurrentPoint = STeamCurrentPoint()
    @objc func tapEvent(_ sender:UITapGestureRecognizer) {
        var hide = true
        let point = sender.location(in: self)
        for (index, arr) in _model.teamArray.enumerated() {
            // 先判断选中点是否在响应动点范围内, 如果在范围内, 把动点赋予可移动点
            for (subIndex, pt) in arr.enumerated() {
                if ((pt.point.x - point.x)*(pt.point.x - point.x) + (pt.point.y - point.y)*(pt.point.y - point.y)) < 400 {
                    if pt.state == 1 {
                        moveB = pt.point
                        teamCurrentPoint.bpt = _model.baseArray[index][subIndex]
                        teamCurrentPoint.pt = pt
                        teamCurrentPoint.i0 = index
                        teamCurrentPoint.i1 = subIndex
                    }
                    
                    hide = false
                    break
                }
            }
        }
        
        if hide {
            moveB.x = -100
            moveB.y = -100
        }
        
        self.setNeedsDisplay()
    }
    func createRectL(_ point:CGPoint, _ val:CGFloat) ->CGRect{
        return CGRect(x: point.x-val/2, y: point.y-val/2, width: val, height: val)
    }
    func createRectR(_ point:CGPoint, _ val:CGFloat) ->CGRect{
        return CGRect(x: point.x-val/2, y: point.y-val/2, width: val, height: val)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        
        for (index, arr) in _model.teamArray.enumerated() {
            if arr.count == 3 {
                context?.move(to: arr[0].point)
                context?.addQuadCurve(to: arr[1].point, control: _model.midpointL(arr[1].point))
                
                context?.move(to: arr[2].point)
                context?.addQuadCurve(to: arr[1].point, control: _model.midpointR(arr[1].point))
            }
            
            if arr.count == 4 {
                context?.move(to: arr[0].point)
                context?.addQuadCurve(to: arr[1].point, control: arr[1].point)
                
                context?.move(to: arr[1].point)
                if index == 6 {
                    // 嘴上
                    context?.addQuadCurve(to: arr[2].point, control: midpointM(arr[1].point, arr[2].point, 0))
                }else if (index == 7) {
                    // 嘴下
                    context?.addQuadCurve(to: arr[2].point, control: midpointM(arr[1].point, arr[2].point, 1))
                }else{
                    // 眉毛
                    context?.addQuadCurve(to: arr[2].point, control: midpointM(arr[1].point, arr[2].point, -1))
                }
                
                context?.move(to: arr[3].point)
                context?.addQuadCurve(to: arr[2].point, control: arr[2].point)
            }
        }
        
        context?.setStrokeColor(UIColor.orange.cgColor)
        context?.setLineWidth(3)
        context?.setLineCap(.round)
        context?.strokePath()
        
        SPen.drawCircle([createRectL(CGPoint(x: _model.a * 4, y: _model.a * 2), 40)], context!)
        SPen.drawCircle([createRectR(CGPoint(x: _model.a * 10, y: _model.a * 2), 40)], context!)
        //        SPen.drawCross(teamCurrentPoint.bpt.point, val: 40, context!)
        SFacePen.drawRuler(teamCurrentPoint.bpt.point, crossData.angle, crossData.R, context!)
        SPen.drawCircle([createRectR(moveB, 20)], context!)
    }
}
