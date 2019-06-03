
//
//  EyeController.swift
//  EManager
//
//  Created by EX DOLL on 2019/5/28.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class EyeController: UIViewController, SCNNodeRendererDelegate {

    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    // 传入值, 改变眼球视觉方向 x 角度
    func setEyeValue(_ x:CGFloat, _ y:CGFloat) {
        ball.runAction(SCNAction.rotateTo(x: y , y: x, z: 0, duration: 0))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        setupScene()
        setupCamera()
        
        spawnShape()
    }
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
    }
    
    func setupView() {
        
        scnView = SCNView(frame: CGRect(x: 150, y: 160, width: 400, height: 400))
        scnView.backgroundColor = UIColor.gray
        self.view.addSubview(scnView)
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        // 3
        scnView.autoenablesDefaultLighting = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        scnView.addGestureRecognizer(pan)
    }
    
    var beginPoint:CGPoint!
    var xx:CGFloat = 0
    var yy:CGFloat = 0
    @objc
    func panEvent(_ sender:UIPanGestureRecognizer) {
        let point = sender.location(in: self.scnView)
        
        if sender.state == .began {
            beginPoint = point
        }
        
        let x = CGFloat(point.x - beginPoint.x) / 400 * CGFloat.pi
        let y = CGFloat(point.y - beginPoint.y) / 400 * CGFloat.pi
        
        if sender.state == .changed {

            var val_y = y + yy
            if val_y > CGFloat.pi * 0.5 {
                val_y = CGFloat.pi * 0.5
            }
            
            if y + yy < -CGFloat.pi * 0.5 {
                val_y = -CGFloat.pi * 0.5
            }
            
            var val_x = x + xx
            if val_x > CGFloat.pi * 0.5 {
                val_x = CGFloat.pi * 0.5
            }
            
            if x + xx < -CGFloat.pi * 0.5 {
                val_x = -CGFloat.pi * 0.5
            }
            self.setEyeValue(val_x,val_y)
        } else if sender.state == .ended {
            xx = x + xx
            yy = y + yy
        }
    }
    
    func setupCamera() {
        // 1创建一个节点
        cameraNode = SCNNode()
        // 2给相机节点赋值相机
        cameraNode.camera = SCNCamera()
        // 3设置视角的位置, x:0,y:0就是中心点, z只代表观察的距离, z越大, 物体越小
        cameraNode.position = SCNVector3(x: 0, y:0, z: 12)
        // 4 把相机的节点添加到根节点里面
        scnScene.rootNode.addChildNode(cameraNode)
    }
    var ball:SCNNode!
    func spawnShape() {
        
        SCoordinateSystem.createSys(scnScene)
        ball = SJointModel.createSphere(0, 0, 0, .white, radius: 5)
        ball.geometry?.firstMaterial?.diffuse.contents = "eye_icon.png"//UIColor.red
        ball.geometry?.firstMaterial?.multiply.intensity = 0.5
        scnScene.rootNode.addChildNode(ball)
    }
    
    func renderNode(_ node: SCNNode, renderer: SCNRenderer, arguments: [String : Any]) {
        print(node.position)
    }

}
