//
//  BasicFunction.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/13.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class BasicFunction: NSObject {
    static func Img(_ name:String) -> UIImage {
        let image:UIImage
        let resource_type = name.components(separatedBy: ".")
        if resource_type.count == 1 || resource_type.count != 2{
            image = UIImage.init(named: name)!
        }else{
            let bundle = Bundle.main.path(forResource: resource_type[0], ofType: resource_type[1])
            image = UIImage.init(contentsOfFile: bundle!)!
        }
        image.withRenderingMode(.alwaysOriginal)
        return image
    }
}
