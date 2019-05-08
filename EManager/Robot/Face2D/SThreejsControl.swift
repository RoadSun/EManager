
//
//  SThreejsControl.swift
//  EManager
//
//  Created by EX DOLL on 2019/4/30.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class SThreejsControl: SFaceBase {

    lazy var webGL: UIWebView = {
        let web = UIWebView(frame: self.bounds)
        self.addSubview(web)
        let path = Bundle.main.path(forResource: "index4", ofType: "html")
        let url = URL.init(string: path!)
        let request = URLRequest.init(url: url!)
        web.loadRequest(request)
        return web
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        _ = webGL
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
