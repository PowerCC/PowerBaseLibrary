//
//  Prompt.swift
//  PowerBaseLibrary
//
//  Created by 邹程 on 2019/9/5.
//

import Foundation
import MBProgressHUD

public let ERROR_GENERAL_MSG = "出错啦，请稍后再试~(>_<)~"

public let ERROR_GET_CODE_MSG = "获取验证码出错，请稍后再试~(>_<)~"

public let ERROR_LOGIN_MSG = "登录出错，请稍后再试~(>_<)~"

public let ERROR_SUBMIT_MSG = "提交失败，请稍后再试~(>_<)~"

public let ERROR_UPLOAD_AVATAR_MSG = "上传头像出错，请重试~(>_<)~"

public let ERROR_UPLOAD_IMAGE_MSG = "上传照片出错，请重试~(>_<)~"

// MARK: - showPrompt

public func showPrompt(_ text: String?, superView: UIView, numberOfLines: Int = 0, afterDelay: TimeInterval = 1.5, darkStyle: Bool = true, completion: MBProgressHUDCompletionBlock? = nil) {
    if text != nil {
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud.bezelView.style = .solidColor
        if darkStyle {
            hud.bezelView.backgroundColor = RGBA(0, g: 0, b: 0, a: 0.8)
        }
        hud.mode = MBProgressHUDMode.text
        hud.label.text = text
        hud.label.numberOfLines = numberOfLines
        if darkStyle {
            hud.label.textColor = UIColor.white
        }
        hud.label.font = UIFont(name: SYSTEM_FONT_LIGHT, size: 14) ?? UIFont.systemFont(ofSize: 14)
        hud.offset = CGPoint(x: 0.0, y: (superView.frame.size.height - hud.frame.size.height) / 2.0)
        hud.hide(animated: true, afterDelay: afterDelay)
        hud.completionBlock = completion
    }
}

// MARK: - showPromptWithSuccessImage

public func showPromptWithSuccessImage(_ text: String?, superView: UIView, darkStyle: Bool = true) {
    if text != nil {
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud.bezelView.style = .solidColor
        if darkStyle {
            hud.bezelView.backgroundColor = RGBA(0, g: 0, b: 0, a: 0.8)
        }
        hud.mode = MBProgressHUDMode.customView
        hud.customView = UIImageView(image: UIImage(named: "icon_prompt_success"))
        hud.isSquare = true
        hud.label.text = text
        hud.label.numberOfLines = 0
        if darkStyle {
            hud.label.textColor = UIColor.white
        }
        hud.label.font = UIFont(name: SYSTEM_FONT_LIGHT, size: 14) ?? UIFont.systemFont(ofSize: 14)
        hud.offset = CGPoint(x: 0.0, y: (superView.frame.size.height - hud.frame.size.height) / 2.0)
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 1.5)
    }
}

// MARK: - showPromptWithFailedImage

public func showPromptWithFailedImage(_ text: String?, superView: UIView, darkStyle: Bool = true) {
    if text != nil {
        let hud = MBProgressHUD.showAdded(to: superView, animated: true)
        hud.bezelView.style = .solidColor
        if darkStyle {
            hud.bezelView.backgroundColor = RGBA(0, g: 0, b: 0, a: 0.8)
        }
        hud.mode = MBProgressHUDMode.customView
        hud.customView = UIImageView(image: UIImage(named: "icon_prompt_failed"))
        hud.isSquare = true
        hud.label.text = text
        hud.label.numberOfLines = 0
        if darkStyle {
            hud.label.textColor = UIColor.white
        }
        hud.label.font = UIFont(name: SYSTEM_FONT_LIGHT, size: 14) ?? UIFont.systemFont(ofSize: 14)
        hud.offset = CGPoint(x: 0.0, y: (superView.frame.size.height - hud.frame.size.height) / 2.0)
        hud.removeFromSuperViewOnHide = true
        hud.hide(animated: true, afterDelay: 1.5)
    }
}
