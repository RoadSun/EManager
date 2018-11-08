//
//  SCell.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/8.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class SCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
        _ = title
        _ = image
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
}
