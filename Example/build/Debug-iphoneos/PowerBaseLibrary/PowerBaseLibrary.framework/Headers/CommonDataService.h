//
//  CommonDataService.h
//  BaiheWeddingApp
//
//  Created by 邹程 on 16/7/4.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonDataService : NSObject

+ (void)createAccessID;

+ (void)clearAccessID;
    
+ (void)appSpread:(nonnull NSString *)event spmCode:(nonnull NSString *)spm userId:(nullable NSString *)userId previousPageDidLoadSpmCode:(nullable NSString *)spmCode extend:(nullable NSString *)extend citycode:(nonnull NSString *)citycode;

+ (void)appSpread:(nonnull NSString *)event spmCode:(nonnull NSString *)spm userId:(nullable NSString *)userId previousPageDidLoadSpmCode:(nullable NSString *)spmCode extendDic:(nullable NSDictionary *)extendDic citycode:(nonnull NSString *)citycode;


@end
