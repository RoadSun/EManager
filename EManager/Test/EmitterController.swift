//
//  EmitterController.swift
//  EManager
//
//  Created by EX DOLL on 2019/2/28.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class EmitterController: UIViewController {
//http://www.aspku.com/kaifa/ios/255853.html
    //https://yq.aliyun.com/articles/400522
//    https://cloud.tencent.com/developer/article/118703
    //路线动画  UIBezierPath 动画 / iOS 动画效果总结方法
    //https://www.jianshu.com/p/83f7e4e3ceb0
//    http://www.hangge.com/blog/cache/detail_1899.html
//    https://www.jb51.net/article/126824.htm
//    https://www.jianshu.com/p/0419c3bed907
//    https://blog.csdn.net/lyl123_456/article/details/85097539
//    https://www.jianshu.com/p/bae091868201
    // 渐变
//    https://www.jianshu.com/p/08d560ba6e5d
    // 轨迹
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    private var rainLayer: CAEmitterLayer!
    
    private func setupRainLayer() {
        // 粒子发射图层
        rainLayer = CAEmitterLayer()
        // 发射器形状为线形，默认发射方向向上
        rainLayer.emitterShape = kCAEmitterLayerLine
        // 从发射器的轮廓发射粒子
        rainLayer.emitterMode = kCAEmitterLayerOutline
        // 优先渲染旧的粒子
        rainLayer.renderMode = kCAEmitterLayerOldestFirst
        // 发射位置
        // 对于线形发射器，线的两端点分别为
        // (emitterPosition.x - emitterSize.width/2, emitterPosition.y, emitterZPosition)和
        // (emitterPosition.x + emitterSize.width/2, emitterPosition.y, emitterZPosition)
        rainLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: 0)
        // 发射器大小
        rainLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        // 粒子生成速率的倍数，一开始不发射，设置为零
        rainLayer.birthRate = 0
        
        // 发射的粒子
        let cell = CAEmitterCell()
        // 粒子显示的内容，设置CGImage，显示图片
        cell.contents = #imageLiteral(resourceName: "Heart_red").cgImage
        // 粒子缩放倍数
        cell.scale = 0.1
        // 粒子寿命，单位是秒
        cell.lifetime = 5
        // 粒子生成速率，单位是个/秒，实际显示效果要乘以CAEmitterLayer的birthRate
        cell.birthRate = 1000
        // 粒子速度
        cell.velocity = 500
        // 粒子发射角度，正值表示顺时针方向
        cell.emissionLongitude = CGFloat.pi
        
        // 图层要发射1种粒子
        rainLayer.emitterCells = [cell]
        // 添加粒子发射图层
        view.layer.addSublayer(rainLayer)
    }
    
//    点击按钮开始或停止动画。用 CABasicAnimation 使粒子生成速率的倍数渐变，达到雨逐渐变大或变小的效果
    
    @IBAction func rainButtonClicked(_ sender: UIButton) {
        // 连续调用此方法会影响雨变大或变小的连贯性，所以禁止连续点击按钮
        sender.isUserInteractionEnabled = false
        // 粒子生成速率渐变动画
        let birthRateAnimation = CABasicAnimation(keyPath: "birthRate")
        birthRateAnimation.duration = 3
        if rainLayer.birthRate == 0 {
            // 雨变大
            birthRateAnimation.fromValue = 0
            birthRateAnimation.toValue = 1
            rainLayer.birthRate = 1
        } else {
            // 雨变小
            birthRateAnimation.fromValue = 1
            birthRateAnimation.toValue = 0
            rainLayer.birthRate = 0
        }
        // 加入动画
        rainLayer.add(birthRateAnimation, forKey: "birthRate")
        // 动画时长过后恢复按钮可点击状态
        DispatchQueue.main.asyncAfter(deadline: .now() + birthRateAnimation.duration) { [weak self] in
            guard self != nil else { return }
            sender.isUserInteractionEnabled = true
        }
    }
//    发射一圈粒子动画效果
//
//    给控制器添加类型为 CAEmitterLayer 的属性 centerHeartLayer，在 viewDidLoad 方法中对此属性进行初始化
    
    private var centerHeartLayer: CAEmitterLayer!
    
    private func setupCenterHeartLayer() {
        centerHeartLayer = CAEmitterLayer()
        // 发射器形状为圆形，默认向四周发射粒子
        centerHeartLayer.emitterShape = kCAEmitterLayerCircle
        centerHeartLayer.emitterMode = kCAEmitterLayerOutline
        centerHeartLayer.renderMode = kCAEmitterLayerOldestFirst
        // 发射器位置
        // 对于圆形发射器
        // 圆心位于(emitterPosition.x, emitterPosition.y, emitterZPosition)
        // 半径为emitterSize.width
        centerHeartLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
//        centerHeartLayer.emitterSize = centerHeartButtonClicked.frame.size
        centerHeartLayer.birthRate = 0
        
        let cell = CAEmitterCell()
        cell.contents = #imageLiteral(resourceName: "Heart_red").cgImage
        cell.lifetime = 1
        cell.birthRate = 2000
        cell.scale = 0.05
        // 粒子缩放倍数每秒减小0.02，粒子逐渐缩小
        cell.scaleSpeed = -0.02
        // 粒子透明度每秒减小1，粒子逐渐变透明
        cell.alphaSpeed = -1
        cell.velocity = 30
        
        centerHeartLayer.emitterCells = [cell]
        view.layer.addSublayer(centerHeartLayer)
    }
    
//    点击按钮开始动画
    
    @IBAction func centerHeartButtonClicked(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        // 设置动画开始时间，否则会有太多粒子
        centerHeartLayer.beginTime = CACurrentMediaTime()
        // 开始生成粒子
        centerHeartLayer.birthRate = 1
        // 一段时间后停止生成粒子
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.centerHeartLayer.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard self != nil else { return }
            sender.isUserInteractionEnabled = true
        }
    }
//    向上发射一个粒子动画效果
//
//    给控制器添加类型为 CAEmitterLayer 的属性 leftHeartLayer，在 viewDidLoad 方法中对此属性进行初始化
    
    private var leftHeartLayer: CAEmitterLayer!
    
    private func setupLeftHeartLayer() {
        leftHeartLayer = CAEmitterLayer()
        // 点状发射器，默认发射方向向右
        // 这句可以省略，点状是默认值
        leftHeartLayer.emitterShape = kCAEmitterLayerPoint
        // 从发射器中的一点发射粒子
        // 这句可以省略，是默认值
        leftHeartLayer.emitterMode = kCAEmitterLayerVolume
        leftHeartLayer.renderMode = kCAEmitterLayerOldestFirst
        // 发射器位置
        // 对于点状发射器，发射点在(emitterPosition.x, emitterPosition.y, emitterZPosition)
        leftHeartLayer.emitterPosition = CGPoint(x: view.bounds.midX * 0.5, y: view.bounds.midY)
        leftHeartLayer.birthRate = 0
        
        let cell = CAEmitterCell()
        cell.contents = #imageLiteral(resourceName: "Heart_red").cgImage
        cell.scale = 0.5
        cell.lifetime = 1
        // 1秒发射1个粒子
        cell.birthRate = 1
        cell.alphaSpeed = -1
        cell.velocity = 50
        cell.emissionLongitude = -CGFloat.pi / 2
        
        leftHeartLayer.emitterCells = [cell]
        view.layer.addSublayer(leftHeartLayer)
    }
    
//    点击按钮开始动画
    
    @IBAction func leftHeartButtonClicked(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        // 从上1秒开始动画，使按钮点击后立即发射粒子
        leftHeartLayer.beginTime = CACurrentMediaTime() - 1
        leftHeartLayer.birthRate = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.leftHeartLayer.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard self != nil else { return }
            sender.isUserInteractionEnabled = true
        }
    }
//    向上发射几个粒子动画效果
//
//    给控制器添加类型为 CAEmitterLayer 的属性 rightHeartLayer，在 viewDidLoad 方法中对此属性进行初始化
//
    private var rightHeartLayer: CAEmitterLayer!
    
    private func setupRightHeartLayer() {
        rightHeartLayer = CAEmitterLayer()
        rightHeartLayer.renderMode = kCAEmitterLayerOldestFirst
        rightHeartLayer.emitterPosition = CGPoint(x: view.bounds.midX * 1.5, y: view.bounds.midY)
        rightHeartLayer.birthRate = 0
        
        let cell = CAEmitterCell()
        cell.contents = #imageLiteral(resourceName: "Heart_red").cgImage
        cell.scale = 0.5
        cell.lifetime = 1
        cell.birthRate = 5
        cell.alphaSpeed = -1
        cell.velocity = 50
        cell.emissionLongitude = -CGFloat.pi / 2
        // 粒子发射角度的变化范围
        cell.emissionRange = CGFloat.pi / 4
        
        rightHeartLayer.emitterCells = [cell]
        view.layer.addSublayer(rightHeartLayer)
    }
    
//    点击按钮开始动画
    
    @IBAction func rightHeartButtonClicked(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        // 1秒发射5个粒子，0.2秒发射1个粒子，从上0.2秒开始动画，使按钮点击后立即发射粒子
        rightHeartLayer.beginTime = CACurrentMediaTime() - 0.2
        rightHeartLayer.birthRate = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.rightHeartLayer.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) { [weak self] in
            guard self != nil else { return }
            sender.isUserInteractionEnabled = true
        }
    }
//    抛物线粒子动画效果
//
//    实现抛物线动画需要给粒子加上重力加速度。此外，这里还加入粒子旋转效果，同时发射两种粒子。
//
//    给控制器添加类型为 CAEmitterLayer 的属性 gravityLayer，在 viewDidLoad 方法中对此属性进行初始化
    
    
    
    private var gravityLayer: CAEmitterLayer!
    
    private func setupGravityLayer() {
        gravityLayer = CAEmitterLayer()
        gravityLayer.renderMode = kCAEmitterLayerOldestFirst
        gravityLayer.emitterPosition = CGPoint(x: 0, y: view.bounds.maxY)
        gravityLayer.birthRate = 0
        
        let cell = CAEmitterCell()
        cell.contents = #imageLiteral(resourceName: "Heart_red").cgImage
        cell.scale = 0.5
        cell.lifetime = 10
        cell.alphaSpeed = -0.1
        cell.birthRate = 10
        cell.velocity = 100
        // y轴方法的加速度，模拟重力加速度
        cell.yAcceleration = 20
        cell.emissionLongitude = -CGFloat.pi / 4
        cell.emissionRange = CGFloat.pi / 4
        // 粒子旋转角速度，单位是弧度/秒，正值表示顺时针旋转
        // 这句可以省略，默认值是零
        cell.spin = 0
        // 粒子旋转角速度变化范围
        cell.spinRange = CGFloat.pi * 2
        
        let cell2 = CAEmitterCell()
        cell2.contents = #imageLiteral(resourceName: "Heart_blue").cgImage
        cell2.scale = 0.3
        cell2.lifetime = 20
        cell2.alphaSpeed = -0.05
        cell2.birthRate = 5
        cell2.velocity = 135
        cell2.yAcceleration = 20
        cell2.emissionLongitude = -CGFloat.pi / 4
        cell2.emissionRange = CGFloat.pi / 4
        cell2.spin = 0
        cell2.spinRange = CGFloat.pi * 2
        
        // 图层要发射2种粒子
        gravityLayer.emitterCells = [cell, cell2]
        view.layer.addSublayer(gravityLayer)
    }
    
    // 点击开始或停止动画
    
    @IBAction func gravityButtonClicked(_ sender: UIButton) {
        if gravityLayer.birthRate == 0 {
            gravityLayer.beginTime = CACurrentMediaTime()
            gravityLayer.birthRate = 1
        } else {
            gravityLayer.birthRate = 0
        }
    }

}
