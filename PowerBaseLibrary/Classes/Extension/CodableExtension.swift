//
//  CodableExtension.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 2018/8/15.
//  Copyright © 2018年 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

/// 扩展Encodable协议,添加编码的方法
public extension Encodable {
    /// 遵守Codable协议的对象转json字符串
    func encodable_toJSONString() -> String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    /// 对象转换成jsonObject
    func encodable_toJSONObject() -> Any? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }

    /// 对象转换成Dictionary
    func encodable_toDictionary() -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any]
    }
}

/// 扩展Decodable协议,添加解码的方法
public extension Decodable {
    /// json字符串转对象&数组
    static func decodable_decodeJSON(from string: String?, designatedPath: String? = nil) -> Self? {
        guard let data = string?.data(using: .utf8),
            let jsonData = getInnerObject(inside: data, by: designatedPath) else {
            return nil
        }
        return try? JSONDecoder().decode(Self.self, from: jsonData)
    }

    /// jsonObject转换对象或者数组
    static func decodable_decodeJSON(from jsonObject: Any?, designatedPath: String? = nil) -> Self? {
        guard let jsonObject = jsonObject,
            JSONSerialization.isValidJSONObject(jsonObject),
            let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
            let jsonData = getInnerObject(inside: data, by: designatedPath) else {
            return nil
        }
        return try? JSONDecoder().decode(Self.self, from: jsonData)
    }
}

/// 扩展Dictionary
public extension Dictionary {
    func getJSONString() -> String? {
        guard JSONSerialization.isValidJSONObject(self),
            let data = try? JSONSerialization.data(withJSONObject: self, options: []),
            let jsonString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }
        
        return jsonString as String
    }
}

/// 扩展Array,添加将jsonString或者jsonObject解码到对应对象数组的方法
public extension Array where Element: Codable {
    static func decodable_decodeJSON(from jsonString: String?, designatedPath: String? = nil) -> [Element?]? {
        guard let data = jsonString?.data(using: .utf8),
            let jsonData = getInnerObject(inside: data, by: designatedPath),
            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [Any] else {
            return nil
        }
        return Array.decodable_decodeJSON(from: jsonObject)
    }

    static func decodable_decodeJSON(from array: [Any]?) -> [Element?]? {
        return array?.map({ (item) -> Element? in
            Element.decodable_decodeJSON(from: item)
        })
    }
}

/// 借鉴HandyJSON中方法，根据designatedPath获取object中数据
///
/// - Parameters:
///   - jsonData: json data
///   - designatedPath: 获取json object中指定路径
/// - Returns: 可能是json object
fileprivate func getInnerObject(inside jsonData: Data?, by designatedPath: String?) -> Data? {
    // 保证jsonData不为空，designatedPath有效
    guard let _jsonData = jsonData,
        let paths = designatedPath?.components(separatedBy: "."),
        paths.count > 0 else {
        return jsonData
    }
    // 从jsonObject中取出designatedPath指定的jsonObject
    let jsonObject = try? JSONSerialization.jsonObject(with: _jsonData, options: .allowFragments)
    var result: Any? = jsonObject
    var abort = false
    var next = jsonObject as? [String: Any]
    paths.forEach({ seg in
        if seg.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || abort {
            return
        }
        if let _next = next?[seg] {
            result = _next
            next = _next as? [String: Any]
        } else {
            abort = true
        }
    })
    // 判断条件保证返回正确结果,保证没有流产,保证jsonObject转换成了Data类型
    guard abort == false,
        let resultJsonObject = result,
        let data = try? JSONSerialization.data(withJSONObject: resultJsonObject, options: []) else {
        return nil
    }
    return data
}
