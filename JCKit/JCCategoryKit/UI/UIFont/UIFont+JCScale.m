//
//  UIFont+JCScale.m
//  JCAPPBaseFramework
//
//  Created by 林建川 on 16/8/14.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIFont+JCScale.h"
#import "NSString+JCString.h"
#import <CoreText/CoreText.h>

#if __has_include("UIView+JCLayout.h") 
#import "UIView+JCLayout.h"
#define _fontscale __scale
#else
#define _fontscale 1
#endif

@implementation UIFont (JCScale)

#pragma maek - 可调用

+ (UIFont *(^)(CGFloat))systemFont {
    return ^(CGFloat size) { return [UIFont systemFontOfSize:size]; };
}

+ (UIFont *(^)(CGFloat))boldSystemFont {
    return ^(CGFloat size) { return [UIFont boldSystemFontOfSize:size]; };
}

/// systemFontOfSize:
+ (UIFont *)scaleFontOfSize:(CGFloat)fontSize {
    fontSize *= _fontscale;
    return [UIFont systemFontOfSize:fontSize];
}

/// fontWithName:size:
+ (UIFont *)scaleFontWithName:(nonnull NSString *)fontName size:(CGFloat)fontSize {
    fontSize *= _fontscale;
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIFont *)fontNameWithHelveticaBold:(CGFloat)size {
    return [UIFont scaleFontWithName:@"Helvetica-Bold" size:size];
}

+ (UIFont *)fontNameWithHelveticaOblique:(CGFloat)size {
    return [UIFont scaleFontWithName:@"Helvetica-Oblique" size:size];
}

#pragma mark - TTF

/**
 加载本地TTF字体
 */
+ (UIFont *)fontWithTTFAtPath:(NSString *)path {
    return [UIFont fontWithTTFAtPath:path size:15.0f];
}

+ (UIFont *)fontWithTTFAtPath:(NSString *)path size:(CGFloat)size {
    BOOL foundFile = [[NSFileManager defaultManager] fileExistsAtPath:path];
    NSAssert(foundFile, @"没有找到在\"%@\"的字体", path);
    if (!foundFile) {
        return [UIFont systemFontOfSize:size];
    }
    
    CFURLRef fontURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)path, kCFURLPOSIXPathStyle, false);
    CGDataProviderRef dataProvider = CGDataProviderCreateWithURL(fontURL);
    CFRelease(fontURL);
    CGFontRef graphicsFont = CGFontCreateWithDataProvider(dataProvider);
    CFRelease(dataProvider);
    CTFontRef smallFont = CTFontCreateWithGraphicsFont(graphicsFont, size, NULL, NULL);
    CFRelease(graphicsFont);
    
    UIFont *returnFont = (__bridge UIFont *)smallFont;
    CFRelease(smallFont);
    
    return returnFont;
}

@end
