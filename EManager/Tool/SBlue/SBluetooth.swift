//
//  SBluetooth.swift
//  EManager
//
//  Created by EX DOLL on 2019/3/6.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
import CoreBluetooth

private var mgr:SBluetooth!
class SBluetooth: UIViewController {

    
    /*
     peripheral 外围central中央
     
     0. 设定权限 Privacy - Bluetooth Peripheral Usage Description
     
     1. 创建管理者
     2. 扫描外设
     3. 连接外设
     4. 获得外设服务
     5. 获得外设服务特征
     6. 从外设读取数据
     7. 给外设发送或写入数据
     */
    
    var s_manager:CBCentralManager! // 中心设备
    var s_peripheralManager:CBPeripheralManager! // 外设管理者
    var peripheralsList = [CBPeripheral]() // 外设管理列表
    var s_peripheral:CBPeripheral! // 当前外设
    var s_characteristic:CBCharacteristic! // 当前外设指定的特征
    
    class var shared:SBluetooth {
        if mgr == nil {
            mgr = SBluetooth()
        }
        return mgr
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
