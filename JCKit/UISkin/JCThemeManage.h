//
//  JCSkinManage.h
//  JCSkinManage
//
//  Created by molin.JC on 2017/10/20.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 主题模式的通知名 */
extern NSString * const JCThemeUpdateNotification;

/** 主题皮肤的管理 */
@interface JCThemeManage : NSObject

/** 单例 */
+ (JCThemeManage *)themeManage;
/** 夜间模式下的背景颜色 */
@property (nonatomic, strong) UIColor *nightColor;
/** 夜间模式下的字体颜色 */
@property (nonatomic, strong) UIColor *nightTextColor;
/** 夜间模式下的图片颜色 */
@property (nonatomic, strong) UIColor *nightImageColor;
/** 设置夜间模式, 默认:NO(白天模式) */
@property (nonatomic, assign) BOOL nightTheme;
@end
