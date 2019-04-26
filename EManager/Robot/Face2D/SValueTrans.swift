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
}
