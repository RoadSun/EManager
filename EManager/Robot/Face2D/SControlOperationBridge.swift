//
//  SControlOperationBridge.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/23.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SControlOperationBridge: UIViewController, SControlDelegate,SOperationDelegate {

    var ctl_face:SFaceControl!
    var ctl_neck:SNeckControl!
    var ctl_body:SBodyControl!
    var ctl_hand:SHandControl!
    var ctl_limb:SLimbControl!
    
    var opt_line:SOperationLine!
    var opt_circle:SOperationCircle!
    var opt_handle:SOperationHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // 设置操作器 控制器代理
    func setDelegates() {
        ctl_face.delegate = self
        ctl_neck.delegate = self
        ctl_body.delegate = self
        ctl_hand.delegate = self
        ctl_limb.delegate = self
        
        opt_line.op_delegate = self
        opt_circle.op_delegate = self
        opt_handle.op_delegate = self
    }
    
    // 操作器代理
    func operation_outputValue(_ value: CGFloat) {
        ctl_face.face_other(value)
    }
    
    func operation_outputObj(_ value: [String : Any], _ tag: Int) {
        if tag == 0 {
            ctl_face.face_eyeMove(value["vval"] as! CGFloat, value["hval"] as! CGFloat)
        }
    }
    
    func operation_outputStruct(_ obj: Any) {
        let angle = (obj as! SAngle)
        ctl_neck.setCurrentValue(angle.radian)
    }
    
    // 控制器代理
    func control_outputValue(_ value: CGFloat, _ tag: Int) {
        if tag == 20 {
            opt_circle.setCurrentValue(value)
        }else{
            opt_line.setCurrentValue(value)
        }
    }
    
    func control_nameCurrentRangeValue(_ value: String, _ min: String, _ max: String) {
        
    }
    
    func control_pointData(_ pt: SPt) {
        if pt.type == .line {
            opt_circle.isHidden = true
            opt_handle.isHidden = true
            opt_line.isHidden = false
            
            opt_line.setAgl(pt.angle)
        } else if (pt.type == .circle) {
            opt_line.isHidden = true
            opt_handle.isHidden = true
            opt_circle.isHidden = false
        }else if (pt.type == .handle) {
            opt_line.isHidden = true
            opt_circle.isHidden = true
            opt_handle.isHidden = false
        }
    }
}
