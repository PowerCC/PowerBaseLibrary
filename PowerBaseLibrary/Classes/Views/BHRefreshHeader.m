//
//  BHRefreshHeader.m
//  BaiHe
//
//  Created by Zhang on 16/1/6.
//  Copyright © 2016年 itotemstudio. All rights reserved.
//

#import "Macro.h"
#import "BHRefreshHeader.h"

@interface BHRefreshHeader ()

@property (nonatomic, strong) UIImageView *refreshImageView;

@property (nonatomic, strong) UILabel *refreshTitleLabel;

@property (nonatomic, assign) CGFloat refreshTitleLabelHeight;

@property (nonatomic, assign) CGFloat refreshTitleLabelBottom;

@property (nonatomic, assign) CGFloat refreshTitleLabelGap;

@end

@implementation BHRefreshHeader

- (void)prepare {
    [super prepare];

    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_loading_%zd", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_loading_%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    self.refreshTitleLabel = [[UILabel alloc] init];
    self.refreshTitleLabel.font = [UIFont systemFontOfSize:11.0];
    self.refreshTitleLabel.textColor = RGBACOLOR(153, 153, 153, 1);
    self.refreshTitleLabel.text = @"懂婚礼 更懂你";
    [self.refreshTitleLabel sizeToFit];
    
    self.refreshTitleLabelHeight = self.refreshTitleLabel.frame.size.height;
    self.refreshTitleLabelBottom = 15;
    self.refreshTitleLabelGap = 5;
    
    [self insertSubview:self.refreshTitleLabel aboveSubview:self.gifView];
    
    self.mj_h = MJRefreshHeaderHeight + self.refreshTitleLabelHeight + self.refreshTitleLabelBottom + self.refreshTitleLabelGap;
    
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    
    CGFloat y = self.frame.size.height - self.refreshTitleLabelHeight - self.refreshTitleLabelBottom;
  
    CGRect rect = self.bounds;
    rect.origin.y -= self.refreshTitleLabelHeight;
    self.gifView.frame = rect;
    
    if (self.refreshTitleLabel != nil) {
        
        CGFloat x = (self.frame.size.width - self.refreshTitleLabel.frame.size.width) / 2;
        
        if (self.refreshTitleLabel.frame.origin.x != x || self.refreshTitleLabel.frame.origin.y != y) {
            self.refreshTitleLabel.frame = CGRectMake(x, y, self.refreshTitleLabel.frame.size.width, self.refreshTitleLabelHeight);
        }
    }
    
    
}

@end


// 排行专用（因为排行vc程实写的，不知道怎样偏移的tableView，单独写一个专用的RefreshHeader）
@implementation BHRankingRefreshHeader

- (void)prepare {
    [super prepare];
    
    if (IPHONE_X) {
        self.ignoredScrollViewContentInsetTop = self.mj_h;
    }
    else {
        self.ignoredScrollViewContentInsetTop = MJRefreshHeaderHeight + self.refreshTitleLabelHeight;
    }
    
}

- (void)placeSubviews
{
    [super placeSubviews];
    
}


@end
