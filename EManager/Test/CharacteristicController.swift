//
//  CharacteristicController.swift
//  EManager
//
//  Created by EX DOLL on 2019/3/4.
//  Copyright © 2019 EX DOLL. All rights reserved.
//

import UIKit

class CharacteristicController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
        }
        cell?.textLabel?.text = "\(SBlueToothManager.shared.peripheralsList[indexPath.row].name ?? "No name")"
        cell?.detailTextLabel?.text = "\(SBlueToothManager.shared.peripheralsList[indexPath.row].identifier)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SBlueToothManager.shared.connectDeviceWithPeripheral(indexPath.row)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    lazy var dList: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: screenW, height: 270), style: .plain)
        table.delegate = self
        table.dataSource = self
        //        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(table)
        return table
    }()
}
