//
//  SPointModel.swift
//  EManager
//
//  Created by Sunlu on 2019/3/28.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

// MARK: -1 上 0 不动 1 下
func midpointM(_ p1:CGPoint, _ p2:CGPoint, _ d:Int)->CGPoint {
    return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y)/2 + (10.0 * CGFloat(d)))
}

// MARK: 操作的当前点
struct STeamCurrentPoint {
    var bpt = SPt(point: CGPoint(x: -200, y: -200), state: 0, No: 0,Min:0,Max:180) // 基础点 base point
    var pt = SPt(point: CGPoint(x: -200, y: -200), state: 0, No: 0,Min:0,Max:180) // point
    var i0 = 0  // 第一层
    var i1 = 0 // 第二层
}

class SPointModel: NSObject {
    var a:CGFloat = 20
    
    var xx:CGFloat = 20
    var yy:CGFloat = 100
    func midpointL(_ p1:CGPoint)->CGPoint {
        return CGPoint(x: p1.x - a, y:p1.y)
    }
    
    func midpointR(_ p1:CGPoint)->CGPoint {
        return CGPoint(x: p1.x + a, y: p1.y)
    }
    // MARK: -
    var teamArray = [[SPt]]()
    var baseArray = [[SPt]]()
    var profileArray = [SPt]()
    var profileMidPointArray = [SPt]()
    var nameArray = [String]()
    func initArray() {
        // 左眼眉上
        let point_0_0 = SPt(point:CGPoint(x: 2*a+xx, y: 1*a+yy),state:0,No:0,Min:0,Max:180)
        let point_0_1 = SPt(point:CGPoint(x: 3*a+xx, y: 0.5*a+yy),state:1,No:1,Min:60,Max:120,Angle:CGFloat.pi/3)
        let point_0_2 = SPt(point:CGPoint(x: 5*a+xx, y: 0.5*a+yy),state:1,No:2,Min:0,Max:180,Angle:-CGFloat.pi/3)
        let point_0_3 = SPt(point:CGPoint(x: 6*a+xx, y: 1*a+yy),state:0,No:3,Min:0,Max:180)
        let array_0 = [point_0_0,point_0_1,point_0_2,point_0_3]
        
        // 左眼上
        let point_1_0 = SPt(point:CGPoint(x: 2*a+xx, y: 2*a+yy),state:0,No:0,Min:0,Max:180)
        let point_1_1 = SPt(point:CGPoint(x: 4*a+xx, y: 1*a+yy),state:1,No:1,Min:60,Max:120)
        let point_1_2 = SPt(point:CGPoint(x: 6*a+xx, y: 2*a+yy),state:0,No:2,Min:0,Max:180)
        let array_1 = [point_1_0,point_1_1,point_1_2]
        
        // 左眼下
        let point_2_0 = SPt(point:CGPoint(x: 2*a+xx, y: 3*a+yy),state:0,No:0,Min:0,Max:180)
        let point_2_1 = SPt(point:CGPoint(x: 4*a+xx, y: 3*a+yy),state:1,No:1,Min:60,Max:120)
        let point_2_2 = SPt(point:CGPoint(x: 6*a+xx, y: 3*a+yy),state:0,No:2,Min:0,Max:180)
        let array_2 = [point_2_0,point_2_1,point_2_2]
        
        // 右眼眉上
        let point_3_0 = SPt(point:CGPoint(x: 8*a+xx, y: 1*a+yy),state:0,No:0,Min:0,Max:180)
        let point_3_1 = SPt(point:CGPoint(x: 9*a+xx, y: 0.5*a+yy),state:1,No:1,Min:0,Max:180,Angle:CGFloat.pi/3)
        let point_3_2 = SPt(point:CGPoint(x: 11*a+xx, y: 0.5*a+yy),state:1,No:2,Min:0,Max:180,Angle:-CGFloat.pi/3)
        let point_3_3 = SPt(point:CGPoint(x: 12*a+xx, y: 1*a+yy),state:0,No:3,Min:0,Max:180)
        let array_3 = [point_3_0,point_3_1,point_3_2,point_3_3]
        // 右眼上
        let point_4_0 = SPt(point:CGPoint(x: 8*a+xx, y: 2*a+yy),state:0,No:0,Min:0,Max:180)
        let point_4_1 = SPt(point:CGPoint(x: 10*a+xx, y: 1*a+yy),state:1,No:1,Min:0,Max:180)
        let point_4_2 = SPt(point:CGPoint(x: 12*a+xx, y: 2*a+yy),state:0,No:2,Min:0,Max:180)
        let array_4 = [point_4_0,point_4_1,point_4_2]
        // 右眼下
        let point_5_0 = SPt(point:CGPoint(x: 8*a+xx, y: 3*a+yy),state:0,No:0,Min:0,Max:180)
        let point_5_1 = SPt(point:CGPoint(x: 10*a+xx, y: 3*a+yy),state:1,No:1,Min:0,Max:180)
        let point_5_2 = SPt(point:CGPoint(x: 12*a+xx, y: 3*a+yy),state:0,No:2,Min:0,Max:180)
        let array_5 = [point_5_0,point_5_1,point_5_2]
        
        // 嘴上
        let point_6_0 = SPt(point:CGPoint(x: 4*a+xx, y: 7*a+yy),state:1,No:0,Min:0,Max:180,Angle:CGFloat.pi/3)
        let point_6_1 = SPt(point:CGPoint(x: 6*a+xx, y: 7.8*a+yy),state:1,No:1,Min:0,Max:180)
        let point_6_2 = SPt(point:CGPoint(x: 8*a+xx, y: 7.8*a+yy),state:1,No:2,Min:0,Max:180)
        let point_6_3 = SPt(point:CGPoint(x: 10*a+xx, y: 7*a+yy),state:1,No:3,Min:0,Max:180,Angle:-CGFloat.pi/3)
        let array_6 = [point_6_0,point_6_1,point_6_2,point_6_3]
        // 嘴下
        let point_7_0 = SPt(point:CGPoint(x: 4*a+xx, y: 7*a+yy),state:1,No:0,Min:0,Max:180,Angle:CGFloat.pi/3)
        let point_7_1 = SPt(point:CGPoint(x: 6*a+xx, y: 8*a+yy),state:1,No:1,Min:0,Max:180)
        let point_7_2 = SPt(point:CGPoint(x: 8*a+xx, y: 8*a+yy),state:1,No:2,Min:0,Max:180)
        let point_7_3 = SPt(point:CGPoint(x: 10*a+xx, y: 7*a+yy),state:1,No:3,Min:0,Max:180,Angle:-CGFloat.pi/3)
        let array_7 = [point_7_0,point_7_1,point_7_2,point_7_3]
        
        // 下巴
        let point_8_0 = SPt(point:CGPoint(x: 6*a+xx, y: 10.5*a+yy),state:0,No:0,Min:0,Max:180)
        let point_8_1 = SPt(point:CGPoint(x: 7*a+xx, y: 11*a+yy),state:1,No:1,Min:0,Max:180)
        let point_8_2 = SPt(point:CGPoint(x: 8*a+xx, y: 10.5*a+yy),state:0,No:2,Min:0,Max:180)
        let array_8 = [point_8_0,point_8_1,point_8_2]
        
        // 脖1
        let point_9_0 = SPt(point:CGPoint(x: 5*a+xx, y: 12*a+yy),state:0,No:0,Min:0,Max:180)
        let point_9_1 = SPt(point:CGPoint(x: 5*a+xx, y: 13*a+yy),state:1,No:1,Min:0,Max:180)
        let point_9_2 = SPt(point:CGPoint(x: 5*a+xx, y: 14*a+yy),state:0,No:2,Min:0,Max:180)
        let array_9 = [point_9_0,point_9_1,point_9_2]
        
        // 脖2
        let point_10_0 = SPt(point:CGPoint(x: 9*a+xx, y: 12*a+yy),state:0,No:0,Min:0,Max:180)
        let point_10_1 = SPt(point:CGPoint(x: 9*a+xx, y: 13*a+yy),state:1,No:1,Min:0,Max:180)
        let point_10_2 = SPt(point:CGPoint(x: 9*a+xx, y: 14*a+yy),state:0,No:2,Min:0,Max:180)
        let array_10 = [point_10_0,point_10_1,point_10_2]
        
        // 转头
        let point_11_0 = SPt(point:CGPoint(x: 2*a+xx, y: 14*a+yy),state:0,No:0,Min:0,Max:180)
        let point_11_1 = SPt(point:CGPoint(x: 7*a+xx, y: 15*a+yy),state:1,No:1,Min:0,Max:180)
        let point_11_2 = SPt(point:CGPoint(x: 12*a+xx, y: 14*a+yy),state:0,No:2,Min:0,Max:180)
        let array_11 = [point_11_0,point_11_1,point_11_2]
        
        teamArray = [array_0,array_1,array_2,array_3,array_4,array_5,array_6,array_7,array_8,array_9,array_10,array_11]
        
        initArrayBase()
        initProfieArray()
        initNameArray()
    }
    
    func initArrayBase() {
        // 左眼眉上
        let point_0_0 = SPt(point:CGPoint(x: 2*a+xx, y: 1*a+yy),state:0,No:0,Min:0,Max:180)
        let point_0_1 = SPt(point:CGPoint(x: 3*a+xx, y: 0.5*a+yy),state:1,No:1,Min:60,Max:120,Angle:CGFloat.pi/3)
        let point_0_2 = SPt(point:CGPoint(x: 5*a+xx, y: 0.5*a+yy),state:1,No:2,Min:0,Max:180,Angle:-CGFloat.pi/3)
        let point_0_3 = SPt(point:CGPoint(x: 6*a+xx, y: 1*a+yy),state:0,No:3,Min:0,Max:180)
        let array_0 = [point_0_0,point_0_1,point_0_2,point_0_3]
        
        // 左眼上
        let point_1_0 = SPt(point:CGPoint(x: 2*a+xx, y: 2*a+yy),state:0,No:0,Min:0,Max:180)
        let point_1_1 = SPt(point:CGPoint(x: 4*a+xx, y: 1*a+yy),state:1,No:1,Min:60,Max:120)
        let point_1_2 = SPt(point:CGPoint(x: 6*a+xx, y: 2*a+yy),state:0,No:2,Min:0,Max:180)
        let array_1 = [point_1_0,point_1_1,point_1_2]
        
        // 左眼下
        let point_2_0 = SPt(point:CGPoint(x: 2*a+xx, y: 3*a+yy),state:0,No:0,Min:0,Max:180)
        let point_2_1 = SPt(point:CGPoint(x: 4*a+xx, y: 3*a+yy),state:1,No:1,Min:60,Max:120)
        let point_2_2 = SPt(point:CGPoint(x: 6*a+xx, y: 3*a+yy),state:0,No:2,Min:0,Max:180)
        let array_2 = [point_2_0,point_2_1,point_2_2]
        
        // 右眼眉上
        let point_3_0 = SPt(point:CGPoint(x: 8*a+xx, y: 1*a+yy),state:0,No:0,Min:0,Max:180)
        let point_3_1 = SPt(point:CGPoint(x: 9*a+xx, y: 0.5*a+yy),state:1,No:1,Min:0,Max:180,Angle:CGFloat.pi/3)
        let point_3_2 = SPt(point:CGPoint(x: 11*a+xx, y: 0.5*a+yy),state:1,No:2,Min:0,Max:180,Angle:-CGFloat.pi/3)
        let point_3_3 = SPt(point:CGPoint(x: 12*a+xx, y: 1*a+yy),state:0,No:3,Min:0,Max:180)
        let array_3 = [point_3_0,point_3_1,point_3_2,point_3_3]
        // 右眼上
        let point_4_0 = SPt(point:CGPoint(x: 8*a+xx, y: 2*a+yy),state:0,No:0,Min:0,Max:180)
        let point_4_1 = SPt(point:CGPoint(x: 10*a+xx, y: 1*a+yy),state:1,No:1,Min:0,Max:180)
        let point_4_2 = SPt(point:CGPoint(x: 12*a+xx, y: 2*a+yy),state:0,No:2,Min:0,Max:180)
        let array_4 = [point_4_0,point_4_1,point_4_2]
        // 右眼下
        let point_5_0 = SPt(point:CGPoint(x: 8*a+xx, y: 3*a+yy),state:0,No:0,Min:0,Max:180)
        let point_5_1 = SPt(point:CGPoint(x: 10*a+xx, y: 3*a+yy),state:1,No:1,Min:0,Max:180)
        let point_5_2 = SPt(point:CGPoint(x: 12*a+xx, y: 3*a+yy),state:0,No:2,Min:0,Max:180)
        let array_5 = [point_5_0,point_5_1,point_5_2]
        
        // 嘴上
        let point_6_0 = SPt(point:CGPoint(x: 4*a+xx, y: 7*a+yy),state:1,No:0,Min:0,Max:180,Angle:CGFloat.pi/3)
        let point_6_1 = SPt(point:CGPoint(x: 6*a+xx, y: 7.8*a+yy),state:1,No:1,Min:0,Max:180)
        let point_6_2 = SPt(point:CGPoint(x: 8*a+xx, y: 7.8*a+yy),state:1,No:2,Min:0,Max:180)
        let point_6_3 = SPt(point:CGPoint(x: 10*a+xx, y: 7*a+yy),state:1,No:3,Min:0,Max:180,Angle:-CGFloat.pi/3)
        let array_6 = [point_6_0,point_6_1,point_6_2,point_6_3]
        // 嘴下
        let point_7_0 = SPt(point:CGPoint(x: 4*a+xx, y: 7*a+yy),state:1,No:0,Min:0,Max:180,Angle:CGFloat.pi/3)
        let point_7_1 = SPt(point:CGPoint(x: 6*a+xx, y: 8*a+yy),state:1,No:1,Min:0,Max:180)
        let point_7_2 = SPt(point:CGPoint(x: 8*a+xx, y: 8*a+yy),state:1,No:2,Min:0,Max:180)
        let point_7_3 = SPt(point:CGPoint(x: 10*a+xx, y: 7*a+yy),state:1,No:3,Min:0,Max:180,Angle:-CGFloat.pi/3)
        let array_7 = [point_7_0,point_7_1,point_7_2,point_7_3]
        
        // 下巴
        let point_8_0 = SPt(point:CGPoint(x: 6*a+xx, y: 10.5*a+yy),state:0,No:0,Min:0,Max:180)
        let point_8_1 = SPt(point:CGPoint(x: 7*a+xx, y: 11*a+yy),state:1,No:1,Min:0,Max:180)
        let point_8_2 = SPt(point:CGPoint(x: 8*a+xx, y: 10.5*a+yy),state:0,No:2,Min:0,Max:180)
        let array_8 = [point_8_0,point_8_1,point_8_2]
        
        // 脖1
        let point_9_0 = SPt(point:CGPoint(x: 5*a+xx, y: 12*a+yy),state:0,No:0,Min:0,Max:180)
        let point_9_1 = SPt(point:CGPoint(x: 5*a+xx, y: 13*a+yy),state:1,No:1,Min:0,Max:180)
        let point_9_2 = SPt(point:CGPoint(x: 5*a+xx, y: 14*a+yy),state:0,No:2,Min:0,Max:180)
        let array_9 = [point_9_0,point_9_1,point_9_2]
        
        // 脖2
        let point_10_0 = SPt(point:CGPoint(x: 9*a+xx, y: 12*a+yy),state:0,No:0,Min:0,Max:180)
        let point_10_1 = SPt(point:CGPoint(x: 9*a+xx, y: 13*a+yy),state:1,No:1,Min:0,Max:180)
        let point_10_2 = SPt(point:CGPoint(x: 9*a+xx, y: 14*a+yy),state:0,No:2,Min:0,Max:180)
        let array_10 = [point_10_0,point_10_1,point_10_2]
        
        // 转头
        let point_11_0 = SPt(point:CGPoint(x: 2*a+xx, y: 14*a+yy),state:0,No:0,Min:0,Max:180)
        let point_11_1 = SPt(point:CGPoint(x: 7*a+xx, y: 15*a+yy),state:1,No:1,Min:0,Max:180)
        let point_11_2 = SPt(point:CGPoint(x: 12*a+xx, y: 14*a+yy),state:0,No:2,Min:0,Max:180)
        let array_11 = [point_11_0,point_11_1,point_11_2]
        
        baseArray = [array_0,array_1,array_2,array_3,array_4,array_5,array_6,array_7,array_8,array_9,array_10,array_11]
    }
    
    func initProfieArray() {
        
        let point_0 =   SPt(point:CGPoint(x: 5*a+xx, y: 12*a+yy),state:0,No:0,Min:0,Max:180)
        let point_1 =   SPt(point:CGPoint(x: 3*a+xx, y: 10*a+yy),state:0,No:0,Min:0,Max:180)
        let point_2 =   SPt(point:CGPoint(x: 1.5*a+xx, y: 7*a+yy),state:0,No:0,Min:0,Max:180)
        let point_3 =   SPt(point:CGPoint(x: 1*a+xx, y: 3*a+yy),state:0,No:0,Min:0,Max:180)
        let point_4 =   SPt(point:CGPoint(x: 2*a+xx, y: 0*a+yy),state:0,No:0,Min:0,Max:180)
        let point_4_0 = SPt(point:CGPoint(x: 4*a+xx, y: 0*a+yy - 2*a),state:0,No:0,Min:0,Max:180)
        let point_4_1 = SPt(point:CGPoint(x: 7*a+xx, y: 0*a+yy - 2.5*a),state:0,No:0,Min:0,Max:180)
        let point_4_2 = SPt(point:CGPoint(x: 10*a+xx, y: 0*a+yy - 2*a),state:0,No:0,Min:0,Max:180)
        let point_5 =   SPt(point:CGPoint(x: 12*a+xx, y: 0*a+yy),state:0,No:0,Min:0,Max:180)
        let point_6 =   SPt(point:CGPoint(x: 13*a+xx, y: 3*a+yy),state:0,No:0,Min:0,Max:180)
        let point_7 =   SPt(point:CGPoint(x: 12.5*a+xx, y: 7*a+yy),state:0,No:0,Min:0,Max:180)
        let point_8 =   SPt(point:CGPoint(x: 11*a+xx, y: 10*a+yy),state:0,No:0,Min:0,Max:180)
        let point_9 =   SPt(point:CGPoint(x: 9*a+xx, y: 12*a+yy),state:0,No:0,Min:0,Max:180)
        
        profileArray = [point_0,point_1,point_2,point_3,point_4,point_4_0,point_4_1,point_4_2,point_5,point_6,point_7,point_8,point_9]
        
        for index in 0..<(profileArray.count-1) {
            let midPoint = SPointModel.CGPointMidPoint(profileArray[index].point, profileArray[index+1].point)
            let pt =   SPt(point:midPoint,state:1,No:0,Min:0,Max:180)
            profileMidPointArray.append(pt)
        }
    }
    
    func initNameArray() {
        nameArray = ["左眼眉上","左眼眉上1","左眼眉上2","左眼眉上3","左眼眉上4","左眼眉上5","左眼眉上6","左眼眉上7","左眼眉上8","左眼眉上9","左眼眉上10","左眼眉上11"]
    }
    
    static func XWPointOnPowerCurveLine(_ p0:CGPoint, _ p1:CGPoint, _ p2:CGPoint, _ t:CGFloat) ->CGPoint {
        let x:CGFloat = (pow(1 - t, 2) * p0.x + 2 * t * (1 - t) * p1.x + pow(t, 2) * p2.x)
        let y:CGFloat = (pow(1 - t, 2) * p0.y + 2 * t * (1 - t) * p1.y + pow(t, 2) * p2.y)
        return CGPoint(x:x, y:y)
    }
    
    // 两点距离公式
    static func XWLengthOfTwoPoint(_ point1:CGPoint, _ point2:CGPoint) ->CGFloat {
        return sqrt(pow(point1.x - point2.x, 2) + pow(point1.y - point2.y, 2))
    }
    
    func containsPointForCurveLineType(_ point:CGPoint, move:CGPoint, to:CGPoint, control:CGPoint) ->[CGPoint]{
        
        let p0:CGPoint = move   //我是贝塞尔曲线的起始点
        let p1:CGPoint = to     //我是贝塞尔曲线终点
        let p2:CGPoint = control//控制点
        var tempPoint1:CGPoint = p0 //记录采样的每条线段起点，第一次起点就是p0
        var tempPoint2:CGPoint = p1 //记录采样线段终点
        
        //这里我取了100个点，基本上满足要求了 CGPoint.zero
        var ptArray = [CGPoint]()
        for i in 0..<100 {    //计算出终点
            tempPoint2 = SPointModel.XWPointOnPowerCurveLine(p0, p2, p1, CGFloat(i) / 100.0)        //调用我们解决第一种情况的方法，判断点是否在这两点构成的直线上
            if (pointIsInLineByTwoPoint(point,tempPoint1,tempPoint2)) {        //如果在可以认为点在这条贝塞尔曲线上，直接跳出循环返回即可
                //                return true
            }
            //如果不在则赋值准备下一次循环
            tempPoint1 = tempPoint2
            ptArray.append(tempPoint2)
        }
        return ptArray
        //        return false
    }
    
    /* bezier 算法 https://blog.csdn.net/m0_37738114/article/details/87987506
     * bezier 算法 http://www.cocoachina.com/cms/wap.php?action=article&id=25052
     * bezier 基础画法 https://www.jianshu.com/p/e136c3e65c29
     * bezier 基础画法 http://www.cocoachina.com/cms/wap.php?action=article&id=19097
     * https://blog.csdn.net/jolie_yang/article/details/54311140
     * 路径 http://www.cnblogs.com/ioshe/p/5481841.html
     * 航哥 http://www.hangge.com/blog/cache/category_72_34.html
     * 折线图 http://www.cnblogs.com/huangzhengguo/p/9495020.html
     *判断点point是否在p0 和 p1两点构成的线段上
     */
    func pointIsInLineByTwoPoint(_ point:CGPoint, _ p0:CGPoint, _ p1:CGPoint) ->Bool{
        //先设置一个所允许的最大值，点到线段的最短距离小于该值说明点在线段上
        let maxAllowOffsetLength:CGFloat = 15    //通过直线方程的两点式计算出一般式的ABC参数，具体可以自己拿起笔换算一下，很容易
        let A:CGFloat = p1.y - p0.y
        let B:CGFloat = p0.x - p1.x
        let C:CGFloat = p1.x * p0.y - p0.x * p1.y    //带入点到直线的距离公式求出点到直线的距离dis
        var dis:CGFloat = fabs((A * point.x + B * point.y + C) / sqrt(pow(A, 2) + pow(B, 2)))    //如果该距离大于允许值说明则不在线段上
        
        if (dis > maxAllowOffsetLength || dis.isNaN) {
            return false
        }else{    //否则我们要进一步判断，投影点是否在线段上，根据公式求出投影点的X坐标jiaoX
            let D:CGFloat = (A * point.y - B * point.x)
            let jiaoX:CGFloat = -(A * C + B * D) / (pow(B, 2) + pow(A, 2))        //判断jiaoX是否在线段上，t如果在0~1之间说明在线段上，大于1则说明不在线段且靠近端点p1，小于0则不在线段上且靠近端点p0，这里用了插值的思想
            let t:CGFloat = (jiaoX - p0.x) / (p1.x - p0.x)
            if (t > 1  || t.isNaN) {        //最小距离为到p1点的距离
                dis = SPointModel.XWLengthOfTwoPoint(p1, point)
            }else if (t < 0){        //最小距离为到p2点的距离
                dis = SPointModel.XWLengthOfTwoPoint(p0, point)
            }        //再次判断真正的最小距离是否小于允许值，小于则该点在直线上，反之则不在
            if (dis <= maxAllowOffsetLength) {
                return true
            }else{
                return false;
            }
        }
    }
    
    static func CGPointMidPoint(_ p0:CGPoint,_ p1:CGPoint) ->CGPoint{
        return CGPoint(x: (p0.x+p1.x)/2.0, y: (p0.y+p1.y)/2.0)
    }
    // 三次贝塞尔曲线
    //    func getList(move:Point2D, to:Point2D) -> <#return type#> {
    //        Point2D cp[] = {{10,100},{30,20},{120,20},{200,100}};
    //        int number = 100;
    //        Point2D curve[number];
    //        ComputeBezier(cp, number, curve); //因为是数组，所以不用加星号。
    //        for (int i=0; i<number; i++) {
    //            printf("curve[%d].x=%f,curve[%d].y=%f\n",i,curve[i].x,i,curve[i].y);
    //        }
    //    }
    
    //    struct Point2D {
    //        var x:CGFloat = 0
    //        var y:CGFloat = 0
    //    }
    //
    //    func PointOnCubicBezier(_ cp:[Point2D], _ t:CGFloat) ->Point2D {
    //        var ax:CGFloat, bx:CGFloat, cx:CGFloat
    //
    //        var ay:CGFloat, by:CGFloat, cy:CGFloat
    //
    //        var tSquared:CGFloat, tCubed:CGFloat
    //
    //        var result:Point2D
    //
    //        /*計算多項式係數*/
    //        cx = 3.0 * (cp[1].x - cp[0].x)
    //        bx = 3.0 * (cp[2].x - cp[1].x) - cx
    //        ax = cp[3].x - cp[0].x - cx - bx
    //
    //        cy = 3.0 * (cp[1].y - cp[0].y)
    //        by = 3.0 * (cp[2].y - cp[1].y) - cy
    //        ay = cp[3].y - cp[0].y - cy - by
    //        /*計算位於參數值t的曲線點*/
    //        tSquared = t * t
    //        tCubed = tSquared * t
    //        result.x = (ax * tCubed) + (bx * tSquared) + (cx * t) + cp[0].x
    //        result.y = (ay * tCubed) + (by * tSquared) + (cy * t) + cp[0].y
    //        return result
    //    }
    
    //    func computeBezier(_ cp:Point2D,_ numberOfPoints:Int, curve:[Point2D]) {
    //        var dt:CGFloat = 0
    //        var i = 0
    //        dt = CGFloat(1.0 / Double(numberOfPoints - 1))
    //        for index in 0..<numberOfPoints {
    //            curve[index] = PointOnCubicBezier(cp, index*dt)
    //        }
    //    }
}
