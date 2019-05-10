//
//  GameViewController.swift
//  Ship
//
//  Created by EX DOLL on 2019/5/5.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
//https://www.jianshu.com/p/f5cb3b74c6e8
class GameViewController: UIViewController {

    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScene()
        setupCamera()
        
        spawnShape()
        createSlider()
        
//        self.createSCN()
    }
    /*
     
     */
    var sliderx:UISlider!
    var slidery:UISlider!
    var sliderz:UISlider!
    
    func createSlider() {
        sliderx = UISlider(frame: CGRect(x: 700, y: 100, width: 200, height: 40 ))
        sliderx.tag = 1
        sliderx.maximumValue = Float(CGFloat.pi)
        sliderx.minimumValue = Float(-CGFloat.pi)
        sliderx.value = 0
        sliderx.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        self.view.addSubview(sliderx)
        
        slidery = UISlider(frame: CGRect(x: 700, y: 140, width: 200, height: 40 ))
        slidery.tag = 2
        slidery.maximumValue = Float(CGFloat.pi)
        slidery.minimumValue = Float(-CGFloat.pi)
        slidery.value = 0
        slidery.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        self.view.addSubview(slidery)
        
        sliderz = UISlider(frame: CGRect(x: 700, y: 180, width: 200, height: 40 ))
        sliderz.tag = 3
        sliderz.maximumValue = Float(CGFloat.pi)
        sliderz.minimumValue = Float(-CGFloat.pi)
        sliderz.value = 0
        sliderz.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        self.view.addSubview(sliderz)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 700, y: 220, width: 200, height: 40 )
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc
    func buttonClick(_ sender:UIButton) {
        lastNode.runAction(SCNAction.rotateBy(x: 0, y: 0.1, z: 0, duration: 0))
    }
    
    @objc
    func sliderChange(_ sender:UISlider) {
        if  sender == sliderx {
            lastNode.runAction(SCNAction.rotateTo(x: CGFloat(sliderx.value), y: 0, z: 0, duration: 0))
        }else if sender == slidery {
            lastNode.runAction(SCNAction.rotateTo(x: 0, y: CGFloat(slidery.value), z: 0, duration: 0))
        }
    }
    
    func createSCN() {
        // 1. 从资源中加载一个scene
        let scene = SCNScene(named: "art.scnassets/obj.scn")!
        // 2. 获取当前ViewController的scnView
        let scnView = self.view as! SCNView
        // 3. 把从资源中加载的scene加载到当前的scnView
        scnView .allowsCameraControl = true
        scnView.scene = scene
    }
    
    func setupView() {
        
        scnView = SCNView(frame: CGRect(x: 50, y: 50, width: 600, height: 700))
        scnView.backgroundColor = UIColor.gray
        self.view.addSubview(scnView)
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        // 3
        scnView.autoenablesDefaultLighting = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapEvent(_:)))
        scnView.addGestureRecognizer(tap)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        pan.isEnabled = false
        scnView.addGestureRecognizer(pan)
    }
    
    var lastNode:SCNNode!
    var lastNodeColor:UIColor!
    var firstPoint:CGPoint!
    
    var pan:UIPanGestureRecognizer!
    @objc
    func tapEvent(_ sender:UITapGestureRecognizer) {
        let results:[SCNHitTestResult] = (self.scnView?.hitTest(sender.location(ofTouch: 0, in: self.scnView), options: nil))!
        
        if lastNode != nil {
            lastNode.geometry?.materials.first?.diffuse.contents = lastNodeColor
        }
        
        guard let node  = results.first else{
            
//            torus.isHidden = true
            pan.isEnabled = false
            return
        }
        // 点击到的节点
        print(node.worldCoordinates)
        lastNode = node.node
        lastNodeColor = (node.node.geometry?.materials.first?.diffuse.contents as! UIColor)
        node.node.geometry?.materials.first?.diffuse.contents = UIColor.green
//        torus.position = SCNVector3(round(node.worldCoordinates.x),
//                                    round(node.worldCoordinates.y),
//                                    round(node.worldCoordinates.z))
//        torus.isHidden = false
        pan.isEnabled = true
    }
    func r_between(_ center:CGPoint, _ point:CGPoint) ->CGFloat{
        return sqrt(pow(abs(point.x - center.x), 2) + pow(abs(point.y - center.y), 2))
    }
    var rotateData = SPointerData()  // 上两个点
    @objc
    func panEvent(_ sender:UIPanGestureRecognizer) {
        let point = sender.location(in: self.scnView)
        if sender.state == .began {
            firstPoint = point
        }
        let r = r_between(firstPoint, point)
        if rotateData.pt != .zero {
            rotateData.setPoint(point,false)
        }
        rotateData.pt = point
        let d:CGFloat = rotateData.sign ? 1 : -1
//        torus.runAction(SCNAction.rotateBy(x: 0, y: d*(CGFloat.pi*r / 3000.0), z: 0, duration: 0))
    }
    
    func setupScene() {
        scnScene = SCNScene()
        //给当前的SCNView 赋值SCNScene
        scnView.scene = scnScene
        //设置背景图片, GeometryFighter.scnassets是我设置的一个资源库, 存放3D资源的
//        scnScene.background.contents = "GeometryFighter.scnassets/Textures/Background_Diffuse.png"
    }
    
    func setupCamera() {
        // 1创建一个节点
        cameraNode = SCNNode()
        // 2给相机节点赋值相机
        cameraNode.camera = SCNCamera()
        // 3设置视角的位置, x:0,y:0就是中心点, z只代表观察的距离, z越大, 物体越小
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        // 4 把相机的节点添加到根节点里面
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    var centerV3:SCNVector3!
    var capsuleNode:SCNNode!
    func spawnShape() {

        SCoordinateSystem.createSys(scnScene)
        
        // 脖
        let neck_0 = SJointModel.createCapsule(0, 3.5, 0, height:1)
        scnScene.rootNode.addChildNode(neck_0)
        neck_0.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        // 背
        let back_0 = SJointModel.createCapsule(0, 1.5, 0, height:3)
        scnScene.rootNode.addChildNode(back_0)
        back_0.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        // 背2
        let back_1 = SJointModel.createCapsule(0, -0.5, 0, height:1)
        scnScene.rootNode.addChildNode(back_1)
        back_1.runAction(SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0))
        
        /////////
        
        // 左臂
        SLimbAssembly.ass_l_arm(scnScene)
        
        // 右臂
        SLimbAssembly.ass_r_arm(scnScene)
        
        // 左腿
        SLimbAssembly.ass_l_leg(scnScene)
        
        // 右腿
        SLimbAssembly.ass_r_leg(scnScene)
        /////////
        
        // 头
        let center = SJointModel.createSphere(0, 0, 0, .red)
        scnScene.rootNode.addChildNode(center)
        
        // 脖1
        let neck0 = SJointModel.createSphere(0, 3, 0)
        scnScene.rootNode.addChildNode(neck0)
        
        // 脖2
        let neck1 = SJointModel.createSphere(0, 4, 0)
        scnScene.rootNode.addChildNode(neck1)
        
        let floor = SJointModel.createFloor(0, -50, 0)
        scnScene.rootNode.addChildNode(floor)
    }
    
    // 创建一个基准坐标
    var torus:SCNNode!
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
