//
//  SDatum.swift
//  EManager
//
//  Created by EX DOLL on 2019/5/8.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class SDatum: NSObject {
    class func createSys(_ scnScene:SCNScene) ->SCNNode{
        // 中心点
        let centerData = SGeoBasedata(l:0.1,w:0.1,h:0.1,r:0)
        let centerNode = SJointModel.createBox(0, 0, 0, .white, data: centerData)
        scnScene.rootNode.addChildNode(centerNode)
        
        /// x
        let x_cone = SJointModel.createCone(1, 0, 0, .red)
        x_cone.runAction(SCNAction.rotateBy(x: 0, y: 0, z: -(CGFloat.pi*0.5), duration: 0))
        scnScene.rootNode.addChildNode(x_cone)
        
        // x_o
        let o_x = SJointModel.createCapsule(0.5, 0, 0, height:1, capR: 0.02)
        scnScene.rootNode.addChildNode(o_x)
        o_x.runAction(SCNAction.rotateBy(x: 0, y: 0, z: -(CGFloat.pi*0.5), duration: 0))
        
        /// y
        let y_cone = SJointModel.createCone(0, 1, 0, .blue)
        scnScene.rootNode.addChildNode(y_cone)
        
        // o_y
        let o_y = SJointModel.createCapsule(0, 0.5, 0, height:1, capR: 0.02)
        scnScene.rootNode.addChildNode(o_y)
        o_y.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        /// z
        let z_cone = SJointModel.createCone(0, 0, 1, .green)
        z_cone.runAction(SCNAction.rotateBy(x: (CGFloat.pi*0.5), y: 0, z: 0, duration: 0))
        scnScene.rootNode.addChildNode(z_cone)
        
        // x_o
        let o_z = SJointModel.createCapsule(0, 0, 0.5, height:1, capR: 0.02)
        scnScene.rootNode.addChildNode(o_z)
        o_z.runAction(SCNAction.rotateBy(x: (CGFloat.pi*0.5), y: 0, z: 0, duration: 0))
        
        centerNode.addChildNode(o_x)
        centerNode.addChildNode(x_cone)
        
        centerNode.addChildNode(o_y)
        centerNode.addChildNode(y_cone)
        
        centerNode.addChildNode(o_z)
        centerNode.addChildNode(z_cone)
        
        return centerNode
    }
}
