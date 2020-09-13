//
//  NSLayoutConstraintExtension.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 2019/4/25.
//  Copyright © 2019 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

public extension NSLayoutConstraint {
    func setMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])

        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)

        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier

        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
