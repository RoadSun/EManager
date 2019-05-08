//
//  SLimbControl.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/24.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

struct SDyWidth {
    var r:CGFloat = 0  // 单位半径
    var r0:CGFloat = 0 // 动态半径
    var w:CGFloat = 10  // 单位线宽
    var w0:CGFloat = 10 // 动态线宽
    var rate:CGFloat = 0
    var rate0:CGFloat = 0 // 小圆半径
    var d:Bool = true // 方向
    mutating func c(_ d_r:CGFloat) {
        r0 = d_r
        if r0 - r <= 0 {
            rate = 1 + (r - r0)/r
            rate0 = 1 - r0/r
            w0 = w * rate
            d = true
        }else if(r0 - r <= r && r0 - r > 0) {
            rate = 1+(r - r0)/r
            rate0 = (r - r0)/r
            w0 = w + w*((r - r0)/r)*0.5
            d = false
        }
    }
}

struct STPoint {
    var p:CGPoint = CGPoint.zero
    var d:Bool = true
}

class SLimbControl: SFaceBase {

    var pointsArray = [STPoint(p: CGPoint(x: 300, y: 200), d: true), STPoint(p: CGPoint(x: 300, y: 400), d: true), STPoint(p: CGPoint(x: 300, y: 600), d: true)]
    var pointsArrayBase = [STPoint(p: CGPoint(x: 300, y: 200), d: true), STPoint(p: CGPoint(x: 300, y: 400), d: true), STPoint(p: CGPoint(x: 300, y: 600), d: true)]
    var angleDifArray = [CGFloat]()
    var movePoint:CGPoint!
    // 动态计算胳膊的宽度
    var dyWidth = SDyWidth()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        _ = frontBtn
        _ = backBtn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        // 拖动 半径 < 20 并且能取得上一个关节点位置, 在半径区域内移动
        if sender.state == .began {
            
        }else if sender.state == .changed {
            
            if (teamCurrentPoint.i0 - 1) >= 0 && movePoint != nil {
                if SOperationModel.r_between(pointsArray[teamCurrentPoint.i0 - 1].p, point) <= 200 {
                    movePoint = point
                    pointsArray[teamCurrentPoint.i0].p = point
                    pointsArray[teamCurrentPoint.i0].d = true
                    dyWidth.c(SOperationModel.r_between(pointsArray[teamCurrentPoint.i0 - 1].p, point))
                    
                }else{
                    dyWidth.c(SOperationModel.r_between(pointsArray[teamCurrentPoint.i0 - 1].p, point))
                    let pt = SOperationModel.omodel_body_moveRange(point, pointsArray[teamCurrentPoint.i0 - 1].p, dyWidth.rate * 200)
                    movePoint = pt
                    pointsArray[teamCurrentPoint.i0].p = pt
                    pointsArray[teamCurrentPoint.i0].d = false
                }
            }
            
            if teamCurrentPoint.i0 == 1 {
                print("中间点")
            }
        }
        self.setNeedsDisplay()
    }
    
    override func tapEvent(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        for (index,pt) in pointsArray.enumerated() {
            if SOperationModel.r_between(pt.p, point) <= 20 {
                // 点中设置
                movePoint = pt.p
                teamCurrentPoint.pt.point = pt.p
                teamCurrentPoint.bpt.point = pointsArrayBase[index].p
                teamCurrentPoint.i0 = index
                
                dyWidth.r = 200
                dyWidth.r0 = 200
                break
            }else{
                // 没点中设置
                teamCurrentPoint.i0 = -1
            }
        }
        self.setNeedsDisplay()
    }
    
    override func draw_canvas(_ rect: CGRect, _ context: CGContext) {
        super.draw_canvas(rect, context)
        
        // 判断点顺序
        for index in 0..<(pointsArray.count-1) {
            // 1, 先判断第一个点在前在后
            
            let pt1 = pointsArray[index]
            let pt2 = pointsArray[index+1]
            
            if pt1.d == true &&  pt2.d == true {

                // 画点1
                if teamCurrentPoint.i0 == index {
                    SFacePen.draw_circle(pt1.p, 10 + 10 * dyWidth.rate0 * 0.5, .green, context)
                }else{
                    SFacePen.draw_circle(pt1.p, 10, .green, context)
                }
                
                // 画线
                if index + 1 == teamCurrentPoint.i0 {
                    SFacePen.draw_line(pt1.p, pt2.p, context, .orange, dyWidth.w0)
                }else{
                    SFacePen.draw_line(pt1.p, pt2.p, context, .orange, dyWidth.w)
                }
                
                // 画点2
                if teamCurrentPoint.i0 == index {
                    SFacePen.draw_circle(pt2.p, 10 + 10 * dyWidth.rate0 * 0.5, .green, context)
                }else{
                    SFacePen.draw_circle(pt2.p, 10, .green, context)
                }
                
                if teamCurrentPoint.i0 == index {
                    SFacePen.draw_circle(pt1.p, 20, .white, context, true, 3)
                } else if (teamCurrentPoint.i0 == index + 1) {
                    SFacePen.draw_circle(pt2.p, 20, .white, context, true, 3)
                }
            }
            
            
            if pt1.d == true &&  pt2.d == false {
                // 画点2
                if teamCurrentPoint.i0 == index {
                    SFacePen.draw_circle(pt2.p, 10 + 10 * dyWidth.rate0 * 0.5, .green, context)
                }else{
                    SFacePen.draw_circle(pt2.p, 10, .green, context)
                }
                
                // 画线
                if index + 1 == teamCurrentPoint.i0 {
                    SFacePen.draw_line(pt1.p, pt2.p, context, .orange, dyWidth.w0)
                }else{
                    SFacePen.draw_line(pt1.p, pt2.p, context, .orange, dyWidth.w)
                }
                
                // 画点1
                if teamCurrentPoint.i0 == index {
                    SFacePen.draw_circle(pt1.p, 10 + 10 * dyWidth.rate0 * 0.5, .green, context)
                }else{
                    SFacePen.draw_circle(pt1.p, 10, .green, context)
                }
                
                if teamCurrentPoint.i0 == index {
                    SFacePen.draw_circle(pt1.p, 20, .white, context, true, 3)
                } else if (teamCurrentPoint.i0 == index + 1) {
                    SFacePen.draw_circle(pt2.p, 20, .white, context, true, 3)
                }
            }
            
            if pt1.d == false &&  pt2.d == true {
                
                // 画点1
                if teamCurrentPoint.i0 == index {
                    SFacePen.draw_circle(pt1.p, 10 + 10 * dyWidth.rate0 * 0.5, .green, context)
                }else{
                    SFacePen.draw_circle(pt1.p, 10, .green, context)
                }
                
                // 画线
                if index + 1 == teamCurrentPoint.i0 {
                    SFacePen.draw_line(pt1.p, pt2.p, context, .orange, dyWidth.w0)
                }else{
                    SFacePen.draw_line(pt1.p, pt2.p, context, .orange, dyWidth.w)
                }
                
                // 画点2
                if teamCurrentPoint.i0 == index {
                    SFacePen.draw_circle(pt2.p, 10 + 10 * dyWidth.rate0 * 0.5, .green, context)
                }else{
                    SFacePen.draw_circle(pt2.p, 10, .green, context)
                }
                
                if teamCurrentPoint.i0 == index {
                    SFacePen.draw_circle(pt1.p, 20, .white, context, true, 3)
                } else if (teamCurrentPoint.i0 == index + 1) {
                    SFacePen.draw_circle(pt2.p, 20, .white, context, true, 3)
                }
            }
        }
        
        
        
        SFacePen.draw_line(CGPoint(x: 300, y: 0), CGPoint(x: 300, y: 700), context, .red, 0.5)
    }
    
    lazy var frontBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(dClick(_:)), for: .touchUpInside)
        btn.frame = CGRect(x: self.w - 60, y: 20, width: 40, height: 30)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.setTitle("前", for: .normal)
        btn.backgroundColor = UIColor.gray
        btn.setTitleColor(UIColor.white, for: .normal)
        self.addSubview(btn)
        return btn
    }()
    
    lazy var backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(dClick(_:)), for: .touchUpInside)
        btn.frame = CGRect(x: self.w - 120, y: 20, width: 40, height: 30)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.setTitle("后", for: .normal)
        btn.backgroundColor = UIColor.gray
        btn.setTitleColor(UIColor.white, for: .normal)
        self.addSubview(btn)
        return btn
    }()
    
    @objc func dClick(_ sender:UIButton) {
        if sender.titleLabel?.text == "前" {
            dyWidth.d = true
        }else {
            dyWidth.d = false
        }
    }
}
