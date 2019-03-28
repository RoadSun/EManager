//
//  STrack.swift
//  EManager
//
//  Created by EX DOLL on 2019/3/28.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
var a:CGFloat = 40
var lx:CGFloat = 0
var ty:CGFloat = 0
var move:CGPoint = CGPoint(x: -100, y: -100)

func midpointL(_ p1:CGPoint)->CGPoint {
    return CGPoint(x: p1.x - 40, y:p1.y)
}

func midpointR(_ p1:CGPoint)->CGPoint {
    return CGPoint(x: p1.x + 40, y: p1.y)
}

func midpointL1(_ p1:CGPoint)->CGPoint {
    return CGPoint(x: p1.x - 10, y:p1.y)
}

// -1 上 0 不动 1 下
func midpointM(_ p1:CGPoint, _ p2:CGPoint, _ d:Int)->CGPoint {
    return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y)/2 + (10.0 * CGFloat(d)))
}

func midpointR1(_ p1:CGPoint)->CGPoint {
    return CGPoint(x: p1.x + 10, y: p1.y)
}

struct SPointTeam {
    var from = CGPoint(x: 0, y: 0)
    var to = CGPoint(x: 0, y: 0)
    var control = CGPoint(x: 0, y: 0)
}

struct STeamCurrentPoint {
    var bpt = SPt(point: CGPoint(x: 0, y: 0), state: 0, No: 0) // 基础点
    var pt = SPt(point: CGPoint(x: 0, y: 0), state: 0, No: 0)
    var i0 = 0  // 第一层
    var i1 = 0 // 第二层
}

class STrack: NSObject {

}
