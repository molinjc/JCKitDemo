//
//  UIApplication+JCApplication.h
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APP(obj) ((obj *)[UIApplication appDelegate])
#define _SystemSet(path) [UIApplication openSystemSet:path]

/** 系统设置无线局域网项的路径 */
FOUNDATION_EXPORT NSString * const kSystemSetWIFI;
/** 蓝牙 */
FOUNDATION_EXPORT NSString * const kSystemSetBluetooth;
/** 蜂窝移动网络 */
FOUNDATION_EXPORT NSString * const kSystemSetMobile;
/** 个人热点 */
FOUNDATION_EXPORT NSString * const kSystemSetInternet;
/** 运营商 */
FOUNDATION_EXPORT NSString * const kSystemSetCarrier;
/** 通知 */
FOUNDATION_EXPORT NSString * const kSystemSetNotification;
/** 通用 */
FOUNDATION_EXPORT NSString * const kSystemSetGeneral;
/** 通用-关于本机 */
FOUNDATION_EXPORT NSString * const kSystemSetGeneralAbout;
/** 通用-键盘 */
FOUNDATION_EXPORT NSString * const kSystemSetGeneralKeyboard;
/** 通用-辅助功能 */
FOUNDATION_EXPORT NSString * const kSystemSetGeneralAccessibility;
/** 通用-语言与地区 */
FOUNDATION_EXPORT NSString * const kSystemSetGeneralInternational;
/** 通用-还原 */
FOUNDATION_EXPORT NSString * const kSystemSetGeneralReset;
/** 墙纸 */
FOUNDATION_EXPORT NSString * const kSystemSetWallpaper;
/** Siri */
FOUNDATION_EXPORT NSString * const kSystemSetSiri;
/** 隐私 */
FOUNDATION_EXPORT NSString * const kSystemSetPrivacy;
/** Safari */
FOUNDATION_EXPORT NSString * const kSystemSetSafari;
/** 音乐 */
FOUNDATION_EXPORT NSString * const kSystemSetMusic;
/** 音乐-均衡器 */
FOUNDATION_EXPORT NSString * const kSystemSetMusicEQ;
/** 照片与相机 */
FOUNDATION_EXPORT NSString * const kSystemSetPhotos;
/** FaceTime */
FOUNDATION_EXPORT NSString * const kSystemSetFaceTime;

@interface UIApplication (JCApplication)

@property (nonatomic, readonly) NSString *appBundleName;   // < Bundle Name >
@property (nonatomic, readonly) NSString *appBundleID;     // < Bundle ID >
@property (nonatomic, readonly) NSString *appVersion;      // < app版本 >
@property (nonatomic, readonly) NSString *appBuildVersion; // < Bundle版本 >
@property (nonatomic, readonly) BOOL isPirated;            // < 判断程序是否为从AppStore安装,否则是盗版 >
@property (nonatomic, readonly) BOOL isBeingDebugged;      // < 是否为调试模式 >

/** 手动更改状态栏的颜色 */
- (void)setStatusBarBackgoundColor:(UIColor *)color;
/** 拨打电话 */
+ (void)call:(NSString *)phone;
/** 隐藏键盘 */
+ (void)hideKeyboard;
/** 返回AppDelegate对象 */
+ (id)appDelegate;
/** 打开系统的设置, 使用上面的字段 */
+ (void)openSystemSet:(NSString *)path;
@end
