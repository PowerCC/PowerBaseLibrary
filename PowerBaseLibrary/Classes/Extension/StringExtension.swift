//
//  StringExtension.swift
//  BaiheWeddingApp
//
//  Created by Cloud on 16/3/9.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

public extension String {
    
    /// 大于10000转换为1.0w
    static func numToCustomString(_ value: String) -> String {
        if value.count == 0 {
            return value
        }
        
        var num = Float(value) ?? 0
        if num >= 10000 {
            num = num / 10000
            return "\(String(format: "%.1f", num))w"
        }
        else {
            return value
        }
    }

	/// 固定宽度内获取高度 ，实际使用过程中cell存在 1 pix 误差，请自行 +1 微调
	func stringHeight(_ inWidth: CGFloat, font: UIFont) -> CGFloat {
        if self.count == 0 {
            return 0
        }
		let attributes = [NSAttributedString.Key.font: font]
		let options = unsafeBitCast(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue, to: NSStringDrawingOptions.self)
		let desStr: NSString = NSString(cString: self, encoding: String.Encoding.utf8.rawValue)!
		let rect = desStr.boundingRect(with: CGSize(width: inWidth, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: attributes, context: nil)
		return rect.height
	}

	/// 固定高度内获取宽度
	func stringWidth(_ inHeight: CGFloat, font: UIFont) -> CGFloat {
        if self.count == 0 {
            return 0
        }
		let attributes = [NSAttributedString.Key.font: font]
		let options = unsafeBitCast(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue, to: NSStringDrawingOptions.self)
		let desStr: NSString = NSString(cString: self, encoding: String.Encoding.utf8.rawValue)!
		let rect = desStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: inHeight), options: options, attributes: attributes, context: nil)
		return rect.width
	}

	func stringByAppendingPathComponent(_ str: String) -> String {
		let sourceString = NSString(cString: self, encoding: String.Encoding.utf8.rawValue) ?? NSString()
		return sourceString.appendingPathComponent(str)
	}

	func pathLastComponent() -> String {
		let sourceString = NSString(cString: self, encoding: String.Encoding.utf8.rawValue) ?? NSString()
		return sourceString.lastPathComponent
	}

	/// 获取ASCII和Unicode混合文本长度
	func unicodeLength() -> Int {
		let nsString: NSString = self as NSString

		var asciiLength: Int = 0

		if self.count > 0 {
			let length = self.count - 1

			for index in 0 ... length {

				let uc: unichar = nsString.character(at: index)

				let uc32 = Int32(uc)

				asciiLength += (isascii(uc32) == 1) ? 1 : 2;
			}
		}

		return asciiLength
	}

	func unicodeStringToIndex(_ end: Int) -> String {
		var result = ""

		let nsString: NSString = self as NSString

		var asciiLength: Int = 0

		if self.count > 0 {
			let length = self.count - 1

			for index in 0 ... length {

				let uc: unichar = nsString.character(at: index)

				let uc32 = Int32(uc)

				asciiLength += (isascii(uc32) == 1) ? 1 : 2;

				if asciiLength > end {
					break
				}
                
				result = String(self[..<self.index(self.startIndex, offsetBy: index + 1)])
			}
		}

		return result
	}

	/// 换行符处理
	func linebreakReplace() -> String {
		return self.replacingOccurrences(of: "\\n", with: "\n")
	}
    
    /// 获取当前时间戳
    
    func getCurrentDateString() -> String {
        let date = NSDate.init(timeIntervalSinceNow: 0)
        let timeInterval = date.timeIntervalSince1970*1000
        let str = String(Int(timeInterval))
        return str
    }

    // 判断字符串是否包含另一个字符串
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }

    // 判断图片路径是否是默认图片
    func imagePictureIsDefault() -> Bool{
        var isDefault = false
        
        if self.count > 0 {
            let splitedArray = self.components(separatedBy: "/")
            let lastString = splitedArray.last ?? ""
            if lastString.contains(find: "_default") || lastString.contains(find: "_DEFAULT") {
                isDefault = true
            }
        }
        
        return isDefault
    }
    
    /**
     *  计算富文本字体高度
     *
     *  @param lineSpeace 行高
     *  @param font       字体
     *  @param maxWidth   字体所占宽度
     *
     *  @return 富文本高度
     */
    func getSpaceLabelHeightWith(lineSpeace: CGFloat, font: UIFont, maxWidth: CGFloat) -> CGFloat {
        let paraStyle = NSMutableParagraphStyle()
        
        paraStyle.lineSpacing = lineSpeace
        
        let dic = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle : paraStyle]
        
        let nsSubs: NSString = NSString(cString: self, encoding: String.Encoding.utf8.rawValue)!
        
        let size = nsSubs.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dic, context: nil).size
        
        return size.height
    }

    /**
     *  计算富文本字体宽度
     *
     *  @param lineSpeace   行高
     *  @param font         字体
     *  @param maxHeight    字体所占高度
     *
     *  @return 富文本高度
     */
    func getSpaceLabelWidthWith(lineSpeace: CGFloat, font: UIFont, maxHeight: CGFloat) -> CGFloat {
        let paraStyle = NSMutableParagraphStyle()
        
        paraStyle.lineSpacing = lineSpeace
        
        let dic = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle : paraStyle]
        
        let nsSubs: NSString = NSString(cString: self, encoding: String.Encoding.utf8.rawValue)!
        
        let size = nsSubs.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: maxHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dic, context: nil).size
        
        return size.width
    }
    
    /**
     *  转富文本字体
     *
     *  @param lineSpeace   行高
     *  @param font         字体
     *  @param color        字体颜色
     *
     *  @return 富文本高度
     */
    func turnAttributedString(lineSpeace: CGFloat = 0, font: UIFont?, color: UIColor?) -> NSMutableAttributedString {
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = lineSpeace
        
        var dic: [NSAttributedString.Key : Any] = [:]
        
        if lineSpeace > CGFloat(0) {
            dic[NSAttributedString.Key.paragraphStyle] = paraStyle
        }
        
        if font != nil {
             dic[NSAttributedString.Key.font] = font
        }
        
        if color != nil {
            dic[NSAttributedString.Key.foregroundColor] = color
        }
        
        let attibutedString = NSMutableAttributedString(string: self, attributes: dic)
        return attibutedString
    }
    
    /**
     *  Json字符串转字典
     *
     *  @param content   Json字符串
     *
     *  @return Dictionary<String, Any>
     */
    func jsonStringToDictionary() -> Dictionary<String, Any>? {
        if let jsonData = self.data(using: .utf8) {
            if let dic = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? Dictionary<String, Any> {
                return dic
            }
        }
        
        return nil
    }
    
}

