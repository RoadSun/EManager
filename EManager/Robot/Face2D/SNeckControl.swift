//
//  SNeckControl.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/9.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SNeckControl: SFaceBase {

    override init(frame: CGRect) {
        super.init(frame: frame)
        _model.a = 30
        _model.initNeckArray()
        self.backgroundColor = .lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: _model.profileMidPointArray[0].point)
        for (index,_) in _model.profileMidPointArray.enumerated() {
            // 在点范围之内
            if index < _model.profileMidPointArray.count - 1 {
                context?.addQuadCurve(to: _model.profileMidPointArray[index + 1].point, control: _model.neckArray[index + 1].point)
            }
        }
        context?.setStrokeColor(UIColor.orange.cgColor)
        context?.setLineWidth(3)
        context?.setLineCap(.round)
        context?.strokePath()
    }
}
