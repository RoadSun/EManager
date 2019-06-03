//
//  SPointSet.swift
//  EManager
//
//  Created by EX DOLL on 2019/5/29.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SPointSet: NSObject {
    var name:String!
    var phone:String!
    
    init(name:String="",phone:String=""){
        self.name = name
        self.phone = phone
        super.init()
    }
    
    func encode(with coder:NSCoder) {
        coder.encode(name, forKey: "Name")
        coder.encode(phone, forKey: "Phone")
    }
    
    init(coder aDecoder:NSCoder!) {
        self.name = (aDecoder.decodeObject(forKey: "Name") as! String)
        self.phone = (aDecoder.decodeObject(forKey: "Phone") as! String)
    }
}
