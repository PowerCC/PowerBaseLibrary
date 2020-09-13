//
//  DispatchQueueExtension.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 2018/12/10.
//  Copyright © 2018 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    private static var _onceTracker = [String]()
    class func once(token: String, block: () -> ()) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
    
    func async(block: @escaping ()->()) {
        self.async(execute: block)
    }
    
    func after(time: DispatchTime, block: @escaping ()->()) {
        self.asyncAfter(deadline: time, execute: block)
    }
}
