//
//  SFaceLog.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/2.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
private let face = SFaceLog()

class SFaceLog: UIView {
    class var shared:SFaceLog {
        return face
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!

    func name(_ val:String) {
        nameLabel.text = " 部位 : \(val)"
    }
    
    func current(_ val:String) {
        currentLabel.text = " 当前值 : \(val)"
    }
    
    func range(_ val:String) {
        rangeLabel.text = " 当前值 : \(val)"
    }
    
}
