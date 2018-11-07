//
//  QRCodeController.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/7.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var scanView:UIView!
    var scanline:UIImageView!
    var result:UILabel!
    
    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var output:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var preview:AVCaptureVideoPreviewLayer!

    var content = CAShapeLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scanPath(CGRect(x: 100, y: 120, width: 200, height: 200))
        self.initSession()
//        _ = s_x
//        _ = s_y
//        _ = s_w
//        _ = s_h
    }

    override func viewWillDisappear(_ animated: Bool) {
        session.stopRunning()
    }
    func scanPath(_ rect:CGRect) {
        let path = CGMutablePath()
        path.addRect(rect)
        path.addRect(self.view.bounds)
        content.fillRule = kCAFillRuleEvenOdd
        content.path = path
        content.fillColor = UIColor.black.cgColor
        content.opacity = 0.3
        content.setNeedsDisplay()
        self.view.layer.addSublayer(content)
    }
    /*
     主题 : iOS原生二维码扫描和调用系统相机的问题
     http://www.cocoachina.com/bbs/read.php?tid-1484419-page-1.html
     肯定是相机被占用了导致的问题,
     进入相册那里前先[_session stopRunning];
     回到这个页面的时候再[_session startRunning];
     试试
     */
    func initSession() {
        
        device = AVCaptureDevice.default(for: .video)
        try! input = AVCaptureDeviceInput(device: device)
        output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.rectOfInterest = CGRect(x: 120, y: 100, width: 200, height: 200)
        
        session = AVCaptureSession()
        session.sessionPreset = .high
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        output.metadataObjectTypes = [.qr,.ean13,.ean8,.code128] // 识别码的类型
        
        preview = AVCaptureVideoPreviewLayer(sessionWithNoConnection: session)
        preview.videoGravity = .resizeAspectFill
        preview.frame = self.view.layer.bounds
        view.layer.insertSublayer(preview, at: 0)
        
        
//        if device.isFocusModeSupported(.continuousAutoFocus){
//            try! input.device.lockForConfiguration()
//            input.device.focusMode = .continuousAutoFocus
//            input.device.unlockForConfiguration()
//        }
        session.startRunning()
    }
    /*
     蒙版中间一块要空出来
     
     -(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
     
     if (layer == self.maskLayer) {
     
     UIGraphicsBeginImageContextWithOptions(self.maskLayer.frame.size, NO, 1.0);
     
     //蒙版新颜色
     CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8].CGColor);
     
     CGContextFillRect(ctx, self.maskLayer.frame);
     
     //转换坐标
     CGRect scanFrame = [self.view convertRect:self.scanView.frame fromView:self.scanView.superview];
     
     //空出中间一块
     CGContextClearRect(ctx, scanFrame);
     }
     }
     */
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        var stringValue = ""
        if metadataObjects.count > 0 {
            session.stopRunning()
            let metadataObj = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObj.stringValue!
            print("\(stringValue)")
            
            let alert = UIAlertController(title: "扫描结果", message: stringValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确认", style: .default, handler: { (action) in
                if self.session != nil {
                    DispatchQueue.main.async {
                        self.session.startRunning()
                    }
                }
            }))
            self.present(self, animated: true, completion: nil)
        }else{
            print("无扫描信息")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var s_x:UISlider = {
        let slider = UISlider(frame: CGRect(x: 50, y: 500, width: self.view.frame.size.width-100, height: 40))
        slider.minimumValue = 0
        slider.maximumValue = 400
        slider.value = 100
        slider.layer.backgroundColor = UIColor.white.cgColor
        slider.addTarget(self, action: #selector(changeX(sender:)), for: .valueChanged)
        self.view.addSubview(slider)
        return slider
    }()
    lazy var s_y:UISlider = {
        let slider = UISlider(frame: CGRect(x: 50, y: 540, width: self.view.frame.size.width-100, height: 40))
        slider.minimumValue = 0
        slider.maximumValue = 400
        slider.value = 120
        slider.layer.backgroundColor = UIColor.white.cgColor
        slider.addTarget(self, action: #selector(changeY(sender:)), for: .valueChanged)
        self.view.addSubview(slider)
        return slider
    }()
    lazy var s_w:UISlider = {
        let slider = UISlider(frame: CGRect(x: 50, y: 580, width: self.view.frame.size.width-100, height: 40))
        slider.minimumValue = 0
        slider.maximumValue = 400
        slider.value = 200
        slider.layer.backgroundColor = UIColor.white.cgColor
        slider.addTarget(self, action: #selector(changeW(sender:)), for: .valueChanged)
        self.view.addSubview(slider)
        return slider
    }()
    lazy var s_h:UISlider = {
        let slider = UISlider(frame: CGRect(x: 50, y: 620, width: self.view.frame.size.width-100, height: 40))
        slider.minimumValue = 0
        slider.maximumValue = 400
        slider.value = 200
        slider.layer.backgroundColor = UIColor.white.cgColor
        //        slider.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi/2)
        slider.addTarget(self, action: #selector(changeH(sender:)), for: .valueChanged)
        self.view.addSubview(slider)
        return slider
    }()
    @objc func changeX(sender:UISlider) {
        scanPath(CGRect(x: CGFloat(sender.value), y: CGFloat(s_y.value), width: CGFloat(s_w.value), height: CGFloat(s_h.value)))
    }
    @objc func changeY(sender:UISlider) {
        scanPath(CGRect(x: CGFloat(s_x.value), y: CGFloat(sender.value), width: CGFloat(s_w.value), height: CGFloat(s_h.value)))
    }
    @objc func changeW(sender:UISlider) {
        scanPath(CGRect(x: CGFloat(s_x.value), y: CGFloat(s_y.value), width: CGFloat(sender.value), height: CGFloat(s_h.value)))
    }
    @objc func changeH(sender:UISlider) {
        scanPath(CGRect(x: CGFloat(s_x.value), y: CGFloat(s_y.value), width: CGFloat(s_w.value), height: CGFloat(sender.value)))
    }
}
