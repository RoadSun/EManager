//
//  MotionModel.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/19.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit
import CoreMotion
class MotionModel: NSObject {
    let motionManager = CMMotionManager()
    public func motion() {
        guard motionManager.isGyroAvailable else {
            return
        }
        self.motionManager.gyroUpdateInterval = 1
        self.motionManager.startGyroUpdates(to: OperationQueue.main) { (gyroData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            // 有更新
            if self.motionManager.isGyroActive {
                if let rotationRate = gyroData?.rotationRate {
                    var text = "------\n"
                    text += "x: \(rotationRate.x)\n"
                    text += "y: \(rotationRate.y)\n"
                    text += "z: \(rotationRate.z)\n"
                    print(text)
                }
            }
        }
    }
    
    public func g() -> Void {
        if motionManager.isDeviceMotionAvailable {
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
//                handleDeviceMotion(deviceMotion: data)
            }
        }
    }
}
    
//    func handleDeviceMotion(deviceMotion:CMDeviceMotion?)->Void{
//        let x:Double =
//let x:Double=(deviceMotion?.gravity.x)!
//
//
//
//                            let y:Double=(deviceMotion?.gravity.y)!
//
//
//
//                            if fabs(y)>=fabs(x){
//
//
//
//                                            if y>=0{
//
//                                                            NSLog("竖屏")
//
//
//                                                    }else{
//                                                                      //UIDeviceOrientationPortrait
//                                                                        NSLog("竖屏")
//
//
//
//                                                            }
//
//
//
//                                    }else{
//
//
//
//                                                    if x>=0{
//
//
//
//                                                                    //UIDeviceOrientationLandscapeRight
//
//
//
//                                                                    NSLog("横屏")
//
//
//
//                                                            }else{
//
//
//
//                                                                              //UIDeviceOrientationLandscapeLeft
//
//
//
//                                                                                NSLog("横屏")
//
//
//
//                                                                    }
//
//
//
//                                            }
//
//}
