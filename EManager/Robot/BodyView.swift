//
//  BodyView.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/12.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

var radius:CGFloat = 20
var w_h:CGFloat = 40
var screenW = UIScreen.main.bounds.size.width
var screenH = UIScreen.main.bounds.size.height

var BodyPoints = ["ctr":CGPoint(x:screenW / 2,y:screenH / 2),
                  "neck":CGPoint(x:screenW / 2,y:screenH / 2-200),
                  "head":CGPoint(x:screenW / 2,y:screenH / 2-200-80),
                  "l_shoulder":CGPoint(x:screenW / 2-120,y:screenH / 2-200),
                  "r_shoulder":CGPoint(x:screenW / 2+120,y:screenH / 2-200),
                  "l_elbow":CGPoint(x:screenW / 2-120,y:screenH / 2-200+100),
                  "r_elbow":CGPoint(x:screenW / 2+120,y:screenH / 2-200+100),
                  "l_hand":CGPoint(x:screenW / 2-120,y:screenH / 2-200+100+100),
                  "r_hand":CGPoint(x:screenW / 2+120,y:screenH / 2-200+100+100),
                  "l_butt":CGPoint(x:screenW / 2-60,y:screenH / 2),
                  "r_butt":CGPoint(x:screenW / 2+60,y:screenH / 2),
                  "l_knee":CGPoint(x:screenW / 2-60,y:screenH / 2+140),
                  "r_knee":CGPoint(x:screenW / 2+60,y:screenH / 2+140),
                  "l_foot":CGPoint(x:screenW / 2-60,y:screenH / 2+140+100),
                  "r_foot":CGPoint(x:screenW / 2+60,y:screenH / 2+140+100)]

class BodyView: UIView {
    var _lineShape:CAShapeLayer!
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = carvas
        _ = self.Ctr
        _ = self.neck
        _ = self.head
        
        _ = self.l_shoulder
        _ = self.l_elbow
        _ = self.l_hand
        _ = self.l_butt
        _ = self.l_knee
        _ = self.l_foot
        
        _ = self.r_shoulder
        _ = self.r_elbow
        _ = self.r_hand
        _ = self.r_butt
        _ = self.r_knee
        _ = self.r_foot
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panEvent(_ sender:UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        if RobotHandle.isEnable(moving: point, current: self.head.center, max: 40) == false {
            return
        }
        let ARange = RobotHandle.adjustRange(60, 120, moving: point, fixed: self.neck.center, length: 100)
        
        self.head.center = CGPoint(x: ARange.x, y:ARange.y)
        
        let linePath = CGMutablePath()
        linePath.move(to: self.neck.center)
        linePath.addLine(to: self.head.center)
        
        let linePath1 = CGMutablePath()
        linePath1.move(to: self.Ctr.center)
        linePath1.addLine(to: self.neck.center)
        
        let linePath2 = CGMutablePath()
        linePath2.move(to: self.neck.center)
        linePath2.addLine(to: self.l_shoulder.center)
        
        let linePath3 = CGMutablePath()
        linePath3.move(to: self.neck.center)
        linePath3.addLine(to: self.r_shoulder.center)
        
        let linePath4 = CGMutablePath()
        linePath4.move(to: self.l_shoulder.center)
        linePath4.addLine(to: self.l_elbow.center)
        
        let linePath5 = CGMutablePath()
        linePath5.move(to: self.r_shoulder.center)
        linePath5.addLine(to: self.r_elbow.center)
        
        let linePath6 = CGMutablePath()
        linePath6.move(to: self.l_elbow.center)
        linePath6.addLine(to: self.l_hand.center)
        
        let linePath7 = CGMutablePath()
        linePath7.move(to: self.r_elbow.center)
        linePath7.addLine(to: self.r_hand.center)
        
        let linePath8 = CGMutablePath()
        linePath8.move(to: self.Ctr.center)
        linePath8.addLine(to: self.l_butt.center)
        
        let linePath9 = CGMutablePath()
        linePath9.move(to: self.Ctr.center)
        linePath9.addLine(to: self.r_butt.center)
        
        let linePath10 = CGMutablePath()
        linePath10.move(to: self.l_butt.center)
        linePath10.addLine(to: self.l_knee.center)
        
        let linePath11 = CGMutablePath()
        linePath11.move(to: self.r_butt.center)
        linePath11.addLine(to: self.r_knee.center)
        
        let linePath12 = CGMutablePath()
        linePath12.move(to: self.l_knee.center)
        linePath12.addLine(to: self.l_foot.center)
        
        let linePath13 = CGMutablePath()
        linePath13.move(to: self.r_knee.center)
        linePath13.addLine(to: self.r_foot.center)
        
        self.nlineShape(linePath,true)
        self.nlineShape(linePath1,false)
        self.nlineShape(linePath2,false)
        self.nlineShape(linePath3,false)
        self.nlineShape(linePath4,false)
        self.nlineShape(linePath5,false)
        self.nlineShape(linePath6,false)
        self.nlineShape(linePath7,false)
        self.nlineShape(linePath8,false)
        self.nlineShape(linePath9,false)
        self.nlineShape(linePath10,false)
        self.nlineShape(linePath11,false)
        self.nlineShape(linePath12,false)
        self.nlineShape(linePath13,false)
    }
    
    lazy var Ctr: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("丹田", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.center = BodyPoints["ctr"]!
        return view
    }()
    
    lazy var neck: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("脖", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.center = BodyPoints["neck"]!
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
        view.center = BodyPoints["head"]!
        self.addSubview(view)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        view.addGestureRecognizer(pan)
        return view
    }()
    
    lazy var l_shoulder: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("左肩", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.center = BodyPoints["l_shoulder"]!
        return view
    }()
    
    lazy var r_shoulder: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("右肩", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.center = BodyPoints["r_shoulder"]!
        return view
    }()
    
    lazy var l_elbow: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("左肘", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.center = BodyPoints["l_elbow"]!
        return view
    }()
    
    lazy var r_elbow: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("右肘", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.center = BodyPoints["r_elbow"]!
        return view
    }()
    
    lazy var l_hand: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("左手", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.center = BodyPoints["l_hand"]!
        view.addTarget(self, action: #selector(l_handClick(_:)), for: .touchUpInside)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        view.addGestureRecognizer(pan)
        return view
    }()
    
    @objc func l_handClick(_ sender:UIButton) {
        
    }
    
    lazy var r_hand: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("右手", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.center = BodyPoints["r_hand"]!
        return view
    }()
    
    lazy var l_butt: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("左胯", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.center = BodyPoints["l_butt"]!
        return view
    }()
    
    lazy var r_butt: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("右胯", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.center = BodyPoints["r_butt"]!
        return view
    }()
    
    lazy var l_knee: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("左膝", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.center = BodyPoints["l_knee"]!
        return view
    }()
    
    lazy var r_knee: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("右膝", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.center = BodyPoints["r_knee"]!
        return view
    }()
    
    
    lazy var l_foot: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("左脚", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.center = BodyPoints["l_foot"]!
        return view
    }()
    
    lazy var r_foot: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("右脚", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.backgroundColor = UIColor.white
        self.addSubview(view)
        view.frame.size = CGSize(width: w_h, height: w_h)
        view.center = BodyPoints["r_foot"]!
        return view
    }()
    
    lazy var carvas: UIView = {
        let bg = UIView(frame: self.bounds)
        bg.backgroundColor = UIColor .white
        self.addSubview(bg)
        return bg
    }()
    
    func nlineShape(_ path:CGPath, _ clear:Bool) {
        if clear == true{
            self.carvas.layer.sublayers?.removeAll()
        }
        let layer = CAShapeLayer()
        layer.frame = CGRect.init(x: 0, y: 0, width: 600, height: 400)
        layer.lineWidth = 2
        layer.lineJoin = kCALineJoinRound
        layer.lineCap = kCALineCapSquare
        layer.strokeColor = UIColor.blue.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.path = path
        self.carvas.layer.addSublayer(layer)
    }
    
}
