//
//  RefreshCollectionView.swift
//  BaiheWeddingApp
//
//  Created by 实 程 on 2017/8/23.
//  Copyright © 2017年 Baihe Network Co., LTD. All rights reserved.
//

import UIKit

@objcMembers
open class RefreshCollectionView: UICollectionView {
    public weak var refreshDelegate: RefreshTableViewProtocol?

    public var customFooterView: UIView?
    public var customFooterBackgroundColor: UIColor?

    public var disableDownRefresh: Bool = false {
        didSet {
            if disableDownRefresh == true {
                mj_header = nil
            }
        }
    }

    public var disableUpRefresh: Bool = false {
        didSet {
            if disableUpRefresh == true {
                mj_footer = nil
                customFooterView = nil
                customFooterBackgroundColor = nil
            }
        }
    }

    fileprivate var mjInited = false

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        if mjInited == false {
            configDownRefresh()
            configUpRefresh()
            mjInited = true
        }
    }

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        if mjInited == false {
            configDownRefresh()
            configUpRefresh()
            mjInited = true
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - configDownRefresh

    open func configDownRefresh() {
        if disableDownRefresh == false {
            // MJ下拉刷新
            mj_header = BHRefreshHeader(refreshingTarget: self, refreshingAction: #selector(RefreshTableViewProtocol.downRefresh))
        }
    }

    // MARK: - configUpRefresh

    open func configUpRefresh() {
        if disableUpRefresh == false {
            // MJ上拉加载
            if customFooterView != nil {
                mj_footer = BHNoDataFooter(refreshingTarget: self, refreshingAction: #selector(RefreshTableViewProtocol.upRefresh), withCustomView: customFooterView!)
//                self.mj_footer?.isAutomaticallyHidden = false
            } else {
                mj_footer = BHNoDataFooter(refreshingTarget: self, refreshingAction: #selector(RefreshTableViewProtocol.upRefresh))
//                self.mj_footer?.isAutomaticallyHidden = false
            }

            if customFooterBackgroundColor != nil {
                mj_footer?.backgroundColor = customFooterBackgroundColor
            }
        }
    }

    open func downRefresh() {
        refreshDelegate?.downRefresh?()
    }

    open func upRefresh() {
        if disableDownRefresh == true {
            refreshDelegate?.upRefresh?()
        } else {
            if mj_header?.isRefreshing == false {
                refreshDelegate?.upRefresh?()
            }
        }
    }

    // 随时开启关闭上下拉刷新功能
    open func setUpReFreshEnable(_ interfaceEnable: Bool) {
        if interfaceEnable {
            // MJ上拉加载
            if customFooterView != nil {
                mj_footer = BHNoDataFooter(refreshingTarget: self, refreshingAction: #selector(RefreshTableViewProtocol.upRefresh), withCustomView: customFooterView!)
            } else {
                mj_footer = BHNoDataFooter(refreshingTarget: self, refreshingAction: #selector(RefreshTableViewProtocol.upRefresh))
            }

            if customFooterBackgroundColor != nil {
                mj_footer?.backgroundColor = customFooterBackgroundColor
            }
        } else {
            if mj_footer != nil && mj_footer?.refreshingTarget != nil {
                mj_footer?.refreshingTarget = nil
            }
            mj_footer = nil
        }
    }

    open func setDownReFreshEnable(_ interfaceEnable: Bool) {
        if interfaceEnable {
            // MJ下拉刷新
            mj_header = BHRefreshHeader(refreshingTarget: self, refreshingAction: #selector(RefreshTableViewProtocol.downRefresh))
        } else {
            if mj_header != nil && mj_header?.refreshingTarget != nil {
                mj_header?.refreshingTarget = nil
            }
            mj_header = nil
        }
    }
}
