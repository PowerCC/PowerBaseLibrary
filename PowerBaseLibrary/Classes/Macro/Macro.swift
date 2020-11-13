//
//  Macro.swift
//  BaseLibrary
//
//  Created by 邹程 on 2019/9/2.
//

import Alamofire
import Foundation
import LocalAuthentication
import Photos
import UserNotifications
import MediaPlayer

// MARK: --------------------------------- 我是分割线 -------------------------

/// AppVersion
public let APP_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"

/// 屏幕边界尺寸
public let SCREEN_BOUNDS = UIScreen.main.bounds

/// 屏幕比例
public let SCREEN_SCALE = UIScreen.main.scale

/// 等比数值320
public func SCALE_VALUE(_ value: CGFloat) -> CGFloat {
    return SCREEN_BOUNDS.width * value / 320.0
}

/// 等比数值375
public func SCALE_375_VALUE(_ value: CGFloat) -> CGFloat {
    return SCREEN_BOUNDS.width * value / 375.0
}

public func SCALE_HEIGHT_4_TO_3(width: CGFloat = SCREEN_BOUNDS.width) -> CGFloat {
    return width / 4 * 3
}

public func SCALE_HEIGHT_3_TO_2(width: CGFloat = SCREEN_BOUNDS.width) -> CGFloat {
    return width / 3 * 2
}

public func SCALE_HEIGHT_3_TO_1(width: CGFloat = SCREEN_BOUNDS.width) -> CGFloat {
    return width / 3
}

/// 是否 iPhone X 系列（iPhone X, iPhone XR, iPhone XS, iPhone XS Max 机型）
public func isiPhoneXSeries() -> Bool {
    _ = currentDeviceType()

    if iPhoneX_Series {
        return true
    }

    return false
}

fileprivate var iPhoneX_Series: Bool = false

public enum DeviceType: Int {
    case
        /// iPhone4S 机型（@2x图）
        iPhone4S,

        /// iPhone5, iPhone SE 机型（@2x图）
        iPhone5_SE,

        /// iPhone6, iPhone7, iPhone8（@2x图）
        iPhone6_7_8,

        /// iPhone6 Plus, iPhone7 Plus, iPhone8 Plus（@3x图）
        iPhone6_7_8Plus,

        /// iPhoneXR 机型（@2x图）
        iPhoneXR,

        /// iPhone X, iPhone XS 机型（@3x图）
        iPhoneX_XS,

        /// iPhone XS Max 机型（@3x图）
        iPhoneXS_Max,

        /// 未知设备不支持
        nonSupport
}

public func currentDeviceType() -> DeviceType {
    iPhoneX_Series = false

    if __CGSizeEqualToSize(UIScreen.main.bounds.size, CGSize(width: 320.0, height: 480.0)) {
        // iPhone 4S 机型
        return DeviceType.iPhone4S
    } else if __CGSizeEqualToSize(UIScreen.main.bounds.size, CGSize(width: 320.0, height: 568.0)) {
        // iPhone5, iPhone SE 机型
        return DeviceType.iPhone5_SE
    } else if __CGSizeEqualToSize(UIScreen.main.bounds.size, CGSize(width: 375.0, height: 667.0)) {
        // iPhone6, iPhone7, iPhone8 机型
        return DeviceType.iPhone6_7_8
    } else if __CGSizeEqualToSize(UIScreen.main.bounds.size, CGSize(width: 414.0, height: 736.0)) {
        // iPhone6 Plus, iPhone7 Plus, iPhone8 Plus 机型
        return DeviceType.iPhone6_7_8Plus
    } else if __CGSizeEqualToSize(UIScreen.main.bounds.size, CGSize(width: 414.0, height: 896.0)) {
        iPhoneX_Series = true

        if UIScreen.main.scale == 2 {
            // iPhone XR 机型
            return DeviceType.iPhoneXR
        } else if UIScreen.main.scale == 3 {
            // iPhone XS Max 机型
            return DeviceType.iPhoneXS_Max
        } else {
            // 未知设备不支持
            return DeviceType.nonSupport
        }
    } else if __CGSizeEqualToSize(UIScreen.main.bounds.size, CGSize(width: 375.0, height: 812.0)) {
        iPhoneX_Series = true

        // iPhone X, iPhone XS 机型
        return DeviceType.iPhoneX_XS
    }

    // 未知设备不支持
    return DeviceType.nonSupport
}

public var NAV_BAR_MAX_Y: CGFloat = 0.0
public var NAV_BAR_HEIGHT: CGFloat = 0.0
public var NAV_LARGE_TITLE_BAR_MAX_Y: CGFloat = 0.0
public var MAIN_TAB_BAR_MIN_Y: CGFloat = 0.0

public var STATUS_BAR_HEIGHT: CGFloat = 20.0
public var MAIN_TAB_BAR_HEIGHT: CGFloat = 0.0
public var SAFE_AREA_HEIGHT: CGFloat = 0.0

public var SYSTEM_FONT = "PingFangSC-Regular"
public var SYSTEM_FONT_MEDIUM = "PingFangSC-Medium"
public var SYSTEM_FONT_SEMIBOLD = "PingFangSC-Semibold"
public var SYSTEM_FONT_LIGHT = "PingFangSC-Light"

/// 1px线
public let LINE_1PX = 1.0 / UIScreen.main.scale

/// 详情页Section间距
public let DETAILVC_SECTION_GAP: CGFloat = 8.0

/// Tableview Section Header & Footer 高度为0时 需要设置为接近于0的小数，如果设置为0则显示默认高度
public let SECTION_ZERO_HF: CGFloat = 0.001

// MARK: --------------------------------- 我是分割线 -------------------------

/// 网络类型
public var CONNECTION_TYPE = NetworkReachabilityManager.ConnectionType.wwan

/// 登录VC是否出现
public var LOGIN_VC_EXISTING = false

/// 每页记录数（首页）
public let HOME_PAGE_SIZE = 10

/// 每页记录数
public let NORMAL_PAGE_SIZE = 20

/// IM数据是否同步完成
public var IM_SYNC_OK = false

// MARK: --------------------------------- 我是分割线 -------------------------

// MARK: - 查找顶层控制器、

// 获取顶层控制器 根据window
public func getTopVC() -> (UIViewController?) {
    var window = UIApplication.shared.keyWindow
    // 是否为当前显示的window
    if window?.windowLevel != UIWindow.Level.normal {
        let windows = UIApplication.shared.windows
        for windowTemp in windows {
            if windowTemp.windowLevel == UIWindow.Level.normal {
                window = windowTemp
                break
            }
        }
    }
    let vc = window?.rootViewController
    return getTopVC(withCurrentVC: vc)
}

/// 根据控制器获取 顶层控制器
public func getTopVC(withCurrentVC VC: UIViewController?) -> UIViewController? {
    if VC == nil {
        print("🌶： 找不到顶层控制器")
        return nil
    }
    if let presentVC = VC?.presentedViewController {
        // modal出来的 控制器
        return getTopVC(withCurrentVC: presentVC)
    } else if let tabVC = VC as? UITabBarController {
        // tabBar 的跟控制器
        if let selectVC = tabVC.selectedViewController {
            return getTopVC(withCurrentVC: selectVC)
        }
        return nil
    } else if let naiVC = VC as? UINavigationController {
        // 控制器是 nav
        return getTopVC(withCurrentVC: naiVC.visibleViewController)
    } else {
        // 返回顶控制器
        return VC
    }
}

/// 颜色含alpha
public func RGBA(_ r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

// MARK: --------------------------------- 我是分割线 -------------------------

/// 遮罩色
public let MASK_COLOR = RGBA(0, g: 0, b: 0, a: 0.5)

/// 菊花tag
public let INDICATOR_TAG = 10010

/// MBProgressHUD tag
public let MBProgressHUD_TAG = 10011

/// 奔跑小人tag
public let LOADING_VIEW_TAG = 10012

/// MBProgressHUD MESSAGE tag
public let MBProgressHUD_MESSAGE_TAG = 10013

/// 调试日志
public func DEBUGLOG<T>(_ message: T, file: NSString = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        print("\(method)[\(line)]: \(message)")
    #endif
}

/// 调试输出
public func dPrint(_ items: Any..., separator: String = "", terminator: String = "") {
    #if DEBUG
        print(items, separator: separator, terminator: terminator)
    #endif
}

/// 判断字符串是否为空
public func legalString(_ testStr: String?) -> Bool {
    return testStr != nil && testStr!.count > 0
}

public func legalNSString(_ testStr: NSString?) -> Bool {
    return testStr != nil && testStr!.length > 0
}

/// 替换图片文件名，取350小图
public func handleImageName(_ urlString: String, imageWidth: CGFloat = UIScreen.main.bounds.size.width) -> String {
    //    #if HTTPS
    //        if urlString.hasPrefix("http://") {
    //            if let nameString = NSString(cString: urlString, encoding: String.Encoding.utf8.rawValue) {
    //                return nameString.replacingOccurrences(of: "http://", with: "https://")
    //            }
    //        }
    //    #endif
    //
    //    let imageHeight = "30000"
    //    var newUrl = ""
    //
    //    if let range = urlString.range(of: "?style=1") {
    //        newUrl = String(urlString.prefix(upTo: range.lowerBound))
    //        newUrl = "\(newUrl)?style=1&w=\(Int(imageWidth))&h=\(imageHeight)"
    //    } else if let range = urlString.range(of: "?") {
    //        newUrl = String(urlString.prefix(upTo: range.lowerBound))
    //        newUrl = "\(newUrl)&style=1&w=\(Int(imageWidth))&h=\(imageHeight)"
    //    } else {
    //        newUrl = "\(urlString)?style=1&w=\(Int(imageWidth))&h=\(imageHeight)"
    //    }

    return urlString
}

/// 收藏数量检测 大于999的显示999+
public func collectCountCheck(count: String?) -> String? {
    if let ccount = count {
        if let c = Int(ccount) {
            if c > 999 {
                return "999+"
            }
        }
    }
    return count
}

// 请柬分享用默认URL
public let INVITATION_DEFAULT_ICON_URL_FOR_SHARE = "https://m.hunli.baihe.com/static/img/invitationDefault.png"

// MARK: --------------------------------- 我是分割线 -------------------------

/// AppStore ID
#if WeddingTarget
    let APP_STORE_ID = "1086884575"
#else
    let APP_STORE_ID = "791486098"
#endif

/// AppStore url
public let APP_STORE_URL = "https://itunes.apple.com/cn/app/%E7%99%BE%E5%90%88%E7%BD%91%E5%A9%9A%E7%A4%BC-%E7%94%A8%E5%BF%83%E7%9A%84%E5%A9%9A%E5%BA%86%E7%AD%96%E5%88%92%E6%9C%8D%E5%8A%A1/id1086884575?mt=8"

/// 默认城市（北京）
public let DEFAULT_CITY_CODE = "110000"

/// 全国CityCode
public let NATION_CITY_CODE = "100000"

/// 默认服务电话（全国为空时用的客服电话）
public let CITY_SERVICE_NUMBER_BEIJING = "400-697-0096"

/// 默认服务电话
public var CITY_SERVICE_NUMBER_DEFAULT = CITY_SERVICE_NUMBER_BEIJING

/// 服务电话号码
public var SERVICE_PHONE_NUMBER = CITY_SERVICE_NUMBER_DEFAULT

/// 通知权限
public var NOTIFICATION_IS_ENABLE: Bool = false

/// 媒体库权限
public var MEDIA_LIBRARY_STATUS: MPMediaLibraryAuthorizationStatus = .denied

/// 麦克风权限
public var MICROPHONE_STATUS: AVAuthorizationStatus = .denied

/// 相机权限
public var CAMERA_STATUS: AVAuthorizationStatus = .denied

/// 照片库权限
public var PHOTO_LIBRARY_STATUS: PHAuthorizationStatus = .denied

// MARK: - callPhoneNumber

public func callPhoneNumber(viewController vc: UIViewController?, number: String!) {
    if vc != nil {
        var phoneNum = NSString(cString: number, encoding: String.Encoding.utf8.rawValue)!
        if legalNSString(phoneNum) {
            phoneNum = phoneNum.replacingOccurrences(of: "-", with: "") as NSString
            if let tel = URL(string: "tel://" + String(phoneNum)) {
                if UIApplication.shared.canOpenURL(tel) {
                    UIApplication.shared.open(tel, options: [:], completionHandler: nil)
                }
            }

            //            let callAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            //
            //            })
            //
            //            let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            //
            //            })
            //
            //            let alert = UIAlertController(title: number, message: "", preferredStyle: UIAlertController.Style.alert)
            //
            //            alert.addAction(cancelAction)
            //            alert.addAction(callAction)
            //
            //            vc!.present(alert, animated: true, completion: { () -> Void in
            //
            //            })
        }
    }
}

// MARK: --------------------------------- 我是分割线 -------------------------

// MARK: - 是否（北上广深）

/// 是否（北上广深）
public func isBSGS(_ cityCode: String) -> Bool {
    if cityCode.hasPrefix("110") || cityCode.hasPrefix("310") || cityCode.hasPrefix("4401") || cityCode.hasPrefix("4403") {
        return true
    }

    return false
}

// MARK: - 检测通知权限

public func notificationIsEnable(action: @escaping (() -> Void), ungrantedAction: @escaping (() -> Void)) {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [UNAuthorizationOptions.badge, UNAuthorizationOptions.sound, UNAuthorizationOptions.alert], completionHandler: { granted, _ in
        NOTIFICATION_IS_ENABLE = granted
        if granted {
            // 已授权
            action()
        } else {
            // 未授权
            ungrantedAction()
        }
    })
}

// MARK: - 检测媒体库访问权限

public func mediaLibraryAuthorizationStatus(_ vc: UIViewController, action: @escaping (() -> Void)) {
    if MPMediaLibrary.authorizationStatus() == .authorized {
        MEDIA_LIBRARY_STATUS = .authorized
        action()
    } else {
        MPMediaLibrary.requestAuthorization { (authStatus) in
            MEDIA_LIBRARY_STATUS = authStatus
            
            if authStatus == .restricted {
                // 应用受内容和隐私访问限制
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "访问媒体库权限未开启", message: "应用受内容和隐私访问限制。", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okAction)

                    vc.present(alert, animated: true, completion: nil)
                }
            } else if authStatus == .denied {
                // 用户未授权
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "访问媒体库权限未开启", message: "请在系统（设置->隐私->媒体与 Apple Music）中启用。", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil)
                    alert.addAction(okAction)

                    vc.present(alert, animated: true, completion: nil)
                }
            } else {
                // 已授权
                action()
            }
        }
    }
}

// MARK: - 检测麦克风访问权限

public func microphoneAuthorizationStatus(_ vc: UIViewController, action: @escaping (() -> Void)) {
    let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
    CAMERA_STATUS = authStatus

    if authStatus == .notDetermined {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if granted {
                CAMERA_STATUS = .authorized
                DispatchQueue.main.async(execute: {
                    // 已授权
                    action()
                })
            }
        }
    } else if authStatus == .restricted {
        // 应用受内容和隐私访问限制
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "访问相机权限未开启", message: "应用受内容和隐私访问限制。", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)

            vc.present(alert, animated: true, completion: nil)
        }
    } else if authStatus == .denied {
        // 用户未授权
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "访问相机权限未开启", message: "请在系统（设置->隐私->相机）中启用。", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)

            vc.present(alert, animated: true, completion: nil)
        }
    } else {
        // 已授权
        action()
    }
}

// MARK: - 检测相机访问权限

public func cameraAuthorizationStatus(_ vc: UIViewController, action: @escaping (() -> Void)) {
    let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    CAMERA_STATUS = authStatus

    if authStatus == .notDetermined {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if granted {
                CAMERA_STATUS = .authorized
                DispatchQueue.main.async(execute: {
                    // 已授权
                    action()
                })
            }
        }
    } else if authStatus == .restricted {
        // 应用受内容和隐私访问限制
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "访问相机权限未开启", message: "应用受内容和隐私访问限制。", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)

            vc.present(alert, animated: true, completion: nil)
        }
    } else if authStatus == .denied {
        // 用户未授权
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "访问相机权限未开启", message: "请在系统（设置->隐私->相机）中启用。", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)

            vc.present(alert, animated: true, completion: nil)
        }
    } else {
        // 已授权
        action()
    }
}

// MARK: - 检测相册访问权限

public func photoLibraryAuthorizationStatus(_ vc: UIViewController, action: @escaping (() -> Void)) {
    let authStatus = PHPhotoLibrary.authorizationStatus()
    PHOTO_LIBRARY_STATUS = authStatus

    if authStatus == .notDetermined {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHOTO_LIBRARY_STATUS = .authorized
                DispatchQueue.main.async(execute: {
                    // 已授权
                    action()
                })
            }
        }
    } else if authStatus == .restricted {
        // 应用受内容和隐私访问限制
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "访问照片权限未开启", message: "应用受内容和隐私访问限制。", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)

            vc.present(alert, animated: true, completion: nil)
        }
    } else if authStatus == .denied {
        // 用户未授权
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "访问照片权限未开启", message: "请在系统（设置->隐私->照片）中启用。", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okAction)

            vc.present(alert, animated: true, completion: nil)
        }
    } else {
        // 已授权
        action()
    }
}

// MARK: - 获取App图标右上角数字

public func appIconBadgeNumber() -> Int {
    let app = UIApplication.shared
    return app.applicationIconBadgeNumber
}

// MARK: - 更新App图标右上角数字

//func updateAppIconBadgeNumber(_ number: Int) {
//    let app = UIApplication.shared
//    let settings = UIUserNotificationSettings(types: UIUserNotificationType.badge, categories: nil)
//    app.registerUserNotificationSettings(settings)
//    app.applicationIconBadgeNumber = number
//}

// MARK: - 从 Storyboard 获得 ViewController 实例

public func instantiateVc(_ storyboardName: String) -> UIViewController? {
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    let vc = storyboard.instantiateInitialViewController()
    return vc
}

// MARK: - 根据 ID 从 Storyboard 获得 ViewController 实例

public func instantiateVcWithID(_ storyboardName: String, storyboardID: String) -> UIViewController {
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: storyboardID)
    return vc
}

// MARK: - 修复像素狭缝

public func fixSlitWith(_ containerWidth: CGFloat, colCount: CGFloat, space: CGFloat) -> CGFloat {
    let totalSpace: CGFloat = (colCount - 1) * space // 总共留出的距离
    let itemWidth: CGFloat = (containerWidth - totalSpace) / colCount // 按照真实屏幕算出的cell宽度 （iPhone6 375*667）93.75
    let fixValue: CGFloat = 1 / UIScreen.main.scale // (1px=0.5pt, 6Plus为3px=1pt)
    var realItemWidth: CGFloat = floor(itemWidth) + fixValue // 取整加fixValue  floor:如果参数是小数，则求最大的整数但不大于本身.
    if realItemWidth < itemWidth { // 有可能原cell宽度小数点后一位大于0.5
        realItemWidth += fixValue
    }

    return realItemWidth // 每个cell的真实宽度
}

public func fixSlitWithRect(rect: inout CGRect, colCount: CGFloat, space: CGFloat) -> CGFloat {
    let containerWidth = rect.width
    let totalSpace: CGFloat = (colCount - 1) * space // 总共留出的距离
    let realItemWidth = fixSlitWith(containerWidth, colCount: colCount, space: space)
    let realWidth: CGFloat = colCount * realItemWidth + totalSpace // 算出屏幕等分后满足1px=([UIScreen mainScreen].scale)pt实际的宽度,可能会超出屏幕,需要调整一下frame
    //    let pointX: CGFloat = (realWidth - containerWidth) / 2 //偏移距离
    //    rect.origin.x = -pointX // 向左偏移
    rect.size.width = realWidth

    return realItemWidth // 每个cell的真实宽度
}

// MARK: - 角度转弧度

public func radians_to_degrees(_ radians: CGFloat) -> CGFloat {
    let result = Double(radians) * (180.0 / Double.pi)
    return CGFloat(result)
}

// MARK: - 弧度转角度

public func degrees_to_radians(_ angle: CGFloat) -> CGFloat {
    let result = Double(angle) / 180.0 * Double.pi
    return CGFloat(result)
}

// MARK: - 图片按宽度裁剪

public func imageCompressForWidth(_ sourceImage: UIImage, targetWidth: CGFloat) -> UIImage {
    let imageSize = sourceImage.size
    let width = imageSize.width
    let height = imageSize.height
    let targetHeight = (targetWidth / width) * height
    UIGraphicsBeginImageContext(CGSize(width: targetWidth, height: targetHeight))
    sourceImage.draw(in: CGRect(x: 0.0, y: 0.0, width: targetWidth, height: targetHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}

// MARK: - 图片按高度裁剪

public func imageCompressForHeight(_ sourceImage: UIImage, targetHeight: CGFloat) -> UIImage {
    let imageSize = sourceImage.size
    let width = imageSize.width
    let height = imageSize.height
    let targetWidth = (targetHeight / height) * width
    UIGraphicsBeginImageContext(CGSize(width: targetWidth, height: targetHeight))
    sourceImage.draw(in: CGRect(x: 0.0, y: 0.0, width: targetWidth, height: targetHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}
