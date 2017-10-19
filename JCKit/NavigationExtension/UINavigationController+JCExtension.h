//
//  UINavigationController+JCExtension.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JCExtension)
/** 是否隐藏导航栏, 只隐藏本控制器的导航栏, 默认NO(不隐藏) */
@property (nonatomic, assign) BOOL navigationBarHidden;
/** 侧滑手势是否失效, 默认NO(不失效) */
@property (nonatomic, assign) BOOL popGestureInvalid;
@end

@interface UINavigationController (JCExtension) <UIGestureRecognizerDelegate>
/** 全屏侧滑返回 */
- (void)fullScreenInteractivePop:(BOOL)interactive;
@end
