//
//  Reachability.swift
//  NetworkReachability
//
//  Created by Xinyuan's on 2/28/18.
//  Copyright © 2018 Xinyuan Wang. All rights reserved.
//

import Foundation
import SystemConfiguration
import CoreTelephony

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

class Reachability: NSObject {
    
    //MARK: Private getters
    private var currentSCNetworkFlags: SCNetworkReachabilityFlags? {
        get {
            guard let reach = reachability else { return nil }
            var flags = SCNetworkReachabilityFlags()
            guard SCNetworkReachabilityGetFlags(reach, &flags) else { return nil }
            return flags
        }
    }
    //MARK: Public getters
    var networkStatus: NetworkStatus {
        get {
            guard let flags = currentSCNetworkFlags else { return .unknown }
            return NetworkStatus(flag: flags)
        }
    }
    
    //MARK: Class instances
    static let networkIdentifier = "alex.learning.Reachability.identifier"
    static let networkChangeNotification = "alex.learning.Reachability.networkChangeNotification"
    static let networkStatusUserInfoKey = "alex.learning.Reachability.networkStatus"
    
    static let shared: Reachability = {
        var addr = sockaddr_in()
        addr.sin_len = UInt8(MemoryLayout<sockaddr_in6>.size)
        addr.sin_family = sa_family_t(AF_INET)
        return Reachability(addr: addr)
    }()
    
    //MARK: Private instances
    private let queue = DispatchQueue(label: Reachability.networkIdentifier, qos: .utility, attributes: .concurrent, autoreleaseFrequency: .workItem)
    
    private static let reachabilityCallback: SCNetworkReachabilityCallBack = { (reach : SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) -> Void in
        let newStatus = NetworkStatus(flag: flags)
        if let info = info {
            let reach = Unmanaged<Reachability>.fromOpaque(info).takeUnretainedValue()
        }
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(Reachability.networkChangeNotification), object: nil, userInfo: [Reachability.networkStatusUserInfoKey : newStatus])
        }
    }
    
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
        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = Unmanaged<Reachability>.passUnretained(self).toOpaque()
        SCNetworkReachabilitySetCallback(reach, Reachability.reachabilityCallback, &context)
        SCNetworkReachabilitySetDispatchQueue(reach, self.queue)
        SCNetworkReachabilityScheduleWithRunLoop(reach, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
    
    func stopMonitor() {
        guard let reach = self.reachability else { return }
        SCNetworkReachabilityUnscheduleFromRunLoop(reach, CFRunLoopGetMain(), CFRunLoopMode.commonModes.rawValue)
    }
}
//MARK: SIM card Related
extension Reachability {
    var isSIMAvailable: Bool {
        get {
            let celluarNetwork = CTTelephonyNetworkInfo()
            guard let carrier = celluarNetwork.subscriberCellularProvider else { return false }
            return carrier.mobileNetworkCode != nil
        }
    }
}
