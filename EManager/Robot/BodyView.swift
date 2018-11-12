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
class BodyView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
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
//        200
//        self.frame.size.width / 2
        
        self.head.snp.updateConstraints { (make) in
            // 80
            make.center.equalTo(CGSize(width: 10, height: 10))
        }
    }
    
    lazy var Ctr: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("丹田", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.center.equalTo(self.snp.center)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    lazy var neck: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("脖", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.Ctr.snp.centerY).offset(-200)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    lazy var head: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("头", for: .normal)
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.orange.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.neck.snp.centerY).offset(-80)
            make.width.height.equalTo(80)
        })
        
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
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self).offset(-120)
            make.centerY.equalTo(self.neck.snp.centerY)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    lazy var r_shoulder: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("右肩", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.neck).offset(120)
            make.centerY.equalTo(self.neck)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    lazy var l_elbow: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("左肘", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.l_shoulder)
            make.centerY.equalTo(self.l_shoulder).offset(100)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    lazy var r_elbow: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("右肘", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.r_shoulder)
            make.centerY.equalTo(self.r_shoulder).offset(100)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    lazy var l_hand: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("左手", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.l_elbow)
            make.centerY.equalTo(self.l_elbow).offset(100)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    lazy var r_hand: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("右手", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.r_elbow)
            make.centerY.equalTo(self.r_elbow).offset(100)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    lazy var l_butt: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("左胯", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self).offset(-60)
            make.centerY.equalTo(self.Ctr.snp.centerY)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    lazy var r_butt: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("右胯", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self).offset(60)
            make.centerY.equalTo(self.Ctr.snp.centerY)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    lazy var l_knee: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("左膝", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.l_butt)
            make.centerY.equalTo(self.l_butt.snp.centerY).offset(130)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    lazy var r_knee: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("右膝", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.r_butt)
            make.centerY.equalTo(self.r_butt.snp.centerY).offset(130)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    
    lazy var l_foot: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("左脚", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.l_knee)
            make.centerY.equalTo(self.l_knee.snp.centerY).offset(100)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
    
    lazy var r_foot: UIView = {
        let view = UIButton(type: .system)
        view.setTitle("右脚", for: .normal)
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.black.cgColor
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.r_knee)
            make.centerY.equalTo(self.r_knee.snp.centerY).offset(100)
            make.width.height.equalTo(w_h)
        })
        return view
    }()
}
