//
//  CollectionViewAlignLeftFlowViewLayout.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 2019/5/18.
//  Copyright © 2019 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

public class CollectionViewAlignLeftFlowViewLayout: UICollectionViewFlowLayout {
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // 1.获取系统计算好的attributes
        guard let systemAttribues = super.layoutAttributesForElements(in: rect) else {return nil}
        let maximumSpacing = self.minimumInteritemSpacing
        // 2. 遍历
        systemAttribues.enumerated().forEach({ (arguments) in
            let (offset, attribute) = arguments
            if offset == 0 {return}

            // 2.1 获取当前的attributes
            let previewLayoutAttributes = systemAttribues[offset - 1]
            let currentLayoutAttributes = attribute
            // 2.2 获取位置
            let previewX = previewLayoutAttributes.frame.maxX
            let previewY = previewLayoutAttributes.frame.maxY
            let currentY = currentLayoutAttributes.frame.maxY
            // 2.3 改变当前的frame
            var frame = currentLayoutAttributes.frame
            frame.origin.x = previewY == currentY ? previewX + maximumSpacing : 0 + self.sectionInset.left
            currentLayoutAttributes.frame = frame
            
        })
        return systemAttribues
    }
}
