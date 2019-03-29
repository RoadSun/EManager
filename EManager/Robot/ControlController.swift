//
//  ControlController.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/12.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class ControlController: UIViewController, SControlDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
//        let boy = BodyView(frame: self.view.bounds)
        let canvas = SCanvasFace(frame: CGRect(x: 100, y: 100, width: 560, height: 440))
        canvas.backgroundColor = UIColor.black
        
        let control = SControl(frame: CGRect(x: 700, y: 100, width: 600, height: 600))
        control.backgroundColor = UIColor.black
        control.delegate = self
//        let scroll = UIScrollView(frame: canvas.frame)
//        scroll.zoomScale = 0.5
//        scroll.contentSize = CGSize(width: ScreenW, height: ScreenH)
//        scroll.addSubview(canvas)
        self.view.addSubview(canvas)
        self.view.addSubview(control)
//        let boy = CirclePan(frame: self.view.bounds)
//        self.view.addSubview(canvas)
    }

    func control_outputValue(_ value: CGFloat) {
        print(value)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
