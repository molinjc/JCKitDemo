//
//  JCAlertController.m
//  JCViewDevelop
//
//  Created by molin.JC on 2017/8/4.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCAlertController.h"
#import <objc/runtime.h>

@implementation UIAlertAction (JCAlertAction)
- (void)setTextColor:(UIColor *)textColor {
    if (iOS9Later) {
        [self setValue:textColor forKey:@"titleTextColor"];
    }
}
@end

@interface UIAlertController (layout)
@property (nonatomic, copy) void (^willLayoutSubviews)(UIAlertController *controller);
@end

@implementation UIAlertController (layout)
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.willLayoutSubviews) { self.willLayoutSubviews(self); }
}

- (void)setWillLayoutSubviews:(void (^)(UIAlertController *))willLayoutSubviews {
    objc_setAssociatedObject(self, _cmd, [willLayoutSubviews copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIAlertController *))willLayoutSubviews {
    return objc_getAssociatedObject(self, @selector(setWillLayoutSubviews:));
}

- (void)_setMessgae:(NSAttributedString *)attr {
    [self setValue:attr forKey:@"attributedMessage"];
}

@end

@interface JCAlertController ()

@end

@implementation JCAlertController

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(NSArray <NSString *>*)actions handler:(alertActionBlock)handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    for (NSString *key in actions) {
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:key style:UIAlertActionStyleDefault handler:handler];
        [alertController addAction:alertAction];
    }
    return alertController;
}

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray <NSString *>*)actions handler:(alertActionBlock)handler {
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert actions:actions handler:handler];
}

+ (UIAlertController *)okAlertControllerWithTitle:(NSString *)title message:(NSString *)message handler:(alertActionBlock)handler {
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert actions:@[@"确定"] handler:handler];
}

+ (UIAlertController *)cancelAndOkAlertControllerWithTitle:(NSString *)title message:(NSString *)message handler:(alertActionBlock)handler {
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert actions:@[@"取消", @"确定"] handler:handler];
}

+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray <NSString *>*)actions layout:(void (^)(UIAlertController *controller))layout handler:(alertActionBlock)handler {
    UIAlertController *alertController = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert actions:actions handler:handler];
    alertController.willLayoutSubviews = [layout copy];
    return alertController;
}

+ (void)imagePickerAlertControllerWithViewController:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)viewController {
    [self imagePickerAlertControllerWithViewController:viewController cancel:nil];
}

+ (void)imagePickerAlertControllerWithViewController:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)viewController cancel:(void (^)())cancel {
    UIAlertController *alertController = [self alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet actions:@[@"拍照", @"相册"] handler:^(UIAlertAction *action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = viewController;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = [action.title isEqualToString:@"拍照"] ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
        [viewController presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
         if (cancel) { cancel(); }
    }];
    [alertController addAction:cancelAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

@end

@implementation JCAlertController (Custom)

+ (void)okAlertControllerWithController:(UIViewController *)viewControll message:(NSString *)message handler:(alertActionBlock)handler {
    UIAlertController *alertController = [self okAlertControllerWithTitle:@"提示" message:message handler:handler];
    [viewControll presentViewController:alertController animated:YES completion:nil];
}

+ (void)okAlertControllerWithController:(UIViewController *)viewControll title:(NSString *)title message:(NSString *)message handler:(alertActionBlock)handler {
    UIAlertController *alertController = [self okAlertControllerWithTitle:title message:message handler:handler];
    [viewControll presentViewController:alertController animated:YES completion:nil];
}

+ (void)cancelAndOkAlertControllerWithController:(UIViewController *)viewControll message:(NSString *)message ok:(alertActionBlock)ok cancel:(alertActionBlock)cancel {
    [self cancelAndOkAlertControllerWithController:viewControll title:@"提示" message:message ok:ok cancel:cancel];
}

+ (void)cancelAndOkAlertControllerWithController:(UIViewController *)viewControll title:(NSString *)title message:(NSString *)message ok:(alertActionBlock)ok cancel:(alertActionBlock)cancel {
    UIAlertController *alertController = [self cancelAndOkAlertControllerWithTitle:title message:message handler:^(UIAlertAction *action) {
        if ([action.title isEqualToString:@"确定"]) {
            if (ok) { ok(action); }
        } else if (cancel) {
            cancel(action);
        }
    }];
    [viewControll presentViewController:alertController animated:YES completion:nil];
}

+ (void)portraitImagePickerAlertControllerWithViewController:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> *)viewController {
    [self imagePickerAlertControllerWithTitle:@"修改用户头像" viewController:viewController];
}

+ (void)imagePickerAlertControllerWithTitle:(NSString *)titel viewController:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)viewController {
    UIAlertController *alertController = [self alertControllerWithTitle:titel message:nil preferredStyle:UIAlertControllerStyleActionSheet actions:@[@"拍照", @"相册"] handler:^(UIAlertAction *action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = viewController;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = [action.title isEqualToString:@"拍照"] ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
        [viewController presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    for (UIAlertAction *action in alertController.actions) {
        [action setTextColor:_RGB16(0x333333)];
    }
    
    if ([alertController valueForKey:@"attributedTitle"]) {
        NSAttributedString *titleAttribute = [[NSAttributedString alloc] initWithString:titel attributes:@{NSForegroundColorAttributeName: _RGB16(0x999999), NSFontAttributeName: [UIFont systemFontOfSize:13]}];
        [alertController setValue:titleAttribute forKey:@"attributedTitle"];
    }
    [cancelAction setTextColor:_RGB16(0xff5400)];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)keepImageAlertControllerWithKeep:(alertActionBlock)keep {
    UIAlertController *alertController = [self alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet actions:@[@"保存到相册"] handler:keep];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)hotlineAlertControllerWithController:(UIViewController *)viewControll {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"56物流" message:@"24小时服务热线" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action_phone = [UIAlertAction actionWithTitle:@"400-1688-956" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [UIApplication call:@"4001688956"];
    }];
    
    UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:action_phone];
    [alertController addAction:action_cancel];
    
    NSMutableAttributedString *titleAttribute = [[NSMutableAttributedString alloc] initWithString:@"56物流"];
    [titleAttribute addAttribute:NSForegroundColorAttributeName value:_RGB16(0x777777) range:NSMakeRange(0, titleAttribute.string.length)];
    [titleAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, titleAttribute.string.length)];
    if ([alertController valueForKey:@"attributedTitle"]) {
        [alertController setValue:titleAttribute forKey:@"attributedTitle"];
    }
    
    NSMutableAttributedString *messageAttribute = [[NSMutableAttributedString alloc] initWithString:@"24小时服务热线"];
    [messageAttribute addAttribute:NSForegroundColorAttributeName value:_RGB16(0xB1B1B1) range:NSMakeRange(0, messageAttribute.string.length)];
    [messageAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, messageAttribute.string.length)];
    if ([alertController valueForKey:@"attributedMessage"]) {
        [alertController setValue:messageAttribute forKey:@"attributedMessage"];
    }
    
    [action_phone setTextColor:_RGB16(0x10A1f1)];
    [action_cancel setTextColor:_RGB16(0x999999)];
    [viewControll presentViewController:alertController animated:YES completion:nil];
}

+ (UIAlertController *)viewDetailsAlertControllerWithTitle:(NSString *)title handler:(alertActionBlock)handler {
    UIAlertController *alertController = [self alertControllerWithTitle:title message:@"" actions:@[@"查看详情"] handler:handler];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = _RGB16(0xE54871);
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"自动报价仅供参考，具体价格以人工报价为准。";
    [alertController.view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"ic_warn.png"];
    [alertController.view addSubview:imageView];
    imageView.layoutLeft(17).layoutTop(44).layoutSize(imageView.image.size);
    label.layoutLeft(38).layoutEqualCenterY(imageView, 0).layoutHeight(20).layoutRight(0);
    
    return alertController;
}

@end
