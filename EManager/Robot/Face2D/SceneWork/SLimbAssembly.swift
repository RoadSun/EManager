//
//  SLimbAssembly.swift
//  EManager
//
//  Created by EX DOLL on 2019/5/9.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

struct SNodeData {
    var cur:CGFloat = 0 // current
    var max:CGFloat = CGFloat.pi
    var min:CGFloat = 0
    var id:Int = -1
}

class SLimbAssembly: NSObject {
    var assList:[SNodeData]!
    
    func createList() {
        
    }
    
    class func ass_l_arm(_ scnScene:SCNScene) {
        // arm-left-肩膀
        let arm_l_shoulder = SJointModel.createSphere(-2, 3, 0)
        scnScene.rootNode.addChildNode(arm_l_shoulder)
        
        // arm-left-大臂转
        let arm_l_rotate_0 = SJointModel.createBox(0, -1, 0, .purple)
        scnScene.rootNode.addChildNode(arm_l_rotate_0)
        
        // arm-left-肘
        let arm_l_elbow = SJointModel.createSphere(0, -1, 0)
        scnScene.rootNode.addChildNode(arm_l_elbow)
        
        // arm-left-小臂转
        let arm_l_rotate_1 = SJointModel.createBox(0, -1, 0, .purple)
        scnScene.rootNode.addChildNode(arm_l_rotate_1)
        
        // arm-left-腕
        let arm_l_wrist = SJointModel.createSphere(0, -1, 0)
        scnScene.rootNode.addChildNode(arm_l_wrist)
        
        // arm-left-大肩膀
        let arm_l_line_0 = SJointModel.createCapsule(-1, 3, 0)
        scnScene.rootNode.addChildNode(arm_l_line_0)
        arm_l_line_0.runAction(SCNAction.rotateBy(x: 0, y: 0, z: (CGFloat.pi*0.5), duration: 0))
        
        // arm-left-大臂
        let arm_l_arm_line_big = SJointModel.createCapsule(0, 0, 0)
        scnScene.rootNode.addChildNode(arm_l_arm_line_big)
        arm_l_arm_line_big.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        // arm-left-小臂
        let arm_l_arm_line_small = SJointModel.createCapsule(0, 0, 0)
        scnScene.rootNode.addChildNode(arm_l_arm_line_small)
        arm_l_arm_line_small.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        // 向末梢
        // 肩 大臂转 大臂 肘 小臂转 小臂 腕
        arm_l_shoulder.addChildNode(arm_l_rotate_0)

        // 大臂转 大臂 肘 小臂转 小臂 腕
        arm_l_rotate_0.addChildNode(arm_l_arm_line_big)
        arm_l_rotate_0.addChildNode(arm_l_elbow)
        
        // 肘 小臂转 小臂 腕
        arm_l_elbow.addChildNode(arm_l_rotate_1)

        // 小臂转 小臂 腕
        arm_l_rotate_1.addChildNode(arm_l_arm_line_small)
        arm_l_rotate_1.addChildNode(arm_l_wrist)
    }
    
    class func ass_r_arm(_ scnScene:SCNScene) {
        // arm-left-肩膀
        let arm_r_shoulder = SJointModel.createSphere(2, 3, 0)
        scnScene.rootNode.addChildNode(arm_r_shoulder)
        
        // arm-left-大臂转
        let arm_r_rotate_0 = SJointModel.createBox(0, -1, 0, .purple)
        scnScene.rootNode.addChildNode(arm_r_rotate_0)
        
        // arm-left-肘
        let arm_r_elbow = SJointModel.createSphere(0, -1, 0)
        scnScene.rootNode.addChildNode(arm_r_elbow)
        
        // arm-left-小臂转
        let arm_r_rotate_1 = SJointModel.createBox(0, -1, 0, .purple)
        scnScene.rootNode.addChildNode(arm_r_rotate_1)
        
        // arm-left-腕
        let arm_r_wrist = SJointModel.createSphere(0, -1, 0)
        scnScene.rootNode.addChildNode(arm_r_wrist)
        
        // arm-left-大肩膀
        let arm_r_line_0 = SJointModel.createCapsule(1, 3, 0)
        scnScene.rootNode.addChildNode(arm_r_line_0)
        arm_r_line_0.runAction(SCNAction.rotateBy(x: 0, y: 0, z: (CGFloat.pi*0.5), duration: 0))
        
        // arm-left-大臂
        let arm_r_arm_line_big = SJointModel.createCapsule(0, 0, 0)
        scnScene.rootNode.addChildNode(arm_r_arm_line_big)
        arm_r_arm_line_big.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        // arm-left-小臂
        let arm_r_arm_line_small = SJointModel.createCapsule(0, 0, 0)
        scnScene.rootNode.addChildNode(arm_r_arm_line_small)
        arm_r_arm_line_small.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        // 向末梢
        // 肩 大臂转 大臂 肘 小臂转 小臂 腕
        arm_r_shoulder.addChildNode(arm_r_rotate_0)
        
        // 大臂转 大臂 肘 小臂转 小臂 腕
        arm_r_rotate_0.addChildNode(arm_r_arm_line_big)
        arm_r_rotate_0.addChildNode(arm_r_elbow)
        
        // 肘 小臂转 小臂 腕
        arm_r_elbow.addChildNode(arm_r_rotate_1)
        
        // 小臂转 小臂 腕
        arm_r_rotate_1.addChildNode(arm_r_arm_line_small)
        arm_r_rotate_1.addChildNode(arm_r_wrist)
    }
    
    class func ass_l_leg(_ scnScene:SCNScene) {
        let leg_l_hip = SJointModel.createSphere(-1, -1, 0)
        scnScene.rootNode.addChildNode(leg_l_hip)
        
        let leg_l_knee = SJointModel.createSphere(0, -2, 0)
        scnScene.rootNode.addChildNode(leg_l_knee)
        
        let leg_l_ankle = SJointModel.createSphere(0, -2, 0)
        scnScene.rootNode.addChildNode(leg_l_ankle)
        
        let leg_l_line_hip = SJointModel.createCapsule(-0.5, -1, 0, height:1)
        scnScene.rootNode.addChildNode(leg_l_line_hip)
        leg_l_line_hip.runAction(SCNAction.rotateBy(x: 0, y: 0, z: (CGFloat.pi*0.5), duration: 0))
        
        // 左腿0
        let arm_l_line_thigh = SJointModel.createCapsule(0, -1, 0)
        scnScene.rootNode.addChildNode(arm_l_line_thigh)
        arm_l_line_thigh.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        // 左腿1
        let arm_l_line_calf = SJointModel.createCapsule(0, -1, 0)
        scnScene.rootNode.addChildNode(arm_l_line_calf)
        arm_l_line_calf.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        // 臀 大腿 膝盖 小腿 脚踝
        leg_l_hip.addChildNode(arm_l_line_thigh)
        leg_l_hip.addChildNode(leg_l_knee)
        
        // 膝盖
        leg_l_knee.addChildNode(arm_l_line_calf)
        leg_l_knee.addChildNode(leg_l_ankle)
    }
    
    class func ass_r_leg(_ scnScene:SCNScene) {
        let leg_r_hip = SJointModel.createSphere(1, -1, 0)
        scnScene.rootNode.addChildNode(leg_r_hip)
        
        let leg_r_knee = SJointModel.createSphere(0, -2, 0)
        scnScene.rootNode.addChildNode(leg_r_knee)
        
        let leg_r_ankle = SJointModel.createSphere(0, -2, 0)
        scnScene.rootNode.addChildNode(leg_r_ankle)
        
        let leg_r_line_hip = SJointModel.createCapsule(0.5, -1, 0, height:1)
        scnScene.rootNode.addChildNode(leg_r_line_hip)
        leg_r_line_hip.runAction(SCNAction.rotateBy(x: 0, y: 0, z: (CGFloat.pi*0.5), duration: 0))
        
        // 左腿0
        let arm_r_line_thigh = SJointModel.createCapsule(0, -1, 0)
        scnScene.rootNode.addChildNode(arm_r_line_thigh)
        arm_r_line_thigh.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        // 左腿1
        let arm_r_line_calf = SJointModel.createCapsule(0, -1, 0)
        scnScene.rootNode.addChildNode(arm_r_line_calf)
        arm_r_line_calf.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        // 臀 大腿 膝盖 小腿 脚踝
        leg_r_hip.addChildNode(arm_r_line_thigh)
        leg_r_hip.addChildNode(leg_r_knee)
        
        // 膝盖
        leg_r_knee.addChildNode(arm_r_line_calf)
        leg_r_knee.addChildNode(leg_r_ankle)
    }
}
