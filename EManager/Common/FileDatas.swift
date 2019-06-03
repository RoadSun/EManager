//
//  FileDatas.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/6.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit
var FilePages = [["排序"],
                 ["约束"],
                 ["二维码"],
                 ["颜色"],
                 ["贝塞尔"],
                 ["BOY","Scene","eye","坐标系"],
                 ["封装"],
                 ["定时器"],
                 ["UDP","UDP Send"],
                 ["画板"],
                 ["蓝牙","wifi","USB"]]

var FilePagesNames = ["排序":"SortController",
                      "约束":"SnapController",
                      "二维码":"QRCodeController",
                      "颜色":"ColorController",
                      "贝塞尔":"BezierController",
                      "BOY":"ControlController",
                      "Scene":"GameViewController",
                      "eye":"EyeController",
                      "坐标系":"CoordinatesController",
                      "封装":"VController",
                      "定时器":"TimerController",
                      "UDP":"UDPController",
                      "UDP Send":"SendUDPController",
                      "画板":"CanvasController",
                      "蓝牙":"SignalController",
                      "wifi":"SignalController",
                      "USB":"SignalController"]

var CellSortTitle = ["冒泡","快速","归并"]
class FileDatas: NSObject {
    // Unmanaged.passUnretained(value).toOpaque() 打印内存地址
}
