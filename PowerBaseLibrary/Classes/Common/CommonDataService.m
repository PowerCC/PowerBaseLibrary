//
//  CommonDataService.m
//  BaiheWeddingApp
//
//  Created by 邹程 on 16/7/4.
//  Copyright © 2016年 Baihe Network Co., LTD. All rights reserved.
//

#import "CommonDataService.h"
#import "Macro.h"

@implementation CommonDataService

#pragma mark - 访客ID
+ (void)createAccessID {
    NSString *accessID = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_ID];
    
    if (!accessID || [accessID isEqualToString:@""] || accessID.length == 0) {
        NSDate *now = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        accessID = [formatter stringFromDate:now];
        accessID = [accessID stringByAppendingFormat:@"%d", (arc4random() % 999999) + 100000];
        
        [[NSUserDefaults standardUserDefaults] setObject:accessID forKey:ACCESS_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    ENVIRONMENT.accessID = accessID;
}

#pragma mark - 清除访客ID
+ (void)clearAccessID {
    ENVIRONMENT.accessID = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_ID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 保存打点计数
+ (void)saveIDCount {
    [ENVIRONMENT.countLock lock];
    
    if (ENVIRONMENT.idcount < NSIntegerMax) {
        NSLog(@"\n\n打点计数 idcount = %ld\n\n", (long)ENVIRONMENT.idcount);
        ENVIRONMENT.idcount = ENVIRONMENT.idcount + 1;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:ENVIRONMENT.idcount] forKey:ID_COUNT];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [ENVIRONMENT.countLock unlock];
}

#pragma mark - 获取当前时间戳有两种方法（以毫秒为单位）

+ (NSString *)getNowTimeTimestamp {
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//
////    //设置时区,这个对于时间的处理有时很重要
////
////    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//
//
//    [formatter setTimeZone:timeZone];
//
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//
////    NSString* sTimer = [formatter stringFromDate:datenow];
////
////    NSLog(sTimer);
//
//    NSString *timeSp = [NSString stringWithFormat:@"%lld", (long long)[datenow timeIntervalSince1970]*1000];
//
//    return timeSp;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];
    
    NSTimeInterval a = [datenow timeIntervalSince1970] * 1000;
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long int)a];
    
    return timeSp;
}

#pragma mark - 获取打点计数
+ (void)getIDCount {
    ENVIRONMENT.idcount = [[NSUserDefaults standardUserDefaults] objectForKey:ID_COUNT] == nil ? 0 : [[NSUserDefaults standardUserDefaults] integerForKey:ID_COUNT];
}

#pragma mark - 清除打点计数
+ (void)clearIDCount {
    ENVIRONMENT.idcount = 0;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ID_COUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - app打点
+ (void)appSpread:(nonnull NSString *)event spmCode:(nonnull NSString *)spm userId:(nullable NSString *)userId previousPageDidLoadSpmCode:(nullable NSString *)spmCode extend:(nullable NSString *)extend citycode:(nonnull NSString *)citycode {
    
    if ([ENVIRONMENT.phoneModel isEqualToString:@"iPhone Simulator (i386)"] || [ENVIRONMENT.phoneModel isEqualToString:@"iPhone Simulator (x86_64)"]) {
        return;
    }
    
    if (!event || event.length == 0) {
        return;
    }
    
    if (!spm || spm.length == 0) {
        return;
    }
    
    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setValue:BHCHANNEL forKey:@"channel"];
    [parameterDic setValue:ENVIRONMENT.accessID forKey:@"accessID"];
    [parameterDic setValue:APP_VERSION forKey:@"version"];
    
    [parameterDic setValue:event forKey:@"event"];
    [parameterDic setValue:spm forKey:@"spm"];
    [parameterDic setValue:citycode forKey:@"citycode"];
    [parameterDic setValue:spmCode forKey:@"from"];
    
    if (userId) {
        [parameterDic setValue:userId forKey:@"userID"];
    }
    
    [CommonDataService getIDCount];
    [parameterDic setValue:[NSString stringWithFormat:@"%ld", (long)ENVIRONMENT.idcount] forKey:@"idcount"];
    [CommonDataService saveIDCount];
    
    [CommonDataService getNowTimeTimestamp];
    
    // 添加时间戳
    NSString* localts = [CommonDataService getNowTimeTimestamp];
    
    [parameterDic setValue:localts forKey:@"localts"];
    
    
    NSString *defaultExtend = @"";
    
    if (ENVIRONMENT.uuID && ENVIRONMENT.uuID.length > 0) {
        defaultExtend = [NSString stringWithFormat:@"%@,%@", citycode, ENVIRONMENT.uuID];
    }
    else {
        defaultExtend = [NSString stringWithFormat:@"%@", citycode];
    }
    
    if (extend && extend.length > 0) {
        defaultExtend = [NSString stringWithFormat:@"%@,%@", defaultExtend, extend];
    }
    
    
    [parameterDic setValue:defaultExtend forKey:@"extend"];
    
    
//    BHBaseDataSource *dataSource = [[BHBaseDataSource alloc] init];
//    [dataSource sendGeneralRequestWithGET:REQUEST_URL_SPREAD requestParameters:parameterDic success:^(id object) {
//        NSLog(@"\n\n\napp打点成功 event:%@ spm:%@\n\n\n", event, spm);
//    } failure:^(NSError *error) {
//        NSLog(@"\n\n\napp打点失败 event:%@ spm:%@\n\n\n", event, spm);
//    }];
    
//    CommonDataSource *dataSource = [[CommonDataSource alloc] init];
//    
//    [dataSource appSpread:parameterDic success: ^(id object) {
//        DLog(@"\n\n\napp打点成功 event:%@ spm:%@\n\n\n", event, spm);
//    } failure: ^(NSError *error) {
//        DLog(@"\n\n\napp打点失败，将缓存至打点文件。 event:%@ spm:%@\n\n\n", event, spm);
//    }];
}

#pragma mark - app用户行为分析打点
+ (void)appSpread:(nonnull NSString *)event spmCode:(nonnull NSString *)spm userId:(nullable NSString *)userId previousPageDidLoadSpmCode:(nullable NSString *)spmCode extendDic:(nullable NSDictionary *)extendDic citycode:(nonnull NSString *)citycode {
    
    if ([ENVIRONMENT.phoneModel isEqualToString:@"iPhone Simulator (i386)"] || [ENVIRONMENT.phoneModel isEqualToString:@"iPhone Simulator (x86_64)"]) {
        return;
    }
    
    if (!event || event.length == 0) {
        return;
    }
    
    if (!spm || spm.length == 0) {
        return;
    }
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:extendDic];
    [tempDic setValue:ENVIRONMENT.cityCode forKey:@"citycode"];
    [tempDic setValue:userId forKey:@"userid"];
    [tempDic setValue:ENVIRONMENT.uuID forKey:@"uuid"];
    

    NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
    [parameterDic setValue:BHCHANNEL forKey:@"channel"];
    [parameterDic setValue:ENVIRONMENT.accessID forKey:@"accessID"];
    [parameterDic setValue:APP_VERSION forKey:@"version"];

    [parameterDic setValue:event forKey:@"event"];
    [parameterDic setValue:spm forKey:@"spm"];
    [parameterDic setValue:citycode forKey:@"citycode"];
    [parameterDic setValue:spmCode forKey:@"from"];

    if (userId) {
        [parameterDic setValue:userId forKey:@"userID"];
    }
    
    [CommonDataService getIDCount];
    [parameterDic setValue:[NSString stringWithFormat:@"%ld", (long)ENVIRONMENT.idcount] forKey:@"idcount"];
    [CommonDataService saveIDCount];
    
    // 添加时间戳
    NSString* localts = [CommonDataService getNowTimeTimestamp];
    
    [parameterDic setValue:localts forKey:@"localts"];
    
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:tempDic
                                                              options:kNilOptions
                                                                error:nil];
    NSString *tempjsonString = [[NSString alloc] initWithData:tempData encoding: NSUTF8StringEncoding];
    
    [parameterDic setValue:tempjsonString forKey:@"extend"];
    
    [parameterDic setValue:citycode forKey:@"citycode"];
    
//    BHBaseDataSource *dataSource = [[BHBaseDataSource alloc] init];
//    [dataSource sendGeneralRequestWithGET:REQUEST_URL_SPREAD requestParameters:parameterDic success:^(id object) {
//        NSLog(@"\n\n\napp用户行为打点成功 event:%@ spm:%@\n\n\n", event, spm);
//    } failure:^(NSError *error) {
//        NSLog(@"\n\n\napp用户行为打点失败 event:%@ spm:%@\n\n\n", event, spm);
//    }];
}

@end
