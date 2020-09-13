//
//  ImageExtension.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 16/3/4.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

public extension UIImage {
    /// 颜色生成图片
    class func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage() // 防崩溃
    }

    class func defaultImage(_ bounds: CGRect) -> UIImage {
        let sacle = bounds.size.width == bounds.size.height ? bounds.size.width * (172.0 / 320.0) : bounds.size.width * (100.0 / 320.0)
        let value = min(sacle, bounds.size.width)
        return UIImage.scaleToSize(UIImage(named: "bg_default_image")!, size: CGSize(width: value, height: value))
    }

    class func scaleToSize(_ image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

//        let minValue = min(size.width, size.height) / 3

//        let x = (size.width - minValue) / 2
//        let y = (size.height - minValue) / 2

        image.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return scaledImage ?? UIImage() // 防崩溃
    }

    // scale为宽高比
    func subImageInTopWithScale(scale: CGFloat) -> UIImage {
        let baseSize = size
        let width: CGFloat = baseSize.width
        let height: CGFloat = width / scale
        let newRect = CGRect(x: 0, y: 0, width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(baseSize, false, 0.0)

        draw(in: newRect)

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return scaledImage ?? UIImage() // 防崩溃
    }

    func subImageInSubRect(frame: CGRect, superFrame: CGRect) -> UIImage {
        var resultImage: UIImage = self
        var resultRect = frame

        if let baseCGImage = self.cgImage {
//            // 获取图片比例
//            let scale = self.size.width/self.size.height

            // 图片真实的像素值
            let pixelWidth: CGFloat = CGFloat(baseCGImage.width)
            let pixelHeight: CGFloat = CGFloat(baseCGImage.height)

            // 计算frame值，使图片不会超过边界裁剪
            if resultRect.origin.x > superFrame.size.width {
                resultRect.origin.x = superFrame.size.width
            }

            if resultRect.origin.y > superFrame.size.height {
                resultRect.origin.y = superFrame.size.height
            }

            if resultRect.origin.x + resultRect.size.width > superFrame.size.width {
                resultRect.size.width = superFrame.size.width - resultRect.origin.x
            }

            if resultRect.origin.y + resultRect.size.height > superFrame.size.height {
                resultRect.size.height = superFrame.size.height - resultRect.origin.y
            }

            // 获取图片真实像素对应区域
            let pix_x = (resultRect.origin.x / size.width) * pixelWidth
            let pix_y = (resultRect.origin.y / size.height) * pixelHeight
            let pix_w = (resultRect.size.width / size.width) * pixelWidth
            let pix_h = (resultRect.size.height / size.height) * pixelHeight

            let resultPixFrame = CGRect(x: pix_x, y: pix_y, width: pix_w, height: pix_h)

            if let resultCGImage = baseCGImage.cropping(to: resultPixFrame) {
                resultImage = UIImage(cgImage: resultCGImage)
            }
        }

        return resultImage
    }

    /**
     *  获取图片主题颜色
     *  width: 取值的宽度
     *  height: 取值的高度
     *  return UIColor
     */

    func getImageMostColor(width: CGFloat = 0, height: CGFloat = 0) -> UIColor? {
        var imgWidth = size.width
        var imgHeight = size.height

        if width > 0 {
            imgWidth = width
        }

        if height > 0 {
            imgHeight = height
        }

        let bitmapByteCount = imgWidth * imgHeight * 4

        // 使用系统的颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // 根据位图大小，申请内存空间
        let bitmapData = malloc(Int(bitmapByteCount))
        defer { free(bitmapData) }
        // 创建一个位图
        let context = CGContext(data: bitmapData, width: Int(imgWidth), height: Int(imgHeight), bitsPerComponent: 8, bytesPerRow: Int(Int(imgWidth) * 4), space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        // 图片的rect
        let rect = CGRect(x: 0, y: 0, width: CGFloat(imgWidth), height: CGFloat(imgHeight))
        // 将图片画到位图中
        context?.draw(cgImage!, in: rect)
        // 获取位图数据
        let bitData = context?.data
        let data = unsafeBitCast(bitData, to: UnsafePointer<CUnsignedChar>.self)
        let cls = NSCountedSet(capacity: Int(imgWidth * imgHeight))

        for x in 0 ... Int(imgWidth) {
            for y in 0 ... Int(imgHeight) {
                let offSet = (y * Int(imgWidth) + x) * 4
                let r = (data + offSet).pointee
                let g = (data + offSet + 1).pointee
                let b = (data + offSet + 2).pointee
                let a = (data + offSet + 3).pointee
                if a > 0 {
                    if !(r == 255 && g == 255 && b == 255) {
                        cls.add([CGFloat(r), CGFloat(g), CGFloat(b), CGFloat(a)])
                    }
                }
            }
        }

        // 找到出现次数最多的颜色
        let enumerator = cls.objectEnumerator()
        var maxColor: Array<CGFloat>?
        var maxCount = 0
        while let curColor = enumerator.nextObject() {
            let tmpCount = cls.count(for: curColor)
            if tmpCount >= maxCount {
                maxCount = tmpCount
                maxColor = curColor as? Array<CGFloat>
            }
        }

        if maxColor?.count ?? 0 > 2 {
            return UIColor(red: maxColor![0] / 255, green: maxColor![1] / 255, blue: maxColor![2] / 255, alpha: maxColor![3] / 255)
        } else {
            return nil
        }
    }
}
