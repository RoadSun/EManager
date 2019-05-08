//
//  SJointModel.swift
//  Ship
//
//  Created by EX DOLL on 2019/5/7.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class SJointModel: NSObject {
    // 绘制胶囊
    class func createCapsule(_ x:CGFloat, _ y:CGFloat, _ z:CGFloat, _ color:UIColor = .lightGray, height:CGFloat = 2) ->SCNNode{
        let capsule = SCNCapsule(capRadius: 0.05, height: height)
        let capsuleNode = SCNNode(geometry: capsule)
        capsuleNode.position = SCNVector3Make(Float(x), Float(y), Float(z))
        
        let material0 = SCNMaterial()
        material0.lightingModel = .lambert
        material0.diffuse.contents = color
        material0.ambient.contents = UIColor.init(white: 0.1, alpha: 1)
        material0.locksAmbientWithDiffuse = false
        capsule.materials = [material0]
        
        return capsuleNode
    }
    
    class func createPart(_ x:CGFloat, _ y:CGFloat, _ z:CGFloat) -> SCNGeometry{
        let sphere = SCNSphere(radius: 0.2)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3Make(Float(x), Float(y), Float(z))
        return sphere
    }
    // 绘制球
    class func createSphere(_ x:CGFloat, _ y:CGFloat, _ z:CGFloat, _ color:UIColor = .yellow, radius:CGFloat = 0.2) ->SCNNode{
        let sphere = SCNSphere(radius: radius)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3Make(Float(x), Float(y), Float(z))
        
        let material = SCNMaterial()
        material.lightingModel = .lambert
        material.diffuse.contents = color
        material.ambient.contents = UIColor.init(white: 0.1, alpha: 1)
        material.locksAmbientWithDiffuse = false
        sphere.materials = [material]
        return sphereNode
    }
    // 绘制立方体
    class func createBox(_ x:CGFloat, _ y:CGFloat, _ z:CGFloat, _ color:UIColor = .yellow) ->SCNNode{
        let sphere = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3Make(Float(x), Float(y), Float(z))
        
        let material = SCNMaterial()
        material.lightingModel = .lambert
        material.diffuse.contents = color
        material.ambient.contents = UIColor.init(white: 0.1, alpha: 1)
        material.locksAmbientWithDiffuse = false
        sphere.materials = [material]
        return sphereNode
    }
    
    // 绘制管
    class func createTube(_ x:CGFloat, _ y:CGFloat, _ z:CGFloat, _ color:UIColor = .yellow) ->SCNNode{
        let tube = SCNTube(innerRadius: 0.3, outerRadius: 0.32, height: 0.1)
        let tubeNode = SCNNode(geometry: tube)
        tubeNode.position = SCNVector3Make(Float(x), Float(y), Float(z))
        
        let material = SCNMaterial()
        material.lightingModel = .lambert
        material.diffuse.contents = color
        material.ambient.contents = UIColor.init(white: 0.1, alpha: 1)
        material.locksAmbientWithDiffuse = false
        tube.materials = [material]
        return tubeNode
    }
    
    // 绘制地板
    class func createFloor(_ x:CGFloat, _ y:CGFloat, _ z:CGFloat, _ color:UIColor = .yellow) ->SCNNode{
        let tube = SCNFloor()
        let tubeNode = SCNNode(geometry: tube)
        tubeNode.position = SCNVector3Make(Float(x), Float(y), Float(z))
        
        let material = SCNMaterial()
        material.lightingModel = .lambert
        material.diffuse.contents = color
//        material.diffuse.contents = UIImage(named: "floorImg.jpg")
        material.ambient.contents = UIColor.init(white: 0.1, alpha: 1)
        material.locksAmbientWithDiffuse = false
        tube.materials = [material]
        return tubeNode
    }
    
    // 环Torus
    class func createTorus(_ x:CGFloat, _ y:CGFloat, _ z:CGFloat, _ color:UIColor = .yellow) ->SCNNode{
        let tube = SCNTorus(ringRadius: 0.3, pipeRadius: 0.05)
        let tubeNode = SCNNode(geometry: tube)
        tubeNode.position = SCNVector3Make(Float(x), Float(y), Float(z))
        
        let material = SCNMaterial()
        material.lightingModel = .lambert
        material.diffuse.contents = color
        material.ambient.contents = UIColor.init(white: 0.1, alpha: 1)
        material.locksAmbientWithDiffuse = false
        tube.materials = [material]
        return tubeNode
    }
    
    class func createCone(_ x:CGFloat, _ y:CGFloat, _ z:CGFloat, _ color:UIColor = .yellow) ->SCNNode{
        let cone = SCNCone(topRadius: 0, bottomRadius: 0.08, height: 0.2)
        let coneNode = SCNNode(geometry: cone)
        coneNode.position = SCNVector3Make(Float(x), Float(y), Float(z))
        
        let material = SCNMaterial()
        material.lightingModel = .lambert
        material.diffuse.contents = color
        material.ambient.contents = UIColor.init(white: 0.1, alpha: 1)
        material.locksAmbientWithDiffuse = false
        cone.materials = [material]
        return coneNode
    }
}
