//
//  UITableViewExtension.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 2018/7/22.
//  Copyright © 2018年 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

public extension UITableView {
    // MARK: - registerNibName
    func registerNibName(_ nibName: String, forCellReuseIdentifier: String) {
        self.register(UINib(nibName: nibName, bundle: Bundle.main), forCellReuseIdentifier: forCellReuseIdentifier)
    }
    
    func registerNibName(_ nibName: String, forHeaderFooterViewReuseIdentifier: String) {
        self.register(UINib(nibName: nibName, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: forHeaderFooterViewReuseIdentifier)
    }
    
    func hideLastSeparator(){
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: SCREEN_BOUNDS.width, height: 0.01)
        self.tableFooterView = footerView
    }
}
