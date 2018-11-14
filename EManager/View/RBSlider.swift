//
//  RBSlider.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/14.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit


typealias ResultBlock = (_ value:CGFloat)->()
class RBSlider: UIView {
    var valChange:ResultBlock!
    init(frame: CGRect, min:CGFloat = 0, max:CGFloat = 180, v:Int = 0, result:@escaping ResultBlock) {
        super.init(frame: frame)
        
        if v == 1 {
            lbtn.frame.origin.y = 5
            slider.frame.origin.y = 5
            slider.transform = CGAffineTransform.init(rotationAngle: -CGFloat.pi/2)
            slider.frame.origin.y = 50
            slider.frame.size = CGSize(width: 40, height: self.frame.size.height - 100)
            rbtn.frame.origin.y = self.frame.size.height - 45
        }else{
            rbtn.frame.origin.x = 5
            slider.frame.origin.x = 50
            slider.frame.size.width = self.frame.size.width - 100
            lbtn.frame.origin.x = self.frame.size.width - 45
        }
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        valChange = result
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sliderChange(_ sender:UISlider) {
        valChange(CGFloat(Int(sender.value)))
    }
    
    @objc func lbtnClick(_ sender:UIButton) {
        if slider.value + 1 > 180 {
            slider.value = 180
            return
        }
        self.slider.value = slider.value + 1
        valChange(CGFloat(Int(self.slider.value)))
    }
    
    @objc func rbtnClick(_ sender:UIButton) {
        if slider.value - 1 < 0 {
            slider.value = 0
            return
        }
        self.slider.value = slider.value - 1
        valChange(CGFloat(Int(self.slider.value)))
    }

    lazy var lbtn:UIButton = {
        let btn = UIButton(type: .system)
        btn.frame.size = CGSize(width: 40, height: 40)
        btn.backgroundColor = UIColor.white
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.setTitle("十", for: .normal)
        btn.addTarget(self, action: #selector(lbtnClick(_:)), for: .touchUpInside)
        self.addSubview(btn)
        return btn
    }()
    
    lazy var slider:UISlider = {
        let slider = UISlider()
        slider.frame.size = CGSize(width: self.frame.size.width, height: 40)
        slider.minimumValue = 0
        slider.maximumValue = 180
        slider.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        self.addSubview(slider)
        return slider
    }()
    
    lazy var rbtn:UIButton = {
        let btn = UIButton(type: .system)
        btn.frame.size = CGSize(width: 40, height: 40)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.layer.borderWidth = 0.5
        btn.setTitle("一", for: .normal)
        btn.addTarget(self, action: #selector(rbtnClick(_:)), for: .touchUpInside)
        self.addSubview(btn)
        return btn
    }()
}
