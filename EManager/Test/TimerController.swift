//
//  TimerController.swift
//  EManager
//
//  Created by EX DOLL on 2018/12/18.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class TimerController: UIViewController {
    
    //动画播放时间
    var duration:CFTimeInterval = 3
    
    //运动的方块
    var square:UIView!
    
    //绘制路线的图层
    var pathLayer:CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let meter = SColorView(frame: CGRect(x: 40, y: 80, width: 80, height: 80))
        self.view.addSubview(meter)
        return
        //初始化方块
        square = UIView(frame:CGRect(x:0, y:0, width:20, height:20))
        square.backgroundColor = UIColor.orange
        
        //设置运动的路线
        let centerX = view.bounds.size.width/2
        //创建用于转移坐标的Transform，这样我们不用按照实际显示做坐标计算
        let transform = CGAffineTransform(translationX: centerX, y: 50)
        let path =  CGMutablePath()
        path.move(to: CGPoint(x:0 ,y:0), transform: transform)
        path.addLine(to: CGPoint(x:0 ,y:75), transform: transform)
        path.addLine(to: CGPoint(x:75 ,y:75), transform: transform)
        path.addArc(center: CGPoint(x:0 ,y:75), radius: 75, startAngle: 0,
                    endAngle: CGFloat(1.5 * .pi), clockwise: false, transform: transform)
        
        //给方块添加移动动画
        let orbit = CAKeyframeAnimation(keyPath:"position")
        orbit.duration = duration
        orbit.path = path
        orbit.calculationMode = CAAnimationCalculationMode.paced
        orbit.isRemovedOnCompletion = false
        orbit.fillMode = CAMediaTimingFillMode.forwards
        square.layer.add(orbit,forKey:"Move")
        
        //绘制运动轨迹
        pathLayer = CAShapeLayer()
        pathLayer.frame = self.view.bounds
        //pathLayer.isGeometryFlipped = true
        pathLayer.path = path
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 1
        pathLayer.strokeColor = UIColor.black.cgColor
        
        //给运动轨迹添加动画
        let pathAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        pathAnimation.duration = duration
        pathAnimation.fromValue = 0
        pathAnimation.toValue = 1
        //pathAnimation.delegate = (window as! CAAnimationDelegate)
        pathLayer.add(pathAnimation , forKey: "strokeEnd")
        
        //将轨道添加到视图层中
        self.view.layer.addSublayer(pathLayer)
        //将方块添加到视图中
        self.view.addSubview(square)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setTimer() {
        var second = 0
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            second = second + 1
            let hh:String = String(format: "%02d", (second / (60 * 60)) % (60 * 60))
            let mm:String = String(format: "%02d", (second / 60) % 60)
            let ss:String = String(format: "%02d", second % 60)
            print("\(hh) : \(mm) : \(ss)")
            }.fire()
    }
    
}
