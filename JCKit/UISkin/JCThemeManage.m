//
//  JCSkinManage.m
//  JCSkinManage
//
//  Created by molin.JC on 2017/10/20.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCThemeManage.h"

NSString * const JCThemeUpdateNotification = @"JCThemeUpdateNotification";

@implementation JCThemeManage

+ (JCThemeManage *)themeManage {
    static JCThemeManage *manage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manage = [[JCThemeManage alloc] init];
    });
    return manage;
}

- (instancetype)init {
    if (self = [super init]) {
        _nightColor = _RGB16(0x343434);
        _nightTextColor = _nightImageColor =  _RGB16(0xffffff);
    }
    return self;
}

- (void)setNightTheme:(BOOL)nightTheme {
    _nightTheme = nightTheme;
    [[NSNotificationCenter defaultCenter] postNotificationName:JCThemeUpdateNotification object:nil];
}

@end
