//
//  ViewController.swift
//  NetworkReachability
//
//  Created by Xinyuan's on 2/28/18.
//  Copyright © 2018 Xinyuan Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        label.centerLayout(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        let constants: [UIView.LayoutPosition : CGFloat] = [.height : 50, .width : 300]
        label.autoLayout(constants: constants)
        label.text = "Started"
        Reachability.shared.customGloabalCallBack = { [weak self] (status : NetworkStatus) in
            self?.label.text = status.value()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.networkChanged(_:)), name: Notification.Name(rawValue: Reachability.networkChangeNotification), object: nil)
    }
    
    @objc func networkChanged(_ notification: Notification) {
        let info = notification.userInfo
        if let status = info?[Reachability.networkStatusUserInfoKey] as? NetworkStatus {
            DispatchQueue.main.async { [weak self] in
                self?.label.text = status.value()
            }
        }
    }
    
}

