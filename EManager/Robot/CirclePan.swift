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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func panEvent(_ sender:UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        var x = point.x - self.Ctr.center.x
        var y = point.y - self.Ctr.center.y

        let sin_α = y / sqrt(pow(x, 2.0) + pow(y, 2.0))
        var angl = asin(sin_α);
        let int_angl = Int((180.0/CGFloat.pi)*angl)
        let sign = CGFloat(x < 0 ? -1.0 : 1.0)
        if angl > -0.6 && sign > 0{
            angl = -0.6
        }
        
        if angl > -1.5 && sign < 0{
            angl = -1.5
        }
        current.setTitle("\(int_angl) -- \(angl)", for: .normal)
        x = 100.0*cos(angl)*sign + self.Ctr.center.x
        y = 100.0*sin(angl) + self.Ctr.center.y
        self.head.center = CGPoint(x: x, y: y)
        
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
        view.setTitle("头", for: .normal)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.orange.cgColor
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
        _lineShape.lineJoin = kCALineJoinRound
        _lineShape.lineCap = kCALineCapSquare
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
