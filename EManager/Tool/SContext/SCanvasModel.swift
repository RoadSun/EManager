//
//  SCanvasModel.swift
//  DSRobotEditorPad
//
//  Created by Sunlu on 2019/1/21.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

/*** 拖动方向 ***/
enum SPanDirection:Int {
    case `default` // 不受控
    case u // 上
    case r // 右
    case d // 下
    case l // 左
    case up_and_down //上下
    case left_and_right // 左右
    case none
}

/*** 选择类型 ***/
enum SCanvasSelectType {
    case point // 单点
    case more  // 多点
    case rect  // 框选
    case draw  // 绘画
}

/*** 通用框选参数 ***/
struct CanvasFrame {
    var x:CGFloat = 200
    var y:CGFloat = 200
    var w:CGFloat = 100
    var h:CGFloat = 100
    var x_w:CGFloat = 300
    var y_h:CGFloat = 300
}

/*** 框选参数确定 ***/
struct SCanvasRectData {
    var marginList:[[Double]] = [[Double]]() // 同一个电机帧值差
    var mulit:[Double] = [Double]()          // 同一点选中电机差值
    var leftNum:Int = 0                      // 左值
    var rightNum:Int = 0                     // 右值
    var current:Int = 0                      // 当前值
}

/*** 框选配置 ***/
struct CanvasConfig {
    var frame:CanvasFrame
    var center:CGPoint
}

private let canvas = SCanvasModel()
class SCanvasModel: NSObject {
    class var shared:SCanvasModel {
        return canvas
    }
    
    /*** 创建配置属性 ***/
    var config = CanvasConfig(frame: CanvasFrame(x: 0,
                                                 y: 0,
                                                 w: 20,
                                                 h: 20,
                                                 x_w: 10,
                                                 y_h: 10), center: CGPoint(x: 0, y: 0))
    /*** 手指刚接触起始点位置 尺寸 ***/
    var o:CGSize = CGSize(width: 0, height: 0)
    
    /*** 反向起始点位置 尺寸 ***/
    var reverse_o:CGSize = CGSize(width: 0, height: 0)
    
    /*** 点选空间宽度, 追加宽度 ***/
    var space:CGFloat = 20
    var t_space:CGFloat = 20

    /*** 选择类型 默认框选 ***/
    var selectedType:SCanvasSelectType = .point
    
    /*** 拖动方向 ***/
    var direction:SPanDirection = .default

}

