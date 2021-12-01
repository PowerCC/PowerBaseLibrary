//
//  BHRefreshHeader.h
//  BaiHe
//
//  Created by Zhang on 16/1/6.
//  Copyright © 2016年 itotemstudio. All rights reserved.
//

#import <MJRefresh/MJRefreshGifHeader.h>
#import <MJRefresh/UIView+MJExtension.h>

@interface BHRefreshHeader : MJRefreshGifHeader

@end


// 排行专用（因为排行vc程实写的，不知道怎样偏移的tableView，单独写一个专用的RefreshHeader）
@interface BHRankingRefreshHeader : BHRefreshHeader

@end
