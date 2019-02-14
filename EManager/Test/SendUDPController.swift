//
//  SendUDPController.swift
//  EManager
//
//  Created by EX DOLL on 2019/2/14.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
class SendUDPController: UIViewController, GCDAsyncUdpSocketDelegate {
    var sendUdpSocket:GCDAsyncUdpSocket!
    
    @IBOutlet weak var log: UILabel!
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendUdpSocket.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "客户端"
        initUDPSocket()
    }

    func initUDPSocket() {
        // 创建后台队列, 等待接收消息
        let queue = DispatchQueue.init(label: "send data to client")
        // 1.实例化一个socket, 客户端
        sendUdpSocket = GCDAsyncUdpSocket.init(delegate: self, delegateQueue: queue, socketQueue: nil)
        // 2.banding一个端口(可选),如果不绑定端口, 那么就会随机产生一个随机的电脑唯一的端口
        // 端口数字范围(1024,2^16-1)
        try? sendUdpSocket.bind(toPort: 9600, interface: nil)
        try? sendUdpSocket.enableBroadcast(true)
        try? sendUdpSocket.beginReceiving()
        // 3.接收一次消息
        try? sendUdpSocket.receiveOnce()
    }
    
    func sendBackToHost(ip:String, port:UInt16, content:[Any]) {
        let msg = "再次发送消息"
        let data = msg.data(using: String.Encoding.utf8) as! Data
        sendUdpSocket.send(data, toHost: ip, port: port, withTimeout: 60, tag: 200)
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        // 获得客户端发送的 port 和 ip
        let ip = GCDAsyncUdpSocket.host(fromAddress: address)
        let port:UInt16 = GCDAsyncUdpSocket.port(fromAddress: address)
        // 接收到的数据
        let list = String.init(data: data, encoding: String.Encoding.utf8)
        // 再次启动一个等待
//        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.sendBackToHost(ip: ip!, port: port, content: [list])
//        }
        print("[\(ip ?? ""):\(port)]\(list ?? "")")
        log.text = log.text! + "[\(ip ?? ""):\(port)]\(list ?? "")\n"
        try? sock.receiveOnce()
        
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        print("未连接")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print("没发送成功")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        if tag == 100 {
            print("发送成功")
        }
    }
    
    @IBAction func sendClick(_ sender: Any) {
        let content = [250,50,50,50]
//        let data = NSData(bytes: content, length: content.count) as Data
        let data = "去去去".data(using: String.Encoding.utf8)
        let host = "255.255.255.255"
        let port:UInt16 = 9600
        // 异步发送
        sendUdpSocket.send(data!, toHost: host, port: port, withTimeout: 10, tag: 100)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
