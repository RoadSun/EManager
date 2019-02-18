//
//  SSnapUpdateView.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/8.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class SSnapUpdateView: UIView {
    var button:UIButton!
//    var size:CGSize!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.size = CGSize(width: 20, height: 50)
        button = UIButton(type: UIButtonType.system)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.lightGray
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 0.5
        button.setTitle("Click", for: .normal)
        self.addSubview(button)

    }
    
    override func updateConstraints() {
        button.snp.updateConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(self.size.width).priority(.low)
            make.height.equalTo(self.size.height).priority(.low)
            make.width.lessThanOrEqualTo(self)
            make.height.lessThanOrEqualTo(self)
        }
        super.updateConstraints()
    }
    
    @objc func buttonClick(_ sender:UIButton) {
        self.size = CGSize(width: self.size.width * 1.3, height: self.size.height * 1.3)
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
