//
//  UTAlert.h
//
//  Created by molin.JC on 2017/9/13.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UTAlertStyle, UTAlertAction;

@interface UTAlert : NSObject
/** 创建 */
+ (UTAlert *)alertWithTitle:(NSString *)title message:(NSString *)message style:(UTAlertStyle *)style;
/** 创建 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message style:(UTAlertStyle *)style;
/** 添加按钮 */
- (void)addAlertAction:(UTAlertAction *)alertAction;
/** 显示 */
- (void)show;
/** 消失 */
- (void)disappear;
@end

@interface UTAlert (UTAdd)
/** 创建默认action(取消、确定)的Alert, 确定有回调 */
+ (void)defaulActionAlertWithTitle:(NSString *)title message:(NSString *)message backcall:(void (^)())backcall;
/** 未设置支付密码的Alert */
+ (void)payPawAlertWithTitle:(NSString *)title backcall:(void (^)())backcall;
/** 余额不足 */
+ (void)rechargeAlertWithTitle:(NSString *)title cancel:(void (^)())cancel recharge:(void (^)())recharge;
/** 重新输入密码 */
+ (void)reenterAlertWithTitle:(NSString *)title cancel:(void (^)())cancel reenter:(void (^)())reenter;
/** 设置支付密码 */
+ (void)setupAlertWithTitle:(NSString *)title cancel:(void (^)())cancel setup:(void (^)())setup;
@end


@interface UTAlertAction : NSObject
/** 背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** 字体大小 */
@property (nonatomic, strong) UIFont *font;
/** 字体颜色 */
@property (nonatomic, strong) UIColor *textColor;
/** 按钮的标题 */
@property (nonatomic, copy) NSString *title;
/** 按钮的图标 */
@property (nonatomic, strong) UIImage *image;
/** 回调 */
@property (nonatomic, copy) void (^action)();
@end

@interface UTAlertStyle : NSObject
/** 背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** 内容的背景颜色 */
@property (nonatomic, strong) UIColor *contentBackgroundColor;
/** 标题字体颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 消息字体颜色 */
@property (nonatomic, strong) UIColor *messageColor;
/** 标题字体 */
@property (nonatomic, strong) UIFont *titleFont;
/** 消息字体 */
@property (nonatomic, strong) UIFont *messageFont;
/** 消息的对齐方式, 默认NSTextAlignmentLeft */
@property (nonatomic, assign) NSTextAlignment messageAlignment;
/** 消息换行 */
@property (nonatomic, assign) NSInteger messageNumberOfLines;
/** 圆角, 默认4px */
@property (nonatomic, assign) CGFloat cornerRadius;
/** 视图的高, 默认150 */
@property (nonatomic, assign) CGFloat height;
/** 按钮的高, 默认50 */
@property (nonatomic, assign) CGFloat alertActionHeight;
/** 在父视图的垂直位置, 默认0.5处的位置 */
@property (nonatomic, assign) CGFloat verticalPadding;
/** 标题下的横线 */
@property (nonatomic, assign) BOOL titleLineHidden;
/** 是否设置按钮的边框, 默认为NO */
@property (nonatomic, assign) BOOL alertActionBorder;
/** 按钮的边框颜色 */
@property (nonatomic, strong) UIColor *alertActionBorderColor;
/** 按钮的边框宽度 */
@property (nonatomic, assign) CGFloat alertActionBordeWidth;
@end
