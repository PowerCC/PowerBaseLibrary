//
//  InAppPurchaseViewModel.swift
//  BaiheWeddingApp
//
//  Created by 邹程 on 2018/8/20.
//  Copyright © 2018年 Baihe Network Co., LTD. All rights reserved.
//

import Foundation

open class InAppPurchaseViewModel: BaseViewModel, Codable {
    var productIdentifier: String?
    var orderId: String?
    var verifyUrl: String?
    var successUrl: String?

    var receiptData: String?
    var transactionIdentifier: String?
}
