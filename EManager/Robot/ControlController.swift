//
//  ControlController.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/12.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class ControlController: UIViewController, SDynamicDataDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false

        //脸
        control = SFaceControl(frame: CGRect(x: 50, y: 50, width: 600, height: 700))
        control.backgroundColor = .black

        // 操控点
        operationLine = SOperationLine(frame: CGRect(x: 700, y: 50, width: 400, height: 400))
        operationLine.isHidden = true
        operationLine.backgroundColor = .lightGray
//
        // 脖子, 脸部朝向
        neck = SNeckControl(frame: CGRect(x: 50, y: 50, width: 600, height: 700))
        
        // 身体
        body = SBodyControl(frame: CGRect(x: 50, y: 50, width: 600, height: 700))

        // 测试
        hand = SHandControl(frame: CGRect(x: 50, y: 50, width: 600, height: 700))
//
        // 测试
        limb = SLimbControl(frame: CGRect(x: 50, y: 50, width: 600, height: 700))
                self.view.addSubview(neck)
                self.view.addSubview(body)
        self.view.addSubview(hand)
                self.view.addSubview(limb)
        
        web = SThreejsControl(frame: CGRect(x: 50, y: 50, width: 600, height: 700))
        self.view.addSubview(web)
        // 环形控制
        operationCircle = SOperationCircle(frame: CGRect(x: 700, y: 50, width: 400, height: 400))
        operationCircle.isHidden = true
        operationCircle.backgroundColor = .lightGray
        
        // 环形控制
        operationHandle = SOperationHandle(frame: CGRect(x: 700, y: 50, width: 400, height: 400))
        operationHandle.isHidden = true
        operationHandle.backgroundColor = .lightGray
        
        // 控制器
        operationCross = SOperationCross(frame: CGRect(x: 700, y: 50, width: 400, height: 400))
        operationCross.isHidden = true
        operationCross.backgroundColor = .lightGray
        
        // 控制器
        operationRotate = SOperationRotate(frame: CGRect(x: 700, y: 50, width: 400, height: 400))
        operationRotate.isHidden = true
        operationRotate.backgroundColor = .lightGray
        
        let bridge = SControlOperationBridge()
        bridge.ctl_face = control
        bridge.ctl_neck = neck
        bridge.ctl_body = body
        bridge.ctl_hand = hand
        bridge.ctl_limb = limb
        
        bridge.opt_line = operationLine
        bridge.opt_circle = operationCircle
        bridge.opt_handle = operationHandle
        bridge.opt_cross = operationCross
        bridge.opt_rotate = operationRotate
        bridge.setDelegates()
        
        self.view.backgroundColor = .black
        self.view.addSubview(control)
        self.view.addSubview(operationLine)

        self.view.addSubview(operationCircle)
        self.view.addSubview(operationHandle)
        self.view.addSubview(operationCross)
        self.view.addSubview(operationRotate)
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: 0, y: 0)
        transform = transform.scaledBy(x: 1, y: 1)
        control.transform = transform
        
        _ = valSliderL
        _ = valSliderR
        _ = faceLog
        _ = test
        
        _ = slider1
        _ = slider2
        _ = slider3
        
        let names = ["face","neck","body","hand","limb","web"]
        let seg = UISegmentedControl(items: names)
        seg.frame = CGRect(x: 50, y: 10, width: 200, height: 30)
        seg.addTarget(self, action: #selector(segClick(_:)), for: .valueChanged)
        self.view.addSubview(seg)
        
        _ = startBtn
        _ = pauseBtn
        data = SDynamicData()
        data.getRobData()
        data.delegate = self
    }
    
    @objc func segClick(_ sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            self.view.bringSubviewToFront(control)
        } else if (sender.selectedSegmentIndex == 1) {
            self.operationCircle.isHidden = false
            self.view.bringSubviewToFront(neck)
        } else if (sender.selectedSegmentIndex == 2) {
            self.view.bringSubviewToFront(body)
        } else if (sender.selectedSegmentIndex == 3) {
            self.view.bringSubviewToFront(hand)
        } else if (sender.selectedSegmentIndex == 4) {
            self.view.bringSubviewToFront(limb)
        } else if (sender.selectedSegmentIndex == 5) {
            self.view.bringSubviewToFront(web)
        }
    }
    
    var control:SFaceControl!
    var operationLine:SOperationLine!
    var operationCircle:SOperationCircle!
    var operationHandle:SOperationHandle!
    var operationCross:SOperationCross!
    var operationRotate:SOperationRotate!
    var neck:SNeckControl!
    var body:SBodyControl!
    var limb:SLimbControl!
    var hand:SHandControl!
    var web:SThreejsControl!
    var scroll:UIScrollView!
    // 取整, 整数错值进行下一赋值动作
    var forValue = 0
    func control_outputValue(_ value: CGFloat, _ tag:Int) {
        if tag == 8 {
            
            return
        }
        
        if tag == 9 {
            
            return
        }
        
        if tag == 20 { // 脖子
            faceLog.name("头部左轴")
        }
    }
    
    func control_nameCurrentRangeValue(_ value: String, _ min: String, _ max: String) {
        faceLog.name(value)
        faceLog.range("\(min) ~ \(max)")
    }
    
    func control_outputObj(_ value: [String : Any], _ tag: Int) {
        if tag == 0 {
            control.face_eyeMove(value["vval"] as! CGFloat, value["hval"] as! CGFloat)
        }
    }

    func operation_outputValue(_ value: CGFloat) {
//        control.face_other(value)
        print(value)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 头右偏
    lazy var valSliderL: UISlider = {
        let slider = UISlider()
        slider.frame = CGRect(x: 900, y: 530, width: 200, height: 40)
        slider.maximumValue = Float(CGFloat.pi/6)
        slider.value = 0
        slider.minimumValue = -Float(CGFloat.pi/6)
        slider.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        self.view.addSubview(slider)
        return slider
    }()
    // 头左偏
    lazy var valSliderR: UISlider = {
        let slider = UISlider()
        slider.isEnabled = false
        slider.frame = CGRect(x: 900, y: 590, width: 200, height: 40)
        slider.maximumValue = 0
        slider.value = 0
        slider.minimumValue = -Float(CGFloat.pi/3)
        slider.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        self.view.addSubview(slider)
        return slider
    }()
    
    lazy var faceLog: SFaceLog = {
        let log = Bundle.main.loadNibNamed(String(describing: SFaceLog.self), owner: self, options: nil)?.last as! SFaceLog
        log.origin = CGPoint(x: 50, y: 50)
        self.view.addSubview(log)
        return log
    }()
    
    lazy var test: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(testClick(_:)), for: .touchUpInside)
        btn.frame = CGRect(x: control.w + 20, y: control.y + 20, width: 40, height: 30)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.setTitle("测试", for: .normal)
        btn.backgroundColor = UIColor.gray//RGBA16(value: 0x00ffff, Alpha: 1)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.isHidden = true
        self.view.addSubview(btn)
        return btn
    }()
    var isChange:Bool = false
    @objc func testClick(_ sender:UIButton) {
        isChange = !isChange
    }
    
    @objc func sliderChange(_ sender:UISlider) {
        if sender == valSliderL {
            var transform = CGAffineTransform.identity
            transform = transform.translatedBy(x: 0, y: 0)
            transform = transform.scaledBy(x: 1, y: 1)
            transform = transform.rotated(by: CGFloat(sender.value))
            control.transform = transform
        }else {
            var transform = CGAffineTransform.identity
            transform = transform.translatedBy(x: 0, y: 0)
            transform = transform.scaledBy(x: 1, y: 1)
            transform = transform.rotated(by: CGFloat(sender.value))
            control.transform = transform
        }
    }
    
    lazy var slider1: UISlider = {
        let slider = UISlider()
        slider.frame = CGRect(x: 900, y: 620, width: 200, height: 40)
        slider.maximumValue = Float(operationLine.w - 120.0)
        slider.value = 0
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(sliderChange1(_:)), for: .valueChanged)
        self.view.addSubview(slider)
        return slider
    }()
    
    lazy var slider2: UISlider = {
        let slider = UISlider()
        slider.frame = CGRect(x: 900, y: 670, width: 200, height: 40)
        slider.maximumValue = 180
        slider.value = 0
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(sliderChange1(_:)), for: .valueChanged)
        self.view.addSubview(slider)
        return slider
    }()
    
    lazy var slider3: UISlider = {
        let slider = UISlider()
        slider.frame = CGRect(x: 900, y: 720, width: 200, height: 40)
        slider.maximumValue = Float(CGFloat.pi * 2.0)
        slider.value = 0
        slider.minimumValue = 0
        slider.addTarget(self, action: #selector(sliderChange1(_:)), for: .valueChanged)
        self.view.addSubview(slider)
        return slider
    }()
    
    @objc func sliderChange1(_ sender:UISlider) {
        if sender == slider1 {
            
        }
        
        if sender == slider2 {
//            operation.setPoint(CGPoint(x: operation.mPt.x, y: CGFloat(sender.value)))
            operationLine.setCurrentValue(CGFloat(sender.value))
        }
        
        if sender == slider3 {
            operationLine.setAgl(CGFloat(sender.value))
        }
    }
    
    var data:SDynamicData!
    lazy var startBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(startBtnClick(_:)), for: .touchUpInside)
        btn.frame = CGRect(x: 20, y: 120, width: 50, height: 30)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.setTitle("开始", for: .normal)
        btn.backgroundColor = UIColor.gray
        btn.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(btn)
        return btn
    }()
    
    lazy var pauseBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(startBtnClick(_:)), for: .touchUpInside)
        btn.frame = CGRect(x: 20, y: 160, width: 50, height: 30)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.setTitle("暂停", for: .normal)
        btn.backgroundColor = UIColor.gray
        btn.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(btn)
        return btn
    }()
    
    @objc
    func startBtnClick(_ sender:UIButton) {
        if sender == startBtn {
            data.start()
        }else{
            data.pause()
        }
    }
    
    func data_output(_ section: Int, _ value: Int, _ list: [Int]) {
        print(list)
        control.face_data(list)
//        print("section : \(section) -- value : \(value)")
//        control.face_other(CGFloat(value))
    }
}
