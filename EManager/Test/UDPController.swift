//
//  UDPController.swift
//  EManager
//
//  Created by EX DOLL on 2019/2/14.
//  Copyright © 2019 EX DOLL. All rights reserved.
//
// 服务端
import UIKit
import CocoaAsyncSocket
class UDPController: UIViewController, GCDAsyncUdpSocketDelegate {

    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var receiveBtn: UIButton!
    var udpServerSocket:GCDAsyncUdpSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "服务端"
        initUDPSocket()
    }
    
    func initUDPSocket() {
        // 创建后台队列, 等待接收消息
        let queue = DispatchQueue.init(label: "send data to service")
        // 1.实例化一个socket, 服务端
        udpServerSocket = GCDAsyncUdpSocket.init(delegate: self, delegateQueue: queue, socketQueue: nil)
        // 2.服务端监听9600
        try? udpServerSocket.bind(toPort: 9600, interface: nil)
        try? udpServerSocket.enableBroadcast(true)
        try? udpServerSocket.beginReceiving()
        // 3.接收一次消息(启动等待接收, 只接收一次)
        try? udpServerSocket.receiveOnce()
    }
    
    func sendBackToHost(ip:String, port:UInt16, content:[Any]) {
        let msg = "接收到消息"
        let data = msg.data(using: String.Encoding.utf8) as! Data
        udpServerSocket.send(data, toHost: ip, port: port, withTimeout: 60, tag: 200)
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        // 获得客户端发送的 port 和 ip
        let ip = GCDAsyncUdpSocket.host(fromAddress: address)
        let port:UInt16 = GCDAsyncUdpSocket.port(fromAddress: address)
        // 接收到的数据
        let list = String.init(data: data, encoding: String.Encoding.utf8)
        // 再次启动一个等待
        try? sock.receiveOnce()
        print("[\(ip ?? ""):\(port)]\(list)")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print("没发送成功")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        print("发送成功")
        if tag == 200 {
            
        }
    }
    
    @IBAction func sendClick(_ sender: Any) {
//        let content = [250,50,50,50]
//        let data = NSData(bytes: content, length: content.count) as Data
        let data = "发发发".data(using: String.Encoding.utf8)
        let host = "192.168.3.174"
        let port:UInt16 = 9600
        // 异步发送
        udpServerSocket.send(data!, toHost: host, port: port, withTimeout: 10, tag: 100)
    }
    
    @IBAction func receiveClick(_ sender: Any) {
        
    }
}
//https://blog.csdn.net/u013303886/article/details/81060338
//https://blog.csdn.net/u012583107/article/details/80395364
