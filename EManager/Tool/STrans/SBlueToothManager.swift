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
    @objc optional func blue_scanDataDeviceListOutput(_ list:[CBPeripheral])
    @objc optional func blue_didConnectBlue()
    @objc optional func blue_dataOutput(_ value:Data) // 读取值
    @objc optional func blue_didWriteSucessWithStyle(_ style:Int) //
}

var S_BT_C_KEY = "servo_contect_data" // s bluetooth contect key
var S_BT_W_KEY = "servo_write_data" // s bluetooth write key
var S_BT_R_KEY = "servo_read_data" // s bluetooth read key

private var mgr:SBlueToothManager!
class SBlueToothManager: UIViewController {
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
    var peripheralsList = [CBPeripheral]()
    var s_peripheral:CBPeripheral!
    var s_characteristic:CBCharacteristic!
    var s_style:Int = 0
    var s_device:String = ""
    var s_id:String = ""
    var s_content:String = ""
    var s_c_characteristic = [Any]()
    /********* 1 初始化 *********/
    /*
     * 创建管理者
     */
    func createManager() {
        s_manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /*
     * 2 -- 初始化 -- 3 -- 连接设备
     * 通过选中的 peripheral(外围设备) 连接设备
     */
    func connectDeviceWithPeripheral(_ index:Int) {
        print("电机连接设备")
        let p = peripheralsList[index]
        self.s_manager.connect(p, options: [:])
    }
    
    /*
     * 连接设备的相关服务
     */
    func service_discoverCharacteristics() {
        let services = s_peripheral!.services
        if services == nil || (services?.count)! < 1 {
            return
        }
        for service in s_peripheral!.services! {
            s_peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    /********* 4 获得外围设备的服务 *********/
    
    /*
     * 发现服务回调
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        var index:Int = 1
        for service in peripheral.services! {
            print("**** \(index )找到服务 : \(service)")
            index += 1
            peripheral.discoverCharacteristics(nil, for: service)
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
        var index:Int = 1
        for characteristic in service.characteristics! {
            print("\(index) 特征 \(characteristic.uuid.uuidString) ------------")
            index += 1
            
//            peripheral.readValue(for: characteristic)
            //                // 订阅 实时接收
            //                peripheral.setNotifyValue(true, for: characteristic)
            self.s_characteristic = characteristic
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("服务 -- 特征 -- \(characteristic)")
    }
    
    /********* 6 从外围设备读取数据 *********/
    /*
     * 获取值
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // characteristic.value就是蓝牙给我们的值(我这里是json格式字符串)
        if characteristic.value == nil {
            print("值为空")
            return
        }
        let val = characteristic.value!
        self.delegate.blue_dataOutput!(val)
    }
    
    /*
     * 中心读取外设时的数据
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.isNotifying {
            peripheral.readValue(for: characteristic)
        }else{
            self.s_manager.cancelPeripheralConnection(peripheral)
        }
    }
    
    /********* 7 给外围设备发送(写入)数据 *********/
    func writeCheckBlueWithBlue(_ content:String) {
        s_style = 1
        // 发送指令!!!
        let data = content.data(using: String.Encoding.utf8)
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
            peripheralsList.removeAll()
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
    
    /*
     * 写入监听
     * didWriteValueForCharacteristic
     */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        print("写入")
    }
}

/*
 * 扫描设备的代理方法
 */
extension SBlueToothManager:CBCentralManagerDelegate {
    /*
     * 2 -- 初始化 -- 1 -- 当前设备状态
     * central delegate
     *
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
            self.s_manager.scanForPeripherals(withServices: nil, options: nil) // [CBCentralManagerScanOptionAllowDuplicatesKey:true]
        default: break
            
        }
    }
    
    /*
     * 2 -- 初始化 -- 2 -- 扫描到设备添加设备
     * central delegate
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("find devices : [\(peripheral.identifier)]")
        // 可以添加指定设备
        var isEqual = false
        for obj in peripheralsList {
            if obj.identifier == peripheral.identifier {
                isEqual = true
            }
        }
        
        if isEqual == false {
            peripheralsList.append(peripheral)
        }
        
        self.delegate.blue_scanDataDeviceListOutput!(peripheralsList)
    }
    
    /*
     * 2 -- 初始化 -- 4 -- 连接上设备
     * central delegate
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // 连接成功后停止扫描
        print("连接设备")
        s_peripheral = peripheral
        s_peripheral.delegate = self
        s_peripheral.discoverServices(nil)
        central.stopScan()
    }
    
    /*
     * 2 -- 初始化 -- 4 -- 连接上设备 -- 1 -- 连接失败
     * central delegate
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("连接外设失败")
    }
    
    /*
     * 2 -- 初始化 -- 4 -- 连接上设备 -- 2 -- 取消连接(或者重新连接)
     * central delegate
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("取消与外设的连接回调")
        central.connect(s_peripheral, options: nil)
    }
}

extension SBlueToothManager:CBPeripheralDelegate, CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
    }
    //
    
}
