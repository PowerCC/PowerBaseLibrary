//
//  ViewControllerExtension.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 16/3/3.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

public extension UIViewController {

    // MARK: - 当前显示的 ViewController
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        
        return base
    }
    
    // MARK: - 检测 3D Touch 是否可用
    func is3DtouchAvailable() -> Bool {
        
        if self.responds(to: #selector(getter: traitCollection)) {
            if #available(iOS 9.0, *) {
                if self.traitCollection.responds(to: #selector(getter: UITraitCollection.forceTouchCapability)) {
                    if self.traitCollection.forceTouchCapability == .available {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    // MARK: - showAlert
    func showAlert(title: String, msg: String) {
        DispatchQueue.main.async {
            let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: nil)
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showOKCancelAlert(title: String, msg: String ,okClosure: @escaping(()->Void) ,cancleClosure: @escaping(()->Void)) {
        DispatchQueue.main.async {
            
            let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (ok) in
                okClosure()
            })
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: { (cancel) in
                cancleClosure()
            })
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

