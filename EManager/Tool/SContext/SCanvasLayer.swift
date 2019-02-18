//
//  SCanvasLayer.swift
//  DSRobotEditorPad
//
//  Created by Sunlu on 2019/1/28.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SCanvasLayer: SCanvasBase, SCanvasControlDelegate {
    var bridge:SChartBridge = SChartBridge()
    var lineLimit:(l:CGFloat,r:CGFloat)!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setRect(_ rect:CGRect) {
        self.frame = rect
        // 转换操作模式的按钮
        createChangeBtn(21).superView = self
    }
    
    func setPointCenter(_ point:CGPoint, _ val:CGFloat = 0) {
        center_point = point
        if __model.selectedType == .point {
            __model.j_type()
            __model.m_p_moveBegin(center_point)
        }else{
            SCanvasModel.shared.config.frame.w = val * 2
            SCanvasModel.shared.config.frame.h = val * 2
            __model.m_c_moveBegin(center_point)
        }
        self.setNeedsDisplay()
    }
    
    /*
     * 专负责点选时, 中心点横坐标
     */
    func setCenterX(_ c_x:CGFloat) {
        __model.config.center.x = c_x
        __model.config.frame.x = __model.config.center.x - __model.config.frame.w / 2
        self.setNeedsDisplay()
    }
    
    /*
     * 拖动手势
     */
    override func panEvent(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        self.__model.j_type(.more)
        if self.points.count == 0 {
            self.points.append([CGPoint]())
        }
        self.points[self.points.count - 1].append(point)
        if sender.state == .began {
            self.points.append([CGPoint]())
        }else{
            self.points[self.points.count - 1].append(point)
        }
        self.setNeedsDisplay()
        return
        if __model.selectedType == .point {
            // 点选
            if sender.state == .began {
                
            }else if (sender.state == .ended) {
                
            }else{
                __model.m_p_move(point)
                self.center_point.y = __model.config.center.y
            }
            
        }else{
            // 框选
            if sender.state == .began {
                __model.m_moveBegin(point)
            }else if (sender.state == .ended) {
                // 框选结束, 需返回选出的部分
                
//                __model.config.frame.x = lineLimit.l
//                __model.config.frame.x_w = lineLimit.r
                
//                if operation.isPush {
//                    self.bridge.bridge_push_rectSelectedValue(self, __model, true)
//                }else{
//                    self.bridge.bridge_rectSelectedValue(self, __model, true)
//                }
            }else{
                if (__model.j_areaMove(point)){
                    __model.m_move(point)
                    
                    __model.j_area(.u, 0)
                    __model.j_area(.d, self.h)
                    __model.j_area(.l, 0)
                    
//                    if operation.isPush {
//                        self.bridge.bridge_push_rectSelectedValue(self, __model, false)
//                    }else{
//                        self.bridge.bridge_rectSelectedValue(self, __model, false)
//                    }
                }else{
                    // 拖动框, 选择区域
                    __model.j_drag(point)
//                    lineLimit = self.bridge.bridge_dragSelect(self, __model)
                }
            }
        }
        
        self.setNeedsDisplay()
    }
    
    override func longPressEvent(_ sender: UILongPressGestureRecognizer) {
//        operation.y = (self.superview?.y)! + self.y + createChangeBtn(21).cBtm + 10
//        operation.x = (self.superview?.x)! + self.cRgt - operation.w - 10
        _ = operation
        UIView.animate(withDuration: 0.3, animations: {
            self.operation.x = ScreenW - 114
        }) { (bool) in
            
        }
        operation.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     * 框选 点选 控制面板
     */
    func switch_control_leftAndRight(_ sender: UISwitch) {
        __model.direction = sender.isOn ? .left_and_right : .default
    }
    
    func switch_control_upAndDown(_ sender: UISwitch) {
        __model.direction = sender.isOn ? .up_and_down : .default
    }
    
    func switch_control_rectSelected(_ sender: UISwitch) {
        if sender.isOn {
            __model.direction = .default
        }else{
            __model.direction = .left_and_right
        }
    }
    
    func btn_btnClick(_ sender: UIButton) {
        
    }
    
    lazy var switchUpDown: UISwitch = {
        let switch_ = UISwitch()
        switch_.w = 10
        switch_.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        switch_.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        self.addSubview(switch_)
        return switch_
    }()
    
    lazy var switchLeftRight: UISwitch = {
        let switch_ = UISwitch()
        switch_.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        switch_.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        self.addSubview(switch_)
        return switch_
    }()
    
    lazy var switchRect: UISwitch = {
        let switch_ = UISwitch()
        switch_.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        switch_.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        self.addSubview(switch_)
        return switch_
    }()
    
    lazy var switchPush: UISwitch = {
        let switch_ = UISwitch()
        switch_.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        switch_.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        self.addSubview(switch_)
        return switch_
    }()
    
    lazy var operation: SCanvasControl = {
        let window = UIApplication.shared.windows[1]
        let control = Bundle.main.loadNibNamed("SCanvasControl", owner: self, options: nil)?.last as! SCanvasControl
        control.delegate = self
        control.x = ScreenW
        control.centerY = ScreenH/2
        control.isHidden = true
        self.addSubview(control)
        window.addSubview(control)
        return control
    }()

    func createChangeBtn(_ tag:Int) -> SChangeBtn {
        let had_btn = self.viewWithTag(tag)
        if had_btn != nil {
            return had_btn as! SChangeBtn
        }
        let b = SChangeBtn(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        b.tag = tag
        b.x = self.w - 45
        b.y = 10
        b.backgroundColor = UIColor.clear
        self.addSubview(b)
        return b
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.__model.j_type(.more)
//    }
}
