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
        return SBlueToothManager.shared.peripheralsList.count
    }
    
    @IBAction func serviceContect(_ sender: UIButton) {
        SBlueToothManager.shared.service_discoverCharacteristics()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            // default 只左黑
            // subtitle 上黑下黑
            // value1 左右 左黑右灰
            // value2 左右 左蓝右黑
        }
        cell?.textLabel?.text = "\(SBlueToothManager.shared.peripheralsList[indexPath.row].name ?? "No name")"
        cell?.detailTextLabel?.text = "\(SBlueToothManager.shared.peripheralsList[indexPath.row].identifier)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let charatic = CharacteristicController()
//        self.navigationController?.pushViewController(charatic, animated: true)
        SBlueToothManager.shared.peripheral_connectDeviceWithPeripheral(indexPath.row)
    }

    @IBOutlet weak var logView: UILabel!
    @IBOutlet weak var insertField: UITextField!
    
    var array:[CBPeripheral] = [CBPeripheral]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        SBlueToothManager.shared.createPeripheral()
        _ = dList
        SBlueToothManager.shared.createManager()
        SBlueToothManager.shared.delegate = self
    }

    func blue_scanDataDeviceListOutput(_ list: [CBPeripheral]) {
        dList.reloadData()
    }
    
    func blue_dataOutput(_ value: Data) {
        print(value)
        logView.text = "\(value)"
    }
    
    func blue_didWriteSucessWithStyle() {
        
    }
    
    var list = ["FA","90","90","90","FA","90","90","90"]
    var index = 0
    @IBAction func sendClick(_ sender: Any) {
        SBlueToothManager.shared.writeCheckBlueWithBlue(list[index]) //insertField.text!
        index += 1
        if index > 7 {
            index = 0
        }
    }

    lazy var dList: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: screenW, height: 270), style: .plain)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        return table
    }()

}
