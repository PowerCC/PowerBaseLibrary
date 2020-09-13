//
//  BHNoDataFooter.m
//  BaiheWeddingApp
//
//  Created by 邹程 on 16/2/26.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

#import "BHNoDataFooter.h"

@interface BHNoDataFooter ()

@property (strong, nonatomic) UIView *customView;

@end

@implementation BHNoDataFooter

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action withCustomView:(UIView *)view {
    BHNoDataFooter *footer = [BHNoDataFooter footerWithRefreshingTarget:target refreshingAction:action];
    footer.customView = view;
    return footer;
}

- (void)prepare {
    [super prepare];
    
    self.triggerAutomaticallyRefreshPercent = -20.0;
}

- (void)placeSubviews {
    [super placeSubviews];
    
//    CALayer *layer = [[CALayer alloc] init];
//    layer.backgroundColor = RGBCOLOR(240.f, 240.f, 240.f).CGColor;
//    layer.frame = CGRectMake(0.f, 0.f, self.frame.size.width, 1.f / [UIScreen mainScreen].scale);
//    [self.layer addSublayer:layer];
    
    [self setTitle:@"" forState:MJRefreshStateIdle];
    [self setTitle:@"没有更多啦！" forState:MJRefreshStateNoMoreData];

    if (self.customView) {
        self.customView.frame = self.bounds;
        [self addSubview:self.customView];
    }
}

@end
