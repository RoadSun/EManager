//
//  BezierController.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/7.
//  Copyright © 2018 EX DOLL. All rights reserved.
//


import UIKit
import CoreMotion

class BezierController: UIViewController,UIAccelerometerDelegate {
    
    var ball:UIImageView!
    var speedX:UIAccelerationValue=0
    var speedY:UIAccelerationValue=0
    var motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //放一个小球在中央
        ball=UIImageView(image:UIImage(named:"ball"))
        ball.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ball.backgroundColor = UIColor.orange
        ball.center=self.view.center
        self.view.addSubview(ball)
        
        motionManager.accelerometerUpdateInterval = 1/60
        //CMAccelerometerHandler
        if(motionManager.isAccelerometerAvailable)
        {
            if motionManager.isDeviceMotionAvailable {
                motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (accelerometerData, error) in
                    //动态设置小球位置
                    self.speedX += accelerometerData!.acceleration.x
                    self.speedY +=  accelerometerData!.acceleration.y
                    var posX=self.ball.center.x + CGFloat(self.speedX)
                    var posY=self.ball.center.y - CGFloat(self.speedY)
                    //碰到边框后的反弹处理
                    if posX<0 {
                        posX=0;
                        //碰到左边的边框后以0.4倍的速度反弹
                        self.speedX *= -0.4
                        
                    }else if posX > self.view.bounds.size.width {
                        posX=self.view.bounds.size.width
                        //碰到右边的边框后以0.4倍的速度反弹
                        self.speedX *= -0.4
                    }
                    if posY<0 {
                        posY=0
                        //碰到上面的边框不反弹
                        self.speedY=0
                    } else if posY>self.view.bounds.size.height{
                        posY=self.view.bounds.size.height
                        //碰到下面的边框以1.5倍的速度反弹
                        self.speedY *= -1.5
                    }
                    self.ball.center=CGPoint(x: posX, y: posY)
                }
            }
        }
    }
}

/*
 import UIKit
 
 class BezierController: UIViewController {
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // Do any additional setup after loading the view.
 let m = MotionModel()
 m.motion()
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
 */
 
 }
 */
