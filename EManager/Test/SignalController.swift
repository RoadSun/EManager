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
        return 1//(SBTManager.shared.deviceList?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SBTManager.shared.writeToPeripheral(Data.init())
    }

    @IBOutlet weak var logView: UILabel!
    @IBOutlet weak var insertField: UITextField!
    @IBOutlet weak var list: UITableView!
    var array:[CBPeripheral] = [CBPeripheral]()
    override func viewDidLoad() {
        super.viewDidLoad()
        SBlueToothManager.shared.delegate = self
    }

    func blue_scanDataDeviceListOutput(_ list: [String : CBPeripheral]) {
        print(list)
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
    lazy var dList: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: screenW, height: 270), style: .plain)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        return table
    }()

}
