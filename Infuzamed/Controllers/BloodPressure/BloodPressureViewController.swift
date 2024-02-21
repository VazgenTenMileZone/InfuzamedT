//
//  BloodPressureViewController.swift
//  Infuzamed
//
//  Created by Vazgen on 7/17/23.
//

import UIKit

class BloodPressureViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet var topContainerView: UIView!
    @IBOutlet var titleLabel: LinkedLabel!
    @IBOutlet var valueLabel: LinkedLabel!
    @IBOutlet var titlesStackView: UIStackView!
    @IBOutlet var pulseValue: UILabel!
    @IBOutlet var systolicPipesView: PipesView!
    @IBOutlet var diastolicPipesView: PipesView!
    @IBOutlet var pulsePipesView: PipesView!

    private var currentDevice: BTDeviceInfo?
    
    convenience init(device:  BTDeviceInfo) {
        self.init()
        currentDevice = device
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AHDevicePlugin.default()?.checkingBluetoothStatus(self)
        self.connectDevice()
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AHDevicePlugin.default().stopSearch()
        AHDevicePlugin.default().stopAutoConnect()
    }
}

// MARK: - Private
private extension BloodPressureViewController {
    func setupViews() {
        titleLabel.text = "Systolic / Diastolic"
        titleLabel.linkedTexts = [
            (text: "Systolic", attributes: [.foregroundColor: UIColor(hex: "519711")], action: {})
        ]

        topContainerView.layer.borderColor = UIColor(hex: "E6E6E6").cgColor
        topContainerView.layer.borderWidth = 1
        topContainerView.roundCorners(corners: .allCorners)
        titlesStackView.layer.borderColor = UIColor(hex: "E6E6E6").cgColor
        titlesStackView.layer.borderWidth = 1
        titlesStackView.roundCorners(corners: .allCorners)
    }



    private func connectDevice() {
        showLoader(color: .black)
        if !(AHDevicePlugin.default()!.isBluetoothPowerOn) {
            return
        }
        // check manager status
        if AHDevicePlugin.default()?.managerStatus == BTManagerState.syncing {
            // waiting for firmware upgrading
            return
        }
        else {
            // add target device
            AHDevicePlugin.default()?.addDevice(currentDevice)
            AHDevicePlugin.default()?.startAutoConnect(self)
        }
    }

    func showPressureData(data: AHBpmData) {
        valueLabel.text = String(format: "%d / %d", data.systolic, data.diastolic)
        valueLabel.linkedTexts = [
            (text: String(data.systolic), attributes: [.foregroundColor: UIColor(hex: "519711")], action: {})
        ]
        pulseValue.text = String(format: "%d bpm", data.pulse)
        let systolicColors = [UIColor(hex: "456F01"), UIColor(hex: "637402"), UIColor(hex: "DB8804"), UIColor(hex: "D62B04"), UIColor(hex: "BA0806")]
        systolicPipesView.configView(currentV: Int(data.systolic), minV: 80, maxV: 170, colors: systolicColors)
        diastolicPipesView.configView(currentV: Int(data.diastolic), minV: 0, maxV: 140, colors: systolicColors)
        pulsePipesView.configView(currentV: Int(data.pulse), minV: 0, maxV: 200, colors: [UIColor(hex: "A80C00"), UIColor(hex: "A80C00")])
    }

    func showErrorAlert(title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

extension BloodPressureViewController: AHBluetoothStatusDelegate {
    func systemDidBluetoothStatusChange(_ bleState: CBManagerState) {
        DispatchQueue.main.async {
            if bleState == .poweredOn {
                self.connectDevice()
            }
        }
    }
}

extension BloodPressureViewController: AHDeviceDataDelegate {
    func bleDevice(_ device: BTDeviceInfo!, didConnectStateChanged state: BTConnectState) {
        switch state {
        case .connected:
            connectDevice()
        case .disconnect:
            hideLoder()
        default:
            break
        }
    }

    func bleDevice(_ device: BTDeviceInfo!, didDataUpdateNotification obj: BTDeviceData!) {
        switch obj {
        case let data as AHBpmData:
            hideLoder()
            DispatchQueue.main.async {
                self.showPressureData(data: data)
            }
            sendDataToServer(data: data)
        case _ as AHBpmErrorData:
            hideLoder()
            DispatchQueue.main.async {
                self.showErrorAlert(title: "No Data", message: "", viewController: self)
            }

        default:
            break
        }
    }

    func sendDataToServer(data: AHBpmData) {
        guard let json = LoginManager.shared.retrieveTokenFromKeychain()?.jsonWithJWT() else { return }
        let uid = json["uid"] as? String ?? ""
        let params: [String: Any] = [
                                     "bloodPressure": String(format: "%d/%d", data.systolic, data.diastolic),
                                     "heartRate": String(format: "%d", data.pulse),
                                     "measurementTime": Date().dateToISO8601String(),
                                     "userId": uid]

        NetworkManager.post(urlString: "http://ec2-54-215-231-89.us-west-1.compute.amazonaws.com:8085/api/data/create", parameters: params)
    }
}

