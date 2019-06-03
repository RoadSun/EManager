//
//  SValueTrans.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/19.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SValueTrans: NSObject {
    // 尺寸转单位值
    class func trans_toAngle(_ minA:CGFloat, _ maxA:CGFloat, _ minV:CGFloat, _ maxV:CGFloat, _ current:CGFloat) ->CGFloat{
        return CGFloat(Int(current / (maxV - minV) * (maxA - minA)))
    }
    // 单位值转尺寸
    class func trans_toVal(_ minA:CGFloat, _ maxA:CGFloat, _ minV:CGFloat, _ maxV:CGFloat, _ current:CGFloat) ->CGFloat{
        return CGFloat(Int(current / (maxA - minA) * (maxV - minV)))
    }
    // 值转换点 v 垂直 h 水平 point 中点 r 活动半径
    class func trans_toPoint(_ v:CGFloat, _ h:CGFloat, _ center:CGPoint, _ r:CGFloat) ->CGPoint{
        let new_h = SValueTrans.trans_toVal(0, 180, center.x - r, center.x + r, h)
        let new_v = SValueTrans.trans_toVal(0, 180, center.y + r, center.y - r, v)
        return CGPoint(x: center.x - r + new_h, y: center.y + r + new_v)
    }
    
    class func trans_toAngle_cross(_ minA:CGFloat, _ maxA:CGFloat, _ minV:CGFloat, _ maxV:CGFloat, _ current:CGFloat) ->CGFloat {
        return CGFloat(Int((current - minV) / (maxV - minV) * (maxA - minA)))
    }
    
    class func trans_toVal_cross(_ minA:CGFloat, _ maxA:CGFloat, _ minV:CGFloat, _ maxV:CGFloat, _ current:CGFloat) ->CGFloat {
        return CGFloat(Int(current / (maxA - minA) * (maxV - minV)))
    }
    
    // 凡是带 _d 均为有方向性
    class func trans_toPoint_cross_d(_ v:CGFloat, _ h:CGFloat, _ center:CGPoint, _ r:CGFloat, v_d:Int = 0, h_d:Int = 0) ->CGPoint{
        
        var new_h:CGFloat = SValueTrans.trans_toVal_cross(0, 180, center.x - r, center.x + r, h)
        var new_v:CGFloat = SValueTrans.trans_toVal_cross(0, 180, center.y + r, center.y - r, v)
        if v_d == 0 && h_d == 0{
            new_h = SValueTrans.trans_toVal_cross(0, 180, center.x - r, center.x + r, h)
            new_v = SValueTrans.trans_toVal_cross(0, 180, center.y - r, center.y + r, v)
        }

        if h_d == 0 && v_d == 1{
            new_h = SValueTrans.trans_toVal_cross(0, 180, center.x - r, center.x + r, h)
            new_v = SValueTrans.trans_toVal_cross(0, 180, center.y + r, center.y - r, v)
        }

        if h_d == 1 && v_d == 0{
            new_h = SValueTrans.trans_toVal_cross(0, 180, center.x + r, center.x - r, h)
            new_v = SValueTrans.trans_toVal_cross(0, 180, center.y - r, center.y + r, v)
        }

        if h_d == 1 && v_d == 1{
            new_h = SValueTrans.trans_toVal_cross(0, 180, center.x + r, center.x - r, h)
            new_v = SValueTrans.trans_toVal_cross(0, 180, center.y + r, center.y - r, v)
        }
        
//        if v_d == 1 {
//            new_v = new_v * -1
//        }
//
//        if h_d == 1 {
//            new_h = new_h * -1
//        }
        
        if v_d == 0 && h_d == 0{
            return CGPoint(x: center.x - r + new_h, y: center.y - r + new_v)
        }
        
        if h_d == 0 && v_d == 1{
            return CGPoint(x: center.x - r + new_h, y: center.y + r + new_v)
        }
        
        if h_d == 1 && v_d == 0{
            return CGPoint(x: center.x + r + new_h, y: center.y - r + new_v)
        }
        
        if h_d == 1 && v_d == 1{
            return CGPoint(x: center.x + r + new_h, y: center.y + r + new_v)
        }

        return CGPoint(x: center.x - r + new_h, y: center.y - r - new_v)
    }
    
    class func trans_toPoint_cross(_ v:CGFloat, _ h:CGFloat, _ center:CGPoint, _ r:CGFloat) ->CGPoint{
        let new_h = SValueTrans.trans_toVal_cross(0, 180, center.x - r, center.x + r, h)
        let new_v = SValueTrans.trans_toVal_cross(0, 180, center.y + r, center.y - r, v)
        return CGPoint(x: center.x - r + new_h, y: center.y - r - new_v)
    }
    
    // 弧度 角度互转
    class func trans_πAngel(_ value:CGFloat, _ toA:Bool = true) ->CGFloat {
        if toA {
            return 180.0 * value / CGFloat.pi
        }
        return CGFloat.pi * value / 180.0
    }
    
    class func trans_toVal_h(_ minA:CGFloat, _ maxA:CGFloat, _ minV:CGFloat, _ maxV:CGFloat, _ current:CGFloat) ->CGFloat {
        return CGFloat(current / (maxA - minA) * (maxV - minV))
    }
}
