//
//  ECGViewCoontroller.swift
//  Infuzamed
//
//  Created by Vazgen on 10/7/23.
//

import UIKit

final class ECGViewCoontroller: UIViewController {
    
    var graphView: ScrollableGraphView?
    var egcProggresData: [Double] = []
    var heartRate: Int = 0
    var selectedEcgDate = ""
    var linePlot = LinePlot(identifier: "line") // Identifier should be unique for each plot.
    var referenceLines = ReferenceLines()

    convenience init(egcProggresData:[Double], hearRate: Int, selectedEcgDate: String) {
        self.init()
        self.egcProggresData = egcProggresData
        self.heartRate = hearRate
        self.selectedEcgDate = selectedEcgDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphView = ScrollableGraphView(frame: self.view.bounds, dataSource: self)
        graphView?.rangeMax = 2
        graphView?.leftmostPointPadding = 16
        graphView?.rightmostPointPadding = 16
        graphView?.dataPointSpacing = 1
        graphView?.shouldAnimateOnStartup = false
        graphView?.rangeMin = -2
        graphView?.addPlot(plot: linePlot)
        graphView?.addReferenceLines(referenceLines: referenceLines)
        self.view.addSubview(graphView!)
        graphView?.pinEdgesToSuperView()
        sendDataToServer()
    }
}

private extension ECGViewCoontroller {
    func sendDataToServer() {
        guard let json = LoginManager.shared.retrieveTokenFromKeychain()?.jsonWithJWT() else { return }
        let uid = json["uid"] as? String ?? ""
        let params: [String: Any] = [
                                     "ekgData": egcProggresData,
                                     "heartRate": String(format: "%d", self.heartRate),
                                     "userId": uid,
                                     "createdAt": selectedEcgDate]
        NetworkManager.post(urlString: "http://ec2-54-215-231-89.us-west-1.compute.amazonaws.com:8085/api/data/create", parameters: params)
    }
}


extension ECGViewCoontroller: ScrollableGraphViewDataSource {

    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
           case "line":
            return egcProggresData[pointIndex]
           default:
               return 0
           }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return ""
    }
    
    
    func numberOfPoints() -> Int {
        return egcProggresData.count
    }
    
}
