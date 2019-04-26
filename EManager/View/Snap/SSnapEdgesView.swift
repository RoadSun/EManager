//
//  SSnapEdgesView.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/9.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class SSnapEdgesView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var lastView:UIView = self
        for _ in 0..<10 {
            let view = UIView()
            view.backgroundColor = randowColor()
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 0.5
            self.addSubview(view)
            
            view.snp.makeConstraints { (make) in
                make.edges.equalTo(lastView).inset(UIEdgeInsets.init(top: 5, left: 10, bottom: 15, right: 20))
            }
            
            lastView = view
        }
    }
    
    func randowColor() -> UIColor {
        return UIColor.init(red: CGFloat(arc4random() % 255) / 255.0, green: CGFloat(arc4random() % 255) / 255.0, blue: CGFloat(arc4random() % 255) / 255.0, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
