//
//  JCToast.m
//  JCViewDevelop
//
//  Created by molin.JC on 2017/8/3.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCToast.h"
#import <objc/runtime.h>

static void *kToastStyle = "kToastStyle";

@interface JCToastStyle ()
@property (nonatomic, assign) NSTimeInterval pause;
@end

@implementation JCToastStyle

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0.174 alpha:1.000];
        self.cornerRadius = 7;
        self.messageNumberOfLines = 0;
        self.messageColor = [UIColor whiteColor];
        self.messageFont = [UIFont systemFontOfSize:13.0];
        self.messageAlignment = NSTextAlignmentLeft;
        self.height = 40;
        self.verticalPadding = 0.8;
        self.animateDuration = 0.2;
        self.pause = 2;
        self.messageEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
    }
    return self;
}

@end

@implementation JCToast

#pragma mark - NSString

+ (void)makeToast:(NSString *)message {
    [self makeToast:message duration:2];
}

+ (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration {
    [self makeToast:message duration:duration style:nil];
}

+ (void)makeToast:(NSString *)message style:(JCToastStyle *)style {
    [self makeToast:message duration:2 style:style];
}

+ (void)makeToast:(NSString *)message duration:(NSTimeInterval)duration style:(JCToastStyle *)style {
    [self makeToast:message inView:[[[UIApplication sharedApplication] delegate] window] duration:duration style:style];
}

+ (void)makeToast:(NSString *)message inView:(UIView *)view duration:(NSTimeInterval)duration style:(JCToastStyle *)style {
    UIView *toast = [view viewWithTag:976];
    if (toast) { return; }
    if (!style) { style = [JCToastStyle new];}
    toast = [self toastViewForMessage:message style:style];
    [self showToast:toast inView:view style:style duration:duration];
}

#pragma mark - NSAttributedString

+ (void)makeAttributedToast:(NSAttributedString *)attributed {
    [self makeAttributedToast:attributed style:nil];
}

+ (void)makeAttributedToast:(NSAttributedString *)attributed style:(JCToastStyle *)style {
    [self makeAttributedToast:attributed duration:2 style:style];
}

+ (void)makeAttributedToast:(NSAttributedString *)attributed duration:(NSTimeInterval)duration style:(JCToastStyle *)style {
    [self makeAttributedToast:attributed inView:[[[UIApplication sharedApplication] delegate] window] duration:duration style:style];
}

+ (void)makeAttributedToast:(NSAttributedString *)attributed inView:(UIView *)view duration:(NSTimeInterval)duration style:(JCToastStyle *)style {
    if (!style) { style = [JCToastStyle new]; }
    UIView *toast = [self toastViewForMessage:attributed.string style:style];
    UILabel *messageLabel = toast.subviews.firstObject;
    messageLabel.attributedText = attributed;
    CGRect rect = messageLabel.frame;
    rect.size = [messageLabel sizeThatFits:view.bounds.size];
    messageLabel.frame = rect;
    
    CGFloat w = style.messageEdgeInsets.left + style.messageEdgeInsets.right;
    CGFloat h = style.messageEdgeInsets.top + style.messageEdgeInsets.bottom;
    
    CGSize wrapperSize = CGSizeMake(MIN((rect.size.width + w), [UIScreen mainScreen].bounds.size.width - 10), rect.size.height + h);
    toast.frame = CGRectMake(0, 0, wrapperSize.width, wrapperSize.height);
    [self showToast:toast inView:view style:style duration:duration];
}

+ (UIView *)toastViewForMessage:(NSString *)message style:(JCToastStyle *)style {
    if (!message) { return nil; }
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.tag = 976;
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = style.cornerRadius;
    wrapperView.backgroundColor = style.backgroundColor;
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.numberOfLines = style.messageNumberOfLines;
    messageLabel.font = style.messageFont;
    messageLabel.textAlignment = style.messageAlignment;
    messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    messageLabel.textColor = style.messageColor;
    messageLabel.text = message;
    
    CGFloat w = style.messageEdgeInsets.left + style.messageEdgeInsets.right;
    CGFloat h = style.messageEdgeInsets.top + style.messageEdgeInsets.bottom;
    
    CGSize expectedSize = [messageLabel sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width * 0.8 - w, [UIScreen mainScreen].bounds.size.height)];
    expectedSize.height = MAX(expectedSize.height, style.height);
    expectedSize.width = MIN(expectedSize.width, [UIScreen mainScreen].bounds.size.width - style.messageEdgeInsets.left * 2);
    messageLabel.frame = CGRectMake(style.messageEdgeInsets.left, style.messageEdgeInsets.top, expectedSize.width, expectedSize.height);
    
    CGSize wrapperSize = CGSizeMake(MIN((expectedSize.width + w), [UIScreen mainScreen].bounds.size.width * 0.8), expectedSize.height + h);
    wrapperView.frame = CGRectMake(0, 0, wrapperSize.width, wrapperSize.height);
    [wrapperView addSubview:messageLabel];
    return wrapperView;
}

+ (void)showToast:(UIView *)toast inView:(UIView *)view style:(JCToastStyle *)style duration:(NSTimeInterval)duration {
    if (!toast || !view) { return; }
    
    toast.frame = CGRectMake((view.bounds.size.width - toast.frame.size.width) * 0.5, view.bounds.size.height, toast.frame.size.width, toast.frame.size.height);
    objc_setAssociatedObject(toast, kToastStyle, style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [view performSelectorOnMainThread:@selector(addSubview:) withObject:toast waitUntilDone:YES];
    CGFloat centerY = view.bounds.size.height * style.verticalPadding;
    UIView *keyBoardView = [self getKeyBoard];
    if (keyBoardView) {
        centerY = centerY > keyBoardView.frame.origin.y ? centerY - keyBoardView.frame.size.height : centerY;
        toast.frame = CGRectMake((view.bounds.size.width - toast.frame.size.width) * 0.5, view.bounds.size.height - keyBoardView.frame.size.height, toast.frame.size.width, toast.frame.size.height);
    }
    [UIView animateWithDuration:style.animateDuration animations:^{
        toast.center = CGPointMake(toast.center.x, centerY);
    } completion:^(BOOL finished) {
        [self performSelectorOnMainThread:@selector(toastStartCountdown:) withObject:toast waitUntilDone:YES];
    }];
}

+ (void)toastStartCountdown:(UIView *)toast {
    JCToastStyle *style = objc_getAssociatedObject(toast, kToastStyle);
    [NSTimer scheduledTimerWithTimeInterval:style.pause target:self selector:@selector(removeToastWithTimer:) userInfo:toast repeats:NO];
}

+ (void)removeToastWithTimer:(NSTimer *)timer {
    UIView *toast = [timer userInfo];
    JCToastStyle *style = objc_getAssociatedObject(toast, kToastStyle);
    
    [UIView animateWithDuration:style.animateDuration animations:^{
        CGRect rect = toast.frame;
        rect.origin.y = toast.superview.bounds.size.height;
        toast.frame = rect;
    } completion:^(BOOL finished) {
        [toast removeFromSuperview];
    }];
}

+ (UIView *)getKeyBoard {
    UIView *keyBoardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow*window in [windows reverseObjectEnumerator]) {
        keyBoardView = [self getKeyBoardInView:window];
        if (keyBoardView) {
            return keyBoardView;
        }
    }
    return nil;
}

+ (UIView *)getKeyBoardInView:(UIView *)view {
    for(UIView *subView in [view subviews]) {
        if (strstr(object_getClassName(subView), "UIKeyboard")) {
            return subView;
        }else{
            UIView *tempView = [self getKeyBoardInView:subView];
            if (tempView) {
                return tempView;
            }
        }
    }
    return nil;
}

@end
