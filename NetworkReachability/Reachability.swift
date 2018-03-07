//
//  Reachability.swift
//  NetworkReachability
//
//  Created by Xinyuan's on 2/28/18.
//  Copyright © 2018 Xinyuan Wang. All rights reserved.
//

import Foundation
import SystemConfiguration

enum NetworkStatus: Int {
    case unknown, wwan, wifi, notReachable
    
    init(flag: SCNetworkReachabilityFlags) {
        let reachable = flag.contains(.reachable)
        let needConnection = flag.contains(.connectionRequired)
        let connectAutomaticly = (flag.contains(.connectionOnDemand) || flag.contains(.connectionOnTraffic) || flag.contains(.connectionAutomatic)) && !flag.contains(.interventionRequired)
        let wwan = flag.contains(.isWWAN)
        guard reachable && (!needConnection || connectAutomaticly) else {
            self = .notReachable
            return
        }
        self = wwan ? .wwan : .wifi
    }
    
    func value() -> String {
        switch self {
        case .wwan:
            return "WWAN"
        case .wifi:
            return "WIFI"
        case .notReachable:
            return "Not Reachable"
        default:
            return "Not Ready"
        }
    }
}

/*
 process:
 
 */

class Reachability: NSObject {
    var networkStatus: NetworkStatus = .unknown
    var customGloabalCallBack: NetworkStatusChangedCallback?
    
    typealias NetworkStatusChangedCallback = (NetworkStatus) -> Void
    static let networkChangeNotification = "alex.learning.Reachability.networkChangeNotification"
    static let networkStatusUserInfoKey = "alex.learning.Reachability.networkStatus"
    
    private static let reachabilityCallback: SCNetworkReachabilityCallBack = { (reach : SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) -> Void in
        let newStatus = NetworkStatus(flag: flags)
        if let userCallback = info?.load(as: Reachability.NetworkStatusChangedCallback.self) {
            userCallback(newStatus)
        }
        DispatchQueue.global(qos: .background).async {
            NotificationCenter.default.post(name: Notification.Name(Reachability.networkChangeNotification), object: nil, userInfo: [Reachability.networkStatusUserInfoKey : newStatus])
        }
    }
    static let shared: Reachability = {
        var addr = sockaddr_in()
        addr.sin_len = UInt8(MemoryLayout<sockaddr_in6>.size)
        addr.sin_family = sa_family_t(AF_INET)
        return Reachability(addr: addr)
        
    }()
    
    private var reachability: SCNetworkReachability?
    init(reachability reach: SCNetworkReachability?) {
        reachability = reach
        super.init()
    }
    
    convenience init(domain: String) {
        let reachability: SCNetworkReachability? = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, domain)
        self.init(reachability: reachability)
    }
    convenience init(addr: sockaddr_in) {
        var address = addr
        let reachability = withUnsafePointer(to: &address, {
            SCNetworkReachabilityCreateWithAddress(nil, $0.withMemoryRebound(to: sockaddr.self, capacity: 1, {$0}))
        })
        self.init(reachability: reachability)
    }
    deinit {
        stopMonitor()
        self.reachability = nil
    }
}
//MARK: public methods
extension Reachability {
    func startMonitor() {
        stopMonitor()
        guard let reach = self.reachability else { return }
        var callBack: NetworkStatusChangedCallback = { [weak self](status: NetworkStatus) in
            DispatchQueue.main.async {
                self?.networkStatus = status
                self?.customGloabalCallBack?(status)
            }
        }
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = 
        SCNetworkReachabilitySetCallback(reach, Reachability.reachabilityCallback, &context)
        SCNetworkReachabilityScheduleWithRunLoop(reach, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
    
    func stopMonitor() {
        guard let reach = self.reachability else { return }
        SCNetworkReachabilityUnscheduleFromRunLoop(reach, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
}
