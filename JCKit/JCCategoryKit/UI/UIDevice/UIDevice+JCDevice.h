//
//  UIDevice+JCDevice.h
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSystemVersion [UIDevice systemVersion]
#define iOS6Later (kSystemVersion >= 6)
#define iOS7Later (kSystemVersion >= 7)
#define iOS8Later (kSystemVersion >= 8)
#define iOS9Later (kSystemVersion >= 9)
#define iOS10Later (kSystemVersion >= 10)

@interface UIDevice (JCDevice)

/** 是否是iPad设备 */
@property (nonatomic, readonly) BOOL isPad;
/** 是否是iPhone设备 */
@property (nonatomic, readonly) BOOL isPhone;
/** 是否是模拟器 */
@property (nonatomic, readonly) BOOL isSimulator;
/** 是否已经越狱 */
@property (nonatomic, readonly) BOOL isJailbroken;
/** 是否能打电话 */
@property (nonatomic, readonly) BOOL canMakePhoneCalls;
/** 是否有摄像头 */
@property (nonatomic, readonly) BOOL hasCamera;
/** 获取设备号（如iPhone5,3、iPhone7,1...） */
@property (nonatomic, readonly) NSString *machineModel;
/** 获取设备名（如iPhone6、iPhone6s...） */
@property (nonatomic, readonly) NSString *machineModelName;
/** 系统启动时间 */
@property (nonatomic, readonly) NSDate *systemUptime;
/** 广告位标识符 */
@property (nonatomic, readonly) NSString *IDFA;

/**
 获取该设备的当前WIFI链接的IP地址
 @return @"192.168.1.111"/nil
 */
@property (nonatomic, readonly) NSString *ipAddressWIFI;

/**
 获取该设备手机网络的IP地址
 @return @"10.2.2.222"/nil
 */
@property (nonatomic, readonly) NSString *ipAddressCell;
/** 获取该设备的mac地址 */
@property (nonatomic, readonly) NSString *macAddress;

#pragma mark - 磁盘空间

/** 磁盘总空间，总的存储空间 */
@property (nonatomic, readonly) int64_t diskSpace;
/** 未使用的磁盘空间，空余存储空间 */
@property (nonatomic, readonly) int64_t diskSpaceFree;
/** 使用的磁盘空间，已使用的存储空间 */
@property (nonatomic, readonly) int64_t diskSpaceUsed;

#pragma mark - 内存信息

/** 总内存空间 */
@property (nonatomic, readonly) int64_t memoryTotal;
/** 正在使用的内存空间 */
@property (nonatomic, readonly) int64_t memoryUsed;
/** 空闲的内存空间 */
@property (nonatomic, readonly) int64_t memoryFree;
/** 活跃的内存空间 */
@property (nonatomic, readonly) int64_t memoryActive;
/** 不活跃的内存空间 */
@property (nonatomic, readonly) int64_t memoryInactive;
/** 存放内核的内存空间 */
@property (nonatomic, readonly) int64_t memoryWired;
/** 可释放的内存空间 */
@property (nonatomic, readonly) int64_t memoryPurgable;

#pragma mark - CPU

/** CPU数量 */
@property (nonatomic, readonly) NSUInteger CPUCount;
/** CPU总的使用百分比 */
@property (nonatomic, readonly) double CPUUsage;
/** 每个CPU的使用百分比 */
@property (nonatomic, readonly) NSArray *everyCPUUsage;

/** 系统版本 */
+ (float)systemVersion;

@end
