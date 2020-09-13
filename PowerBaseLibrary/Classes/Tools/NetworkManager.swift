//
//  NetworkManager.swift
//  BaseLibrary
//
//  Created by 邹程 on 2019/9/2.
//

import Foundation
import Alamofire

public class NetworkManager {
    // shared instance
    public static let shared = NetworkManager()
    
    public let reachabilityManager = NetworkReachabilityManager(host: "hlapp.hunli.baihe.com")
    
    public func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in
            switch status {
            case .reachable(.ethernetOrWiFi):
                DEBUGLOG("The network is reachable over the WiFi connection")
                CONNECTION_TYPE = .ethernetOrWiFi
                NotificationCenter.default.post(name: Notification.Name(rawValue: N_APP_NETWORK_AVAILABLE), object: nil)
                
            case .reachable(.wwan):
                DEBUGLOG("The network is reachable over the WWAN connection")
                CONNECTION_TYPE = .wwan
                NotificationCenter.default.post(name: Notification.Name(rawValue: N_APP_NETWORK_AVAILABLE), object: nil)
                
            case .notReachable:
                DEBUGLOG("The network is not reachable")
                NotificationCenter.default.post(name: Notification.Name(rawValue: N_APP_NETWORK_UNAVAILABLE), object: nil)
                
            case .unknown:
                DEBUGLOG("It is unknown whether the network is reachable")
            }
        }
        
        if reachabilityManager?.isReachable == false {
            NotificationCenter.default.post(name: Notification.Name(rawValue: N_APP_NETWORK_UNAVAILABLE), object: nil)
        }
        
        // start listening
        reachabilityManager?.startListening()
    }
}
