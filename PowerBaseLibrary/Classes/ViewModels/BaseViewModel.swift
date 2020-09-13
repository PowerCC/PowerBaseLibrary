//
//  BaseViewModel.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 16/2/2.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

import HandyJSON

public protocol Copyable: class, Codable {
    func copySelf() -> Self
}

public extension Copyable {
    func copySelf() -> Self {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            fatalError("encode失败")
        }

        let decoder = JSONDecoder()
        guard let target = try? decoder.decode(Self.self, from: data) else {
            fatalError("decode失败")
        }

        return target
    }
}

@objcMembers
open class BaseViewModel: HandyJSON {
    public var code: String?
    public var data: Any?
    public var msg: String?

    open func willStartMapping() {
    }

    open func mapping(mapper: HelpingMapper) {
    }

    open func didFinishMapping() {
    }

    public required init() {}
}

@objcMembers
open class BaseObjectViewModel: NSObject {
    /// 服务器返回码
    var serverCode: String?

    /// 服务器返回信息
    var serverMsg: String?

    /// 统一数据模型
    var commonData: CommonData?

    /// 是否为空
    var empty = false

    /// 错误信息
    var error: NSError?

    override public required init() {
        super.init()
    }

    init(code: String, msg: String) {
        super.init()
        serverCode = code
        serverMsg = msg

        if code != "" {
            if msg == "" {
                serverMsg = "数据错误"
            }
        }
    }

    init(code: String, msg: String, emptyData: Bool) {
        super.init()
        serverCode = code
        serverMsg = msg
        empty = emptyData

        if code != "" {
            if msg == "" {
                serverMsg = "数据错误"
            }
        }
    }

    init(commonData: CommonData) {
        super.init()
        self.commonData = commonData
    }

    init(emptyData: Bool) {
        super.init()
        empty = emptyData
    }

    init(errorInfo: NSError?, code: String? = nil, msg: String? = nil) {
        super.init()
        serverCode = code
        serverMsg = msg
        error = errorInfo
    }

    deinit {
//        DEBUGLOG(String(describing: self) + " 执行了 deinit ，释放了，好棒！！！")
    }

    func initCodeMsg(code: String?, msg: String) {
        serverCode = code
        serverMsg = msg

        if code != "" {
            if msg == "" {
                serverMsg = "数据错误"
            }
        }
    }

    func initCodeMsgEmptyData(code: String, msg: String, emptyData: Bool) {
        serverCode = code
        serverMsg = msg
        empty = emptyData

        if code != "" {
            if msg == "" {
                serverMsg = "数据错误"
            }
        }
    }

    func initCommonData(commonData: CommonData) {
        self.commonData = commonData
    }

    func initEmptyData(emptyData: Bool) {
        empty = emptyData
    }

    func initErrorInfo(errorInfo: NSError?) {
        error = errorInfo
    }

    func legalFeedback<T>(_ pty: inout String, obj: T) {
        if let temp = obj as? String, legalString(temp) {
            pty = temp
        }
    }

    func fillData(_ dataDic: Dictionary<String, Any>) {
        // 子类实现
    }

    /// 网络请求返回Json数据通用解析
    class func genericJsonAnalysis(result: CommonResultModel, viewModel: @escaping ((BaseObjectViewModel) -> Void)) {
        let jsonModel: CommonJsonModel? = result.jsonModel
        if result.emptyData {
            viewModel(BaseObjectViewModel(emptyData: true))
        } else if result.errorInfo != nil {
            if jsonModel != nil && jsonModel!.code != nil && jsonModel!.msg != nil {
                viewModel(BaseObjectViewModel(errorInfo: result.errorInfo! as NSError, code: jsonModel!.code, msg: jsonModel!.msg))
            } else {
                viewModel(BaseObjectViewModel(errorInfo: result.errorInfo! as NSError))
            }
        } else {
            if jsonModel != nil && jsonModel!.code != nil && jsonModel!.code == CODE_INTERFACE_SUCCESS {
                let model = BaseObjectViewModel()
                model.initCodeMsg(code: nil, msg: jsonModel!.msg)
                model.initCommonData(commonData: jsonModel!.data)
                viewModel(model)
            } else {
                if jsonModel != nil && jsonModel!.code != nil && jsonModel!.msg != nil {
                    let model = BaseObjectViewModel()
                    model.initCodeMsg(code: jsonModel!.code, msg: jsonModel!.msg)
                    model.initCommonData(commonData: jsonModel!.data)
                    viewModel(model)
                }
            }
        }
    }

    class func genericJsonAnalysisToViewModel<T: BaseObjectViewModel>(type: T.Type, result: CommonResultModel, viewModel: @escaping ((T) -> Void)) {
        if result.emptyData {
            let model = type.init()
            model.initEmptyData(emptyData: true)
            viewModel(model)
        } else if result.errorInfo != nil {
            let model = type.init()
            model.initErrorInfo(errorInfo: result.errorInfo! as NSError)
            viewModel(model)
        } else {
            let jsonModel: CommonJsonModel? = result.jsonModel
            if jsonModel != nil && jsonModel!.code != nil && jsonModel!.code == CODE_INTERFACE_SUCCESS {
                let data: AnyObject = result.jsonModel.data.result
                if let contents = data as? Dictionary<String, Any> {
                    let model = type.init()
                    model.fillData(contents)

                    viewModel(model)
                } else {
                    let model = type.init()
                    model.initCodeMsg(code: "-1", msg: ERROR_GENERAL_MSG)
                    viewModel(model)
                }
            } else {
                if jsonModel != nil && jsonModel!.code != nil && jsonModel!.msg != nil {
                    let model = type.init()
                    model.initCodeMsg(code: jsonModel!.code, msg: jsonModel!.msg)
                    viewModel(model)
                }
            }
        }
    }

    class func genericJsonAnalysisToViewModels<T: BaseObjectViewModel>(type: T.Type, result: CommonResultModel, viewModels: @escaping (([T]) -> Void)) {
        if result.emptyData {
            let model = type.init()
            model.initEmptyData(emptyData: true)
            viewModels([model])
        } else if result.errorInfo != nil {
            let model = type.init()
            model.initErrorInfo(errorInfo: result.errorInfo! as NSError)
            viewModels([model])
        } else {
            let jsonModel: CommonJsonModel? = result.jsonModel
            if jsonModel != nil && jsonModel!.code != nil && jsonModel!.code == CODE_INTERFACE_SUCCESS {
                let data: AnyObject = result.jsonModel.data.result
                if let contents = data as? [Dictionary<String, Any>] {
                    var models = [T]()
                    for model in contents {
                        let m = type.init()
                        m.fillData(model)
                        models.append(m)
                    }

                    viewModels(models)
                } else {
                    let model = type.init()
                    model.initCodeMsg(code: "-1", msg: ERROR_GENERAL_MSG)
                    viewModels([model])
                }
            } else {
                if jsonModel != nil && jsonModel!.code != nil && jsonModel!.msg != nil {
                    let model = type.init()
                    model.initCodeMsg(code: jsonModel!.code, msg: jsonModel!.msg)
                    viewModels([model])
                }
            }
        }
    }

    /// 创建新实例并填充数据
    class func newInstance<T: BaseObjectViewModel>(type: T.Type, dataDic: Dictionary<String, Any>) -> T {
        let instance = type.init()
        instance.fillData(dataDic)
        return instance
    }

    /// 从本地缓存解码得到模型
    static func decodeFormLocalCahce<T>(key: String, type: T.Type) -> Any? where T: Decodable {
        let ud = UserDefaults.standard
        guard let data = ud.data(forKey: key) else {
            return nil
        }

        guard let us = try? JSONDecoder().decode(type, from: data) else {
            return nil
        }

        return us
    }

    /// 将模型编码保存到本地缓存
    static func encodeToLocalCache<T>(key: String, value: T) where T: Encodable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let data = try? JSONEncoder().encode(value) {
            let us = UserDefaults.standard
            us.set(data, forKey: key)
            us.synchronize()
        }
    }
}

class RequestResultViewModel: BaseViewModel, Codable {
}

//// 自定义Section
// struct BaseViewModelSection {
//    var header: String
//    var items: [Item]
// }
//
// extension BaseViewModelSection: AnimatableSectionModelType {
//    typealias Item = BaseViewModel
//
//    var identity: String {
//        return header
//    }
//
//    init(original: BaseViewModelSection, items: [Item]) {
//        self = original
//        self.items = items
//    }
// }
