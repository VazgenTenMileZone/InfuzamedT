//
//  DeviceListViewController.swift
//  Infuzamed
//
//  Created by Vazgen Hovakimyan on 21.02.24.
//

import UIKit

final class DeviceListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var devices: [BTDeviceInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "DeviceListTableViewCell", bundle: nil), forCellReuseIdentifier: "DeviceListTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        startScanning()
    }

    func startScanning() {
        let filter = BTScanFilter()
        filter.scanTypes = [BTDeviceType.bloodPressureMeter.rawValue]
        AHDevicePlugin.default().searchDevice(filter) { [weak self] device in
            if let device {
                DispatchQueue.main.async {
                    if device.deviceName != nil {
                        self?.devices.append(device)
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension DeviceListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        devices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceListTableViewCell", for: indexPath) as! DeviceListTableViewCell
        cell.title.text = devices[indexPath.row].deviceName ?? ""
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = devices[indexPath.row]
        navigationController?.pushViewController(BloodPressureViewController(device: device), animated: true)
    }
}
