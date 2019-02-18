//
//  SCanvasControl.swift
//  DSRobotEditorPad
//
//  Created by Sunlu on 2019/1/28.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

protocol SCanvasControlDelegate {
    func switch_control_leftAndRight(_ sender:UISwitch)
    func switch_control_upAndDown(_ sender:UISwitch)
    func switch_control_rectSelected(_ sender:UISwitch)
    func btn_btnClick(_ sender:UIButton)
}

class SCanvasControl: UIView {
    
    var delegate:SCanvasControlDelegate!
    @IBOutlet weak var leftRight: UISwitch!
    @IBOutlet weak var upDown: UISwitch!
    @IBOutlet weak var rectSelect: UISwitch!
    @IBOutlet weak var pushSwitch: UISwitch!
    var isPush:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.w = 114
        self.h = 311
        
        leftRight.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        leftRight.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        
        upDown.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        upDown.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        
        rectSelect.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        rectSelect.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        
        pushSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        pushSwitch.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.masksToBounds = false
        
        let swip = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swip.direction = .right
        self.addGestureRecognizer(swip)
        self.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchEvent(_:)))
        self.addGestureRecognizer(pinch)
    }
    
    @objc func swipeEvent(_ swipe:UISwipeGestureRecognizer) {
        if (swipe.direction == .right) {
            UIView.animate(withDuration: 0.3) {
                self.x = ScreenW
            }
        }
    }
    
    @objc func pinchEvent(_ sender: UIPinchGestureRecognizer) {
        let point = sender.location(in: self)
        self.y = point.y
    }
    
    @IBAction func switch_leftAndRightEvent(_ sender: UISwitch) {
        upDown.isOn = !sender.isOn
        self.delegate.switch_control_leftAndRight(sender)
    }
    
    @IBAction func switch_upAndDownEvent(_ sender: UISwitch) {
        leftRight.isOn = !sender.isOn
        self.delegate.switch_control_upAndDown(sender)
    }
    
    @IBAction func switch_rectSelectedEvent(_ sender: UISwitch) {
        self.delegate.switch_control_rectSelected(sender)
    }
    
    @IBAction func switch_pushEvent(_ sender: UISwitch) {
        leftRight.isOn = !sender.isOn
        upDown.isOn = !sender.isOn
        isPush = sender.isOn
    }
    
    @IBAction func copyClick(_ sender: UIButton) {
        self.delegate.btn_btnClick(sender)
    }
    
    @IBAction func insertClick(_ sender: UIButton) {
        self.delegate.btn_btnClick(sender)
    }
    
    @IBAction func replaceClick(_ sender: UIButton) {
        self.delegate.btn_btnClick(sender)
    }
    
    @IBAction func mirrorClick(_ sender: UIButton) {
        self.delegate.btn_btnClick(sender)
    }
    
    @objc func switchEvent(_ sender:UISwitch) {
        
    }
    
    func createSwitch(_ tag:Int) -> UISwitch {
        let sv = self.viewWithTag(tag)
        if sv != nil {
            return sv as! UISwitch
        }
        let s = UISwitch(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        s.size = CGSize(width: 60, height: 30)
        s.tag = tag
        s.onTintColor = UIColor.black
        s.x = frame.size.width - 80
        s.y = 70
        s.tintColor = UIColor.lightGray
        s.addTarget(self, action: #selector(switchEvent(_:)), for: .valueChanged)
        self.addSubview(s)
        return s
    }
}
