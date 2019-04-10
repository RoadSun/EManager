//
//  SFaceBase.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/4.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SFaceBase: UIView {
    // 基础数据
    var _model = SPointModel()
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panEvent(_ sender:UIPanGestureRecognizer) {}
    
    @objc func pinchEvent(_ sender:UIPinchGestureRecognizer) {}
    
    @objc func longPressEvent(_ sender:UILongPressGestureRecognizer) {}
    
    @objc func tapEvent(_ sender:UITapGestureRecognizer) {}
    
    lazy var capturePoint: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(capturePointClick(_:)), for: .touchUpInside)
        btn.frame = CGRect(x: self.w - 60, y: 20, width: 40, height: 30)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.setTitle("捕捉", for: .normal)
        btn.backgroundColor = UIColor.gray//RGBA16(value: 0x00ffff, Alpha: 1)
        btn.setTitleColor(UIColor.white, for: .normal)
        self.addSubview(btn)
        return btn
    }()
    
    var isCapture:Bool = false
    @objc func capturePointClick(_ sender:UIButton) {
        
    }
}
