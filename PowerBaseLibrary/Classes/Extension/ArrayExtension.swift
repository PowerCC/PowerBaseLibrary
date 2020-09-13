//
//  ArrayExtension.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 2018/12/10.
//  Copyright © 2018 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

public extension Array {
    /// 数组安全索引取值
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
