//
//  SCell.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/8.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

typealias CellSelectedBlock = (_ tag:Int)->()
class SCell: UICollectionViewCell {
    var selectedBlock:CellSelectedBlock!
    var row:Int!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
        _ = title
        _ = image
        _ = delete
    }
    
    @objc func deleteClick(_ sender:UIButton) {
        if selectedBlock != nil {
            selectedBlock(sender.tag)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title:UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: self.frame.size.height*0.75, width: self.frame.size.width, height: self.frame.size.height*0.25))
        label.backgroundColor = UIColor.lightGray
        label.textAlignment = .center
        label.text = "123"
        self.addSubview(label)
        return label
    }()
    
    lazy var image:UIImageView = {
        let imgV = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height*0.75))
        self.addSubview(imgV)
        return imgV
    }()
    
    lazy var delete:UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: self.frame.size.width - 30, y: 0, width: 30, height: 30)
        btn.setTitle("X", for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(deleteClick), for: .touchUpInside)
        self.addSubview(btn)
        return btn
    }()
    
}
