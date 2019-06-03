//
//  SOperationRotate.swift
//  EManager
//
//  Created by EX DOLL on 2019/5/29.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class SOperationRotate: SFaceBase {
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    var isReverse:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupScene()
        setupCamera()
        
        spawnShape()
        
        dataLabel.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 传入值, 改变眼球视觉方向 x 角度
    func setEyeValue(_ x:CGFloat, _ y:CGFloat) {
        var tranToAngle_x = x * 90 + 90
        let tranToAngle_y = 90 - y * 90
        if self.isReverse {
            tranToAngle_x = 180 - tranToAngle_x
        }
        dataLabel.text = "x : \(Int(tranToAngle_x))  y : \(Int(tranToAngle_y))"
        ball.runAction(SCNAction.rotateTo(x: y , y: x, z: 0, duration: 0))
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
    }
    
    func setupView() {
        scnView = SCNView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        scnView.backgroundColor = UIColor.gray
        self.addSubview(scnView)
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        // 3
        scnView.autoenablesDefaultLighting = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEventScene(_:)))
        scnView.addGestureRecognizer(pan)
    }
    
    var beginPoint:CGPoint!
    var xx:CGFloat = 0
    var yy:CGFloat = 0
    
    @objc
    func panEventScene(_ sender:UIPanGestureRecognizer) {
        let point = sender.location(in: self.scnView)
        
        if sender.state == .began {
            beginPoint = point
        }
        
        let x = CGFloat(point.x - beginPoint.x) / 400
        let y = CGFloat(point.y - beginPoint.y) / 400
        
        if sender.state == .changed {
            
            var val_y = y + yy
            if val_y > 1 {
                val_y = 1
            }
            
            if y + yy < -1 {
                val_y = -1
            }
            
            var val_x = x + xx
            if val_x > 1 {
                val_x = 1
            }
            
            if x + xx < -1 {
                val_x = -1
            }
            
            self.setEyeValue(val_x,val_y)
            var tranToAngle_x = val_x * 90 + 90
            let tranToAngle_y = 90 - val_y * 90
            if self.isReverse {
                tranToAngle_x = 180 - tranToAngle_x
            }
            dataLabel.text = "x : \(Int(tranToAngle_x))  y : \(Int(tranToAngle_y))"
            // 输出值(角度)
            self.op_delegate.operation_outputObj!(["eye.x":val_x,"eye.y":val_y], 5)
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
