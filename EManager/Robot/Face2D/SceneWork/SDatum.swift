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
    func createSys(_ scnScene:SCNScene) {
        // 中心点
        let boxCenter = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let boxCenterNode = SCNNode(geometry: boxCenter)
        boxCenterNode.position = SCNVector3Make(0, 0, 0)
        scnScene.rootNode.addChildNode(boxCenterNode)
        
        let material = SCNMaterial()
        material.lightingModel = .lambert
        material.diffuse.contents = UIColor.white
        material.ambient.contents = UIColor.init(white: 0.1, alpha: 1)
        material.locksAmbientWithDiffuse = false
        boxCenter.materials = [material]
        
        /// x
        let sphereX = SCNSphere(radius: 0.1)
        let sphereXNode = SCNNode(geometry: sphereX)
        sphereXNode.position = SCNVector3Make(1, 0, 0)
        scnScene.rootNode.addChildNode(sphereXNode)
        
        let materialX = SCNMaterial()
        materialX.lightingModel = .lambert
        materialX.diffuse.contents = UIColor.red
        materialX.ambient.contents = UIColor.init(white: 0.1, alpha: 1)
        materialX.locksAmbientWithDiffuse = false
        sphereX.materials = [materialX]
        /// y
        let sphereY = SCNSphere(radius: 0.1)
        let sphereYNode = SCNNode(geometry: sphereY)
        sphereYNode.position = SCNVector3Make(0, 1, 0)
        scnScene.rootNode.addChildNode(sphereYNode)
        
        let materialY = SCNMaterial()
        materialY.lightingModel = .lambert
        materialY.diffuse.contents = UIColor.blue
        materialY.ambient.contents = UIColor.init(white: 0.1, alpha: 1)
        materialY.locksAmbientWithDiffuse = false
        sphereY.materials = [materialY]
        /// z
        let sphereZ = SCNSphere(radius: 0.1)
        let sphereZNode = SCNNode(geometry: sphereZ)
        sphereZNode.position = SCNVector3Make(0, 0, 1)
        scnScene.rootNode.addChildNode(sphereZNode)
        
        let materialZ = SCNMaterial()
        materialZ.lightingModel = .lambert
        materialZ.diffuse.contents = UIColor.green
        materialZ.ambient.contents = UIColor.init(white: 0.1, alpha: 1)
        materialZ.locksAmbientWithDiffuse = false
        sphereZ.materials = [materialZ]
    }
}
