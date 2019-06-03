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

var tempArray = [(id:Int,cls:Int,name:String,less:String,increase:String,des:String)]()
class GameViewController: UIViewController, SDynamicDataDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tempArray.removeAll()
        for obj in desList.values {
            if obj.cls == 2 {
                tempArray.append(obj)
            }
        }
        return tempArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "nodeIdentify")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "nodeIdentify")
        }
        cell?.textLabel?.text = tempArray[indexPath.row].name
        return cell!
    }
    // 通过列表点击选择肢体节点
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 点击到的节点
        if lastItem != nil {
            lastItem.node.geometry?.materials.first?.diffuse.contents = lastNodeColor
        }
        for obj in SLimbAssembly.shared.assList {
            if obj.id == tempArray[indexPath.row].id {
                lastItem = obj
                
                sliderAngle.maximumValue = Float(obj.map_max)
                sliderAngle.minimumValue = Float(obj.map_min)
                sliderAngle.value = Float(obj.map_val)
                print("差值\(Float(obj.max - obj.standard))   ----   \(Float(obj.min - obj.standard))")
                
                displaySceneData.setData(desList["\(obj.id)"]!.name, obj.servoD, obj.min, obj.max, obj.angle, obj.current, desList["\(obj.id)"]!.des, desList["\(obj.id)"]!.less, desList["\(obj.id)"]!.increase)
                
                lastNodeColor = (lastItem.node.geometry?.materials.first?.diffuse.contents as! UIColor)
                lastItem.node.geometry?.materials.first?.diffuse.contents = UIColor.green
                pan.isEnabled = true
                break
            }
        }
    }
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SDynamicData.shared.getRobData()
        SDynamicData.shared.delegate = self
        
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
        sliderx = UISlider(frame: CGRect(x: 950, y: 100, width: 200, height: 40 ))
        sliderx.tag = 1
        sliderx.maximumValue = Float(CGFloat.pi)
        sliderx.minimumValue = Float(-CGFloat.pi)
        sliderx.value = 0
        sliderx.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        self.view.addSubview(sliderx)
        
        slidery = UISlider(frame: CGRect(x: 950, y: 140, width: 200, height: 40 ))
        slidery.tag = 2
        slidery.maximumValue = Float(CGFloat.pi)
        slidery.minimumValue = Float(-CGFloat.pi)
        slidery.value = 0
        slidery.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        self.view.addSubview(slidery)
        
        sliderz = UISlider(frame: CGRect(x: 950, y: 180, width: 200, height: 40 ))
        sliderz.tag = 3
        sliderz.maximumValue = Float(CGFloat.pi)
        sliderz.minimumValue = Float(-CGFloat.pi)
        sliderz.value = 0
        sliderz.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        self.view.addSubview(sliderz)
        
        sliderAngle = UISlider(frame: CGRect(x: 950, y: 240, width: 200, height: 40 ))
        sliderAngle.tag = 3
        sliderAngle.maximumValue = 180
        sliderAngle.minimumValue = -180
        sliderAngle.value = 0
        sliderAngle.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
        self.view.addSubview(sliderAngle)
        
        let buttonStart = UIButton(type: .system)
        buttonStart.frame = CGRect(x: 950, y: 290, width: 200, height: 40 )
        buttonStart.backgroundColor = .blue
        buttonStart.setTitle("Start", for: .normal)
        buttonStart.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        self.view.addSubview(buttonStart)
        
        let buttonEnd = UIButton(type: .system)
        buttonEnd.frame = CGRect(x: 950, y: 340, width: 200, height: 40 )
        buttonEnd.backgroundColor = .blue
        buttonEnd.setTitle("Pause", for: .normal)
        buttonEnd.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        self.view.addSubview(buttonEnd)
        
        show = UIButton(type: .system)
        show.frame = CGRect(x: 950, y: 59, width: 200, height: 40 )
        show.tag = 11
        show.backgroundColor = .lightGray
        show.setTitle("--", for: .normal)
        show.addTarget(self, action: #selector(buttonClickChange(_:)), for: .touchUpInside)
        self.view.addSubview(show)
        
        sliderCameraX = UISlider(frame: CGRect(x: 950, y: 400, width: 200, height: 40 ))
        sliderCameraX.tag = 3
        sliderCameraX.maximumValue = 1
        sliderCameraX.minimumValue = -1
        sliderCameraX.value = 0
        sliderCameraX.addTarget(self, action: #selector(sliderCameraChange(_:)), for: .valueChanged)
        self.view.addSubview(sliderCameraX)
        
        sliderCameraY = UISlider(frame: CGRect(x: 950, y: 440, width: 200, height: 40 ))
        sliderCameraY.tag = 3
        sliderCameraY.maximumValue = 1
        sliderCameraY.minimumValue = -1
        sliderCameraY.value = 0
        sliderCameraY.addTarget(self, action: #selector(sliderCameraChange(_:)), for: .valueChanged)
        self.view.addSubview(sliderCameraY)
        
        sliderCameraZ = UISlider(frame: CGRect(x: 950, y: 480, width: 200, height: 40 ))
        sliderCameraZ.tag = 3
        sliderCameraZ.maximumValue = 20
        sliderCameraZ.minimumValue = -20
        sliderCameraZ.value = 10
        sliderCameraZ.addTarget(self, action: #selector(sliderCameraChange(_:)), for: .valueChanged)
        self.view.addSubview(sliderCameraZ)
        
        let buttonChange = UIButton(type: .system)
        buttonChange.frame = CGRect(x: 950, y: 530, width: 200, height: 40 )
        buttonChange.backgroundColor = .blue
        buttonChange.setTitle("Change", for: .normal)
        buttonChange.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        self.view.addSubview(buttonChange)
        
        let buttonOnce = UIButton(type: .system)
        buttonOnce.frame = CGRect(x: 950, y: 580, width: 200, height: 40 )
        buttonOnce.backgroundColor = .blue
        buttonOnce.setTitle("Once", for: .normal)
        buttonOnce.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        self.view.addSubview(buttonOnce)
        
    }
    
    var sliderAngle:UISlider!
    var sliderCameraX:UISlider!
    var sliderCameraY:UISlider!
    var sliderCameraZ:UISlider!
    var show:UIButton!
    func data_output(_ section: Int, _ value: Int, _ list: [Int]) {
        
        for var obj in SLimbAssembly.shared.assList {
            let val = obj.trans(CGFloat(list[obj.id - 1]), toAngle:false).current
            if obj.id == 30 {
                print("胸部动作 : \(list[30]) 标准值 : \(obj.standard)")
            }
            let node = obj.node
            if obj.rotateD == .r_x {
                node.runAction(SCNAction.rotateTo(x: val, y: 0, z: 0, duration: 0))
            } else if obj.rotateD == .r_y {
                node.runAction(SCNAction.rotateTo(x: 0, y: val, z: 0, duration: 0))
            } else if obj.rotateD == .r_z {
                node.runAction(SCNAction.rotateTo(x: 0, y: 0, z: val, duration: 0))
            } else if obj.rotateD == .h {
                
            } else if obj.rotateD == .w {
                node.position.z = Float(val / 180.0 * 0.5)
            }
        }
    }
    
    @objc
    func sliderCameraChange(_ sender:UISlider) {
        cameraNode.position = SCNVector3(x: sliderCameraX.value, y: sliderCameraY.value, z: sliderCameraZ.value)
        if sender == sliderCameraX {
            cameraNode.position = SCNVector3(x: sliderCameraX.value, y: 0, z: 0)
        }else if sender == sliderCameraY {
            cameraNode.position = SCNVector3(x: 0, y: sliderCameraY.value, z: 0)
        }else if sender == sliderCameraZ {
        }
    }
    
    @objc
    func buttonClick(_ sender:UIButton) {
        if sender.titleLabel?.text == "Start" {
            SDynamicData.shared.start()
        }else if sender.titleLabel?.text == "Pause" {
            SDynamicData.shared.pause()
        }else if sender.titleLabel?.text == "Change" {
            
        }else if sender.titleLabel?.text == "Once" {
            SDynamicData.shared.once()
        }
    }
    
    @objc
    func buttonClickChange(_ sender:UIButton) {
        if sender.backgroundColor == .lightGray {
            sender.backgroundColor = .yellow
        }else{
            sender.backgroundColor = .lightGray
        }
    }
    
    @objc
    func sliderChange(_ sender:UISlider) {
        if lastItem == nil {
            return
        }
        show.setTitle("\(sender.value) -- \(lastItem.current)", for: .normal)
        
        if  sender == sliderx {
            lastItem.node.transform = SCNMatrix4MakeRotation(sliderx.value, 1, 0, 0)
        }else if sender == slidery {
            lastItem.node.transform = SCNMatrix4MakeRotation(slidery.value, 0, 1, 0)
        }else if sender == sliderz {
            lastItem.node.transform = SCNMatrix4MakeRotation(sliderz.value, 0, 0, 1)
        }else if sender == sliderAngle {
            displaySceneData.setDisplay(CGFloat(lastItem.angle))
            // 单位滑动
            let val = lastItem.trans(CGFloat(sliderAngle!.value), toAngle: false).current
            let val1 = lastItem.trans(CGFloat(sliderAngle!.value), toAngle: false).current * 0.5
            if lastItem.rotateD == .y {
                lastItem.node.position.y = lastItem.position.y + Float(val1)
            }else if lastItem.rotateD == .z {
                lastItem.node.position.z = lastItem.position.z + Float(val1)
            }else if lastItem.rotateD == .r_x {
                lastItem.node.runAction(SCNAction.rotateTo(x: val, y: 0, z: 0, duration: 0))
            }else if lastItem.rotateD == .r_y {
                lastItem.node.runAction(SCNAction.rotateTo(x: 0, y: val, z: 0, duration: 0))
            }else if lastItem.rotateD == .r_z {
                lastItem.node.runAction(SCNAction.rotateTo(x: 0, y: 0, z: val, duration: 0))
            }else if lastItem.rotateD == .h {
                
                (lastItem.node.geometry as! SCNCapsule).height = SValueTrans.trans_toVal_h(0, CGFloat.pi, 0.3, 0.7, val)+0.5
                lastItem.node.position.y = Float(0.5 + SValueTrans.trans_toVal_h(0, CGFloat.pi, 0.3, 0.7, val)/2.0)
                
                // 算脖子摇摆的角度 查找肢体节点, 脖子与身体连接部分
                let h1:CGFloat = (SLimbAssembly.shared.neck_l.geometry as! SCNCapsule).height
                let h2:CGFloat = (SLimbAssembly.shared.neck_r.geometry as! SCNCapsule).height
                
                let h0 = h2 - h1
                let α = atan(h0/0.4)
                
                // 不一齐平高度算法
                let h_half = (h1 + h2) * 0.5
                let β = atan((h_half - 0.5)/0.2)
                SLimbAssembly.shared.neck01.transform = SCNMatrix4MakeRotation(Float(β), 1, 0, 0)
                SLimbAssembly.shared.neck01.transform = SCNMatrix4Rotate(SLimbAssembly.shared.neck01.transform, Float(α), 0, 0, 1)
            }
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
        
        scnView = SCNView(frame: CGRect(x: 50, y: 60, width: 800, height: 700))
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
        
        _ = displaySceneData
        _ = nodeTableView
    }
    
    var lastItem:SSNodeItem!
    var lastNodeColor:UIColor!
    var firstPoint:CGPoint!
    
    var pan:UIPanGestureRecognizer!
    // 点击选择当前的节点
    @objc
    func tapEvent(_ sender:UITapGestureRecognizer) {
        let results:[SCNHitTestResult] = (self.scnView?.hitTest(sender.location(ofTouch: 0, in: self.scnView), options: nil))!
        
        if lastItem != nil {
            lastItem.node.geometry?.materials.first?.diffuse.contents = lastNodeColor
        }
        
        // 沿着屏幕拖动
        guard let node  = results.first else{
            pan.isEnabled = false
            return
        }

        // 点击到的节点
        for obj in SLimbAssembly.shared.assList {
            if obj.node == node.node {
                print(obj.id)
                
                lastItem = obj
                
                sliderAngle.maximumValue = Float(obj.map_max)
                sliderAngle.minimumValue = Float(obj.map_min)
                sliderAngle.value = Float(obj.map_val)
                print("差值\(Float(obj.max - obj.standard))   ----   \(Float(obj.min - obj.standard))")
                
                displaySceneData.setData(desList["\(obj.id)"]!.name, obj.servoD, obj.min, obj.max, obj.angle, obj.current, desList["\(obj.id)"]!.des, desList["\(obj.id)"]!.less, desList["\(obj.id)"]!.increase)
                
                lastNodeColor = (node.node.geometry?.materials.first?.diffuse.contents as! UIColor)
                node.node.geometry?.materials.first?.diffuse.contents = UIColor.green
                pan.isEnabled = true
                break
            }
        }
    }
    func r_between(_ center:CGPoint, _ point:CGPoint) ->CGFloat{
        return sqrt(pow(abs(point.x - center.x), 2) + pow(abs(point.y - center.y), 2))
    }

    @objc
    func panEvent(_ sender:UIPanGestureRecognizer) {

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
        cameraNode.position = SCNVector3(x: 0, y: -0.8, z: 12)
        // 4 把相机的节点添加到根节点里面
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    var centerV3:SCNVector3!
    var capsuleNode:SCNNode!
    func spawnShape() {
        
        SCoordinateSystem.createSys(scnScene)
        
        // 背
        let back_0 = SJointModel.createCapsule(0, 1.5, 0, height:3)
        scnScene.rootNode.addChildNode(back_0)
        
        // 背2
        let back_1 = SJointModel.createCapsule(0, -0.5, 0, height:1)
        scnScene.rootNode.addChildNode(back_1)
        
        /////////
        
        // 左臂
        SLimbAssembly.shared.ass_l_arm(scnScene)
        
        // 右臂
        SLimbAssembly.shared.ass_r_arm(scnScene)
        
        // 左腿
        SLimbAssembly.shared.ass_l_leg(scnScene)
        
        // 右腿
        SLimbAssembly.shared.ass_r_leg(scnScene)
        
        // 脖子
        SLimbAssembly.shared.ass_r_neck(scnScene)
        
        // 胸
        SLimbAssembly.shared.ass_l_r_chest(scnScene)
        /////////
        
        // 中心点, 腰部
        let center = SJointModel.createSphere(0, 0, 0, .red)
        scnScene.rootNode.addChildNode(center)
        
        let floor = SJointModel.createFloor(0, -50, 0)
        scnScene.rootNode.addChildNode(floor)
    }
    
    lazy var displaySceneData: SSceneData = {
        let log = Bundle.main.loadNibNamed(String(describing: SSceneData.self), owner: self, options: nil)?.last as! SSceneData
        log.origin = CGPoint(x: 55, y: 65)
        log.size = CGSize(width: 235, height: 298)
        self.view.addSubview(log)
        return log
    }()
    
    lazy var nodeTableView: UITableView = {
        let tableview = UITableView.init(frame: CGRect(x: scnView.cRgt - 235 - 5, y: scnView.y + 5, width: 235, height: scnView.h - 10), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.alpha = 0.4
        self.view.addSubview(tableview)
        return tableview
    }()
    
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
