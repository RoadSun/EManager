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
    var w:CGFloat = 6  // 单位线宽
    var w0:CGFloat = 6 // 动态线宽
    var rate:CGFloat = 0
    var rate0:CGFloat = 0 // 小圆半径
    var d:Bool = true // 方向
    mutating func c(_ d_r:CGFloat) {
        r0 = d_r
        if r0 - r <= 0 {
            rate0 = 1 - r0/r
            w0 = w + w*(1-rate)
            d = true
        }else if(r0 - r <= r && r0 - r > 0){
            rate = 1+(r - r0)/r
            rate0 = (r - r0)/r
            w0 = w + w*((r - r0)/r)*0.5
            d = false
        }
    }
}

class SLimbControl: SFaceBase {

    var pointsArray = [CGPoint(x: 300, y: 200), CGPoint(x: 300, y: 400), CGPoint(x: 300, y: 600)]
    var pointsArrayBase = [CGPoint(x: 300, y: 200), CGPoint(x: 300, y: 400), CGPoint(x: 300, y: 600)]
    
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
                if SOperationModel.r_between(pointsArray[teamCurrentPoint.i0 - 1], point) <= 200 {
                    movePoint = point
                    pointsArray[teamCurrentPoint.i0] = point
                    dyWidth.c(SOperationModel.r_between(pointsArray[teamCurrentPoint.i0 - 1], point))
                }else{
                    dyWidth.c(SOperationModel.r_between(pointsArray[teamCurrentPoint.i0 - 1], point))
                    let pt = SOperationModel.omodel_body_moveRange(point, pointsArray[teamCurrentPoint.i0 - 1], dyWidth.rate * 200)
                    movePoint = pt
                    pointsArray[teamCurrentPoint.i0] = pt
                }
            }
        }
        self.setNeedsDisplay()
    }
    
    override func tapEvent(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        for (index,pt) in pointsArray.enumerated() {
            if SOperationModel.r_between(pt, point) <= 20 {
                // 点中设置
                movePoint = pt
                teamCurrentPoint.pt.point = pt
                teamCurrentPoint.bpt.point = pointsArrayBase[index]
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
        
        
        // 关节点
        for (index, pt) in pointsArray.enumerated() {
            if teamCurrentPoint.i0 == index {
                SFacePen.draw_circle(pt, 20, .white, context, true, 3)
                SFacePen.draw_circle(pt, 10 + 10 * dyWidth.rate0 * 0.5, .red, context)
            }else{
                SFacePen.draw_circle(pt, 10, .green, context)
            }
        }
        
        // 肢体连接线
        for (index, pt) in pointsArray.enumerated() {
            if index != pointsArray.count - 1 {
                if index + 1 == teamCurrentPoint.i0 {
                    SFacePen.draw_line(pt, pointsArray[index + 1], context, .orange, dyWidth.w0)
                }else{
                    SFacePen.draw_line(pt, pointsArray[index + 1], context, .orange, dyWidth.w)
                }
            }
        }
        
//        SFacePen.draw_ellipse_rect(_OP.center, eye__sub__y - self.w/2, eyeSubSize, .black, context, CGFloat.pi*1.5 - SOperationModel.omodel_body_angle(_OP.center, eyeMove))

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
