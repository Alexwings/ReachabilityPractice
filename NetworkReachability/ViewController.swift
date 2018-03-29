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
    let cellularLable = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        label.textAlignment = .center
        label.layout(toCenterX: (view.centerXAnchor, 0), centerY: (view.centerYAnchor, 0))
        _ = label.dimensionLayout(constant: 50, position: .height)
        _ = label.dimensionLayout(constant: 300, position: .width)
        label.text = "Started"
        label.backgroundColor = .blue
        
        view.addSubview(cellularLable)
        cellularLable.attachEdgeTo(top: (label.bottomAnchor, 20), leading: (label.leadingAnchor, 0), trailing: (label.trailingAnchor, 0))
        _ = cellularLable.dimensionLayout(constant: 50, position: .height)
        cellularLable.titleLabel?.text = "\(Reachability.shared.isSIMAvailable)"
        cellularLable.backgroundColor = .yellow
        
        cellularLable.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.networkChanged(_:)), name: Notification.Name(rawValue: Reachability.networkChangeNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        label.text = Reachability.shared.networkStatus.value()
        cellularLable.setTitle("\(Reachability.shared.isSIMAvailable)", for: .normal)
    }
    
    @objc func networkChanged(_ notification: Notification) {
        let info = notification.userInfo
        if let status = info?[Reachability.networkStatusUserInfoKey] as? NetworkStatus {
            DispatchQueue.main.async { [weak self] in
                self?.label.text = status.value()
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        cellularLable.setTitle("\(Reachability.shared.isSIMAvailable)", for: .normal)
    }
    
}

