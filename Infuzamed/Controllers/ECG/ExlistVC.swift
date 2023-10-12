//
//  ExlistVC.swift
//  CheckMeDeviceIntegration
//
//  Created by apple on 10/25/21.
//

import Foundation
import UIKit
class ExlistVC: BaseViewController, VTProCommunicateDelegate {
    var listArray: [VTProEXHistory] = []
    @IBOutlet var tblView: UITableView!
    override func viewDidLoad() {
        tblView.tableFooterView = UIView(frame: CGRect.zero)
        VTProCommunicate.sharedInstance().delegate = self
        VTProCommunicate.sharedInstance().beginReadHistoryList()
        super.viewDidLoad()
    }

    func postCurrentReadProgress(_ progress: Double) {
        print(progress)
    }

    func postCurrentWriteProgress(_ progress: Double) {
        print(progress)
    }

    func writeSuccess(withData fileData: VTProFileToRead) {
        print(fileData.description)
    }

//
    func getInfoWithResultData(_ infoData: Data?) {
        print(infoData)
    }

    func realTimeCallBack(with object: VTProMiniObject) {
        print(object.pkgNum)
    }

    func currentState(ofPeripheral state: VTProState) {
        print(state)
    }

    func updatePeripheralRSSI(_ RSSI: NSNumber) {
        print(RSSI)
    }

    func serviceDeployed(_ completed: Bool) {
        print(completed)
    }

    func commonResponse(_ cmdType: VTProCmd, andResult result: VTProCommonResult) {
        print(result.rawValue)
    }

    func readComplete(withData fileData: VTProFileToRead) {
        if fileData.fileType == VTProFileTypeEXHistoryList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let arr = VTProFileParser.parseHeartCheckList(fileData.fileData as Data)!
                listArray = arr
                tblView.reloadData()
            } else {
                print("Error %ld", fileData.enLoadResult)
            }
        } else if fileData.fileType == VTProFileTypeEXHistoryDetail {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                VTProFileParser.parseECGDetail(withFileData: fileData.fileData as Data, callBack: { [weak self] header, ecgContent in
                    // Detail data
                    let ecgVC  = ECGViewCoontroller(egcProggresData: ecgContent as! [Double], hearRate: Int(header.hrResult))
                    self?.navigationController?.pushViewController(ecgVC, animated: true)
                    print("Heart rate is %d", header.hrResult)
                    self?.hideLoder()
                })
            } else {
                print("Detail Error %ld", fileData.enLoadResult)
                hideLoder()
            }
        }
    }
}

extension ExlistVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }

    static let tableViewIdentifier = "exListCell"

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewIdentifier = "exListCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: tableViewIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: tableViewIdentifier)
        }
        let model = listArray[indexPath.row]
        let dc = (model as AnyObject).value(forKey: "dtcDate") as? DateComponents
        cell?.textLabel?.text = String(format: "%04ld-%02ld-%02ld %02ld:%02ld:%02ld", Int(dc?.year ?? 0), Int(dc?.month ?? 0), Int(dc?.day ?? 0), Int(dc?.hour ?? 0), Int(dc?.minute ?? 0), Int(dc?.second ?? 0))
        return cell!
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ex = listArray[indexPath.row] as! VTProEXHistory
        VTProCommunicate.sharedInstance().beginReadHistoryDetail(ex.recordTime)
        showLoader()
    }
}
