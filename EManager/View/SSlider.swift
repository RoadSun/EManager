//
//  SSlider.swift
//  DSRobotEditorPad
//
//  Created by Sunlu on 2019/1/4.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

protocol SSliderDirTypeDelegate {
    func slider_output(_ sender:SSlider, _ value:CGFloat)
}

enum SSliderDirType {
    case h
    case v
}

class SSlider: UIView {
    var delegate:SSliderDirTypeDelegate! // 输出代理
    var sliderType:SSliderDirType = .h   // 默认水平样式
    var maxValue:CGFloat! // 最大值
    var minValue:CGFloat! // 最小值
    var currentValue:CGFloat! // 当前值
    var ratio:CGFloat = 0 // 比率(开发不需要填)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.alpha = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAngle(_ value:CGFloat) {
        monitor.text = "\(value)"
    }
    
    func setCurrentValue(_ value:CGFloat) {
        if sliderType == .h {
            var value_transfer = value / self.ratio
            value_transfer = value_transfer + move.w/2
            move.centerX = value_transfer
            if move.x < 0 {
                move.x = 0
            }
            if move.cRgt > self.w {
                move.x = self.w - move.w
            }
            point.centerX = move.centerX
            monitor.centerX = move.centerX
            self.currentValue = CGFloat(Int(value))
        }else{
            var value_transfer = self.h - move.h - value / self.ratio
            value_transfer = value_transfer + move.h/2
            move.centerY = value_transfer
            if move.y < 0 {
                move.y = 0
            }
            if move.cBtm > self.h {
                move.y = self.h - move.h
            }
            point.centerY = move.centerY
            monitor.centerY = move.centerY
            self.currentValue = CGFloat(Int(value))
        }
        setAngle(value)
    }
    
    /*
     * 设置是否水平
     */
    func setType(_ type:SSliderDirType) {
        sliderType = type
        if type == .h {
            _ = point
            _ = move
            point.centerX = move.centerX
            point.y = move.y - 20
            monitor.y = point.y - 20
            monitor.centerX = move.centerX
        }else{
            _ = point
            move.x = 1
            move.size = CGSize(width: 18, height: 40)
            move.y = self.h - move.h
            point.centerX = move.centerX
            point.size = CGSize(width: 30, height: 2)
            point.x = point.x - 20
            point.centerY = move.centerY
            monitor.centerY = move.centerY
            monitor.x = point.x - 60
        }
    }
    
    // 高亮部分
    lazy var light: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.backgroundColor = UIColor.orange
        self.addSubview(view)
        return view
    }()
    
    lazy var move: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 1, width: 40, height: 18))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        self.addSubview(view)
        return view
    }()
    
    lazy var point: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 30))
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.red
        self.addSubview(view)
        return view
    }()
    
    lazy var monitor: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        label.layer.cornerRadius = 1
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.text = "180"
        self.addSubview(label)
        return label
    }()
    
    /*
     * 设置最大最小值范围
     */
    func setRange(min:CGFloat, max:CGFloat) {
        self.currentValue = CGFloat(Int(min))
        self.minValue = min
        self.maxValue = max
        if sliderType == .h {
            self.ratio = (max - min) / (self.w - move.w)
        }else{
            self.ratio = (max - min) / (self.h - move.h)
        }
        self.monitor.text = "\(min)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            print(t.location(in: self))
            let pnt = t.location(in: self)
            if sliderType == .h {
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.move.centerX = pnt.x
                    if self.move.x < 0 {
                        self.move.x = 0
                    }
                    if self.move.cRgt > self.w {
                        self.move.x = self.w - self.move.w
                    }
                    self.point.centerX = self.move.centerX
                    self.monitor.centerX = self.move.centerX
                }) { (bool) in
                    if self.delegate != nil {
                        let val = self.minValue + self.ratio * (self.move.centerX - self.move.w/2)
                        self.delegate.slider_output(self, val)
                        self.currentValue = CGFloat(Int(val))
                        self.monitor.text = "\(Int(val))"
                    }
                }
                
            }else{
                UIView.animate(withDuration: 0.5, animations: {
                    self.move.centerY = pnt.y
                    if self.move.y < 0 {
                        self.move.y = 0
                    }
                    if self.move.cBtm > self.h {
                        self.move.y = self.h - self.move.h
                    }
                    self.point.centerY = self.move.centerY
                    self.monitor.centerY = self.move.centerY
                }) { (bool) in
                    if self.delegate != nil {
                        let val = self.minValue + self.ratio * (self.h - (self.move.centerY + self.move.h/2))
                        self.delegate.slider_output(self, val)
                        self.currentValue = CGFloat(Int(val))
                        self.monitor.text = "\(Int(val))"
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            print(t.location(in: self))
            let pnt = t.location(in: self)
            //            if pnt.x > move.x && pnt.x < move.cRgt && pnt.y > move.y && pnt.y < move.cBtm {
            if sliderType == .h {
                move.centerX = pnt.x
                if move.x < 0 {
                    move.x = 0
                }
                if move.cRgt > self.w {
                    move.x = self.w - move.w
                }
                point.centerX = move.centerX
                monitor.centerX = move.centerX
                if self.delegate != nil {
                    let val = self.minValue + self.ratio * (move.centerX - move.w/2)
                    self.delegate.slider_output(self, val)
                    self.currentValue = CGFloat(Int(val))
                    monitor.text = "\(Int(val))"
                }
            }else{
                move.centerY = pnt.y
                if move.y < 0 {
                    move.y = 0
                }
                if move.cBtm > self.h {
                    move.y = self.h - move.h
                }
                point.centerY = move.centerY
                monitor.centerY = move.centerY
                if self.delegate != nil {
                    let val = self.minValue + self.ratio * (self.h - (move.centerY + move.h/2))
                    self.delegate.slider_output(self, val)
                    self.currentValue = CGFloat(Int(val))
                    monitor.text = "\(Int(val))"
                }
                //                }
            }
        }
    }
}
