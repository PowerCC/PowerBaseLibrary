//
//  NotificationName.swift
//  BaseLibrary
//
//  Created by 邹程 on 2019/9/2.
//

/// app即将进入后台
public let N_APP_WILL_ENTER_BACKGROUND = "applicationWillEnterBackground"

/// app已进入后台
public let N_APP_DID_ENTER_BACKGROUND = "applicationDidEnterBackground"

/// app即将进入前台
public let N_APP_WILL_ENTER_FOREGROUND = "applicationWillEnterForeground"

/// app已激活
public let N_APP_DID_BECOME_ACTIVE = "applicationDidBecomeActive"

/// app即将终结
public let N_APP_WILL_TERMINATE = "applicationWillTerminate"

/// 设备横竖屏转换
public let N_APP_INTERFACE_ORIENTATION = "InterfaceOrientation"

/// 网络不可用
public let N_APP_NETWORK_UNAVAILABLE = "NetworkUnavailable"

/// 网络可用
public let N_APP_NETWORK_AVAILABLE = "NetworkAvailable"

/// push接收操作
public let N_PUSH_RECEIVE_OPERATION = "PushReceiveOperation"

// MARK: --------------------------------- 我是分割线 -------------------------

// MARK: ----------------——-------↓↓↓↓↓↓- IM -↓↓↓↓↓↓------------------

/// 网易云信登录成功
public let N_NIM_LOGIN_SUCESSED = "nimLoginSucessed"

/// 网易云信同步数据成功
public let N_NIM_SYNC_SUCESSED = "nimSyncSucessed"

/// 网易云信收到消息
public let N_NIM_ON_RECV_MESSAGES = "nimOnRecvMessages"

/// 网易云信APNS点击
public let N_NIM_APNS_TAP = "nimApnsTap"
