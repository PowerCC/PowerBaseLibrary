//
//  Environment.m
//  BaseLibrary
//
//  Created by 邹程 on 2019/9/2.
//

#import <sys/utsname.h>
#import "Environment.h"

@implementation Environment

static Environment *sharedInst = nil;

+ (id)allocWithZone:(struct _NSZone *)zone {
    // 调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInst = [super allocWithZone:zone];
    });
    return sharedInst;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInst = [[Environment alloc] init];
    });
    return sharedInst;
}

- (id)copyWithZone:(NSZone *)zone {
    return sharedInst;
}

#pragma mark - 获取os版本
- (nonnull NSString *)os {
    UIDevice *device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%@_%@", [device systemName], [device systemVersion]];
}

#pragma mark - 获取设备型号
- (nonnull NSString *)phoneModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";

    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";

    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";

    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";

    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";

    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";

    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524/A1593)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586/A1589)";

    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1700)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1699)";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhone SE (1st generation)";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE (1st generation)";

    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";

    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";

    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";

    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone12,8"]) return @"iPhone SE (2nd generation)";

    if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
    if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";

    if ([platform isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";
    if ([platform isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";
    if ([platform isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
    if ([platform isEqualToString:@"iPhone14,5"]) return @"iPhone 13";
    
    if ([platform isEqualToString:@"iPhone14,6"]) return @"iPhone SE (3rd generation)";
    
    if ([platform isEqualToString:@"iPhone14,7"]) return @"iPhone 14";
    if ([platform isEqualToString:@"iPhone14,8"]) return @"iPhone 14 Plus";
    if ([platform isEqualToString:@"iPhone15,2"]) return @"iPhone 14 Pro";
    if ([platform isEqualToString:@"iPhone15,3"]) return @"iPhone 14 Pro Max";
    
    if ([platform isEqualToString:@"iPhone15,4"]) return @"iPhone 15";
    if ([platform isEqualToString:@"iPhone15,5"]) return @"iPhone 15 Plus";
    if ([platform isEqualToString:@"iPhone16,1"]) return @"iPhone 15 Pro";
    if ([platform isEqualToString:@"iPhone16,2"]) return @"iPhone 15 Pro Max";

    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch (A1213)";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod touch (2th generation)";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod touch (3th generation)";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod touch (4th generation)";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod touch (5th generation)";
    if ([platform isEqualToString:@"iPod7,1"]) return @"iPod touch (6th generation)";
    if ([platform isEqualToString:@"iPod9,1"]) return @"iPod touch (7th generation)";

    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad (A1219/A1337)";

    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2 (A1395 + New Chip)";
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini (A1432)";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini (A1454)";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini (A1455)";

    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad (3rd generation) (A1416)";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad (3rd generation) (A1403)";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad (3rd generation) (A1430)";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad (4th generation) (A1458)";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad (4th generation) (A1459)";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad (4th generation) (A1460)";

    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2 (A1489)";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2 (A1490)";
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2 (A1491)";
    if ([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3 (A1599)";
    if ([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3 (A1600)";
    if ([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3 (A1601)";

    if ([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4 (A1538)";
    if ([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4 (A1550)";
    if ([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2 (A1566)";
    if ([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2 (A1567)";

    if ([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro (9.7-inch)";
    if ([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro (12.9-inch)";
    if ([platform isEqualToString:@"iPad6,11"]) return @"iPad (5th generation) (A1822)";
    if ([platform isEqualToString:@"iPad6,12"]) return @"iPad (5th generation) (A1823)";

    if ([platform isEqualToString:@"iPad7,1"]) return @"iPad Pro (12.9-inch) (2nd generation) (A1670)";
    if ([platform isEqualToString:@"iPad7,2"]) return @"iPad Pro (12.9-inch) (2nd generation) (A1671/A1821)";
    if ([platform isEqualToString:@"iPad7,3"]) return @"iPad Pro (10.5-inch) (A1701)";
    if ([platform isEqualToString:@"iPad7,4"]) return @"iPad Pro (10.5-inch) (A1709)";
    if ([platform isEqualToString:@"iPad7,5"]) return @"iPad (6th generation) (A1893)";
    if ([platform isEqualToString:@"iPad7,6"]) return @"iPad (6th generation) (A1954)";
    if ([platform isEqualToString:@"iPad7,11"]) return @"iPad (7th generation) (A2197)";
    if ([platform isEqualToString:@"iPad7,12"]) return @"iPad (7th generation) (A2198/A2200)";

    if ([platform isEqualToString:@"iPad8,1"]) return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,2"]) return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,3"]) return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,4"]) return @"iPad Pro (11-inch)";
    if ([platform isEqualToString:@"iPad8,5"]) return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([platform isEqualToString:@"iPad8,6"]) return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([platform isEqualToString:@"iPad8,7"]) return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([platform isEqualToString:@"iPad8,8"]) return @"iPad Pro (12.9-inch) (3rd generation)";
    if ([platform isEqualToString:@"iPad8,9"]) return @"iPad Pro (11-inch) (2nd generation)";
    if ([platform isEqualToString:@"iPad8,10"]) return @"iPad Pro (11-inch) (2nd generation)";
    if ([platform isEqualToString:@"iPad8,11"]) return @"iPad Pro (12.9-inch) (4th generation)";
    if ([platform isEqualToString:@"iPad8,12"]) return @"iPad Pro (12.9-inch) (4th generation)";

    if ([platform isEqualToString:@"iPad11,1"]) return @"iPad mini (5th generation) (A2133)";
    if ([platform isEqualToString:@"iPad11,2"]) return @"iPad mini (5th generation) (A2124/A2125/A2126)";
    if ([platform isEqualToString:@"iPad11,3"]) return @"iPad Air (3rd generation) (A2152)";
    if ([platform isEqualToString:@"iPad11,4"]) return @"iPad Air (3rd generation) (A2123/A2153/A2154)";
    if ([platform isEqualToString:@"iPad11,6"]) return @"iPad (8th generation) (A2270)";
    if ([platform isEqualToString:@"iPad11,7"]) return @"iPad (8th generation) (A2428/A2429/A2430)";

    if ([platform isEqualToString:@"iPad12,1"]) return @"iPad (9th generation)";
    if ([platform isEqualToString:@"iPad12,2"]) return @"iPad (9th generation) (A2603/A2604/A2605)";

    if ([platform isEqualToString:@"iPad13,1"]) return @"iPad Air (4th generation)";
    if ([platform isEqualToString:@"iPad13,2"]) return @"iPad Air (4th generation) (A2324/A2072)";
    if ([platform isEqualToString:@"iPad13,4"]) return @"iPad Pro (11-inch) (3rd generation)";
    if ([platform isEqualToString:@"iPad13,5"]) return @"iPad Pro (11-inch) (3rd generation)";
    if ([platform isEqualToString:@"iPad13,6"]) return @"iPad Pro (11-inch) (3rd generation)";
    if ([platform isEqualToString:@"iPad13,7"]) return @"iPad Pro (11-inch) (3rd generation)";
    if ([platform isEqualToString:@"iPad13,8"]) return @"iPad Pro (12.9-inch) (5th generation)";
    if ([platform isEqualToString:@"iPad13,9"]) return @"iPad Pro (12.9-inch) (5th generation)";
    if ([platform isEqualToString:@"iPad13,10"]) return @"iPad Pro (12.9-inch) (5th generation)";
    if ([platform isEqualToString:@"iPad13,11"]) return @"iPad Pro (12.9-inch) (5th generation)";
    if ([platform isEqualToString:@"iPad13,16"]) return @"iPad Air (5th generation) (A2588)";
    if ([platform isEqualToString:@"iPad13,17"]) return @"iPad Air (5th generation) (A2589/A2591)";
    if ([platform isEqualToString:@"iPad13,18"]) return @"iPad (10th generation)";
    if ([platform isEqualToString:@"iPad13,19"]) return @"iPad (10th generation)";
    

    if ([platform isEqualToString:@"iPad14,1"]) return @"iPad mini (6th generation)";
    if ([platform isEqualToString:@"iPad14,2"]) return @"iPad mini (6th generation)";
    if ([platform isEqualToString:@"iPad14,3"]) return @"iPad Pro (11-inch) (4rd generation)";
    if ([platform isEqualToString:@"iPad14,4"]) return @"iPad Pro (11-inch) (4rd generation)";
    if ([platform isEqualToString:@"iPad14,5"]) return @"iPad Pro (12.9-inch) (6th generation)";
    if ([platform isEqualToString:@"iPad14,6"]) return @"iPad Pro (12.9-inch) (6th generation)";

    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator (i386)";
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator (x86_64)";
    return platform;
}

- (BOOL)iPhonePlus {
#if ITTDEBUG

    return deviceScreenRelative.width == 414;
#else

    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([platform isEqualToString:@"iPhone7,1"]) return YES;
    if ([platform isEqualToString:@"iPhone8,2"]) return YES;
    if ([platform isEqualToString:@"iPhone9,2"]) return YES;
    if ([platform isEqualToString:@"iPhone9,4"]) return YES;
    if ([platform isEqualToString:@"iPhone10,2"]) return YES;
    if ([platform isEqualToString:@"iPhone10,5"]) return YES;
    return NO;

#endif
}

- (NSLock *)countLock {
    if (_countLock == nil) {
        _countLock = [[NSLock alloc] init];
    }

    return _countLock;
}

@end
