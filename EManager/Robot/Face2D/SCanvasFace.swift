//
//  SCanvasFace.swift
//  EManager
//
//  Created by EX DOLL on 2019/3/27.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SCanvasFace: UIView {
    
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
        _model.initArray()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                        move = pt.point
                        teamCurrentPoint.bpt = _model.baseArray[index][subIndex]
                        teamCurrentPoint.pt = pt
                        teamCurrentPoint.i0 = index
                        teamCurrentPoint.i1 = subIndex
                    }
                    
                    print("点中")
                    hide = false
                    break
                }
            }
        }
        
        if hide {
            move.x = -100
            move.y = -100
        }
        
        print("1")
        self.setNeedsDisplay()
    }
    
    @objc func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        // 先判断可移动点位置, 如果不在范围内, 不让进行移动
        if sender.state == .began {
            if ((move.x - point.x)*(move.x - point.x) + (move.y - point.y)*(move.y - point.y)) >= 400 {
                return
            }
        }
        
        if sender.state == .changed {
                        
            // 上下范围控制
            if point.y < teamCurrentPoint.bpt.point.y - 40 {
                move.y = teamCurrentPoint.bpt.point.y - 40
            }else if (point.y > teamCurrentPoint.bpt.point.y + 40) {
                move.y = teamCurrentPoint.bpt.point.y + 40
            }else{
                move.y = point.y
            }
                // 左右控制
//                if point.x < teamCurrentPoint.bpt.point.x - 40 {
//                    move.x = teamCurrentPoint.bpt.point.x - 40
//                }else if (point.x > teamCurrentPoint.bpt.point.x + 40) {
//                    move.x = teamCurrentPoint.bpt.point.x + 40
//                }else{
//                    move.x = point.x
//                }
            // 左右范围控制

            teamCurrentPoint.pt.point = move
            _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1] = teamCurrentPoint.pt
        }
        
        self.setNeedsDisplay()
    }
    
    @objc func pinchEvent(_ sender: UIPinchGestureRecognizer) {
        
    }
    
    @objc func longPressEvent(_ sender:UILongPressGestureRecognizer) {
        
    }
    
    func createRectL(_ point:CGPoint, _ val:CGFloat) ->CGRect{
        return CGRect(x: point.x-val/2, y: point.y-val/2, width: val, height: val)
    }
    
    func createRectR(_ point:CGPoint, _ val:CGFloat) ->CGRect{
        return CGRect(x: point.x-val/2, y: point.y-val/2, width: val, height: val)
    }
    
    var teamArray = [SPointTeam(),]
    var _model = SPointModel()
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()

        for (index, arr) in _model.teamArray.enumerated() {
            if arr.count == 3 {

                context?.move(to: arr[0].point)
                context?.addQuadCurve(to: arr[1].point, control: midpointL(arr[1].point))

                context?.move(to: arr[2].point)
                context?.addQuadCurve(to: arr[1].point, control: midpointR(arr[1].point))
            }
            
            if arr.count == 4 {
                context?.move(to: arr[0].point)
                context?.addQuadCurve(to: arr[1].point, control: arr[1].point) // midpointL1(arr[1].point)

                context?.move(to: arr[1].point)
                // 嘴为6
                if index == 6 {
                    context?.addQuadCurve(to: arr[2].point, control: midpointM(arr[1].point, arr[2].point, 0))
                }else if (index == 7) {
                    context?.addQuadCurve(to: arr[2].point, control: midpointM(arr[1].point, arr[2].point, 1))
                }else{
                    context?.addQuadCurve(to: arr[2].point, control: midpointM(arr[1].point, arr[2].point, -1))
                }

                context?.move(to: arr[3].point)
                context?.addQuadCurve(to: arr[2].point, control: arr[2].point) // midpointR1(arr[2].point)
            }
        }
        
        context?.setStrokeColor(UIColor.orange.cgColor)
        context?.setLineWidth(3)
        context?.setLineCap(.round)
        context?.strokePath()
        
        SPen.drawCircle([createRectL(CGPoint(x: a * 4, y: a * 2), 40)], context!)
        SPen.drawCircle([createRectR(CGPoint(x: a * 10, y: a * 2), 40)], context!)
        SPen.drawCross(teamCurrentPoint.bpt.point, val: 40, context!)
        SPen.drawCircle([createRectR(move, 20)], context!)
    }
    
    // 获取path上的点
    func getPointFromPath(_ path:CGPath){
        path.apply(info: nil) { (_, elementPointer) in
            var element = elementPointer.pointee
            let command: String
            let pointCount: Int
            switch element.type {
            case .moveToPoint: command = "moveTo"; pointCount = 1
            case .addLineToPoint: command = "lineTo"; pointCount = 1
            case .addQuadCurveToPoint: command = "quadCurveTo"; pointCount = 2
            case .addCurveToPoint: command = "curveTo"; pointCount = 3
            case .closeSubpath: command = "close"; pointCount = 0
            }
            let points = Array(UnsafeBufferPointer(start: element.points, count: pointCount))
            print("\(command),   \(points)")
        }
    }
    
}
