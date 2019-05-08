//
//  SFaceBase.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/4.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

struct SBaseData {
    var radius:CGFloat = 0
    var center:CGPoint = CGPoint.zero
    mutating func dif(_ val:CGFloat) ->CGFloat{
        return radius - val
    }
}

enum SOperationType {
    case line   // 线性
    case circle  // 圆盘
    case handle // 手控
    case cross  // 嘴角
    case none   // 无
}

class SFaceBase: UIView, SControlDelegate {
    // 基础数据
    var _model = SPointModel()
    var delegate:SControlDelegate!
    var op_delegate:SOperationDelegate!
    var teamCurrentPoint = STeamCurrentPoint()
    
    var _DIS = SBaseData()
    var currentType:SOperationType!
    
    // 线边操作
    var isLineCap:Bool = true
    var catObserveLog:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 拖动
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        self.addGestureRecognizer(pan)
        // 捏合
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchEvent(_:)))
        self.addGestureRecognizer(pinch)
        // 长按
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressEvent(_:)))
        self.addGestureRecognizer(longPress)
        // 轻拍
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent(_:)))
        self.addGestureRecognizer(tap)
        // 轻拍2
        let tapTwice = UITapGestureRecognizer(target: self, action: #selector(tapEvent(_:)))
        tapTwice.numberOfTapsRequired = 2
        self.addGestureRecognizer(tapTwice)
        // 轻扫
        let swip = UISwipeGestureRecognizer()
        swip.direction = [.left,.right]
        swip.addTarget(self, action: #selector(swipeEvent(_:)))
        self.addGestureRecognizer(swip)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setObserverKey(_ key:String) {
        self.addObserver(self, forKeyPath: key, options: [.new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let newValue = change?[NSKeyValueChangeKey.newKey] {
            if catObserveLog == true {
                print("\(keyPath!) : \(newValue)")
            }
            self.listen(newValue)
        }
    }
    
    // 监听
    func listen(_ value:Any) {
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        if isLineCap {
            context?.setLineCap(.round)
            context?.setLineJoin(.round)
        }
        self.draw_canvas(rect, context!)
    }
    
    func draw_canvas(_ rect: CGRect, _ context:CGContext) {
        
    }
    
    @objc func panEvent(_ sender:UIPanGestureRecognizer) {}
    
    @objc func pinchEvent(_ sender:UIPinchGestureRecognizer) {}
    
    @objc func longPressEvent(_ sender:UILongPressGestureRecognizer) {}
    
    @objc func tapEvent(_ sender:UITapGestureRecognizer) {}
    
    @objc func swipeEvent(_ sender:UISwipeGestureRecognizer) {}
    
    lazy var capturePoint: UIButton = {
        let btn = UIButton(type: .system)
        btn.addTarget(self, action: #selector(capturePointClick(_:)), for: .touchUpInside)
        btn.frame = CGRect(x: self.w - 60, y: 20, width: 40, height: 30)
        btn.layer.cornerRadius = 3
        btn.layer.masksToBounds = true
        btn.setTitle("捕捉", for: .normal)
        btn.backgroundColor = UIColor.gray
        btn.setTitleColor(UIColor.white, for: .normal)
        self.addSubview(btn)
        return btn
    }()
    
    var isCapture:Bool = false
    @objc func capturePointClick(_ sender:UIButton) {
        
    }
    
    lazy var dataLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 4, y: 0, width: 150, height: 30))
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.text = "--"
        self.addSubview(label)
        return label
    }()
}
