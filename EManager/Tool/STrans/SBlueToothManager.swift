//
//  SBlueToothManager.swift
//  EManager
//
//  Created by EX DOLL on 2019/2/19.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
import CoreBluetooth

@objc protocol SBlueToothManagerDelegate{
    @objc optional func blue_scanDataDeviceListOutput(_ list:[String:CBPeripheral])
    @objc optional func blue_didConnectBlue()
    @objc optional func blue_dataOutput(_ value:[String:String]) // 读取值
    @objc optional func blue_didWriteSucessWithStyle(_ style:Int) //
}

private var mgr:SBlueToothManager!
class SBlueToothManager: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var delegate:SBlueToothManagerDelegate!
    
    class var shared:SBlueToothManager {
        if mgr == nil {
            mgr = SBlueToothManager()
            mgr.createManager()
        }
        return mgr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
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

    var s_manager:CBCentralManager!
    var designatedDic = [String:CBPeripheral]()
    var s_peripheral:CBPeripheral!
    var s_characteristic:CBCharacteristic!
    var s_style:Int!
    var s_device:String = ""
    var s_id:String = ""
    var s_content:String = ""
    /********* 1 初始化 *********/
    /*
     * 创建管理者
     */
    func createManager() {
        s_manager = CBCentralManager(delegate: self, queue: nil)
    }
    /********* 2 初始化 *********/
    /*
     * delegate
     * 当前设备状态
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("Unknown 不知道")
        case .resetting:
            print("Resetting 重置")
        case .unsupported:
            print("Unsupported 不支持")
        case .unauthorized:
            print("Unauthorized 未授权")
        case .poweredOff:
            print("PoweredOff 关机")
        case .poweredOn:
            print("PoweredOn 开机")
            // 扫描指定设备, 为nil时表示全部扫描
            self.s_manager.scanForPeripherals(withServices: nil, options: nil)
        default: break
            
        }
    }
    /*
     * delegate
     * 扫描到设备添加设备
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("find devices : [\(peripheral.name ?? "")]")
        if peripheral.name == nil {
            return
        }
        // 可以添加指定设备
        designatedDic[peripheral.name!] = peripheral
        self.delegate.blue_scanDataDeviceListOutput!(designatedDic)
    }
    
    /*
     * 连接设备
     */
    func connectDeviceWithPeripheral(_ periphera:CBPeripheral) {
        if periphera == nil {
            print("设备为空")
            return
        }
        print("连接上设备")
        self.s_manager.connect(periphera, options: [:])
    }
    
    /*
     * delegate
     * 连接设备成功
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // 连接成功后停止扫描
        central.stopScan()
        peripheral.delegate = self
        s_peripheral = peripheral
        peripheral.discoverServices([CBUUID.init(string: "FF15")])
        self.delegate.blue_didConnectBlue!()
    }
    
    /*
     * 连接外设失败
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("连接外设失败")
    }
    
    /*
     * 取消与外设的连接回调
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("取消与外设的连接回调")
    }
    
    /********* 4 获得外围设备的服务 *********/
    
    /*
     * 发现服务回调
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            if service.uuid == CBUUID.init(string: "FF15") {
                print("找到服务 : \(service.uuid)")
                peripheral.discoverCharacteristics([], for: service)
                break
            }
        }
    }
    
    /********* 5 获得服务的特征 *********/
    /*
     * 发现特征后，可以根据特征的properties进行：读readValueForCharacteristic、
     * 写writeValue、
     * 订阅通知setNotifyValue、
     * 扫描特征的描述discoverDescriptorsForCharacteristic。
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            if characteristic.uuid == CBUUID.init(string: "") {
                self.s_characteristic = characteristic
                // 接收一次(是读一次信息还是数据经常变实时接收视情况而定, 再决定使用哪个)
                peripheral.readValue(for: characteristic)
                // 订阅 实时接收
                peripheral.setNotifyValue(true, for: characteristic)
                
                // 发送指令!!!
                let data = "发送指令给设备, 蓝牙返回信息".data(using: String.Encoding.utf8)
                self.s_peripheral.writeValue(data!, for: characteristic, type: CBCharacteristicWriteType.withResponse)
            }
            // -- 当发现characteristic有descriptor,回调didDiscoverDescriptorsForCharacteristic
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
    /*
     * 单写一次数据
     */
    func writeDataForBind() {
        let data = "发送指令给设备, 蓝牙返回信息".data(using: String.Encoding.utf8)
        self.s_peripheral.writeValue(data!, for: s_characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    /********* 6 从外围设备读取数据 *********/
    /*
     * 获取值
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // characteristic.value就是蓝牙给我们的值(我这里是json格式字符串)
        let val = characteristic.value! as NSData
        let dicInfo = try? JSONSerialization.data(withJSONObject: val, options: []) as! [String:String]
        self.delegate.blue_dataOutput!(dicInfo!)
        // 值输出
    }
    
    /*
     * 中心读取外设时的数据
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.isNotifying {
            peripheral.readValue(for: characteristic)
        }else{
            print("")
            print("")
            self.s_manager.cancelPeripheralConnection(peripheral)
        }
    }
    
    /********* 7 给外围设备发送(写入)数据 *********/
    func writeCheckBlueWithBlue() {
        s_style = 1
        // 发送指令!!!
        let data = "发送指令给设备, 蓝牙返回信息".data(using: String.Encoding.utf8)
        self.s_peripheral.writeValue(data!, for: self.s_characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    /*
     * 数据写入成功后回调
     */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        self.delegate.blue_didWriteSucessWithStyle!(s_style)
    }
    
    /********* 8 备注 *********/
    /*
     * 扫描设备
     */
    func scanDevice() {
        if s_manager == nil {
            s_manager = CBCentralManager(delegate: self, queue: nil)
            designatedDic.removeAll()
        }
    }
    
    /*
     * 断开连接
     * 断开连接后回调didDisconnectPeripheral
     * 注意断开后如果要重新扫描这个外设，需要重新调用[self.centralManager scanForPeripheralsWithServices:nil options:nil];
     */
    func disConnectPeripheral() {
        self.s_manager.cancelPeripheralConnection(self.s_peripheral)
    }
    
    /*
     * 停止扫描设备
     */
    func stopScanPeripheral() {
        self.s_manager.stopScan()
    }
}
