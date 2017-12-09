//
//  UIView+JCSkin.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/30.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UIView+JCTheme.h"
#import <objc/runtime.h>

#define _registerTheme  \
BOOL exist = [objc_getAssociatedObject(self, @selector(setTheme_backgroundColor:)) boolValue]; \
if (!exist) { \
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_themeUpdateColor) name:JCThemeUpdateNotification object:nil]; \
    objc_setAssociatedObject(self, @selector(setTheme_backgroundColor:), @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
    [self deallocUsingBoloc:^(UIView *sender) { \
        [[NSNotificationCenter defaultCenter] removeObserver:sender name:JCThemeUpdateNotification object:nil]; \
    }]; \
}

@implementation UIView (JCTheme)
@dynamic theme_backgroundColor;

- (void)setTheme_backgroundColor:(UIColor *)theme_backgroundColor {
    _registerTheme
    objc_setAssociatedObject(self, @selector(_themeUpdateColor), theme_backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _themeUpdateColor];
}

- (void)_themeUpdateColor {
    if ([JCThemeManage themeManage].nightTheme) {
        [self setBackgroundColor:[JCThemeManage themeManage].nightColor];
    } else {
        [self setBackgroundColor:objc_getAssociatedObject(self, _cmd)];
    }
}

@end

@implementation UINavigationBar (JCTheme)
@dynamic theme_tintColor, theme_barTintColor;

+ (void)load {
    swizzledMethod(self, @selector(setBackgroundImage:forBarMetrics:), @selector(theme_setBackgroundImage:forBarMetrics:));
}

- (void)theme_setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics {
    _registerTheme
    objc_setAssociatedObject(self, @selector(_themeUpdateBarTintColor), backgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTheme_barTintColor:(UIColor *)theme_barTintColor {
    _registerTheme
    objc_setAssociatedObject(self, @selector(_themeUpdateBarTintColor), theme_barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _themeUpdateColor];
}

- (void)setTheme_tintColor:(UIColor *)theme_tintColor {
    _registerTheme
    objc_setAssociatedObject(self, @selector(_themeUpdateTintColor), theme_tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self _themeUpdateColor];
}

- (void)_themeUpdateColor {
    [super _themeUpdateColor];
    [self _themeUpdateBarTintColor];
    [self _themeUpdateTintColor];
}

- (void)themeUpdateBackgroundImage {
    
}

- (void)_themeUpdateBarTintColor {
    if ([JCThemeManage themeManage].nightTheme) {
        [self setBarTintColor:[JCThemeManage themeManage].nightColor];
    } else {
        [self setBarTintColor:objc_getAssociatedObject(self, _cmd)];
    }
}

- (void)_themeUpdateTintColor {
    if ([JCThemeManage themeManage].nightTheme) {
        [self setTintColor:[JCThemeManage themeManage].nightColor];
    } else {
        [self setTintColor:objc_getAssociatedObject(self, _cmd)];
    }
}

@end

//@implementation UINavigationItem (JCTheme)
//@dynamic theme_textColor;
//
//- (void)setTheme_textColor:(UIColor *)theme_textColor {
//    _registerTheme
//    objc_setAssociatedObject(self, @selector(_themeUpdateColor), theme_textColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self _themeUpdateColor];
//}
//
//@end

#define _TextColorCore \
@dynamic theme_textColor; \
- (void)setTheme_textColor:(UIColor *)theme_textColor { \
    _registerTheme \
    objc_setAssociatedObject(self, @selector(_themeUpdateTextColor), theme_textColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
    [self _themeUpdateColor]; \
} \
- (void)_themeUpdateColor { \
    [super _themeUpdateColor]; \
    [self _themeUpdateTextColor]; \
} \
- (void)_themeUpdateTextColor { \
    if ([JCThemeManage themeManage].nightTheme) { \
        [self setTextColor:[JCThemeManage themeManage].nightTextColor]; \
    } else { \
        [self setTextColor:objc_getAssociatedObject(self, _cmd)]; \
    } \
}

@implementation UILabel (JCTheme)
_TextColorCore
@end

@implementation UITextField (JCTheme)
_TextColorCore
@end

@implementation UITextView (JCTheme)
_TextColorCore
@end
