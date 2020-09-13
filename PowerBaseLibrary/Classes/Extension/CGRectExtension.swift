//
//  CGRectExtension.swift
//  BaiheWeddingApp
//
//  Created by 实 程 on 16/4/25.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

public extension CGRect {
    func scale(_ scale: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x * scale, y: self.origin.y * scale , width: self.size.width * scale, height: self.size.height * scale)
    }
}
