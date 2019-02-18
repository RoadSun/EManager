//
//  SDuda.swift
//  DSRobotEditorPad
//
//  Created by Sunlu on 2019/1/18.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

private var duda:SDuda!

class SDuda: NSObject {
    // 保存在chart中获得点的容器
    class var shared:SDuda {
        if duda == nil {
            duda = SDuda()
            duda.addObserver(duda, forKeyPath: "yPx", options: .new, context: nil)
            return duda
        }
        return duda
    }
    
    var o_x:CGFloat = 0 // chart O点 x坐标
    var o_y:CGFloat = 0
    var xPx:CGFloat = 0
    var yPx:CGFloat = 0
    var chart_h:CGFloat = 0
    var chart_w:CGFloat = 0
    var x:CGFloat = 0
    var y:NSNumber = 0
    var zoomCurrentValue:CGFloat = 20
    var extreme_left:CGFloat = 0 // 及左侧
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
    /*
     * 每个单元格的宽度
     * w 表宽度
     * num 表单元格数量
     */
    class func chartCellWidth(_ w:CGFloat, _ num:CGFloat) -> CGFloat {
        return w / num
    }
}
