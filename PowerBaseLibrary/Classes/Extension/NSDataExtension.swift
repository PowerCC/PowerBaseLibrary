//
//  NSDataExtension.swift
//  BaiheWeddingApp
//
//  Created by 实 程 on 16/5/4.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

public extension Data {
    func writeFileToPath(_ path: String, name: String) -> (result: Bool, fullPath: String) {
        let filePath = path.stringByAppendingPathComponent(name)
        let result = (try? write(to: URL(fileURLWithPath: filePath), options: [.atomic])) != nil
        return (result, filePath)
    }
}
