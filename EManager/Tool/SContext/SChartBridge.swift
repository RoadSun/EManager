//
//  SChartBridge.swift
//  DSRobotEditorPad
//
//  Created by EX DOLL on 2019/1/29.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

protocol SChartBridgeDelegate {
}

class SChartBridge: SCanvasModel {
    var delegate:SChartBridgeDelegate!
    /*
     * 选后移动
     */
}
extension Array {
    func mySwap<T>(_ i : inout T, _ j : inout T){
        let temp = i
        i = j
        j = temp
    }
    
    /*
     * 洗牌 原有, 目的
     */
    mutating func shuffle(current i:Int, aim j:Int) {
        let temp = self[i]
        self.insert(temp, at: j)
        self.remove(at: i)
    }
}
