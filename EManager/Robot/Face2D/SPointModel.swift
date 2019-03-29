//
//  SPointModel.swift
//  EManager
//
//  Created by Sunlu on 2019/3/28.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SPointModel: NSObject {
    var a:CGFloat = 40
    
    func midpointL(_ p1:CGPoint)->CGPoint {
        return CGPoint(x: p1.x - a, y:p1.y)
    }
    
    func midpointR(_ p1:CGPoint)->CGPoint {
        return CGPoint(x: p1.x + a, y: p1.y)
    }
    
    var teamArray = [[SPt]]()
    var baseArray = [[SPt]]()
    func initArray() {
        // 左眼眉上
        var point_0_0 = SPt(point:CGPoint(x: 2*a, y: 1*a),state:0,No:0)
        var point_0_1 = SPt(point:CGPoint(x: 3*a, y: 0.5*a),state:1,No:1)
        var point_0_2 = SPt(point:CGPoint(x: 5*a, y: 0.5*a),state:1,No:2)
        var point_0_3 = SPt(point:CGPoint(x: 6*a, y: 1*a),state:0,No:3)
        var array_0 = [point_0_0,point_0_1,point_0_2,point_0_3]
        
        // 左眼上
        var point_1_0 = SPt(point:CGPoint(x: 2*a, y: 2*a),state:0,No:0)
        var point_1_1 = SPt(point:CGPoint(x: 4*a, y: 1*a),state:1,No:1)
        var point_1_2 = SPt(point:CGPoint(x: 6*a, y: 2*a),state:0,No:2)
        var array_1 = [point_1_0,point_1_1,point_1_2]
        
        // 左眼下
        var point_2_0 = SPt(point:CGPoint(x: 2*a, y: 3*a),state:0,No:0)
        var point_2_1 = SPt(point:CGPoint(x: 4*a, y: 3*a),state:1,No:1)
        var point_2_2 = SPt(point:CGPoint(x: 6*a, y: 3*a),state:0,No:2)
        var array_2 = [point_2_0,point_2_1,point_2_2]
        
        // 右眼眉上
        var point_3_0 = SPt(point:CGPoint(x: 8*a, y: 1*a),state:0,No:0)
        var point_3_1 = SPt(point:CGPoint(x: 9*a, y: 0.5*a),state:1,No:1)
        var point_3_2 = SPt(point:CGPoint(x: 11*a, y: 0.5*a),state:1,No:2)
        var point_3_3 = SPt(point:CGPoint(x: 12*a, y: 1*a),state:0,No:3)
        var array_3 = [point_3_0,point_3_1,point_3_2,point_3_3]
        // 右眼上
        var point_4_0 = SPt(point:CGPoint(x: 8*a, y: 2*a),state:0,No:0)
        var point_4_1 = SPt(point:CGPoint(x: 10*a, y: 1*a),state:1,No:1)
        var point_4_2 = SPt(point:CGPoint(x: 12*a, y: 2*a),state:0,No:2)
        var array_4 = [point_4_0,point_4_1,point_4_2]
        // 右眼下
        var point_5_0 = SPt(point:CGPoint(x: 8*a, y: 3*a),state:0,No:0)
        var point_5_1 = SPt(point:CGPoint(x: 10*a, y: 3*a),state:1,No:1)
        var point_5_2 = SPt(point:CGPoint(x: 12*a, y: 3*a),state:0,No:2)
        var array_5 = [point_5_0,point_5_1,point_5_2]
        
        // 嘴上
        var point_6_0 = SPt(point:CGPoint(x: 4*a, y: 7*a),state:1,No:0)
        var point_6_1 = SPt(point:CGPoint(x: 6*a, y: 7*a),state:1,No:1)
        var point_6_2 = SPt(point:CGPoint(x: 8*a, y: 7*a),state:1,No:2)
        var point_6_3 = SPt(point:CGPoint(x: 10*a, y: 7*a),state:1,No:3)
        var array_6 = [point_6_0,point_6_1,point_6_2,point_6_3]
        // 嘴下
        var point_7_0 = SPt(point:CGPoint(x: 4*a, y: 7*a),state:1,No:0)
        var point_7_1 = SPt(point:CGPoint(x: 6*a, y: 9*a),state:1,No:1)
        var point_7_2 = SPt(point:CGPoint(x: 8*a, y: 9*a),state:1,No:2)
        var point_7_3 = SPt(point:CGPoint(x: 10*a, y: 7*a),state:1,No:3)
        var array_7 = [point_7_0,point_7_1,point_7_2,point_7_3]
        
        teamArray = [array_0,array_1,array_2,array_3,array_4,array_5,array_6,array_7]
        baseArray = [array_0,array_1,array_2,array_3,array_4,array_5,array_6,array_7]
        
        initArrayBase()
    }
    
    func initArrayBase() {
        // 左眼眉上
        var point_0_0 = SPt(point:CGPoint(x: 2*a, y: 1*a),state:0,No:0)
        var point_0_1 = SPt(point:CGPoint(x: 3*a, y: 0.5*a),state:1,No:1)
        var point_0_2 = SPt(point:CGPoint(x: 5*a, y: 0.5*a),state:1,No:2)
        var point_0_3 = SPt(point:CGPoint(x: 6*a, y: 1*a),state:0,No:3)
        var array_0 = [point_0_0,point_0_1,point_0_2,point_0_3]
        
        // 左眼上
        var point_1_0 = SPt(point:CGPoint(x: 2*a, y: 2*a),state:0,No:0)
        var point_1_1 = SPt(point:CGPoint(x: 4*a, y: 1*a),state:1,No:1)
        var point_1_2 = SPt(point:CGPoint(x: 6*a, y: 2*a),state:0,No:2)
        var array_1 = [point_1_0,point_1_1,point_1_2]
        
        // 左眼下
        var point_2_0 = SPt(point:CGPoint(x: 2*a, y: 3*a),state:0,No:0)
        var point_2_1 = SPt(point:CGPoint(x: 4*a, y: 3*a),state:1,No:1)
        var point_2_2 = SPt(point:CGPoint(x: 6*a, y: 3*a),state:0,No:2)
        var array_2 = [point_2_0,point_2_1,point_2_2]
        
        // 右眼眉上
        var point_3_0 = SPt(point:CGPoint(x: 8*a, y: 1*a),state:0,No:0)
        var point_3_1 = SPt(point:CGPoint(x: 9*a, y: 0.5*a),state:1,No:1)
        var point_3_2 = SPt(point:CGPoint(x: 11*a, y: 0.5*a),state:1,No:2)
        var point_3_3 = SPt(point:CGPoint(x: 12*a, y: 1*a),state:0,No:3)
        var array_3 = [point_3_0,point_3_1,point_3_2,point_3_3]
        // 右眼上
        var point_4_0 = SPt(point:CGPoint(x: 8*a, y: 2*a),state:0,No:0)
        var point_4_1 = SPt(point:CGPoint(x: 10*a, y: 1*a),state:1,No:1)
        var point_4_2 = SPt(point:CGPoint(x: 12*a, y: 2*a),state:0,No:2)
        var array_4 = [point_4_0,point_4_1,point_4_2]
        // 右眼下
        var point_5_0 = SPt(point:CGPoint(x: 8*a, y: 3*a),state:0,No:0)
        var point_5_1 = SPt(point:CGPoint(x: 10*a, y: 3*a),state:1,No:1)
        var point_5_2 = SPt(point:CGPoint(x: 12*a, y: 3*a),state:0,No:2)
        var array_5 = [point_5_0,point_5_1,point_5_2]
        
        // 嘴上
        var point_6_0 = SPt(point:CGPoint(x: 4*a, y: 7*a),state:1,No:0)
        var point_6_1 = SPt(point:CGPoint(x: 6*a, y: 7*a),state:1,No:1)
        var point_6_2 = SPt(point:CGPoint(x: 8*a, y: 7*a),state:1,No:2)
        var point_6_3 = SPt(point:CGPoint(x: 10*a, y: 7*a),state:1,No:3)
        var array_6 = [point_6_0,point_6_1,point_6_2,point_6_3]
        // 嘴下
        var point_7_0 = SPt(point:CGPoint(x: 4*a, y: 7*a),state:1,No:0)
        var point_7_1 = SPt(point:CGPoint(x: 6*a, y: 9*a),state:1,No:1)
        var point_7_2 = SPt(point:CGPoint(x: 8*a, y: 9*a),state:1,No:2)
        var point_7_3 = SPt(point:CGPoint(x: 10*a, y: 7*a),state:1,No:3)
        var array_7 = [point_7_0,point_7_1,point_7_2,point_7_3]
        
        baseArray = [array_0,array_1,array_2,array_3,array_4,array_5,array_6,array_7]
    }
}
