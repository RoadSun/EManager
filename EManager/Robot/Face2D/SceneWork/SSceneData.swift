//
//  SSceneData.swift
//  EManager
//
//  Created by EX DOLL on 2019/5/17.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SSceneData: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var angleLabel: UILabel!
    @IBOutlet weak var radianLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var increaseLabel: UILabel!
    @IBOutlet weak var lessLabel: UILabel!
    
    func setData(_ name:String,
                 _ dir:Int,
                 _ min:CGFloat,
                 _ max:CGFloat,
                 _ angle:CGFloat,
                 _ radian:CGFloat,
                 _ des:String,
                 _ less:String,
                 _ increase:String) {
        self.nameLabel.text = "\(name)"
        self.directionLabel.text = "\(dir)"
        self.minLabel.text = "\(min)"
        self.maxLabel.text = "\(max)"
        self.radianLabel.text = "\(angle)"
        self.displayLabel.text = "\(radian)"
        self.desLabel.text = "\(des)"
        self.lessLabel.text = "\(less)"
        self.increaseLabel.text = "\(increase)"
    }
    
    func setDisplay(_ val:CGFloat) {
        self.displayLabel.text = "\(val)"
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
