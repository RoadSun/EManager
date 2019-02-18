//
//  SChangeBtn.swift
//  DSRobotEditorPad
//
//  Created by EX DOLL on 2019/1/30.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SChangeBtn: UIView {
    var superView:SCanvasLayer!
    var isChange:Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = frame.size.height/2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        
    }
    
    @objc func tapEvent(_ sender:UITapGestureRecognizer) {
        isChange = !isChange
        UIView.animate(withDuration: 0.1) {
            if self.isChange {
                self.layer.cornerRadius = 0
            }else{
                self.layer.cornerRadius = self.frame.size.height/2
            }
        }
        if isChange {
            superView.__model.selectedType = .rect
        }else{
            superView.__model.selectedType = .point
        }
        superView.setPointCenter(superView.center_point)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    icon_btn_draw
}
