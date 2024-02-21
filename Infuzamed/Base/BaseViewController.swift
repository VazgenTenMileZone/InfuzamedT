//
//  BaseViewController.swift
//  Infuzamed
//
//  Created by Vazgen on 7/18/23.
//

import UIKit

class BaseViewController: UIViewController {
    //MARK: - Properites
    private var activityIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        createIndicator()
    }
    
    func createIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator!.center = view.center
        view.addSubview(activityIndicator!)
    }
    
    func showLoader(color: UIColor = .white) {
        activityIndicator?.color = color
        DispatchQueue.main.async {
            self.activityIndicator!.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
        
    }
    
    func hideLoder() {
        DispatchQueue.main.async {
            self.activityIndicator!.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
}
