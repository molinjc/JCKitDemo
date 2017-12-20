//
//  UTAlert.m
//
//  Created by molin.JC on 2017/9/13.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UTAlert.h"
#import <objc/runtime.h>
#import "UIBezierPath+JCBezierPath.h"

@implementation UTAlertAction

- (instancetype)init {
    if (self = [super init]) {
        _backgroundColor = [UIColor whiteColor];
        _font = [UIFont systemFontOfSize:16];
        _textColor = [UIColor blackColor];
    }
    return self;
}

@end

@implementation UTAlertStyle

- (instancetype)init {
    if (self = [super init]) {
        _backgroundColor = _RGBA16(0x000000, 0.3);
        _contentBackgroundColor = [UIColor whiteColor];
        _titleFont = [UIFont systemFontOfSize:17];
        _titleColor = _RGB16(0xff6317);
        _messageFont = [UIFont systemFontOfSize:14];
        _messageColor = _RGB16(0x333333);
        _messageAlignment = NSTextAlignmentLeft;
        _messageNumberOfLines = 0;
        _cornerRadius = 4;
        _height = 150;
        _alertActionHeight = 50;
        _verticalPadding = 0.5;
    }
    return self;
}

@end

@interface UTAlert ()
@property (nonatomic, strong) UTAlertStyle *style;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) CALayer *titleLine;
@property (nonatomic, strong) NSMutableArray *alertActions;
@end

@implementation UTAlert

- (void)dealloc {
    JCLog(@"<UTAlert dealloc>");
}

+ (UTAlert *)alertWithTitle:(NSString *)title message:(NSString *)message {
    return [[self alloc] initWithTitle:title message:message style:nil];
}

+ (UTAlert *)alertWithTitle:(NSString *)title message:(NSString *)message style:(UTAlertStyle *)style {
    return [[self alloc] initWithTitle:title message:message style:style];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message style:(UTAlertStyle *)style {
    if (self = [super init]) {
        _style = style;
        if (!_style) { _style = [UTAlertStyle new]; }
        _alertActions = @[].mutableCopy;
        [self _initView];
        _titleLabel.text = title;
        _messageLabel.text = message;
        if (title && message) {
            _titleLabel.frame = CGRectMake(0, 0, _contentView.width, 40);
            _messageLabel.frame = CGRectMake(15, _titleLabel.bottom, _contentView.width - 30, 60);
        }else if (!title && message) {
            _messageLabel.frame = CGRectMake(15, _titleLabel.bottom, _contentView.width - 30, _contentView.height - _style.alertActionHeight);
        }else if (title && !message) {
            _titleLabel.frame = CGRectMake(0, 0, _contentView.width, _contentView.height - _style.alertActionHeight);
        }
    }
    return self;
}

- (void)addAlertAction:(UTAlertAction *)alertAction {
    [_alertActions addObject:alertAction];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = _alertActions.count + 100;
    if (alertAction.title) {
        button.titleSet(alertAction.title).titleColorSet(alertAction.textColor).fontSet(alertAction.font);
    }
    if (alertAction.image) {
        button.imageSet(alertAction.image);
    }
    button.backgroundColor = alertAction.backgroundColor;
    [_contentView addSubview:button];
    
    CGFloat w = _contentView.width / _alertActions.count;
    for (NSInteger i = 0; i < _alertActions.count; i++) {
        UIButton *subview = [_contentView viewWithTag:i + 101];
        subview.frame = CGRectMake(w * i, _contentView.height - _style.alertActionHeight, w, _style.alertActionHeight);
    }
}

- (void)drawAlertActionBorder {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = _style.alertActionBorderColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = _style.alertActionBordeWidth;
    
    UIBezierPath *path = [UIBezierPath newPath];
    path.moveTo(CGPointMake(0, _contentView.height - _style.alertActionHeight));
    path.addLineTo(CGPointMake(_contentView.width, _contentView.height - _style.alertActionHeight));
    if (_alertActions.count > 1) {
        CGFloat w = _contentView.width / _alertActions.count;
        for (NSInteger i = 1; i < _alertActions.count; i++) {
            path.moveTo(CGPointMake(w * i, _contentView.height - _style.alertActionHeight));
            path.addLineTo(CGPointMake(w * i, _contentView.height));
        }
    }
    layer.path = path.CGPath;
    [_contentView.layer addSublayer:layer];
}

- (void)show {
    if (_style.alertActionBorder) { [self drawAlertActionBorder]; }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_backgroundView];
    objc_setAssociatedObject(window, _cmd, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)disappear {
    [_backgroundView removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    objc_setAssociatedObject(window, @selector(show), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_initView {
    _backgroundView = [UIView new];
    _backgroundView.frame = [UIScreen mainScreen].bounds;
    _backgroundView.backgroundColor = _style.backgroundColor;
    
    _contentView = [UIView new];
    _contentView.backgroundColor = _style.contentBackgroundColor;
    _contentView.layer.cornerRadius = _style.cornerRadius;
    _contentView.layer.masksToBounds = YES;
    _contentView.size = CGSizeMake(_backgroundView.width * 0.8, _style.height);
    _contentView.centerX = _backgroundView.centerX;
    _contentView.centerY = _backgroundView.height * _style.verticalPadding;
    [_backgroundView addSubview:_contentView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = _style.titleFont;
    _titleLabel.textColor = _style.titleColor;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLabel];
    
    _titleLine = [CALayer new];
    _titleLine.backgroundColor = _RGB16(0xf5f5f5).CGColor;
    _titleLine.frame = CGRectMake(26, _titleLabel.bottom, _contentView.width - 52, 1);
    [_contentView.layer addSublayer:_titleLine];
    _titleLine.hidden = _style.titleLineHidden;
    
    _messageLabel = [UILabel new];
    _messageLabel.font = _style.messageFont;
    _messageLabel.textColor = _style.messageColor;
    _messageLabel.textAlignment = _style.messageAlignment;
    _messageLabel.numberOfLines = _style.messageNumberOfLines;
    [_contentView addSubview:_messageLabel];
}

- (void)buttonAction:(UIButton *)sender {
    NSInteger index = sender.tag - 101;
    if (index >= _alertActions.count) { return; }
    UTAlertAction *alertAction = _alertActions[index];
    if (alertAction.action) { alertAction.action(); }
    [self disappear];
}

@end

@implementation UTAlert (UTAdd)

+ (void)defaulActionAlertWithTitle:(NSString *)title message:(NSString *)message backcall:(void (^)())backcall {
    UTAlert *alert = [self alertWithTitle:title message:message style:nil];
    
    UTAlertAction *cancelActiion = [UTAlertAction new];
    cancelActiion.title = @"取消";
    cancelActiion.backgroundColor = _RGB16(0xf5f5f5);
    cancelActiion.textColor = _RGB16(0x666666);
    [alert addAlertAction:cancelActiion];
    
    UTAlertAction *confirmActiion = [UTAlertAction new];
    confirmActiion.title = @"确定";
    confirmActiion.action = backcall;
    confirmActiion.backgroundColor = _RGB16(0xff5400);
    confirmActiion.textColor = [UIColor whiteColor];
    [alert addAlertAction:confirmActiion];
    [alert show];
}

+ (void)payPawAlertWithTitle:(NSString *)title backcall:(void (^)())backcall {
    UTAlertStyle *style = [UTAlertStyle new];
    style.messageColor = _RGB16(0x000000);
    style.messageFont = [UIFont systemFontOfSize:17];
    style.messageAlignment = NSTextAlignmentCenter;
    style.titleLineHidden = YES;
    style.height = 125;
    style.alertActionBorder = YES;
    style.alertActionBordeWidth = 1;
    style.alertActionBorderColor = _RGB16(0xf3f3f3);
    UTAlert *alert = [self alertWithTitle:nil message:title style:style];
    
    UTAlertAction *cancelActiion = [UTAlertAction new];
    cancelActiion.title = @"下次再说";
    cancelActiion.textColor = _RGB16(0x666666);
    cancelActiion.font = [UIFont systemFontOfSize:17];
    [alert addAlertAction:cancelActiion];
    
    UTAlertAction *confirmActiion = [UTAlertAction new];
    confirmActiion.title = @"去设置";
    confirmActiion.action = backcall;
    confirmActiion.textColor = _RGB16(0xff5400);
    confirmActiion.font = [UIFont systemFontOfSize:17];
    [alert addAlertAction:confirmActiion];
    [alert show];
}

+ (void)rechargeAlertWithTitle:(NSString *)title cancel:(void (^)())cancel recharge:(void (^)())recharge {
    UTAlertStyle *style = [UTAlertStyle new];
    style.messageColor = _RGB16(0x000000);
    style.messageFont = [UIFont systemFontOfSize:17];
    style.messageAlignment = NSTextAlignmentCenter;
    style.titleLineHidden = YES;
    style.height = 125;
    style.alertActionBorder = YES;
    style.alertActionBordeWidth = 1;
    style.alertActionBorderColor = _RGB16(0xf3f3f3);
    UTAlert *alert = [self alertWithTitle:nil message:title style:style];
    
    UTAlertAction *cancelActiion = [UTAlertAction new];
    cancelActiion.title = @"取消";
    cancelActiion.action = cancel;
    cancelActiion.textColor = _RGB16(0x666666);
    cancelActiion.font = [UIFont systemFontOfSize:17];
    [alert addAlertAction:cancelActiion];
    
    UTAlertAction *confirmActiion = [UTAlertAction new];
    confirmActiion.title = @"去充值";
    confirmActiion.action = recharge;
    confirmActiion.textColor = _RGB16(0xff5400);
    confirmActiion.font = [UIFont systemFontOfSize:17];
    [alert addAlertAction:confirmActiion];
    [alert show];
}

+ (void)reenterAlertWithTitle:(NSString *)title cancel:(void (^)())cancel reenter:(void (^)())reenter {
    UTAlertStyle *style = [UTAlertStyle new];
    style.messageColor = _RGB16(0x000000);
    style.messageFont = [UIFont systemFontOfSize:17];
    style.messageAlignment = NSTextAlignmentCenter;
    style.titleLineHidden = YES;
    style.height = 125;
    style.alertActionBorder = YES;
    style.alertActionBordeWidth = 1;
    style.alertActionBorderColor = _RGB16(0xf3f3f3);
    UTAlert *alert = [self alertWithTitle:nil message:title style:style];
    
    UTAlertAction *cancelActiion = [UTAlertAction new];
    cancelActiion.title = @"取消";
    cancelActiion.action = cancel;
    cancelActiion.textColor = _RGB16(0x666666);
    cancelActiion.font = [UIFont systemFontOfSize:17];
    [alert addAlertAction:cancelActiion];
    
    UTAlertAction *confirmActiion = [UTAlertAction new];
    confirmActiion.title = @"重输密码";
    confirmActiion.action = reenter;
    confirmActiion.textColor = _RGB16(0xff5400);
    confirmActiion.font = [UIFont systemFontOfSize:17];
    [alert addAlertAction:confirmActiion];
    [alert show];
}

+ (void)setupAlertWithTitle:(NSString *)title cancel:(void (^)())cancel setup:(void (^)())setup {
    UTAlertStyle *style = [UTAlertStyle new];
    style.messageColor = _RGB16(0x000000);
    style.messageFont = [UIFont systemFontOfSize:17];
    style.messageAlignment = NSTextAlignmentCenter;
    style.titleLineHidden = YES;
    style.height = 125;
    style.alertActionBorder = YES;
    style.alertActionBordeWidth = 1;
    style.alertActionBorderColor = _RGB16(0xf3f3f3);
    UTAlert *alert = [self alertWithTitle:nil message:title style:style];
    
    UTAlertAction *cancelActiion = [UTAlertAction new];
    cancelActiion.title = @"下次再说";
    cancelActiion.action = cancel;
    cancelActiion.textColor = _RGB16(0x666666);
    cancelActiion.font = [UIFont systemFontOfSize:17];
    [alert addAlertAction:cancelActiion];
    
    UTAlertAction *confirmActiion = [UTAlertAction new];
    confirmActiion.title = @"去设置";
    confirmActiion.action = setup;
    confirmActiion.textColor = _RGB16(0xff5400);
    confirmActiion.font = [UIFont systemFontOfSize:17];
    [alert addAlertAction:confirmActiion];
    [alert show];
}

@end
