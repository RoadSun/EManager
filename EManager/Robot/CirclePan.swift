//
//  CirclePan.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/12.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class CirclePan: UIView {
    var _lineShape:CAShapeLayer!
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = carvas
        _ = self.Ctr
        _ = self.head
        _ = min
        _ = max
        _ = current
        let linePath = CGMutablePath()
        linePath.move(to: self.Ctr.center)
        linePath.addLine(to: self.head.center)
        self.nlineShape(linePath)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panEvent(_ sender:UIPanGestureRecognizer) {
        let point = sender.location(in: self)

        if RobotHandle.isEnable(moving: point, current: self.center, max: 40) == false {
            return
        }
        let ARange = RobotHandle.adjustRange(30, 120, moving: point, fixed: self.Ctr.center, length: 100)
 
        self.head.center = CGPoint(x: ARange.x, y:ARange.y)
        
        let linePath = CGMutablePath()
        linePath.move(to: self.Ctr.center)
        linePath.addLine(to: self.head.center)
        self.nlineShape(linePath)
    }
    
    lazy var carvas: UIView = {
        let bg = UIView(frame: self.bounds)
        bg.backgroundColor = UIColor .white
        self.addSubview(bg)
        return bg
    }()
    
    lazy var Ctr: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("丹田", for: .normal)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.frame.size = CGSize(width: 40, height: 40)
        view.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addSubview(view)
        return view
    }()
    
    lazy var head: UIView = {
        let view = UIButton(type: .system)
        view.setBackgroundImage(BasicFunction.Img("headicon"), for: .normal)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 1
        view.frame.size = CGSize(width: 80, height: 80)
        view.center = CGPoint(x: self.Ctr.center.x, y: self.Ctr.center.y - 100)
        self.addSubview(view)

        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        view.addGestureRecognizer(pan)
        return view
    }()
    
    func nlineShape(_ path:CGPath) {
        if _lineShape != nil {
            _lineShape.removeFromSuperlayer()
        }
        _lineShape = CAShapeLayer()
        _lineShape.frame = CGRect.init(x: 0, y: 0, width: 600, height: 400)
        _lineShape.lineWidth = 2
        _lineShape.lineJoin = CAShapeLayerLineJoin.round
        _lineShape.lineCap = CAShapeLayerLineCap.square
        _lineShape.strokeColor = UIColor.blue.cgColor
        _lineShape.fillColor = UIColor.clear.cgColor
        _lineShape.path = path
        self.carvas.layer.addSublayer(_lineShape)
    }
    
    lazy var min: UITextField = {
        let min = UITextField(frame: CGRect(x: 10, y: 10, width: 50, height: 40))
        min.placeholder = "最小值"
        min.layer.cornerRadius = 4
        min.layer.masksToBounds = true
        min.layer.borderWidth = 0.5
        min.layer.borderColor = UIColor.lightGray.cgColor
        min.text = "60"
        self.addSubview(min)
        return min
    }()
    
    lazy var max: UITextField = {
        let min = UITextField(frame: CGRect(x: self.frame.size.width - 60, y: 10, width: 50, height: 40))
        min.placeholder = "最大值"
        min.layer.cornerRadius = 4
        min.layer.masksToBounds = true
        min.layer.borderWidth = 0.5
        min.layer.borderColor = UIColor.lightGray.cgColor
        min.text = "120"
        self.addSubview(min)
        return min
    }()
    
    lazy var current: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("丹田", for: .normal)
        view.setTitleColor(UIColor.blue, for: .normal)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        view.frame.size = CGSize(width: 240, height: 40)
        view.center = CGPoint(x: self.frame.size.width/2, y: min.center.y)
        self.addSubview(view)
        return view
    }()
}
