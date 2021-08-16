//
//  BHNoDataFooter.h
//  BaiheWeddingApp
//
//  Created by 邹程 on 16/2/26.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

#import <MJRefresh/MJRefreshAutoNormalFooter.h>

@interface BHNoDataFooter : MJRefreshAutoNormalFooter

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action withCustomView:(UIView *)view;

@end
