//
//  BaseTableViewCell.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 16/2/17.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

import UIKit
import RxSwift

@objc public protocol BaseTableViewCellProtocol: NSObjectProtocol {
	@objc optional func bindViewModel()
	@objc optional func bindViewModels()
}

@objcMembers
open class BaseTableViewCell: UITableViewCell, BaseTableViewCellProtocol {

	@IBOutlet var lineConstantArray: Array<NSLayoutConstraint>?
	@IBOutlet var lineViewArray: Array<UIView>?

    open var cellIndex: Int = 0
    
	open var cellHeight: CGFloat = 0.0
    
	open var indicatorView: UIActivityIndicatorView?

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
    
    open var disposeBag = DisposeBag()
    
    deinit {
        DEBUGLOG("\(self) --- 执行了 deinit ，释放了，好棒！！！")
    }

    override open func awakeFromNib() {
		super.awakeFromNib()
		self.selectionStyle = .none

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

    override open func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }

	// MARK: - class func
	open class func cellFromNib(nibName name: String) -> BaseTableViewCell? {
        let cell = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? BaseTableViewCell ?? nil
        return cell
	}

	open class func cellFromNib(nibName name: String, owner: AnyObject) -> BaseTableViewCell? {
		let cell = Bundle.main.loadNibNamed(name, owner: owner, options: nil)?.first as? BaseTableViewCell ?? nil
		return cell
	}

	open class func nibFromClass(nibName name: String) -> UINib? {
		let bundle = Bundle.main
		return UINib(nibName: name, bundle: bundle)
	}

	// MARK: - enabledIndicator
	func enabledIndicator(_ superView: UIView) {
		if self.indicatorView == nil {
			self.indicatorView = UIActivityIndicatorView()
//            self.indicatorView!.color = MAIN_ORANGE_COLOR
		}
		self.indicatorView?.removeFromSuperview()
		superView.addSubview(self.indicatorView!)

//        _ = constrain(self.indicatorView!, superView) { view1, view2 in
//            _ = view1.width == 20.0
//            _ = view1.height == 20.0
//            _ = view1.centerY == view2.centerY
//            _ = view1.trailing == view2.trailing - 20.0
//        }
	}

    // MARK: - clearUI
    open func clearUI() {
        // 清除UI内容，子类复写
    }
    
	// MARK: - bindViewModel
    open func bindViewModel() {
		// 绑定ViewModel，子类复写
	}

	open func bindViewModels() {
		// 绑定ViewModes，子类复写
	}
    
    open func setScheme(_ scheme: String) {
        // 子类复写 主题设置
    }

    // MARK: - 改变皮肤
    open func changeSkin(type: String) {
        // 子类复写
    }
    
}
