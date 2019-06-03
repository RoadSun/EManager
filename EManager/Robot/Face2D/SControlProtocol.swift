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
    @objc optional func control_outputObj(_ value:[String:CGFloat], _ tag:Int)
    @objc optional func control_nameCurrentRangeValue(_ value:String, _ min:String, _ max:String) // 部位 当前值 范围
    @objc optional func control_pointData(_ pt:SPt)
}

@objc protocol SOperationDelegate {
    @objc optional func operation_outputObj(_ value:[String:Any], _ tag:Int)
    @objc optional func operation_outputValue(_ value:CGFloat)
    @objc optional func operation_outputStruct(_ obj:Any)
}

class SControlProtocol: NSObject {

}
