//
//  SSnapUsingView.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/9.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class SSnapUsingView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let redView = UIView()
        redView.backgroundColor = UIColor.red
        redView.layer.borderColor = UIColor.black.cgColor
        redView.layer.borderWidth = 0.5
        self.addSubview(redView)
        
        let greenView = UIView()
        greenView.backgroundColor = UIColor.yellow
        greenView.layer.borderColor = UIColor.black.cgColor
        greenView.layer.borderWidth = 0.5
        self.addSubview(greenView)
        
        redView.snp.makeConstraints { (make) in
            make.left.top.equalTo(20)
            make.right.bottom.equalTo(-20)
        }
        
        greenView.snp.makeConstraints { (make) in
            make.center.equalTo(self);
            make.size.equalTo(CGSize(width: 200, height: 100));
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
