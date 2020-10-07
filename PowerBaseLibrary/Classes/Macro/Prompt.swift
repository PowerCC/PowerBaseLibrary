//
//  Prompt.swift
//  PowerBaseLibrary
//
//  Created by 邹程 on 2019/9/5.
//

import Foundation
import MBProgressHUD

public let MSG_ERROR_GENERAL = "出错啦，请稍后再试~(>_<)~"

// MARK: - showPrompt

public func showPrompt(_ text: String?, superView: UIView, numberOfLines: Int = 0, afterDelay: TimeInterval = 2, darkStyle: Bool = true, completion: MBProgressHUDCompletionBlock? = nil) {
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
        hud.hide(animated: true, afterDelay: 2)
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
        hud.hide(animated: true, afterDelay: 2)
    }
}
