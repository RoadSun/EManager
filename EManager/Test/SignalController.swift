//
//  SignalController.swift
//  EManager
//
//  Created by EX DOLL on 2019/2/19.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit
import CoreBluetooth
class SignalController: UIViewController, SBlueToothManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = ""//array[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SBlueToothManager.shared.connectDeviceWithPeripheral(0)
    }
    

    @IBOutlet weak var logView: UILabel!
    @IBOutlet weak var insertField: UITextField!
    @IBOutlet weak var list: UITableView!
    var array:[CBPeripheral] = [CBPeripheral]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SBlueToothManager.shared.delegate = self
    }

    private func blue_scanDataDeviceListOutput(_ list: [String : CBPeripheral]) {
        logView.text = "\(list)"
        array.removeAll()
        for obj in list.values {
            array.append(obj)
        }
    }
    
    func blue_didConnectBlue() {
        
    }
    
    @IBAction func sendClick(_ sender: Any) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
