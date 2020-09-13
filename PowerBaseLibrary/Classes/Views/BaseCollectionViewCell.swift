//
//  BaseCollectionViewCell.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 16/2/25.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

@objc public protocol BaseCollectionViewCellProtocol : NSObjectProtocol {
    @objc optional func bindViewModel()
}

@objcMembers
open class BaseCollectionViewCell: UICollectionViewCell, BaseCollectionViewCellProtocol {
    
    open var cellWidth: CGFloat = 0.0
    open var cellHeight: CGFloat = 0.0
    
    @IBOutlet var lineConstantArray: Array<NSLayoutConstraint>?
    @IBOutlet var lineViewArray: Array<UIView>?
    
    open var viewModel: BaseViewModel? {
        didSet {
            self.bindViewModel()
        }
    }
    
    open var viewModels: [BaseViewModel]? {
        didSet {
            self.bindViewModels()
        }
    }
    
    open var disposeBag = DisposeBag()
    
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
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    open class func cellFromNib(nibName name:String) -> BaseCollectionViewCell? {
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? BaseCollectionViewCell ?? nil
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
    
    open func setScheme(_ scheme: String) {
        // 子类复写 主题颜色
    }
}
