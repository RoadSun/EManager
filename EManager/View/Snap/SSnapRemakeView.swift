//
//  SSnapRemakeView.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/9.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class SSnapRemakeView: UIView {
    var button:UIButton!
    var isLeft = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        button = UIButton(type: UIButton.ButtonType.system)
        button.addTarget(self, action: #selector(buttonClick(_:)), for: .touchUpInside)
        button.backgroundColor = UIColor.lightGray
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 0.5
        button.setTitle("Click", for: .normal)
        self.addSubview(button)
        self.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        button.snp.remakeConstraints { (make) in
            make.width.height.equalTo(100)
            if self.isLeft {
                make.left.top.equalTo(self).offset(10);
            }else{
                make.bottom.right.equalTo(self).offset(-10);
            }
        }
    }
    
    @objc func buttonClick(_ sender:UIButton) {
        isLeft = !isLeft
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
    }

}
