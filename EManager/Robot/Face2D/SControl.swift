//
//  SControl.swift
//  EManager
//
//  Created by EX DOLL on 2019/3/29.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

@objc protocol SControlDelegate {
    @objc optional func control_outputValue(_ value:CGFloat)
    @objc optional func control_nameCurrentRangeValue(_ value:String, _ min:String, _ max:String) // 部位 当前值 范围
}

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
        self.sinV = r*sin(a)
        self.cosV = r*cos(a)
         // 纯角度值
        self.angleTan = tan(a)
        self.angleSin = sin(a)
        self.angleCos = cos(a)
    }
}

class SControl: UIView {
    // 基础数据
    var _model = SPointModel()
    // 选中的动点
    var moveB:CGPoint = CGPoint(x: -200, y: -200)
    // 滑动杆滑动范围
    var crossData = SCrossData()
    
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
        _model.a = 40
        _model.initArray()
//        crossData.setVal(CGFloat.pi / 2, 50)
        _ = test
        _ = valSlider
    }
   
    
//    初始化面部表情数据
    func changeData(_ val:CGFloat) {
        let o_base_y = teamCurrentPoint.bpt.point.y - crossData.sinV // 范围起点
        moveB.y = (val / crossData.angleRange) * (crossData.sinV * 2) + o_base_y
        moveB.x = (moveB.y - teamCurrentPoint.bpt.point.y) / crossData.angleTan + teamCurrentPoint.bpt.point.x
        
        teamCurrentPoint.pt.point = moveB
        _model.teamArray[teamCurrentPoint.i0][teamCurrentPoint.i1] = teamCurrentPoint.pt
        self.setNeedsDisplay()
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
                moveB.x = (moveB.y - teamCurrentPoint.bpt.point.y) / crossData.angleTan + teamCurrentPoint.bpt.point.x
            }else if (point.y > teamCurrentPoint.bpt.point.y + crossData.sinV) {
                moveB.y = teamCurrentPoint.bpt.point.y + crossData.sinV
                moveB.x = (moveB.y - teamCurrentPoint.bpt.point.y) / crossData.angleTan + teamCurrentPoint.bpt.point.x
            }else{
                moveB.y = point.y
                moveB.x = (moveB.y - teamCurrentPoint.bpt.point.y) / crossData.angleTan + teamCurrentPoint.bpt.point.x
            }
            // 输出值
            let val = 90 - (moveB.y - teamCurrentPoint.bpt.point.y) * 90 / crossData.sinV
            self.delegate.control_outputValue!(val)
            valSlider.value = Float(val)
            crossData.value = Int(val)
            
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
    var resultPTS = [CGPoint]()
    @objc func tapEvent(_ sender:UITapGestureRecognizer) {
        var hide = true
        let point = sender.location(in: self)
        /*
        for (index, arr) in _model.teamArray.enumerated() {
            if index == 1 {
                resultPTS.removeAll()
                resultPTS = _model.containsPointForCurveLineType(point, move: arr[0].point, to: arr[1].point, control: _model.midpointL(arr[1].point))
                resultPTS += _model.containsPointForCurveLineType(point, move: arr[2].point, to: arr[1].point, control: _model.midpointR(arr[1].point))
                break
            }
        }
        self.setNeedsDisplay()
        return
        */
        for (index, arr) in _model.teamArray.enumerated() {
            // 先判断选中点是否在响应动点范围内, 如果在范围内, 把动点赋予可移动点
            for (subIndex, pt) in arr.enumerated() {
                
                if ((pt.point.x - point.x)*(pt.point.x - point.x) + (pt.point.y - point.y)*(pt.point.y - point.y)) < 400 {
                    self.delegate.control_nameCurrentRangeValue!(_model.nameArray[index], "\(teamCurrentPoint.bpt.min)", "\(teamCurrentPoint.bpt.max)")
                    
                    if pt.state == 1 {
                        moveB = pt.point
                        teamCurrentPoint.bpt = _model.baseArray[index][subIndex]
                        teamCurrentPoint.pt = pt
                        teamCurrentPoint.i0 = index
                        teamCurrentPoint.i1 = subIndex
                    }
                    crossData.setVal(teamCurrentPoint.bpt.angle, 50)
                    hide = false
                    break
                }
            }
        }
        
        if hide {
            moveB.x = -200
            moveB.y = -200
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
            print(index)
            if arr.count == 3 {
                if index == 9 || index == 10 {
                    
                    context?.move(to: arr[0].point)
                    context?.addLine(to: arr[1].point)
                    context?.addLine(to: arr[2].point)
                }else{
                    context?.move(to: arr[0].point)
                    context?.addQuadCurve(to: arr[1].point, control: _model.midpointL(arr[1].point))
                    
                    context?.move(to: arr[2].point)
                    context?.addQuadCurve(to: arr[1].point, control: _model.midpointR(arr[1].point))
                }
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
        
//        for (index,obj) in _model.profileArray.enumerated() {
//            if index == 0 {
//                context?.move(to: obj.point)
//            }else{
//                context?.addLine(to: obj.point)
//            }
//        }
        // 遍历所有的中点
        context?.move(to: _model.profileMidPointArray[0].point)
        for (index,_) in _model.profileMidPointArray.enumerated() {
            // 在点范围之内
            if index < _model.profileMidPointArray.count - 1 {
                context?.addQuadCurve(to: _model.profileMidPointArray[index + 1].point, control: _model.profileArray[index + 1].point)
            }
        }

        context?.setStrokeColor(UIColor.orange.cgColor)
        context?.setLineWidth(3)
        context?.setLineCap(.round)
        context?.strokePath()
        
        SPen.drawCircle([createRectL(CGPoint(x: _model.a * 4 + _model.xx, y: _model.a * 2 + _model.yy), 40)], context!)
        SPen.drawCircle([createRectR(CGPoint(x: _model.a * 10 + _model.xx, y: _model.a * 2 + _model.yy), 40)], context!)
        if moveB.x != -200 {
            SFacePen.drawRuler(teamCurrentPoint.bpt.point, crossData.angle, crossData.R, context!)
        }
        SPen.drawCircle([createRectR(moveB, 20)], context!)
        
//        SFacePen.drawText("左眼眉上", .left, CGRect(x: 20, y: 30, width: 120, height: 30), context!)
//        SFacePen.drawText("当前值: \(crossData.value)", .left, CGRect(x: 20, y: 60, width: 120, height: 30), context!)
//        SFacePen.drawText("范围: \(teamCurrentPoint.pt.min) ~ \(teamCurrentPoint.pt.max)", .left, CGRect(x: 20, y: 90, width: 120, height: 30), context!)
        
        SPen.drawCirclePoint(resultPTS, context!)
    }
    
    
    lazy var test: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(testClick(_:)), for: .touchUpInside)
        btn.frame = CGRect(x: self.w - 60, y: 20, width: 40, height: 30)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.setTitle("测试", for: .normal)
        btn.isHidden = true
        btn.backgroundColor = UIColor.gray//RGBA16(value: 0x00ffff, Alpha: 1)
        btn.setTitleColor(UIColor.white, for: .normal)
        self.addSubview(btn)
        return btn
    }()
    var isChange:Bool = false
    @objc func testClick(_ sender:UIButton) {
        isChange = !isChange
    }
    
    lazy var valSlider: UISlider = {
        let slider = UISlider()
        slider.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        slider.maximumValue = 180
        slider.value = 90
        slider.minimumValue = 0
        slider.isHidden = true
        slider.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        self.addSubview(slider)
        return slider
    }()
    
    @objc func sliderChange(_ sender:UISlider) {
        var val = CGFloat(sender.value)
        if isChange {
            val = crossData.angleRange - val
        }
        changeData(val)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
