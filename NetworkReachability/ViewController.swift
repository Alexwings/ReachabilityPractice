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
    let previousLable = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        label.textAlignment = .center
        label.layout(toCenterX: (view.centerXAnchor, 0), centerY: (view.centerYAnchor, 0))
        _ = label.dimensionLayout(constant: 50, position: .height)
        _ = label.dimensionLayout(constant: 300, position: .width)
        label.text = "Started"
        label.backgroundColor = .blue
        
        view.addSubview(previousLable)
        previousLable.textAlignment = .center
        previousLable.attachEdgeTo(top: (label.bottomAnchor, 20), leading: (label.leadingAnchor, 0), trailing: (label.trailingAnchor, 0))
        _ = previousLable.dimensionLayout(constant: 50, position: .height)
        previousLable.text = "previous"
        previousLable.backgroundColor = .yellow
//        Reachability.shared.customGlobalCallBack = { [weak self] (status : NetworkStatus) in
//            DispatchQueue.main.async {
//                self?.label.text = status.value()
//            }
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.networkChanged(_:)), name: Notification.Name(rawValue: Reachability.networkChangeNotification), object: nil)
    }
    
    @objc func networkChanged(_ notification: Notification) {
        let info = notification.userInfo
        if let status = info?[Reachability.networkStatusUserInfoKey] as? NetworkStatus {
            DispatchQueue.main.async { [weak self] in
                self?.previousLable.text = self?.label.text
                self?.label.text = status.value()
            }
        }
    }
    
}

