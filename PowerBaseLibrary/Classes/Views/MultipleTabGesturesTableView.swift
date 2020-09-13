//
//  MultipleTabGesturesTableView.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 2018/9/6.
//  Copyright © 2018年 Baihe Network Co., LTD. All rights reserved.
//

import UIKit

public class MultipleTabGesturesTableView: RefreshTableView, UIGestureRecognizerDelegate {
    
    public weak var limitView1: UIView?
    public weak var limitView2: UIView?
    public weak var limitView3: UIView?
    
    // MARK: - GestureRefreshTableViewDelegate Methods
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if otherGestureRecognizer.isKind(of: RCTTouchHandler.self) {
//            return false
//        }
        
        if let limitView = self.limitView1 {
            let touchPoint = gestureRecognizer.location(in: limitView)
            if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) == true {
//                DEBUGLOG("\n limitView1 \(touchPoint)\n")
                if limitView.bounds.contains(touchPoint) {
                    return false
                }
            }
        }
        
        if let limitView = self.limitView2 {
            let touchPoint = gestureRecognizer.location(in: limitView)
            if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) == true {
                if limitView.bounds.contains(touchPoint) {
                    return false
                }
            }
        }
        
        if let limitView = self.limitView3 {
//            let touchPoint = gestureRecognizer.location(in: limitView)
            if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) == true {
                if let pan = gestureRecognizer as? UIPanGestureRecognizer {
                    let point = pan.translation(in: limitView)
                    if abs(point.x) > abs(point.y) {
                        return false
                    }
                }
            }
        }
        
        return true
    }
}
