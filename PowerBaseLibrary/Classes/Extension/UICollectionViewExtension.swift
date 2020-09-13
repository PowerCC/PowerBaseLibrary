//
//  UICollectionViewExtension.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 16/5/22.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

public extension UICollectionView {
    
	func aapl_indexPathsForElementsInRect(_ rect: CGRect) -> [IndexPath]? {
		let allLayoutAttributes = self.collectionViewLayout.layoutAttributesForElements(in: rect)
		if (allLayoutAttributes?.count == 0) { return nil }

		if allLayoutAttributes != nil {
			var indexPaths = [IndexPath]()

			for layoutAttributes in allLayoutAttributes! {
				let indexPath = layoutAttributes.indexPath
				indexPaths.append(indexPath)
			}

			return indexPaths
		}
		else {
			return nil
		}
	}

}
