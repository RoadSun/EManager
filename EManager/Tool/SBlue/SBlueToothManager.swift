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
    @objc optional func blue_didConnectState(_ isContect:Bool)
    @objc optional func blue_dataOutput(_ value:Data) // 读取值
    @objc optional func blue_didWriteSucessWithStyle() //
}

private var mgr:SBlueToothManager!
class SBlueToothManager: UIViewController {
    var delegate:SBlueToothManagerDelegate!
    
    class var shared:SBlueToothManager {
        if mgr == nil {
            mgr = SBlueToothManager()
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
    
    var s_manager:CBCentralManager! // 中心设备
    var s_peripheralManager:CBPeripheralManager! // 外设管理者
    var peripheralsList = [CBPeripheral]() // 外设管理列表
    var s_peripheral:CBPeripheral! // 当前外设
    var s_characteristic:CBCharacteristic! // 当前外设指定的特征
    var s_continue:Bool = true // 持续连接
    /*
     * 1 -- 创建管理者
     */
    func createManager() {
        s_manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func createPeripheral() {
        s_peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    
    /*
     * 2 -- 初始化 -- 3 -- 连接设备
     * 通过选中的 peripheral(外围设备) 连接设备
     */
    func peripheral_connectDeviceWithPeripheral(_ index:Int) {
        print("电机连接设备")
        s_continue = true
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
    
    /*
     * 写数据, 发送指令
     */
    func writeCheckBlueWithBlue(_ content:String) {
        let data = content.dataFromHexadecimalString()//content.data(using: String.Encoding.utf8)
        self.s_peripheral.writeValue(data!, for: self.s_characteristic, type: CBCharacteristicWriteType.withResponse)
    }
    
    /*
     * 数据写入成功后回调
     */
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        self.delegate.blue_didWriteSucessWithStyle!()
    }
    
    /*
     * 断开连接
     * 断开连接后回调didDisconnectPeripheral
     * 注意断开后如果要重新扫描这个外设，需要重新调用[self.centralManager scanForPeripheralsWithServices:nil options:nil];
     */
    func disConnectPeripheral() {
        s_continue = false
        self.s_manager.cancelPeripheralConnection(self.s_peripheral)
    }
    
    /*
     * 停止扫描设备
     */
    func stopScanPeripheral() {
        self.s_manager.stopScan()
    }
}

/*
 * 扫描设备的代理方法
 */
extension SBlueToothManager:CBCentralManagerDelegate {
    /*
     * 2 -- 初始化 -- 1 -- 当前设备状态
     * central delegate
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
            self.delegate.blue_scanDataDeviceListOutput!(peripheralsList)
        }
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
        self.delegate.blue_didConnectState!(s_peripheral.state == .connected ? true:false)
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
        if s_continue {
            central.connect(s_peripheral, options: nil)
        }else{
            if self.delegate != nil {
                self.delegate.blue_didConnectState!(s_peripheral.state == .connected ? true:false)
            }
        }
    }
}

/*
 * 外围服务
 */
extension SBlueToothManager:CBPeripheralDelegate {
    /*
     * 3 -- 外围服务 -- 1 -- 通过服务查找特征
     * peripheral delegate
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        var index:Int = 1
        for service in peripheral.services! {
            print("**** \(index )找到服务 : \(service)")
            index += 1
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    /*
     * 3 -- 外围服务 -- 2 -- 通过特征查找功能属性
     * peripheral delegate
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
            print("characteristic.properties -- \(characteristic.properties)")
            //            peripheral.readValue(for: characteristic)
            //                // 订阅 实时接收
            //                            peripheral.setNotifyValue(true, for: characteristic)
            self.s_characteristic = characteristic
            peripheral.discoverDescriptors(for: characteristic)
        }
    }
    
    /*
     * 3 -- 外围服务 -- 3 -- 查找单个属性
     * peripheral delegate
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        //        print("服务 -- 特征 -- \(characteristic)")
    }
    
    /*
     * 3 -- 外围服务 -- 4 -- 获取外部设备消息
     * peripheral delegate
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.value == nil {
            print("值为空")
            return
        }
        let val = characteristic.value!
        self.delegate.blue_dataOutput!(val)
    }
    
    /*
     * 3 -- 外围服务 -- 4 -- 获取外部设备消息 -- 1 -- 消息通知
     * peripheral delegate
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.isNotifying {
            peripheral.readValue(for: characteristic)
        }else{
            self.s_manager.cancelPeripheralConnection(peripheral)
        }
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
 * 作为外设, 设置
 * https://github.com/coolnameismy/demo/blob/master/BleDemo/BleDemo/BePeripheralViewController.m
 * https://blog.csdn.net/eric_dream/article/details/81239522
 */
var SERVICE_CBUUID_1 = "FFF0"
var NOTIY_CHARACTERISTIC_CBUUID = "FFF1"
var READ_WRITE_CHARACTERISTIC_CBUUID = "FFF2"

var SERVICE_CBUUID_2 = "FFE0"
var READ_CHARACTERISTIC_CBUUID = "FFE1"

var NAME_KEY = "LocalNameKey"
var step:Int = 0
var blueTimer:Timer!
extension SBlueToothManager:CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            setServices()
            break
            
        default: break
            
        }
    }
    
    func setServices() {
        //characteristics字段描述
        let CBUUIDCharacteristicUserDescriptionStringUUID = CBUUID.init(string: CBUUIDCharacteristicUserDescriptionString)
        
        /*
        可以通知的Characteristic
        properties：CBCharacteristicPropertyNotify
        permissions CBAttributePermissionsReadable
        CBMutableCharacteristic
        */
        let notiyCharacteristic = CBMutableCharacteristic(type: CBUUID.init(string: NOTIY_CHARACTERISTIC_CBUUID),
                                                          properties: .notify,
                                                          value: nil,
                                                          permissions: .readable)
        /*
          可读写的characteristics
          properties：CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead
          permissions CBAttributePermissionsReadable | CBAttributePermissionsWriteable
        */
        let readWriteCharacteristic = CBMutableCharacteristic(type: CBUUID.init(string: READ_WRITE_CHARACTERISTIC_CBUUID),
                                                              properties: [.read,.write],
                                                              value: nil,
                                                              permissions: [.readable,.writeable])
        
        let readwriteCharacteristicDescription = CBMutableDescriptor(type: CBUUIDCharacteristicUserDescriptionStringUUID,
                                                                     value: "name")
        //设置description
        readWriteCharacteristic.descriptors = [readwriteCharacteristicDescription]

       /*
         只读的Characteristic
         properties：CBCharacteristicPropertyRead
         permissions CBAttributePermissionsReadable
        */
        let readCharacteristic = CBMutableCharacteristic(type: CBUUID.init(string: READ_CHARACTERISTIC_CBUUID),
                                                         properties: .read,
                                                         value: nil,
                                                         permissions: .readable)
        
        //service1初始化并加入两个characteristics
        let service_1 = CBMutableService(type: CBUUID.init(string: SERVICE_CBUUID_1), primary: true)
        service_1.characteristics = [notiyCharacteristic,readWriteCharacteristic]
        
        //service2初始化并加入一个characteristics
        let service_2 = CBMutableService(type: CBUUID.init(string: SERVICE_CBUUID_2), primary: true)
        service_2.characteristics = [readCharacteristic]

        //添加后就会调用代理 peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?)
        s_peripheralManager.add(service_1)
        s_peripheralManager.add(service_2)
    }
    // 添加服务后调用的代理
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if error == nil {
            step += 1
        }
        if step == 2 {
            peripheral.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[CBUUID.init(string: SERVICE_CBUUID_1),
                                                                             CBUUID.init(string: SERVICE_CBUUID_2)],
                                         CBAdvertisementDataLocalNameKey:NAME_KEY])
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("开始发送")
    }
    
    /*
     * 订阅消息
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("订阅了消息 : \(characteristic.uuid)")
        blueTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendData(_:)), userInfo: characteristic, repeats: true)
    }
    
    /*
     * 取消订阅
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        blueTimer.invalidate()
    }
    
    /*
     * send Data
     */
    @objc func sendData(_ sender:Timer)->Bool {
        let characteristic:CBMutableCharacteristic = sender.userInfo as! CBMutableCharacteristic
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss"
        return s_peripheralManager.updateValue("bbb".data(using: String.Encoding.utf8)!, for: characteristic, onSubscribedCentrals: nil)
    }
    
    /*
     * 读取请求
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        print("获得了读权限")
        if request.characteristic.properties.rawValue == CBCharacteristicProperties.read.rawValue {
            let data = request.characteristic.value
            request.value = data
            peripheral.respond(to: request, withResult: CBATTError.success)
        }else{
            peripheral.respond(to: request, withResult: CBATTError.readNotPermitted)
        }
    }
    
    /*
     * 写入
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        let request = requests[0]
        if request.characteristic.properties == CBCharacteristicProperties.write {
            let characteristic:CBMutableCharacteristic = request.characteristic as! CBMutableCharacteristic
            characteristic.value = request.value
            peripheral.respond(to: request, withResult: CBATTError.success)
        }else{
            peripheral.respond(to: request, withResult: CBATTError.writeNotPermitted)
        }
    }
    
    /*
     * 准备实时更新
     */
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        print("准备实时更新")
    }
}

/*
 * 字符串扩展
 */
extension String {
    func dataFromHexadecimalString() -> Data? {
        let trimmedString = self.trimmingCharacters(in: CharacterSet(charactersIn: "<> ")).replacingOccurrences(of: " ", with: "")
        
        // make sure the cleaned up string consists solely of hex digits, and that we have even number of them
        
        let regex = try! NSRegularExpression(pattern: "^[0-9a-f]*$", options: .caseInsensitive)
        
        let found = regex.firstMatch(in: trimmedString, options: [], range: NSMakeRange(0, trimmedString.count))
        if found == nil || found?.range.location == NSNotFound || trimmedString.count % 2 != 0 {
            return nil
        }
        
        // everything ok, so now let's build NSData
        
        let data = NSMutableData(capacity: trimmedString.count / 2)
        
        var index = trimmedString.startIndex
        while index < trimmedString.endIndex {
            let byteString = String(trimmedString[index ..< trimmedString.index(after: trimmedString.index(after: index))])
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            data?.append([num] as [UInt8], length: 1)
            index = trimmedString.index(after: trimmedString.index(after: index))
        }
        
        return data as Data?
    }
}

