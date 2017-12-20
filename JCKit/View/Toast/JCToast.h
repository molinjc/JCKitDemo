//
//  JCToast.h
//  JCViewDevelop
//
//  Created by molin.JC on 2017/8/3.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCToastStyle;

@interface JCToast : NSObject
+ (void)makeToast:(NSString *)message;
+ (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration;
+ (void)makeToast:(NSString *)message style:(JCToastStyle *)style;
+ (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration style:(JCToastStyle *)style;
+ (void)makeToast:(NSString *)message inView:(UIView *)view duration:(NSTimeInterval)duration style:(JCToastStyle *)style;

+ (void)makeAttributedToast:(NSAttributedString *)attributed;
+ (void)makeAttributedToast:(NSAttributedString *)attributed style:(JCToastStyle *)style;
+ (void)makeAttributedToast:(NSAttributedString *)attributed duration:(NSTimeInterval)duration style:(JCToastStyle *)style;
+ (void)makeAttributedToast:(NSAttributedString *)attributed inView:(UIView *)view duration:(NSTimeInterval)duration style:(JCToastStyle *)style;
@end

@interface JCToastStyle : NSObject
/** 背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** 消息字体颜色 */
@property (nonatomic, strong) UIColor *messageColor;
/** 消息字体, 默认[UIFont systemFontOfSize:13.0] */
@property (nonatomic, strong) UIFont *messageFont;
/** 消息的对齐方式, 默认NSTextAlignmentCenter */
@property (nonatomic, assign) NSTextAlignment messageAlignment;
/** 消息换行 */
@property (nonatomic, assign) NSInteger messageNumberOfLines;
/** 圆角, 默认7px */
@property (nonatomic, assign) CGFloat cornerRadius;
/** 视图的高, 默认40 */
@property (nonatomic, assign) CGFloat height;
/** 在父视图的垂直位置, 默认85%处的位置 */
@property (nonatomic, assign) CGFloat verticalPadding;
/** 动画时长, 默认0.2s */
@property (nonatomic, assign) NSTimeInterval animateDuration;
/** 消息的距背景视图的距离, 内边距, 默认(5, 5, 5, 5) */
@property (nonatomic, assign) UIEdgeInsets messageEdgeInsets;
@end
