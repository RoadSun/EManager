//
//  SDynamicData.swift
//  EManager
//
//  Created by EX DOLL on 2019/5/10.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

protocol SDynamicDataDelegate {
    func data_output(_ section:Int, _ value:Int)
}
private let data = SDynamicData()
class SDynamicData: NSObject {
    class var shared:SDynamicData {
        return data
    }
    var delegate:SDynamicDataDelegate!
    var row:Int! = 0
    var section:Int! = 0
    var num:Int = 34
    var groupNum:Int = 0
    var duration:TimeInterval = 0.04
    var list = [Substring]()
    func getRobData() {
        // 获取文件路径
        let path = Bundle.main.path(forResource: "01", ofType: "txt")
        // 获取内容
        let content:String = try! String.init(contentsOfFile: path!, encoding: String.Encoding.utf8)
        // 转成数组
        list = content.split(separator: ",")
        // 数组数量
        let count = list.count
        // 分组
        groupNum = count / num
        print(groupNum)
    }
    
    lazy var timer: Timer = {
        let time = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(sendData), userInfo: nil, repeats: true)
        return time
    }()
    
    @objc
    func sendData(_ time:Timer) {
        self.delegate.data_output(section, Int(list[section * num + row])!)
        section+=1
        if section == groupNum {
            pause()
            section = 0
        }
    }
    
    func pause() {
        self.timer.fireDate = Date.distantFuture
    }
    
    func start() {
        self.timer.fireDate = Date.distantPast//计时器继续
    }
    
    /*
     ////电动机用列表数据
     var data_servos :[Servos] = [
     //"左侧眉毛"
     Servos(name:ServosType.face_Left_Eyebrow , currentAngle: 90, standard:90, minD:0.39, maxD:0.51, minA: 40, maxA: 110,isOrder:false, selected: false),
     //"右侧眉毛"
     Servos(name:ServosType.face_Right_Eyebrow , currentAngle: 90, standard:90, minD:0.39, maxD:0.51, minA: 60, maxA: 130,isOrder:true, selected: false),
     //"左眼左右"
     Servos(name:ServosType.face_Left_Eyeball_LR , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 30, maxA: 140,isOrder:true, selected: false),
     //"右眼左右"
     Servos(name:ServosType.face_Right_Eyeball_LR , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 60, maxA: 130,isOrder:true, selected: false),
     //"左眼上下"
     Servos(name:ServosType.face_Left_Eyeball_TB , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 30, maxA: 140,isOrder:true, selected: false),
     //"右眼上下"
     Servos(name:ServosType.face_right_Eyeball_TB , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 60, maxA: 130,isOrder:true, selected: false),
     //"左上眼皮"
     Servos(name:ServosType.face_Left_Eye_T , currentAngle: 70, standard:70, minD:-5, maxD:5, minA:70, maxA: 130,isOrder:false, selected: false),
     //"右上眼皮"
     Servos(name:ServosType.face_Right_Eye_T , currentAngle: 50, standard:50, minD:-5, maxD:5, minA: 50, maxA: 130,isOrder:false, selected: false),
     //"左下眼皮"
     Servos(name:ServosType.face_Left_Eye_B , currentAngle: 100, standard:100, minD:-5, maxD:5, minA: 40, maxA: 120,isOrder:true, selected: false),
     //"右下眼皮"
     Servos(name:ServosType.face_Right_Eye_B , currentAngle: 100, standard:100, minD:-5, maxD:5, minA: 80, maxA: 120,isOrder:true, selected: false),
     //"左唇上下"
     Servos(name:ServosType.face_Left_Mouth_TB , currentAngle: 90, standard:90, minD:0.7, maxD:0.9, minA: 60, maxA: 140,isOrder:false, selected: false),
     //"右唇上下"
     Servos(name:ServosType.face_Right_Mouth_TB , currentAngle: 90, standard:90, minD:0.7, maxD:0.9, minA: 60, maxA: 120,isOrder:true, selected: false),
     //"左唇前后"
     Servos(name:ServosType.face_Left_Mouth_FB , currentAngle: 90, standard:90, minD:0.5, maxD:1.5, minA: 60, maxA: 130,isOrder:false, selected: false),
     //"右唇前后"
     Servos(name:ServosType.face_Right_Mouth_FB , currentAngle: 90, standard:90, minD:0.5, maxD:1.5, minA: 60, maxA: 130,isOrder:true, selected: false),
     //"嘴部张合"
     Servos(name:ServosType.face_Mouth , currentAngle: 90, standard:90, minD:0.25, maxD:0.75, minA: 20, maxA: 100,isOrder:true, selected: false),//,//10-150
     //"头部旋转"
     Servos(name:ServosType.Head_Shook , currentAngle: 110, standard:110, minD:-1.5, maxD:1.5, minA: 90, maxA: 130,isOrder:false, selected: false),
     //"头部前后"
     Servos(name:ServosType.Head_Nod , currentAngle: 90, standard:90, minD:-0.35, maxD:0.35, minA: 90, maxA: 110,isOrder:true, selected: false),
     //"头部左右"
     Servos(name:ServosType.Head_Move , currentAngle: 90, standard:90, minD:0.7, maxD:2.3, minA: 70, maxA: 110,isOrder:true, selected: false),
     //"左肩上下"
     Servos(name:ServosType.body_Left_Shoulder_TB , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"右肩上下"
     Servos(name:ServosType.body_Right_Shoulder_TB , currentAngle: 85, standard:85, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"左肩前后"
     Servos(name:ServosType.body_Left_Shoulder_FB , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"右肩前后"
     Servos(name:ServosType.body_Right_Shoulder_FB , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"呼吸频率"
     Servos(name:ServosType.mouth_BreathRate , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"舌头伸缩"
     Servos(name:ServosType.mouth_Tongue , currentAngle: 120, standard:120, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"左臂前后"
     Servos(name:ServosType.arm_Left_FB , currentAngle: 100, standard:100, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"左大臂抬"
     Servos(name:ServosType.arm_left_Lifting , currentAngle: 120, standard:120, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"左大臂转"
     Servos(name:ServosType.arm_left_Top_Turn , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"左肘关节"
     Servos(name:ServosType.arm_left_Joint , currentAngle: 130, standard:130, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"左小臂转"
     Servos(name:ServosType.arm_left_Bottom_Turn , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"右臂前后"
     Servos(name:ServosType.arm_Right_FB , currentAngle: 95, standard:95, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"右大臂抬"
     Servos(name:ServosType.arm_Right_Lifting , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"右大臂转"
     Servos(name:ServosType.arm_Right_Top_Turn , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"右肘关节"
     Servos(name:ServosType.arm_Right_Joint , currentAngle: 50, standard:50, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false),
     //"右小臂转"
     Servos(name:ServosType.arm_Right_Bottom_Turn , currentAngle: 90, standard:90, minD:-5, maxD:5, minA: 0, maxA: 180,isOrder:true, selected: false)
     ]

     */
    
}
