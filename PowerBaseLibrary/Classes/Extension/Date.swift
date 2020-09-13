//
//  Date.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 2018/7/12.
//  Copyright © 2018年 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

public extension Date {
    func daysBetweenDate(toDate: Date) -> Array<Int> {
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self, to: toDate)
        return [components.day ?? 0, components.hour ?? 0, components.minute ?? 0, components.second ?? 0]
    }
}
