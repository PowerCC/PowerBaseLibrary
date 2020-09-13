//
//  BaseView.swift
//  BaiheWeddingApp
//
//  Created by 实 程 on 16/2/19.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@objc public protocol BaseViewProtocol : NSObjectProtocol {
    @objc optional func bindViewModel()
    @objc optional func bindViewModels()
}

@objcMembers
open class BaseView: UIView, BaseViewProtocol {
    
    @IBOutlet var lineConstantArray : Array<NSLayoutConstraint>?
    @IBOutlet var lineViewArray : Array<UIView>?
    
    open var disposeBag = DisposeBag()
    
    ///子类在layoutSubviews 执行完毕后设置为false,防止layoutSubviews 多次执行自定义布局
    open var isFirstLayout = true
    
    open var viewModel: BaseViewModel? {
        didSet {
            self.bindViewModel()
        }
    }
    
    open var viewModels: Array<BaseViewModel>? {
        didSet {
            self.bindViewModels()
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()

        if self.lineConstantArray != nil {
            for lineConstant in self.lineConstantArray! {
                lineConstant.constant = LINE_1PX
            }
        }
        
        if self.lineViewArray != nil {
            for lineView in self.lineViewArray! {
//                lineView.backgroundColor = MAIN_LINE_COLOR
            }
        }
    }
    
    deinit {
        DEBUGLOG(String(describing: self) + " 执行了 deinit ，释放了，好棒！！！")
    }
    
    open class func viewFromNib(nibName name: String) -> UIView? {
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? UIView ?? nil
    }
    
    open class func viewFromNib(nibName name: String, objIndex index: Int) -> UIView? {
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?[safe: index] as? UIView ?? nil
    }
    
    open class func viewsFromNib(nibName name: String) -> [UIView]? {
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil) as? [UIView]
    }
    
    open class func nibFromClass(nibName name:String) -> UINib? {
        let bundle = Bundle.main
        return UINib(nibName: name, bundle: bundle)
    }
    
    open func bindViewModel() {
        // 子类复写
    }
    
    open func bindViewModels() {
        // 子类复写
    }
    
    open func clearUI() {
        // 子类复写
    }
    
    open func setScheme(_ scheme: String){
        // 子类复写 主题颜色
    }
}
