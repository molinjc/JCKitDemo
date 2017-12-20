//
//  JCAlertController.h
//  JCViewDevelop
//
//  Created by molin.JC on 2017/8/4.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^alertActionBlock)(UIAlertAction *action);

@interface UIAlertAction (JCAlertAction)
- (void)setTextColor:(UIColor *)textColor;
@end

@interface JCAlertController : UIAlertController
/** 确定的弹框 */
+ (UIAlertController *)okAlertControllerWithTitle:(NSString *)title message:(NSString *)message handler:(alertActionBlock)handler;
/** 取消, 确定的弹框  */
+ (UIAlertController *)cancelAndOkAlertControllerWithTitle:(NSString *)title message:(NSString *)message handler:(alertActionBlock)handler;
/** 创建弹框 */
+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(NSArray <NSString *>*)actions handler:(alertActionBlock)handler;
/** 创建弹框, actions自定义 */
+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray <NSString *>*)actions handler:(alertActionBlock)handler;
/** 创建UIAlertControllerStyleAlert弹框, layout用于布局 */
+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray <NSString *>*)actions layout:(void (^)(UIAlertController *controller))layout handler:(alertActionBlock)handler;
/** 图片选择器弹框 */
+ (void)imagePickerAlertControllerWithViewController:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)viewController;
/** 图片选择器弹框, 取消有回调 */
+ (void)imagePickerAlertControllerWithViewController:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)viewController cancel:(void (^)())cancel;
@end

@interface JCAlertController (Custom)
/** 提示标题+确定按钮的弹框 */
+ (void)okAlertControllerWithController:(UIViewController *)viewControll message:(NSString *)message handler:(alertActionBlock)handler;
/** 确定弹框 */
+ (void)okAlertControllerWithController:(UIViewController *)viewControll title:(NSString *)title message:(NSString *)message handler:(alertActionBlock)handler;
/** 提示标题+取消+确定按钮的弹框 */
+ (void)cancelAndOkAlertControllerWithController:(UIViewController *)viewControll message:(NSString *)message ok:(alertActionBlock)ok cancel:(alertActionBlock)cancel;
/** 取消+确定按钮的弹框 */
+ (void)cancelAndOkAlertControllerWithController:(UIViewController *)viewControll title:(NSString *)title message:(NSString *)message ok:(alertActionBlock)ok cancel:(alertActionBlock)cancel;
/** 头像图片选取 */
+ (void)portraitImagePickerAlertControllerWithViewController:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)viewController;
/** 图片选取 */
+ (void)imagePickerAlertControllerWithTitle:(NSString *)titel viewController:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)viewController;
/** 保存图片 */
+ (void)keepImageAlertControllerWithKeep:(alertActionBlock)keep;
/** 热线电话 */
+ (void)hotlineAlertControllerWithController:(UIViewController *)viewControll;
/** 查看详情 */
+ (UIAlertController *)viewDetailsAlertControllerWithTitle:(NSString *)title handler:(alertActionBlock)handler;
@end
