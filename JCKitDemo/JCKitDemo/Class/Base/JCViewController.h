//
//  JCViewController.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/10.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCViewController : UIViewController
/** 导航栏的高度 */
@property (nonatomic, readonly) CGFloat navigationHeight;
/** 导航栏的Y */
@property (nonatomic, readonly) CGFloat navigationY;
/** 标签栏的高度 */
@property (nonatomic, readonly) CGFloat tabHeight;
/** 标签栏底部的空隙 */
@property (nonatomic, readonly) CGFloat tabBottom;
/** 状态栏的高度 */
@property (nonatomic, readonly) CGFloat statusHeight;
@end
