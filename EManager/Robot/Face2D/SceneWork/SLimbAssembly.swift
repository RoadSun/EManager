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

struct SSNodeItem {
    enum SSRotateDirection {
        case l
        case w
        case h
        case x
        case y
        case z
        case r_x
        case r_y
        case r_z
    }
    
    enum SServoDirection:Int {
        case o = 0// 正方向
        case x = 1// 反方向
    }
    
    var id:Int = -1
    var node:SCNNode = SCNNode() // 节点
    var d:Int = 1 // 相对标准方向, 相对于标准姿势(调试中有的电机方向相反, 单独设定) 1 为正 0 为反
    var servoD:Int = 0 // 电机方向 0 正方向 1 反方向
    var min:CGFloat = 0 //最小值
    var max:CGFloat = 0 // 最大值
    
    var map_min:CGFloat = 0 // 影射
    var map_max:CGFloat = 0 // 影射
    var map_val:CGFloat = 0 // 当前影射值
    
    var current:CGFloat = 0 // 当前值
    var angle:CGFloat = 0 // 当前角度
    var rotateD:SSRotateDirection = .r_x // 旋转的轴
    var margin:CGFloat = 0 // 角度余量
    var standard:CGFloat = 0 // 标准值
    var input_value:CGFloat = 0 // 输出的大小差值
    var position:SCNVector3 = SCNVector3(0, 0, 0) // 标准位置
    var interchange:Bool = false //镜像互换

    mutating func trans(_ val:CGFloat, toAngle:Bool = false, proportion:CGFloat = 1)->SSNodeItem {
        //        print("滑动值 : \(val)")
        self.map_val = val
        self.angle = self.mapping(val)
        let trans_servod:CGFloat = self.operation_mapping(val)
        // 传入角度值
        let valueTrans = SValueTrans.trans_πAngel(trans_servod, false) * (self.d == 1 ? 1 : -1)
        // 余量
        let marginTrans = SValueTrans.trans_πAngel(self.margin, false)
        // 当前值
        self.current = valueTrans + marginTrans * 2
        return self
    }
    
    // 影射
    mutating func mapping(_ val:CGFloat) -> CGFloat {
        var ang:CGFloat = 0
        if self.servoD == 0 {
            ang = val + self.standard
            //            print("标准值  : \(ang)")
        }else{
            ang = (val + self.standard)
        }
        return ang
    }
    
    // 操作影射
    mutating func operation_mapping(_ val:CGFloat) ->CGFloat {
        var ang:CGFloat = 0
        if self.servoD == 0 {
            ang = val
        }else{
            ang = -val
            //            print("影射值  : \(ang)")
        }
        return ang
    }
    
    init(id:Int, node:SCNNode, d:Int, min:CGFloat, max:CGFloat, rd:SSRotateDirection, std:CGFloat, sd:Int, margin:CGFloat) {
        self.id = id
        self.node = node
        self.d = d
        self.min = min
        self.max = max
        self.rotateD = rd
        self.servoD = sd
        self.margin = margin
        self.input_value = max - min
        self.standard = std
        
        self.map_max = max - std
        self.map_min = min - std
    }
}

private let limb = SLimbAssembly()

class SLimbAssembly: NSObject {
    class var shared:SLimbAssembly {
        return limb
    }
    
    var assList = [SSNodeItem]()
    func ass_l_arm(_ scnScene:SCNScene) {
        // arm-left-肩膀 上下
        let arm_l_shoulder_updown = SJointModel.createBox(-1.7, 3, 0,.red,data:SGeoBasedata(l:0.3,w:0.3,h:0.3,r:0))
        scnScene.rootNode.addChildNode(arm_l_shoulder_updown)
        var item = SSNodeItem(id: 19, node: arm_l_shoulder_updown, d: 1, min: 70, max: 130, rd:.y, std:90, sd:0, margin:0)
        item.position = SCNVector3(-1.7, 3, 0)
        assList.append(item)
        
        // arm-left-肩膀 前后
        let arm_l_shoulder_frontback = SJointModel.createBox(-0.3, 0, 0,data:SGeoBasedata(l:0.3,w:0.3,h:0.3,r:0))
        scnScene.rootNode.addChildNode(arm_l_shoulder_frontback)
        var item1 = SSNodeItem(id: 21, node: arm_l_shoulder_frontback, d: 0, min: 80, max: 143, rd:.z, std:90, sd:0, margin:0)
        item1.position = SCNVector3(-0.3, 0, 0)
        assList.append(item1)
        
        let connection_shoulder_bigarm = SJointModel.createSphere(-0.25, 0, 0, radius:0.05)
        scnScene.rootNode.addChildNode(connection_shoulder_bigarm)
        
        // arm-left-大臂
        let arm_l_bigarm_leftright = SJointModel.createSphere(0, 0, 0, radius:0.1)
        scnScene.rootNode.addChildNode(arm_l_bigarm_leftright)
        var item2 = SSNodeItem(id: 26, node: arm_l_bigarm_leftright, d: 0, min: 40, max: 180, rd:.r_z, std:140, sd:1, margin:0)
        item2.position = SCNVector3(0, 0, 0)
        assList.append(item2)
        
        // arm-left-大臂
        let arm_l_bigarm_frontback = SJointModel.createSphere(-0.25, 0, 0)
        scnScene.rootNode.addChildNode(arm_l_bigarm_frontback)
        var item3 = SSNodeItem(id: 25, node: arm_l_bigarm_frontback, d: 0, min: 50, max: 124, rd:.r_x, std:50, sd:0, margin:0)
        item3.position = SCNVector3(-0.25, 0, 0)
        assList.append(item3)
        
        // arm-left-大臂转
        let arm_l_rotate_0 = SJointModel.createBox(0, -1, 0, .purple)
        scnScene.rootNode.addChildNode(arm_l_rotate_0)
        var item4 = SSNodeItem(id: 27, node: arm_l_rotate_0, d: 0, min: 7, max: 157, rd:.r_y, std:90, sd:0, margin:0)
        item4.position = SCNVector3(0, -1, 0)
        assList.append(item4) //左大臂旋转
        
        // arm-left-肘
        let arm_l_elbow = SJointModel.createSphere(0, -1, 0)
        scnScene.rootNode.addChildNode(arm_l_elbow)
        assList.append(SSNodeItem(id: 28, node: arm_l_elbow, d: 1, min: 30, max: 130, rd:.r_x, std:130, sd:0, margin:180))
        
        // arm-left-小臂转
        let arm_l_rotate_1 = SJointModel.createBox(0, -1, 0, .purple)
        scnScene.rootNode.addChildNode(arm_l_rotate_1)
        assList.append(SSNodeItem(id: 29, node: arm_l_rotate_1, d: 0, min: 16, max: 170, rd:.r_y, std:90, sd:1, margin:0)) //左小臂旋转
        
        // arm-left-腕
        let arm_l_wrist = SJointModel.createBox(0, -1, 0, .lightGray, data:SGeoBasedata(l:0.4,w:0.1,h:0.4,r:0))
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
        
        //手指 -- 拇指 0 - 1
        let arm_l_wrist_thumb = SJointModel.createBox(0, 0, 0.30, .lightGray, data:SGeoBasedata(l:0.1,w:0.1,h:0.24,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_thumb)
        
        //手指 -- 拇指 0 - 2
        let arm_l_wrist_thumb_2 = SJointModel.createBox(0, -0.25, 0.30, .lightGray, data:SGeoBasedata(l:0.1,w:0.1,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_thumb_2)
        
        //手指 -- 食指 1 - 1
        let arm_l_wrist_forefinger = SJointModel.createBox(0, -0.25, 0.15, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_forefinger)
        
        //手指 -- 食指 1 - 2
        let arm_l_wrist_forefinger_1 = SJointModel.createBox(0, -0.37, 0.15, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_forefinger_1)
        
        //手指 -- 食指 1 - 3
        let arm_l_wrist_forefinger_2 = SJointModel.createBox(0, -0.49, 0.15, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_forefinger_2)
        
        //手指 -- 中指 2 - 1
        let arm_l_wrist_middle = SJointModel.createBox(0, -0.25, 0.05, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_middle)
        
        //手指 -- 中指 2 - 2
        let arm_l_wrist_middle_1 = SJointModel.createBox(0, -0.37, 0.05, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_middle_1)
        
        //手指 -- 中指 2 - 3
        let arm_l_wrist_middle_2 = SJointModel.createBox(0, -0.49, 0.05, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_middle_2)
        
        //手指 -- 无名指 3 - 1
        let arm_l_wrist_ring = SJointModel.createBox(0, -0.25, -0.05, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_ring)
        
        //手指 -- 无名指 3 - 2
        let arm_l_wrist_ring_1 = SJointModel.createBox(0, -0.37, -0.05, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_ring_1)
        
        //手指 -- 无名指 3 - 3
        let arm_l_wrist_ring_2 = SJointModel.createBox(0, -0.49, -0.05, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_ring_2)
        
        //手指 -- 小指 4 - 1
        let arm_l_wrist_little = SJointModel.createBox(0, -0.25, -0.15, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_little)
        
        //手指 -- 小指 4 - 2
        let arm_l_wrist_little_1 = SJointModel.createBox(0, -0.37, -0.15, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_little_1)
        
        //手指 -- 小指 4 - 3
        let arm_l_wrist_little_2 = SJointModel.createBox(0, -0.49, -0.15, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_l_wrist_little_2)
        
        // 向末梢
        //肩膀上下
        arm_l_shoulder_updown.addChildNode(arm_l_shoulder_frontback)
        
        // 肩膀前后
        arm_l_shoulder_frontback.addChildNode(connection_shoulder_bigarm)
        
        // 肩臂衔接
        connection_shoulder_bigarm.addChildNode(arm_l_bigarm_leftright)
        
        //大臂左右
        arm_l_bigarm_leftright.addChildNode(arm_l_bigarm_frontback)
        
        // 肩左右 大臂转 大臂 肘 小臂转 小臂 腕
        arm_l_bigarm_frontback.addChildNode(arm_l_rotate_0)
        
        // 大臂转 大臂 肘 小臂转 小臂 腕
        arm_l_rotate_0.addChildNode(arm_l_arm_line_big)
        arm_l_rotate_0.addChildNode(arm_l_elbow)
        
        // 肘 小臂转 小臂 腕
        arm_l_elbow.addChildNode(arm_l_rotate_1)
        
        // 小臂转 小臂 腕
        arm_l_rotate_1.addChildNode(arm_l_arm_line_small)
        arm_l_rotate_1.addChildNode(arm_l_wrist)
        
        // 手腕 拇指
        arm_l_wrist.addChildNode(arm_l_wrist_thumb)
        arm_l_wrist.addChildNode(arm_l_wrist_thumb_2)
        
        // 食指
        arm_l_wrist.addChildNode(arm_l_wrist_forefinger)
        arm_l_wrist.addChildNode(arm_l_wrist_forefinger_1)
        arm_l_wrist.addChildNode(arm_l_wrist_forefinger_2)
        
        // 中指
        arm_l_wrist.addChildNode(arm_l_wrist_middle)
        arm_l_wrist.addChildNode(arm_l_wrist_middle_1)
        arm_l_wrist.addChildNode(arm_l_wrist_middle_2)
        
        // 无名指
        arm_l_wrist.addChildNode(arm_l_wrist_ring)
        arm_l_wrist.addChildNode(arm_l_wrist_ring_1)
        arm_l_wrist.addChildNode(arm_l_wrist_ring_2)
        
        // 小指
        arm_l_wrist.addChildNode(arm_l_wrist_little)
        arm_l_wrist.addChildNode(arm_l_wrist_little_1)
        arm_l_wrist.addChildNode(arm_l_wrist_little_2)
    }
    
    func ass_r_arm(_ scnScene:SCNScene) {
        // arm-right-肩膀 上下
        let arm_r_shoulder_updown = SJointModel.createBox(1.85, 3, 0,.red,data:SGeoBasedata(l:0.3,w:0.3,h:0.3,r:0))
        scnScene.rootNode.addChildNode(arm_r_shoulder_updown)
        var item = SSNodeItem(id: 20, node: arm_r_shoulder_updown, d: 1, min: 56, max: 115, rd:.y, std:90, sd:1, margin:0)
        item.position = SCNVector3(1.85, 3, 0)
        assList.append(item)
        
        // arm-right-肩膀 前后
        let arm_r_shoulder_frontback = SJointModel.createBox(0.3, 0, 0,data:SGeoBasedata(l:0.3,w:0.3,h:0.3,r:0))
        scnScene.rootNode.addChildNode(arm_r_shoulder_frontback)
        var item1 = SSNodeItem(id: 22, node: arm_r_shoulder_frontback, d: 0, min: 77, max: 140, rd:.z, std:90, sd:1, margin:0)
        item1.position = SCNVector3(0.15, 0, 0)
        assList.append(item1)
        
        let connection_shoulder_bigarm = SJointModel.createSphere(0.25, 0, 0, radius:0.05)
        scnScene.rootNode.addChildNode(connection_shoulder_bigarm)
        
        // arm-right-大臂
        let arm_r_bigarm_leftright = SJointModel.createSphere(0, 0, 0, radius:0.1)
        scnScene.rootNode.addChildNode(arm_r_bigarm_leftright)
        var item2 = SSNodeItem(id: 31, node: arm_r_bigarm_leftright, d: 1, min: 40, max: 180, rd:.r_z, std:40, sd:0, margin:0)
        item2.position = SCNVector3(0, 0, 0)
        assList.append(item2)
        
        // arm-right-大臂
        let arm_r_bigarm_frontback = SJointModel.createSphere(0.25, 0, 0)
        scnScene.rootNode.addChildNode(arm_r_bigarm_frontback)
        var item3 = SSNodeItem(id: 30, node: arm_r_bigarm_frontback, d: 0, min: 77, max: 140, rd:.r_x, std:130, sd:1, margin:0)
        item3.position = SCNVector3(0.35, 0, 0)
        assList.append(item3)
        
        // arm-right-大臂转
        let arm_r_rotate_0 = SJointModel.createBox(0, -1, 0, .purple)
        scnScene.rootNode.addChildNode(arm_r_rotate_0)
        assList.append(SSNodeItem(id: 32, node: arm_r_rotate_0, d: 1, min: 56, max: 115, rd:.r_y, std:90, sd:1, margin:0))
        
        // arm-right-肘
        let arm_r_elbow = SJointModel.createSphere(0, -1, 0)
        scnScene.rootNode.addChildNode(arm_r_elbow)
        assList.append(SSNodeItem(id: 33, node: arm_r_elbow, d: 1, min: 31, max: 130, rd:.r_x, std:50, sd:1, margin:180))
        
        // arm-right-小臂转
        let arm_r_rotate_1 = SJointModel.createBox(0, -1, 0, .purple)
        scnScene.rootNode.addChildNode(arm_r_rotate_1)
        assList.append(SSNodeItem(id: 34, node: arm_r_rotate_1, d: 1, min: 15, max: 170, rd:.r_y, std:90, sd:0, margin:0))
        
        // arm-right-腕
        let arm_r_wrist = SJointModel.createBox(0, -1, 0, .lightGray, data:SGeoBasedata(l:0.4,w:0.1,h:0.4,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist)
        
        // arm-right-大肩膀
        let arm_r_line_0 = SJointModel.createCapsule(1, 3, 0)
        scnScene.rootNode.addChildNode(arm_r_line_0)
        arm_r_line_0.runAction(SCNAction.rotateBy(x: 0, y: 0, z: (CGFloat.pi*0.5), duration: 0))
        
        // arm-right-大臂
        let arm_r_arm_line_big = SJointModel.createCapsule(0, 0, 0)
        scnScene.rootNode.addChildNode(arm_r_arm_line_big)
        arm_r_arm_line_big.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        // arm-right-小臂
        let arm_r_arm_line_small = SJointModel.createCapsule(0, 0, 0)
        scnScene.rootNode.addChildNode(arm_r_arm_line_small)
        arm_r_arm_line_small.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        //手指 -- 拇指 0 - 1
        let arm_r_wrist_thumb = SJointModel.createBox(0, 0, 0.30, .lightGray, data:SGeoBasedata(l:0.1,w:0.1,h:0.24,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_thumb)
        
        //手指 -- 拇指 0 - 2
        let arm_r_wrist_thumb_2 = SJointModel.createBox(0, -0.25, 0.30, .lightGray, data:SGeoBasedata(l:0.1,w:0.1,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_thumb_2)
        
        //手指 -- 食指 1 - 1
        let arm_r_wrist_forefinger = SJointModel.createBox(0, -0.25, 0.15, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_forefinger)
        
        //手指 -- 食指 1 - 2
        let arm_r_wrist_forefinger_1 = SJointModel.createBox(0, -0.37, 0.15, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_forefinger_1)
        
        //手指 -- 食指 1 - 3
        let arm_r_wrist_forefinger_2 = SJointModel.createBox(0, -0.49, 0.15, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_forefinger_2)
        
        //手指 -- 中指 2 - 1
        let arm_r_wrist_middle = SJointModel.createBox(0, -0.25, 0.05, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_middle)
        
        //手指 -- 中指 2 - 2
        let arm_r_wrist_middle_1 = SJointModel.createBox(0, -0.37, 0.05, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_middle_1)
        
        //手指 -- 中指 2 - 3
        let arm_r_wrist_middle_2 = SJointModel.createBox(0, -0.49, 0.05, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_middle_2)
        
        //手指 -- 无名指 3 - 1
        let arm_r_wrist_ring = SJointModel.createBox(0, -0.25, -0.05, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_ring)
        
        //手指 -- 无名指 3 - 2
        let arm_r_wrist_ring_1 = SJointModel.createBox(0, -0.37, -0.05, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_ring_1)
        
        //手指 -- 无名指 3 - 3
        let arm_r_wrist_ring_2 = SJointModel.createBox(0, -0.49, -0.05, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_ring_2)
        
        //手指 -- 小指 4 - 1
        let arm_r_wrist_little = SJointModel.createBox(0, -0.25, -0.15, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_little)
        
        //手指 -- 小指 4 - 2
        let arm_r_wrist_little_1 = SJointModel.createBox(0, -0.37, -0.15, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_little_1)
        
        //手指 -- 小指 4 - 3
        let arm_r_wrist_little_2 = SJointModel.createBox(0, -0.49, -0.15, .orange, data:SGeoBasedata(l:0.08,w:0.08,h:0.1,r:0))
        scnScene.rootNode.addChildNode(arm_r_wrist_little_2)
        
        // 向末梢
        //肩膀上下
        arm_r_shoulder_updown.addChildNode(arm_r_shoulder_frontback)
        
        // 肩膀前后
        arm_r_shoulder_frontback.addChildNode(connection_shoulder_bigarm)
        
        // 肩臂衔接
        connection_shoulder_bigarm.addChildNode(arm_r_bigarm_leftright)
        
        //大臂左右
        arm_r_bigarm_leftright.addChildNode(arm_r_bigarm_frontback)
        // 肩左右 大臂转 大臂 肘 小臂转 小臂 腕
        arm_r_bigarm_frontback.addChildNode(arm_r_rotate_0)
        
        // 大臂转 大臂 肘 小臂转 小臂 腕
        arm_r_rotate_0.addChildNode(arm_r_arm_line_big)
        arm_r_rotate_0.addChildNode(arm_r_elbow)
        
        // 肘 小臂转 小臂 腕
        arm_r_elbow.addChildNode(arm_r_rotate_1)
        
        // 小臂转 小臂 腕
        arm_r_rotate_1.addChildNode(arm_r_arm_line_small)
        arm_r_rotate_1.addChildNode(arm_r_wrist)
        
        // 手腕 拇指
        arm_r_wrist.addChildNode(arm_r_wrist_thumb)
        arm_r_wrist.addChildNode(arm_r_wrist_thumb_2)
        
        // 食指
        arm_r_wrist.addChildNode(arm_r_wrist_forefinger)
        arm_r_wrist.addChildNode(arm_r_wrist_forefinger_1)
        arm_r_wrist.addChildNode(arm_r_wrist_forefinger_2)
        
        // 中指
        arm_r_wrist.addChildNode(arm_r_wrist_middle)
        arm_r_wrist.addChildNode(arm_r_wrist_middle_1)
        arm_r_wrist.addChildNode(arm_r_wrist_middle_2)
        
        // 无名指
        arm_r_wrist.addChildNode(arm_r_wrist_ring)
        arm_r_wrist.addChildNode(arm_r_wrist_ring_1)
        arm_r_wrist.addChildNode(arm_r_wrist_ring_2)
        
        // 小指
        arm_r_wrist.addChildNode(arm_r_wrist_little)
        arm_r_wrist.addChildNode(arm_r_wrist_little_1)
        arm_r_wrist.addChildNode(arm_r_wrist_little_2)
    }
    
    func ass_l_leg(_ scnScene:SCNScene) {
        let leg_l_hip = SJointModel.createSphere(-1, -1, 0)
        scnScene.rootNode.addChildNode(leg_l_hip)
        
        let leg_l_knee = SJointModel.createSphere(0, -2, 0)
        scnScene.rootNode.addChildNode(leg_l_knee)
        
        let leg_l_ankle = SJointModel.createBox(0, -2, 0, .lightGray,data:SGeoBasedata(l:0.2,w:0.2,h:0.2,r:0))
        scnScene.rootNode.addChildNode(leg_l_ankle)
        
        let leg_l_footer = SJointModel.createBox(0, -0.25, 0.2, .lightGray,data:SGeoBasedata(l:0.8,w:0.4,h:0.1,r:0))
        scnScene.rootNode.addChildNode(leg_l_footer)
        
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
        
        // 脚
        leg_l_ankle.addChildNode(leg_l_footer)
    }
    
    func ass_r_leg(_ scnScene:SCNScene) {
        let leg_r_hip = SJointModel.createSphere(1, -1, 0)
        scnScene.rootNode.addChildNode(leg_r_hip)
        
        let leg_r_knee = SJointModel.createSphere(0, -2, 0)
        scnScene.rootNode.addChildNode(leg_r_knee)
        
        let leg_r_ankle = SJointModel.createBox(0, -2, 0, .lightGray,data:SGeoBasedata(l:0.2,w:0.2,h:0.2,r:0))
        scnScene.rootNode.addChildNode(leg_r_ankle)
        
        let leg_r_footer = SJointModel.createBox(0, -0.25, 0.2, .lightGray,data:SGeoBasedata(l:0.8,w:0.4,h:0.1,r:0))
        scnScene.rootNode.addChildNode(leg_r_footer)
        
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
        
        // 脚
        leg_r_ankle.addChildNode(leg_r_footer)
    }
    
    var neck01:SCNNode!
    var neck_l:SCNNode!
    var neck_r:SCNNode!
    func ass_r_neck(_ scnScene:SCNScene) {
        // 脖 与身体连接部分
        let neck0 = SJointModel.createSphere(0, 3, 0)
        scnScene.rootNode.addChildNode(neck0)
        
        // 脖子左右晃
        neck01 = SJointModel.createSphere(0, 0, 0, radius: 0.1)
        scnScene.rootNode.addChildNode(neck01)
        
        // 脖子左轴
        neck_l = SJointModel.createCapsule(-0.2, 0.5, -0.2, height:0.5, capR:0.05)
        scnScene.rootNode.addChildNode(neck_l)
        assList.append(SSNodeItem(id: 17, node: neck_l, d: 1, min: 6, max: 156, rd:.h, std:90, sd:0, margin:-90)) // 脖子基座
        
        // 脖子右轴
        neck_r = SJointModel.createCapsule(0.2, 0.5, -0.2, height:0.5, capR:0.05)
        scnScene.rootNode.addChildNode(neck_r)
        assList.append(SSNodeItem(id: 18, node: neck_r, d: 0, min: 6, max: 156, rd:.h, std:90, sd:1, margin:90)) // 脖子基座
        
        // 脖子上 与头连接部分
        let head = SJointModel.createBox(0, 1.2, 0, data:SGeoBasedata(l:0.3,w:0.5,h:0.7,r:0))
        scnScene.rootNode.addChildNode(head)
        assList.append(SSNodeItem(id: 16, node: head, d: 1, min: 10, max: 170, rd:.r_y, std:90, sd:0, margin:-90)) // 脖子基座
        
        // 鼻子
        let nose = SJointModel.createSphere(0, 0, 0.2, .orange, radius: 0.1)
        scnScene.rootNode.addChildNode(nose)
        head.addChildNode(nose)
        
        // 脖支撑 杆
        let neck_0 = SJointModel.createCapsule(0, 0.5, 0, height:1, capR:0.1)
        scnScene.rootNode.addChildNode(neck_0)
        neck_0.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        neck0.addChildNode(neck_r)
        neck0.addChildNode(neck_l)
        
        neck0.addChildNode(neck01)
        //        neck0.addChildNode(neck_rotate)
        
        neck01.addChildNode(neck_0)
        neck01.addChildNode(head)
    }
    
    func ass_l_r_chest(_ scnScene:SCNScene) {
        // 脖子上 与头连接部分
        let chest = SJointModel.createBox(0, 1.8, 0.1, data:SGeoBasedata(l:0.4,w:1,h:1,r:0))
        scnScene.rootNode.addChildNode(chest)
        assList.append(SSNodeItem(id: 23, node: chest, d: 1, min: 10, max: 170, rd:.w, std:90, sd:0, margin:0))
    }
}

let desList:[String : (id:Int,cls:Int,name:String,less:String,increase:String,des:String)] =
    ["1": (id:1 ,cls:0,name:"左侧眉毛",less:"眉毛下降",increase:"眉毛上升",des:"摆臂与拉杆呈垂直状态"),
     "2": (id:2 ,cls:0,name:"右侧眉毛",less:"眉毛下降",increase:"眉毛上升",des:"摆臂与拉杆呈垂直状态"),
     "3": (id:3 ,cls:0,name:"左眼左右",less:"向里转动",increase:"向外转动",des:"眼球水平居中"),
     "4": (id:4 ,cls:0,name:"右眼左右",less:"向里转动",increase:"向外转动",des:"眼球水平居中"),
     "5": (id:5 ,cls:0,name:"左眼上下",less:"向下转动",increase:"向上转动",des:"眼球垂直居中"),
     "6": (id:6 ,cls:0,name:"右眼上下",less:"向下转动",increase:"向上转动",des:"眼球垂直居中"),
     "7": (id:7 ,cls:0,name:"左上眼皮",less:"向下转动",increase:"向上转动",des:"上眼皮在瞳孔上边缘"),
     "8": (id:8 ,cls:0,name:"右上眼皮",less:"向下转动",increase:"向上转动",des:"上眼皮在瞳孔上边缘"),
     "9": (id:9 ,cls:0,name:"左下眼皮",less:"向下转动",increase:"向上转动",des:"下眼皮在瞳孔下边缘"),
     "10":(id:10,cls:0,name:"右下眼皮",less:"向下转动",increase:"向上转动",des:"下眼皮在瞳孔下边缘"),
     "11":(id:11,cls:0,name:"左唇上下",less:"向下转动",increase:"向上转动",des:"支撑面上沿与上红牙床下沿对齐"),
     "12":(id:12,cls:0,name:"右唇上下",less:"向下转动",increase:"向上转动",des:"支撑面上沿与上红牙床下沿对齐"),
     "13":(id:13,cls:0,name:"左唇前后",less:"向前移动",increase:"向后转动",des:"支撑面前凹点距离头部中心线20mm"),
     "14":(id:14,cls:0,name:"右唇前后",less:"向前移动",increase:"向后转动",des:"支撑面前凹点距离头部中心线20mm"),
     "15":(id:15,cls:0,name:"嘴部张合",less:"向下移动",increase:"向上移动",des:"上下牙齿轻微接触"),
     "16":(id:16,cls:1,name:"头部旋转",less:"向左旋转",increase:"向右旋转",des:"头部朝向正前方"),
     "17":(id:17,cls:1,name:"头部左轴",less:"向下移动",increase:"向上移动",des:"头部处于竖直状态"),
     "18":(id:18,cls:1,name:"头部右轴",less:"向下移动",increase:"向上移动",des:"头部处于竖直状态"),
     "19":(id:19,cls:2,name:"左肩上下",less:"向下移动",increase:"向上移动",des:"肩部呈水平状态"),
     "20":(id:20,cls:2,name:"右肩上下",less:"向下移动",increase:"向上移动",des:"肩部呈水平状态"),
     "21":(id:21,cls:2,name:"左肩前后",less:"向前移动",increase:"向后移动",des:"肩部、身体前后为一直线"),
     "22":(id:22,cls:2,name:"右肩前后",less:"向前移动",increase:"向后移动",des:"肩部、身体前后为一直线"),
     "23":(id:23,cls:2,name:"呼吸频率",less:"胸部收缩",increase:"胸部抬起",des:"摆臂呈竖直状态"),
     "24":(id:24,cls:0,name:"舌头伸缩",less:"舌头收缩",increase:"舌头伸出",des:"舌头处于最内部状态"),
     "25":(id:25,cls:2,name:"左臂前后",less:"向后放下",increase:"向前抬起",des:"肩部、身体前后为一直线时，大臂前后方向与地面垂直"),
     "26":(id:26,cls:2,name:"左大臂抬",less:"左右放下",increase:"左右抬起",des:"肩部水平、大臂前后方向与地面垂直时，大臂与身体左右方向轻微接触"),
     "27":(id:27,cls:2,name:"左大臂转",less:"向内转动",increase:"向内转动",des:"连接端面凹槽对齐"),
     "28":(id:28,cls:2,name:"左肘关节",less:"弯曲动作",increase:"伸直动作",des:"伸直动作"),
     "29":(id:29,cls:2,name:"左小臂转",less:"向内转动",increase:"向外转动",des:"连接端面凹槽对齐"),
     "30":(id:30,cls:2,name:"右臂前后",less:"向后放下",increase:"向前抬起",des:"肩部、身体前后为一直线时，大臂前后方向与地面垂直"),
     "31":(id:31,cls:2,name:"右大臂抬",less:"放下动作",increase:"抬起动作",des:"肩部水平、大臂前后方向与地面垂直时，大臂与身体左右方向轻微接触"),
     "32":(id:32,cls:2,name:"右大臂转",less:"向内转动",increase:"向外转动",des:"连接端面凹槽对齐"),
     "33":(id:33,cls:2,name:"右肘关节",less:"弯曲动作",increase:"伸直动作",des:"肘部角度最大"),
     "34":(id:34,cls:2,name:"右小臂转",less:"向内转动",increase:"向外转动",des:"连接端面凹槽对齐"),]

