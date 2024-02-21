//
//  MenuList.swift
//  CheckMeDeviceIntegration
//
//  Created by apple on 10/22/21.
//
class NameEventModel: NSObject {
    var title: String?
    var event = 0

    init(title: String?, event: Int) {
        self.title = title
        self.event = event
        super.init()
    }
}

import Foundation
import UIKit
import VTProLib

class MenuList: UIViewController, VTProCommunicateDelegate {
    @IBOutlet var miniDescLab: UILabel!
    @IBOutlet var tableView: UITableView!
    var funcArray = [NameEventModel]()
    var state: VTProState?
    var currNEModel: NameEventModel?
    var isInitialRequest = false
    var isDomesticCheckme = false
    var KDomesticCodes = ["10220002", "10220003"]
    var info: VTProInfo?
    var userList: [VTProUser]?
    var xuserList: [VTProXuser]?
    var getInfo_ = "Get info"
    var syncTime_ = "Sync time"
    var readUserList_ = "Read UserList"
    var readDlc_ = "Daily Check"
    var readEcg_ = "ECG Recorder"
    var readOxi_ = "Pulse Oximeter"
    var readBP_ = "Blood Pressure"
    var readBG_ = "Blood Glucose"
    var readTM_ = "Thermometer"
    var readSlm_ = "Sleep Monitor"
    var readPed_ = "Pedometer"
    var readXuserList_ = "Read XuserList"
    var readQC_ = "Quick check"
    var readHC_ = "HeartCheck"

    override func viewDidLoad() {
        super.viewDidLoad()
        state = VTProStateSyncData
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        if !VTProCommunicate.sharedInstance().peripheral.name!.hasPrefix("Checkme") {
            initFuncArray()
        }
        VTProCommunicate.sharedInstance().delegate = self
        VTProCommunicate.sharedInstance().beginPing()
        isInitialRequest = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            VTProCommunicate.sharedInstance().beginGetInfo()
        }

        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        VTProCommunicate.sharedInstance().delegate = self
    }

    func initFuncArray() {
        if funcArray != nil, funcArray.count > 0 {
            return
        }

        if VTProCommunicate.sharedInstance().peripheral.name!.hasPrefix("Checkme"), KDomesticCodes.contains(info?.branchCode ?? "") {
            title = "menu"
            isDomesticCheckme = true
            getInfo_ = "Get device information"
            syncTime_ = "Sync time"
            readEcg_ = "ECG"
            readOxi_ = "Finger pulse"
            readBP_ = "Blood pressure"
            readBG_ = "blood sugar"
            readTM_ = "body temperature"
            readQC_ = "One-key physical examination"
            readXuserList_ = "Read user list"
        }

        let getInfoModel = NameEventModel(title: getInfo_, event: 0)
        let syncTimeModel = NameEventModel(title: syncTime_, event: 1)
        let readUserListModel = NameEventModel(title: readUserList_, event: 2)
        print(readUserListModel)
        let readDlcModel = NameEventModel(title: readDlc_, event: 3)
        let readEcgModel = NameEventModel(title: readEcg_, event: 4)
        let readOxiModel = NameEventModel(title: readOxi_, event: 5)
        let readBPModel = NameEventModel(title: readBP_, event: 6)
        let readBGModel = NameEventModel(title: readBG_, event: 7)
        let readTMModel = NameEventModel(title: readTM_, event: 8)
        let readSlmModel = NameEventModel(title: readSlm_, event: 9)
        let readPedModel = NameEventModel(title: readPed_, event: 10)
        let readXuserListModel = NameEventModel(title: readXuserList_, event: 11)
        let readQCModel = NameEventModel(title: readQC_, event: 12)
        let readHCModel = NameEventModel(title: readHC_, event: 13)

        if VTProCommunicate.sharedInstance().peripheral.name!.hasPrefix("Checkme") {
            if isDomesticCheckme {
                // Domestic version
                funcArray = [
                    getInfoModel,
                    syncTimeModel,
                    readEcgModel,
                    readOxiModel,
                    readBPModel,
                    readBGModel,
                    readTMModel,
                    readQCModel,
                    readXuserListModel
                ]
                return
            }

            funcArray = [
                getInfoModel,
                syncTimeModel,
                readUserListModel,
                readDlcModel,
                readEcgModel,
                readOxiModel,
                readBPModel,
                readBGModel,
                readTMModel,
                readSlmModel,
                readPedModel
            ]
        } else {
            funcArray = [getInfoModel, syncTimeModel, readHCModel]
        }
    }

    @IBAction func getInformation(_ sender: AnyObject?) {
        if state == VTProStateMinimoniter {
            return
        }
        VTProCommunicate.sharedInstance().beginGetInfo()
    }

    @IBAction func syncTime(_ sender: AnyObject?) {
        if state == VTProStateMinimoniter {
            return
        }
        VTProCommunicate.sharedInstance().beginSyncTime(Date())
    }

    @IBAction func readUserList(_ sender: AnyObject?) {
        if state == VTProStateMinimoniter {
            return
        }
        VTProCommunicate.sharedInstance().beginReadFileList(with: nil, fileType: VTProFileTypeUserList)
    }

    func readXuserLists() {
        if state == VTProStateMinimoniter {
            return
        }
        VTProCommunicate.sharedInstance().beginReadFileList(with: nil, fileType: VTProFileTypeXuserList)
    }

    func getInfoWithResultData(_ infoData: Data?) {
        if isInitialRequest, infoData != nil {
            isInitialRequest = false
            info = VTProFileParser.parseProInfo(with: infoData)
            initFuncArray()
            tableView.reloadData()
            return
        }

        if infoData != nil {
            let info = VTProFileParser.parseProInfo(with: infoData)
            self.info = info!
            performSegue(withIdentifier: "gotoVTInfoViewController", sender: nil)
        } else {}
    }

    func commonResponse(_ cmdType: VTProCmd, andResult result: VTProCommonResult) {
        if cmdType == VTProCmdSyncTime {
            var titleStr = "Sync time success"
            var actionStr = "OK"
            if isDomesticCheckme {
                titleStr = "同步时间成功"
                actionStr = "知道了"
            }
            if result == VTProCommonResultSuccess {
                let alert = UIAlertController(
                    title: titleStr,
                    message: nil,
                    preferredStyle: .alert)
                let okAction = UIAlertAction(title: actionStr, style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true)

            } else {}
        }
    }

    func readComplete(withData fileData: VTProFileToRead) {
        if fileData.fileType == VTProFileTypeUserList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let userList = VTProFileParser.parseUserList_(withFileData: fileData.fileData as Data)
                self.userList = userList!
                if currNEModel!.event == 2 {
                    performSegue(withIdentifier: "gotoVTUserListViewController", sender: nil)
                } else {
                    performSegue(withIdentifier: "gotoVTDataListViewController", sender: nil)
                }
            }
        }
        if fileData.fileType == VTProFileTypeXuserList {
            if fileData.enLoadResult == VTProFileLoadResultSuccess {
                let userList = VTProFileParser.parseUserList_(withFileData: fileData.fileData as Data)
                self.userList = userList!
                if currNEModel!.event == 2 {
                    performSegue(withIdentifier: "gotoVTUserListViewController", sender: nil)
                } else {
                    performSegue(withIdentifier: "gotoVTDataListViewController", sender: nil)
                }
            }
        }
    }

    func realTimeCallBack(with object: VTProMiniObject) {
        if state == VTProStateMinimoniter {
            miniDescLab.text = object.description
        }
    }

    func currentState(ofPeripheral state: VTProState) {
        if state == VTProStateMinimoniter {
            miniDescLab.isHidden = false
            tableView.isHidden = true
        } else {
            miniDescLab.isHidden = true
            tableView.isHidden = false
        }
        self.state = state
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoVTInfoViewController" {
            let vc = segue.destination as? DeviceInformationVc
            vc?.proInfo = info
            vc?.title = isDomesticCheckme ? "Device Information" : "Device information"
        } else if segue.identifier == "gotoVTUserListViewController" {
            let vc = segue.destination as? UserListVc
            if currNEModel!.event == 2 {
                vc?.userArray = userList! as NSArray
            } else {
                vc?.userArray = xuserList! as NSArray
            }
            vc?.title = isDomesticCheckme ? "User List" : "User List"
        } else if segue.identifier == "gotoVTDataListViewController" {
            let vc = segue.destination as? DataListView
            vc?.dataType = currNEModel!.event
            if userList != nil {
                vc?.userList = userList as! NSArray
            }
            if currNEModel!.event == 12 {
                vc?.userList = xuserList as! NSArray
            }
            vc?.title = currNEModel?.title
        }
    }
}

extension MenuList: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return funcArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScannerDeviceCell", for: indexPath) as! ScannerDeviceCell
        cell.deviceName?.text = funcArray[indexPath.row].title

        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currNEModel = funcArray[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! ScannerDeviceCell
        let title = cell.deviceName?.text
        if title == getInfo_ {
            getInformation(nil)
        }
        if title == syncTime_ {
            syncTime(nil)
        }
        if title == readUserList_ {
            readUserList(nil)
        }
        if (title == readDlc_) || (title == readBP_) || (title == readBG_) || (title == readPed_) {
            if userList != nil {
                performSegue(withIdentifier: "gotoVTDataListViewController", sender: nil)
            } else {
                readUserList(nil)
            }
        }
        if (title == readEcg_) || (title == readOxi_) || (title == readTM_) || (title == readSlm_) {
            userList = nil
            xuserList = nil
            performSegue(withIdentifier: "gotoVTDataListViewController", sender: nil)
        }
        if title == readXuserList_ {
            readXuserLists()
        }
        if title == readQC_ {
            if xuserList != nil {
                performSegue(withIdentifier: "gotoVTDataListViewController", sender: nil)
            } else {
                readXuserLists()
            }
        }
        if title == readHC_ {
            performSegue(withIdentifier: "gotoVTEXListViewController", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
