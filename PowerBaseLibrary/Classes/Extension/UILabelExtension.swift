//
//  UILabelExtension.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 16/6/12.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

public extension UILabel {
    func textWithUnderline(text: String, color: UIColor) {
        let attrStr = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.strikethroughColor: color])

        attributedText = attrStr
    }

    /// 调整行间距
    func lineSpacingWithString(_ string: String, lineSpace: CGFloat, alignment: NSTextAlignment = .left, verticalGlyphForm: Int = -1) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStye = NSMutableParagraphStyle()

        // 调整行间距
        paragraphStye.lineSpacing = lineSpace

        // 对齐方式
        paragraphStye.alignment = alignment

        let rang = NSMakeRange(0, CFStringGetLength(string as CFString?))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStye, range: rang)

        // 垂直或者水平，value是 NSNumber，0表示水平，1垂直
        if verticalGlyphForm >= 0 {
            attributedString.addAttribute(NSAttributedString.Key.verticalGlyphForm, value: verticalGlyphForm, range: rang)
        }

        return attributedString
    }

    /// 调整带图行间距
    func lineSpacingWithImageString(_ string: String, lineSpace: CGFloat, alignment: NSTextAlignment = .left, image: UIImage, imageRect: CGRect, insertIndex: Int = 0, verticalGlyphForm: Int = -1) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStye = NSMutableParagraphStyle()

        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        textAttachment.bounds = imageRect

        if insertIndex < attributedString.length {
            attributedString.insert(NSAttributedString(attachment: textAttachment), at: insertIndex)

            if insertIndex + 1 < attributedString.length {
                attributedString.insert(NSAttributedString(string: "  "), at: insertIndex + 1)
            }
        } else {
            attributedString.insert(NSAttributedString(string: "  "), at: insertIndex)
            attributedString.insert(NSAttributedString(attachment: textAttachment), at: attributedString.length - 1)
        }

        // 调整行间距
        paragraphStye.lineSpacing = lineSpace
        
        // 对齐方式
        paragraphStye.alignment = alignment

        let rang = NSMakeRange(0, CFStringGetLength(string as CFString?))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStye, range: rang)

        // 垂直或者水平，value是 NSNumber，0表示水平，1垂直
        if verticalGlyphForm >= 0 {
            attributedString.addAttribute(NSAttributedString.Key.verticalGlyphForm, value: verticalGlyphForm, range: rang)
        }

        return attributedString
    }

    /// 文本尺寸
    func textSize(width: CGFloat) -> CGSize {
        if #available(iOS 10.0, *) {
            self.adjustsFontForContentSizeCategory = true
        } else {
            sizeToFit()
        }

//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 13.0
//
//        let dic = [NSAttributedString.Key.font: self.font, NSAttributedString.Key.paragraphStyle: paragraphStyle] as [NSAttributedString.Key : Any]
//
//        let tsize = (self.text as! NSString).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dic, context: nil).size

        _ = systemLayoutSizeFitting(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))

        let size = sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))

        return size
    }

    // 文字平铺label
    func textAlignmentLeftAndRight() {
        textAlignmentLeftAndRightWith(labelWidth: frame.width)
    }

    /**
     *  文字平铺label
     *
     *  @param labelWidth 宽度 （宽度一定要有富余，若果展示有问题请调大宽度）
     *
     */
    func textAlignmentLeftAndRightWith(labelWidth: CGFloat) {
        guard let text = self.text, text.count > 0 else {
            DEBUGLOG("text没有内容")
            return
        }

        let attributes = [NSAttributedString.Key.font: font]
        let options = unsafeBitCast(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue, to: NSStringDrawingOptions.self)

        let desStr: NSString = NSString(cString: text, encoding: String.Encoding.utf8.rawValue)!

        let size = desStr.boundingRect(with: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attributes as [NSAttributedString.Key: Any], context: nil)

        var length = text.count - 1

        let starIndex = text.index(text.startIndex, offsetBy: text.count - 1)
        let lastStr = text.suffix(from: starIndex)

        if (lastStr == ":") || (lastStr == "：") {
            length = text.count - 2
        }

        let maragin = Int((Float(labelWidth) - Float(size.width)) / Float(length))

        let number = NSNumber(value: maragin)

        let attribute = NSMutableAttributedString(string: text)

        attribute.addAttribute(NSAttributedString.Key.kern, value: number, range: NSRange(location: 0, length: length))

        attributedText = attribute
    }
}
