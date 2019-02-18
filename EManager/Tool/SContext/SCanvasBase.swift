//
//  SCanvasBase.swift
//  DSRobotEditorPad
//
//  Created by Sunlu on 2019/1/28.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SCanvasBase: UIView {
    var center_point:CGPoint!
    var points:[[CGPoint]] = [[CGPoint]]()
    var __model:SCanvasModelExtend = SCanvasModelExtend()
    var __data:SCanvasRectData = SCanvasRectData()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panEvent(_:)))
        self.addGestureRecognizer(pan)

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchEvent(_:)))
        self.addGestureRecognizer(pinch)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressEvent(_:)))
        self.addGestureRecognizer(longPress)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panEvent(_ sender: UIPanGestureRecognizer) {
        
    }
    
    @objc func pinchEvent(_ sender: UIPinchGestureRecognizer) {
        
    }
    
    @objc func longPressEvent(_ sender:UILongPressGestureRecognizer) {
        
    }
    
    /*
     * 画布绘画
     */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        if __model.selectedType == .point {
            let rect = CGRect(x: __model.config.frame.x,
                              y: __model.config.frame.y,
                              width: __model.config.frame.w,
                              height: __model.config.frame.h)
            SPen.drawCircle([rect], context!)
            __model.space = 10
        }else if (__model.selectedType == .more){
            SPen.drawBoard(points, context!)
        }else if (__model.selectedType == .rect) {
            let holeRection = CGRect(x: __model.config.frame.x,
                                     y: __model.config.frame.y,
                                     width: __model.config.frame.w,
                                     height: __model.config.frame.h)
            
            SPen.drawFill(rect: self.bounds, holeRection, context: context!)
        }
    }
}
