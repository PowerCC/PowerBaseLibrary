//
//  ServerCode.swift
//  PowerBaseLibrary
//
//  Created by 邹程 on 2019/9/5.
//

import Foundation

// MARK: - 服务器代码

// MARK: - 客户端内部错误
public let CODE_CLIENT_INTERNAL_ERROR = "-404"

// MARK: - 接口调用成功
public let CODE_INTERFACE_SUCCESS = "200"

// MARK: - 服务器错误
public let CODE_INNER_ERR_SERV = "500"

// MARK: - 安全域错误
public let CODE_INNER_ERR_DOMAIN = "510"

// MARK: - 显示服务器端返回的消息
public let CODE_INNER_ERR_SHOW_MESSAGE = "550"


// MARK: --------------------------------- 我是分割线 -------------------------


// MARK: - 用户相关包括注册登录

// MARK: - 用户未登录
public let CODE_USER_NOT_LOGIN = "1005"

// MARK: - 用户被禁止
public let CODE_USER_FORBIDDEN = "1011"

// MARK: - 用户被关闭
public let CODE_USER_CLOSED = "1012"

// MARK: - 用户被删除
public let CODE_USER_DELETED = "1013"
