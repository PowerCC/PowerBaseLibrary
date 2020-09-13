//
//  BaseDataSource.swift
//  PowerBaseLibrary
//
//  Created by 邹程 on 2019/9/6.
//

import Alamofire
import Foundation

open class BaseDataSource: NSObject {
    // Alamofire数据请求数组
    var requestCacheArray = [DataRequest]()

    deinit {
        self.cancelAlamofireRequest()
    }

    // MARK: - 空数据

    /**
     空数据

     - returns: CommonServerDataModel
     */
    fileprivate func emptyData() -> CommonServerDataModel {
        let result = CommonServerDataModel()
        result.emptyData = true
        return result
    }

    fileprivate func cancelAlamofireRequest() {
        for task in requestCacheArray {
            task.cancel()
        }

        requestCacheArray.removeAll()
    }

    // MARK: - 发起http的GET请求

    /**
     发起http的GET请求

     - parameter url:      请求地址
     - parameter params:   请求参数
     - parameter response: 结果
     */
    public func httpGetRequest(requestUrl url: String, requestParameters params: Dictionary<String, Any>, responseClosure response: ((CommonServerDataModel) -> Void)?) {
        let dataRequest = SessionManager.default.request(url, method: .get, parameters: params)
        dataRequest.responseJSON { [weak self] responseJSON in
            guard let strongSelf = self else { return }
            strongSelf.alamofireResponseResult(request: dataRequest, response: responseJSON, closure: response)
        }

        requestCacheArray.append(dataRequest)
    }

    // MARK: - 发起http的POST请求

    /**
     发起http的POST请求

     - parameter url:      请求地址
     - parameter params:   请求参数
     - parameter response: 结果
     */
    public func httpPostRequest(requestUrl url: String, requestParameters params: Dictionary<String, Any>, responseClosure response: ((CommonServerDataModel) -> Void)?) {
        let dataRequest = SessionManager.default.request(url, method: .post, parameters: params)
        dataRequest.responseJSON { [weak self] responseJSON in
            guard let strongSelf = self else { return }
            strongSelf.alamofireResponseResult(request: dataRequest, response: responseJSON, closure: response)
        }

        requestCacheArray.append(dataRequest)
    }

    // MARK: - 发起通用http的GET请求

    /**
     发起http的GET请求

     - parameter url:      请求地址
     - parameter params:   请求参数
     - parameter response: 结果
     */
    public func generalHttpGetRequest(requestUrl url: String, requestParameters params: Dictionary<String, Any>, responseClosure response: ((DataResponse<Data>) -> Void)?) {
        let dataRequest = SessionManager.default.request(url, method: .get, parameters: params)
        dataRequest.responseData { responseData in
            response?(responseData)
        }

        requestCacheArray.append(dataRequest)
    }

    // MARK: - 发起通用http的POST请求

    /**
     发起http的POST请求

     - parameter url:      请求地址
     - parameter params:   请求参数
     - parameter response: 结果
     */
    public func generalHttpPostRequest(requestUrl url: String, requestParameters params: Dictionary<String, Any>, responseClosure response: ((DataResponse<Data>) -> Void)?) {
        let dataRequest = SessionManager.default.request(url, method: .post, parameters: params)
        dataRequest.responseData { responseData in
            response?(responseData)
        }

        requestCacheArray.append(dataRequest)
    }
}

extension BaseDataSource {
    func alamofireResponseResult(request: DataRequest, response: DataResponse<Any>, closure: ((CommonServerDataModel) -> Void)?) {
        if case let .failure(error) = response.result {
            if let error = error as? AFError {
                switch error {
                case let .invalidURL(url):
                    DEBUGLOG("Invalid URL: \(url) - \(error.localizedDescription)")
                case let .parameterEncodingFailed(reason):
                    DEBUGLOG("Parameter encoding failed: \(error.localizedDescription)")
                    DEBUGLOG("Failure Reason: \(reason)")
                case let .multipartEncodingFailed(reason):
                    DEBUGLOG("Multipart encoding failed: \(error.localizedDescription)")
                    DEBUGLOG("Failure Reason: \(reason)")
                case let .responseValidationFailed(reason):
                    DEBUGLOG("Response validation failed: \(error.localizedDescription)")
                    DEBUGLOG("Failure Reason: \(reason)")

                    switch reason {
                    case .dataFileNil, .dataFileReadFailed:
                        DEBUGLOG("Downloaded file could not be read")
                    case let .missingContentType(acceptableContentTypes):
                        DEBUGLOG("Content Type Missing: \(acceptableContentTypes)")
                    case let .unacceptableContentType(acceptableContentTypes, responseContentType):
                        DEBUGLOG("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                    case let .unacceptableStatusCode(code):
                        DEBUGLOG("Response status code was unacceptable: \(code)")
                    }
                case let .responseSerializationFailed(reason):
                    DEBUGLOG("Response serialization failed: \(error.localizedDescription)")
                    DEBUGLOG("Failure Reason: \(reason)")
                }

                DEBUGLOG("Underlying error: \(String(describing: error.underlyingError))")
            } else if let error = error as? URLError {
                DEBUGLOG("URLError occurred: \(error)")
            } else {
                DEBUGLOG("Unknown error: \(error)")
            }

            closure?(emptyData())
        } else {
            DEBUGLOG("原始的URL请求：\(response.request?.url?.absoluteString ?? "")") // 原始的URL请求
//            DEBUGLOG("HTTP URL响应：\(response.response?.description ?? "")") // HTTP URL响应

            if response.data?.count == 0 {
                DEBUGLOG("ResponseData 0: \(response.response.debugDescription)")
            }

            if let data = response.data {
                let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "nil"
                DEBUGLOG("服务器返回的数据：\(json)")

                let jsonString = json as String
                
                if let dataModel = CommonServerDataModel.deserialize(from: jsonString) {
                    dataModel.jsonString = jsonString
                    
                    let array = dataModel.data?.result as? NSArray
                    if array != nil {
                        if array!.count == 0 {
                            closure?(emptyData())
                        }
                    } else {
                        let dic = dataModel.data?.result as? NSDictionary
                        if dic?.count == 0 {
                            closure?(emptyData())
                        }
                    }

                    closure?(dataModel)
                } else {
                    closure?(emptyData())
                }
            } else {
                closure?(emptyData())
            }
        }
    }
}
