//
//  Macro.h
//  PowerBaseLibrary
//
//  Created by 邹程 on 2019/9/2.
//

#import "Environment.h"

#ifndef Macro_h
#define Macro_h

/****************  渠道定义 start  ****************************************************************/

#define APP_VERSION          [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_VERSION_INT      [APP_VERSION stringByReplacingOccurrencesOfString:@"." withString:@""].integerValue
#define BHCHANNEL            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"BHCHANNEL"]
#define BHCODE               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"BHCODE"]

// 友盟渠道号
#define U_MENG_APP_CHANEL_ID BHCHANNEL

/***************  配置区 start  ********************************************************************/


#define NAVGATION_BAR_HEIGHT FULL_SCREEN ? 88.0 : 64.0

#define FULL_SCREEN          CGSizeEqualToSize([[UIScreen mainScreen] bounds].size, CGSizeMake(375.0, 812.0))

#define IPHONE_X \
    ({ BOOL isPhoneX = NO; \
       if (@available(iOS 11.0, *)) { \
           isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0; \
       } \
       (isPhoneX); })

/***************  配置区 end  **********************************************************************/

#ifdef DEBUG // 开发阶段
#define NSLog(format, ...) printf("%s", [[NSString stringWithFormat:(format), ## __VA_ARGS__] UTF8String])
#else // 发布阶段
#define NSLog(...)
#endif

#define ACCESS_ID          @"accessID"
#define ID_COUNT           @"idCount"

#define ENVIRONMENT        [Environment sharedInstance]

//  打点
#define REQUEST_URL_SPREAD [NSString stringWithFormat:@"https://t%d.hunli.baihe.com", (arc4random() % 10) + 1]

#if !__has_feature(objc_arc)

#define WeakSelf           __block typeof(self) weakSelf = self

#else

#define WeakSelf           __weak typeof(self) weakSelf = self

#endif

#define RGBCOLOR(r, g, b)     [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]

#endif /* Macro_h */
