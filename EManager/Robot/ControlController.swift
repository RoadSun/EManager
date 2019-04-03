//
//  ControlController.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/12.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class ControlController: UIViewController, SControlDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false

        control = SControl(frame: CGRect(x: 50, y: 50, width: 600, height: 1200))
        control.backgroundColor = .lightGray
        control.delegate = self
        self.view.backgroundColor = .black
        self.view.addSubview(control)

        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: 0, y: 0)
        transform = transform.scaledBy(x: 1, y: 1)
        control.transform = transform
        
        _ = valSliderL
        _ = valSliderR
        _ = faceLog
        _ = test
    }
    var control:SControl!
    var scroll:UIScrollView!
    // 取整, 整数错值进行下一赋值动作
    var forValue = 0
    func control_outputValue(_ value: CGFloat) {
        if forValue != Int(value) {
            forValue = Int(value)
            faceLog.current("\(forValue)")
        }
    }
    
    func control_nameCurrentRangeValue(_ value: String, _ min: String, _ max: String) {
        faceLog.name(value)
        faceLog.range("\(min) ~ \(max)")
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
}
