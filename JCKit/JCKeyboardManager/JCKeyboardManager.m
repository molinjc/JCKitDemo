//
//  JCKeyboardManager.m
//  JCKeyboardTest
//
//  Created by 林建川 on 16/10/11.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "JCKeyboardManager.h"

@interface UIView (JCResponder)
- (UIViewController *)_kb_viewController;
@end
@implementation UIView (JCResponder)

- (UIViewController *)_kb_viewController {
    UIResponder *nextResponder = self;
    do {
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    } while (nextResponder != nil);
    return nil;
}

@end

@interface JCKeyboardManager ()
{
    __weak UIView *_textFieldView;
    CGFloat        _animationDuration;
    CGFloat        _keyboardHeight;
    CGRect         _oldRect;
    BOOL           _animationDown;
    UIToolbar     *_toolbar;
}

@end

@implementation JCKeyboardManager

#pragma mark - init(初始化)

+ (instancetype)shareManager {
    static JCKeyboardManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.enable = NO;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        });
    }
    return self;
}

- (void)textFieldViewDidBeginEditing:(NSNotification *)notification {
    _textFieldView = notification.object;
    if ([_textFieldView isKindOfClass:[UITextField class]] && self.accompanyToolbar) {
        UITextField *textF = (UITextField *)_textFieldView;
        if (!textF.inputAccessoryView) { [textF setInputAccessoryView:self.toolbar]; }
    }else if ([_textFieldView isKindOfClass:[UITextView class]]) {
        if (self.accompanyToolbar) {
            UITextView *textView = (UITextView *)_textFieldView;
            if (!textView.inputAccessoryView) {
                [textView setInputAccessoryView:self.toolbar];
                [textView reloadInputViews];
            }
        }
        _animationDuration = _animationDuration * 2;
        [self adjustFrame];
    }
}

-(void)textFieldViewDidEndEditing:(NSNotification*)notification {
    _textFieldView = nil;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    _animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (_animationDuration == 0.0) { _animationDuration = 0.25; }
    _keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if (_textFieldView && [_textFieldView isKindOfClass:[UITextField class]]) { [self adjustFrame]; }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (_animationDown) {
        _animationDown = NO;
        [UIView animateWithDuration:_animationDuration animations:^{
            UIViewController *viewController = _textFieldView._kb_viewController;
            viewController.view.frame = _oldRect;
        } completion:nil];
    }
}

- (void)down {
    if ([_textFieldView isKindOfClass:[UITextField class]]) {
        UITextField *textF = (UITextField *)_textFieldView;
        [textF resignFirstResponder];
    }else if ([_textFieldView isKindOfClass:[UITextView class]]) {
        UITextView *textV = (UITextView *)_textFieldView;
        [textV resignFirstResponder];
    }
}

- (void)adjustFrame {
    if (!self.enable) { return; }
    UIViewController *viewController = _textFieldView._kb_viewController;
    CGRect textFieldViewRect = [[_textFieldView superview] convertRect:_textFieldView.frame toView:viewController.view];
    CGFloat textViewBottom = viewController.view.bounds.size.height - (textFieldViewRect.size.height + textFieldViewRect.origin.y);
    if (textViewBottom < _keyboardHeight) {
        _animationDown = YES;
        [UIView animateWithDuration:_animationDuration animations:^{
            UIViewController *viewController = _textFieldView._kb_viewController;
            CGRect rect = viewController.view.frame;
            _oldRect = rect;
            rect.origin.y = -(_keyboardHeight - textViewBottom);
            viewController.view.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
    }else if (viewController.view.frame.origin.y < 0) {
        [UIView animateWithDuration:_animationDuration animations:^{
            UIViewController *viewController = _textFieldView._kb_viewController;
            CGRect rect = viewController.view.frame;
            _oldRect = CGRectMake(rect.origin.x, 0, rect.size.width, rect.size.height);
            rect.origin.y = rect.origin.y + (textViewBottom - _keyboardHeight);
            if (rect.origin.y > 0) {
                rect.origin.y = 0;
            }
            viewController.view.frame = rect;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)setToolbar:(UIToolbar *)toolbar {
    _toolbar = toolbar;
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        [_toolbar setBarStyle:UIBarStyleDefault];
        UIBarButtonItem *down = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(down)];
        _toolbar.items = @[down].mutableCopy;
    }
    return _toolbar;
}

@end
