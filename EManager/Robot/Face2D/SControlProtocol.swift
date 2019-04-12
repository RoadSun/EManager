//
//  SControlProtocol.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/11.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit


@objc protocol SControlDelegate {
    @objc optional func control_outputValue(_ value:CGFloat, _ tag:Int)
    @objc optional func control_nameCurrentRangeValue(_ value:String, _ min:String, _ max:String) // 部位 当前值 范围
}

class SControlProtocol: NSObject {

}
