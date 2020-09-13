//
//  ImageViewExtension.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 16/3/6.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

import UIKit

public extension UIImageView {
    func defaultImageFrame() -> CGRect {
        if constraints.count > 0 {
            var width: CGFloat = 0.0
            var height: CGFloat = 0.0
            for temp in constraints {
                if temp.firstAttribute == .width {
                    width = temp.constant
                } else if temp.firstAttribute == .height {
                    height = temp.constant
                }
            }
            if width > 0 && height > 0 {
                return CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
            } else {
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
            }
        } else {
            return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
        }
    }

    func placeholderImage() -> UIImage {
        return UIImage.defaultImage(bounds)
    }

    func placeholderImage(_ size: CGSize) -> UIImage {
        return UIImage.defaultImage(CGRect(origin: CGPoint.zero, size: size))
    }

    func placeholderUserHeaderImage() -> UIImage? {
        return UIImage(named: "icon_guide_default_header")
    }

    func placeholderFemaleUserHeaderImage(_ imageName: String = "icon_female_default_avatar") -> UIImage? {
        return UIImage(named: imageName)
    }
    
    func placeholderMaleUserHeaderImage(_ imageName: String = "icon_male_default_avatar") -> UIImage? {
        return UIImage(named: imageName)
    }

    /// 设置圆角，iOS9之后UIButton设置圆角会触发离屏渲染，而UIImageView里png图片设置圆角不会触发离屏渲染了, 所以无性能问题
    func circleImage(showBorder: Bool = true, borderColor: UIColor = RGBA(230, g: 230, b: 230, a: 1), borderWidth: CGFloat = LINE_1PX) {
        if showBorder {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
        }

        layer.cornerRadius = bounds.size.width / 2
        layer.isOpaque = true
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = UIScreen.main.scale
        layer.masksToBounds = true
        tag = 999
    }
}
