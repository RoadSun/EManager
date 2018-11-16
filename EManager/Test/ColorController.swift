//
//  ColorController.swift
//  EManager
//
//  Created by EX DOLL on 2018/11/7.
//  Copyright © 2018 EX DOLL. All rights reserved.
//

import UIKit

class ColorController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        let rect = CGRect(x: 30, y: 60, width: 200, height: 200)
//
//        let gradientView = UIView(frame: rect)
//
//
//
//        let gradientLayer = CAGradientLayer()
//
//        gradientLayer.frame = gradientView.frame
//
//
//
//        let fromColor = UIColor.yellow.cgColor
//
//        let midColor = UIColor.red.cgColor
//
//        let toColor = UIColor.purple.cgColor
//
//
//
//        gradientLayer.colors = [fromColor, midColor, toColor]
//
//        view.layer.addSublayer(gradientLayer)
//
//        self.view.addSubview(gradientView)
        
        let cauves = Canvas(frame: self.view.bounds)
        self.view.addSubview(cauves)
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
