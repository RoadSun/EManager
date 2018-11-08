//
//  SSnapBasicView.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/8.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit
import SnapKit
class SSnapBasicView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let redView = UIView()
        redView.backgroundColor = UIColor.red
        redView.layer.borderColor = UIColor.black.cgColor
        redView.layer.borderWidth = 0.5
        self.addSubview(redView)
        
        let yellowView = UIView()
        yellowView.backgroundColor = UIColor.yellow
        yellowView.layer.borderColor = UIColor.black.cgColor
        yellowView.layer.borderWidth = 0.5
        self.addSubview(yellowView)
        
        let blueView = UIView()
        blueView.backgroundColor = UIColor.blue
        blueView.layer.borderColor = UIColor.black.cgColor
        blueView.layer.borderWidth = 0.5
        self.addSubview(blueView)
        
        let superView = self
        let padding:Int = 10
        
        redView.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(superView).offset(padding)
            make.left.equalTo(superView.snp.left).offset(padding)
            make.bottom.equalTo(blueView.snp.top).offset(-padding)
            make.right.equalTo(yellowView.snp.left).offset(-padding)
            make.width.equalTo(yellowView.snp.width)
            
            make.height.equalTo(yellowView.snp.height)
            make.height.equalTo(blueView.snp.height)
        }
        
        yellowView.snp.makeConstraints { (make) in
            make.top.equalTo(superView.snp.top).offset(padding);
            make.left.equalTo(redView.snp.right).offset(padding);
            make.bottom.equalTo(blueView.snp.top).offset(-padding);
            make.right.equalTo(superView.snp.right).offset(-padding);
            make.width.equalTo(redView.snp.width);
            make.height.equalTo(redView.snp.height);
            make.height.equalTo(blueView.snp.height);
        }
        
        blueView.snp.makeConstraints { (make) in
            make.top.equalTo(redView.snp.bottom).offset(padding);
            make.left.equalTo(superView).offset(padding);
            make.bottom.equalTo(superView).offset(-padding);
            make.right.equalTo(superView).offset(-padding);
            make.height.equalTo(redView.snp.height);
            make.height.equalTo(yellowView.snp.height);
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
