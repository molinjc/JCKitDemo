//
//  UIScreen+JCScale.h
//
//  Created by 林建川 on 16/8/14.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (JCScreen)
/** 屏幕大小 */
@property (nonatomic, readonly) CGSize size;

/** 获取当前屏幕的bounds */
- (CGRect)currentBounds;

/**
 根据屏幕的旋转方向设置bounds
 @param orientation 界面的当前旋转方向
 */
- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation;

@end
