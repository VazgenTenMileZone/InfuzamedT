//
//  UserListVc.swift
//  CheckMeDeviceIntegration
//
//  Created by apple on 10/25/21.
//

import Foundation
import UIKit
class UserListVc : UIViewController{
    var userArray : NSArray = []
    @IBOutlet weak var tbllist: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    func setUserArray(_ userArray: [NSArray]?) {
        self.userArray = userArray as! NSArray
    }
}
extension UserListVc : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ScannerDeviceCell", for: indexPath) as! ScannerDeviceCell
  
    let u = userArray[indexPath.row]
    if  type(of: u) == VTProUser.self {
        let user = u as? VTProUser
        let imagePath = Bundle.main.path(forResource: "VTProLibBundle", ofType: "bundle")
        let imageBundle = Bundle(path: imagePath ?? "")
        var image: UIImage? = nil
        if let iconID = user?.iconID {
            image = UIImage(contentsOfFile: imageBundle?.path(forResource: "ico\(iconID)", ofType: "png") ?? "")
        }
        cell.deviceName?.text = user?.userName
    }else{
        let xuser = u
        cell.deviceName?.text = (xuser as AnyObject).userName
    }
    return cell
   }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

