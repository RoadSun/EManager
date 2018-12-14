//
//  CoordinatesController.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/13.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class CoordinatesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = moveTest
    }
    var pointT:CGPoint!
    var w:CGFloat!
    var h:CGFloat!
    @objc func moveTestEvent(_ sender:UIPanGestureRecognizer) {

        if sender.state == .began {
            pointT = self.moveTest.convert(self.moveTest.frame.origin, to: self.view)
            w = pointT.x - self.moveTest.frame.origin.x
            h = pointT.y - self.moveTest.frame.origin.y
        }else if (sender.state == .changed){
            let point = sender.location(in: self.view)
            self.moveTest.frame.origin = CGPoint(x: point.x - w, y: point.y - h)
        }
        
        
//        let window = UIApplication.shared.delegate?.window
        
        
//        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
//
//        CGRect rect=[view1 convertRect: view1.bounds toView:window];
    }
    
    lazy var moveTest: UIButton = {
        let view = UIButton(type: .system)
        view.titleLabel?.numberOfLines = 0
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        view.frame.size = CGSize(width: 150, height: 150)
        view.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2)
        self.view.addSubview(view)
        
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(moveTestEvent(_:)))
//        view.addGestureRecognizer(pan)
        return view
    }()
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            pointT = t.location(in: self.view)
            print(t.location(in: self.view))
            w = pointT.x - self.moveTest.frame.origin.x
            h = pointT.y - self.moveTest.frame.origin.y
            //当在屏幕上连续拍动两下时，背景回复为白色
//            if t.tapCount == 2
//            {
//                self.view.backgroundColor = UIColor.white
//            }else if t.tapCount == 1
//            {
//                self.view.backgroundColor = UIColor.blue
//            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
            let t:UITouch = touch as! UITouch
            pointT = t.location(in: self.view)
            self.moveTest.frame.origin = CGPoint(x: pointT.x - w, y: pointT.y - h)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(touches)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     
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
     var point = sender.location(in: self)
     var x = point.x - self.Ctr.center.x
     var y = point.y - self.Ctr.center.y
     
     let sin_α = y / sqrt(pow(x, 2.0) + pow(y, 2.0))
     var angle = asin(sin_α); // 弧度
     let int_angle = Int((180.0/CGFloat.pi)*angle) // 角度
     let sign = CGFloat(x < 0 ? -1.0 : 1.0)
     
     point.y = self.frame.size.height - point.y
     var ctr_center = self.Ctr.center
     ctr_center.y = self.frame.size.height - self.Ctr.center.y
     let ARange = adjustRange(0, 120, moving: point, fixed: ctr_center)
     
     
     current.setTitle("\(int_angle) -- \(angle)", for: .normal)
     x = 100.0*cos(angle)*sign + self.Ctr.center.x
     y = 100.0*sin(angle) + self.Ctr.center.y
     self.head.center = CGPoint(x: ARange.x, y: ARange.y)
     
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
     view.layer.borderColor = UIColor.white.cgColor
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

    */

}
