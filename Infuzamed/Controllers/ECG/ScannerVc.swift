//
//  ScannerVc.swift
//  CheckMeDeviceIntegration
//
//  Created by apple on 10/14/21.
//

import Foundation
import UIKit
import VTProLib

class ScannerVc: UIViewController, VTBLEUtilsDelegate, VTProCommunicateDelegate {
    var periArray: NSMutableArray = .init(capacity: 10)
    @IBOutlet var tableViewDevice: UITableView!
    var vbleUtils = VTBLEUtils()

    override func viewDidLoad() {
        tableViewDevice.reloadData()
        VTBLEUtils.sharedInstance().delegate = self
        super.viewDidLoad()
        VTBLEUtils.sharedInstance().startScan()
        title = "Scanner"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(true)
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    func getViewControllerFromStoryboard() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ScannerVc")
        return viewController
    }

    // ble states
    func update(_ state: VTBLEState) {
        if state == .poweredOn {
            VTBLEUtils.sharedInstance().startScan()
        }
    }

    func didDiscover(_ device: VTDevice) {
        periArray.add(device)
        tableViewDevice.reloadData()
    }

    func didConnectedDevice(_ device: VTDevice) {
        VTProCommunicate.sharedInstance().peripheral = device.rawPeripheral
        VTProCommunicate.sharedInstance().delegate = self
    }

    func didDisconnectedDevice(_ device: VTDevice, andError error: Error) {
        showAlert(text: "No connected device")
    }
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: text, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default))
        present(alert, animated: true, completion: nil)
    }

    func serviceDeployed(_ completed: Bool) {
        performSegue(withIdentifier: "presentViewController", sender: nil)
    }
}

extension ScannerVc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScannerDeviceCell", for: indexPath) as! ScannerDeviceCell
//        if cell == nil {
//            cell = UITableViewCell(style: .value1, reuseIdentifier: "ScannerDeviceCell") as! ScannerDeviceCell
//        }
        let device = periArray[indexPath.row] as? VTDevice
        cell.deviceName?.text = device?.rawPeripheral.name
//        if let RSSI = device?.rssi {
//            cell.detailTextLabel?.text = "\(RSSI)"
//        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return periArray.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = periArray[indexPath.row] as? VTDevice
        VTBLEUtils.sharedInstance().stopScan()
        VTBLEUtils.sharedInstance().connect(to: device!)
    }
}
