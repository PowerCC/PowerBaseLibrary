//
//  CommonResultModel.m
//  BaiHe
//
//  Created by PowerCC on 15/1/13.
//  Copyright (c) 2015年 itotemstudio. All rights reserved.
//

#import "CommonResultModel.h"

@implementation CommonData

@end

@implementation CommonJsonModel

@end

@implementation CommonResultModel

- (id)initWithEmpty:(BOOL)emptyData {
    self = [super init];
    self.emptyData = emptyData;
    return self;
}

- (id)initWithError:(NSError *)errorInfo {
    self = [super init];
    self.errorInfo = errorInfo;
    return self;
}

@end

@implementation CommonDownloadModel

@end
