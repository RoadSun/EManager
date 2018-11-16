//
//  Canvas.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/15.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class Canvas:UIView{
    //负责线条的生成、操作与管理
    private let pathCreator:PathCreator
    //是否处于擦除状态
    private var isInErasering:Bool
    //橡皮擦视图
    private let eraserView:UIView
    
    override init(frame: CGRect) {
        isInErasering = false
        pathCreator = PathCreator()
        
        eraserView = UIView.init()
        eraserView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        eraserView.backgroundColor = UIColor.white
        eraserView.alpha = 0
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
        
        self.addSubview(eraserView)
        
        let revokeBut = UIButton(type: UIButtonType.system)
        revokeBut.frame = CGRect(x: 20, y: 20, width: 80, height: 30)
        revokeBut.setTitle("撤销", for: UIControlState.normal)
        revokeBut.addTarget(self, action: #selector(revokeButClick), for: UIControlEvents.touchUpInside)
        self.addSubview(revokeBut)
        
        let cleanBut = UIButton(type: UIButtonType.system)
        cleanBut.frame = CGRect(x: 110, y: 20, width: 80, height: 30)
        cleanBut.setTitle("清空", for: UIControlState.normal)
        cleanBut.addTarget(self, action: #selector(cleanButClick), for: UIControlEvents.touchUpInside)
        self.addSubview(cleanBut)
        
        let eraserBut = UIButton(type: UIButtonType.system)
        eraserBut.frame = CGRect(x: 200, y: 20, width:80, height: 30)
        eraserBut.setTitle("橡皮", for: UIControlState.normal)
        eraserBut.setTitle("画笔", for: UIControlState.selected)
        eraserBut.addTarget(self, action: #selector(eraserButClick(but:)), for: UIControlEvents.touchUpInside)
        self.addSubview(eraserBut)
        
        let ges = UIPanGestureRecognizer(target: self, action:#selector(handleGes(ges:)))
        ges.maximumNumberOfTouches = 1
        self.addGestureRecognizer(ges)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        
    }
    
    @objc private func handleGes(ges:UIPanGestureRecognizer) -> Void {
        let point = ges.location(in: self)
        switch ges.state {
        case UIGestureRecognizerState.began:
            if isInErasering {
                //擦除状态,显示出橡皮擦
                eraserView.alpha = 1
                eraserView.center = point
            }
            //生成新的一笔
            pathCreator.addNewPath(to: point,isEraser: isInErasering)
            self.setNeedsDisplay()
        case UIGestureRecognizerState.changed:
            if isInErasering {
                //移动橡皮擦
                eraserView.center = ges.location(in: self)
            }
            //更新当前笔画路径
            pathCreator.addLineForCurrentPath(to: point,isEraser:isInErasering)
            self.setNeedsDisplay()
        case UIGestureRecognizerState.ended:
            if isInErasering {
                //擦除状态,隐藏橡皮擦
                eraserView.alpha = 0
                eraserView.center = ges.location(in: self)
            }
            //更新当前笔画路径
            pathCreator.addLineForCurrentPath(to: point,isEraser: isInErasering)
            self.setNeedsDisplay()
        case UIGestureRecognizerState.cancelled:
            print("cancel")
        case UIGestureRecognizerState.failed:
            print("fail")
        default:
            return
        }
    }
    
    override public func draw(_ rect: CGRect) {
        //画线
        pathCreator.drawPaths()
    }
    
    @objc private func revokeButClick()->Void{
        //撤销操作
        pathCreator.revoke()
        self.setNeedsDisplay()
    }
    
    @objc private func cleanButClick()->Void{
        //清空操作
        pathCreator.clean()
        self.setNeedsDisplay()
    }
    
    @objc private func eraserButClick(but:UIButton)->Void{
        //切换画图与擦除状态
        if but.isSelected {
            but.isSelected = false
            isInErasering = false
        }else{
            but.isSelected = true
            isInErasering = true
        }
    }
}
