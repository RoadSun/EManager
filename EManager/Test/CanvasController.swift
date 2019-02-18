//
//  CanvasController.swift
//  EManager
//
//  Created by EX DOLL on 2019/2/15.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class CanvasController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        _ = s_canvas
    }
    lazy var s_canvas: SCanvasLayer = {
        var rect = self.view.frame
        rect.size.width = rect.size.width - 60
        rect.size.height = rect.size.height - 60
        rect.origin.x = 30
        rect.origin.y = 30
        let canvas = SCanvasLayer(frame: rect)
        canvas.backgroundColor = UIColor.lightGray
        self.view.addSubview(canvas)
        return canvas
    }()
}
