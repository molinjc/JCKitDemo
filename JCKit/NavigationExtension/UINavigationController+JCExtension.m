//
//  UINavigationController+JCExtension.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UINavigationController+JCExtension.h"
#import <objc/runtime.h>

#if __has_include(<JCCategoryKit/NSObject+JCObject.h>)
#import <JCCategoryKit/NSObject+JCObject.h>
#else 
#if __has_include("NSObject+JCObject.h")
#import "NSObject+JCObject.h"
#else
void swizzledMethod(Class cls, SEL originalSEL, SEL swizzledSEL) {
    Method originalMethod = class_getInstanceMethod(cls, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSEL);
    
    BOOL success = class_addMethod(cls, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
#endif
#endif

typedef void (^_viewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

#pragma mark - UIViewController

@implementation UIViewController (JCExtension)

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    objc_setAssociatedObject(self, _cmd, @(navigationBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)navigationBarHidden {
    return [objc_getAssociatedObject(self, @selector(setNavigationBarHidden:)) boolValue];
}

- (void)setPopGestureInvalid:(BOOL)popGestureInvalid {
    objc_setAssociatedObject(self, _cmd, @(popGestureInvalid), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)popGestureInvalid {
    return [objc_getAssociatedObject(self, @selector(setPopGestureInvalid:)) boolValue];
}

@end

@interface UIViewController (JCExtensionPrivate)
/** 在viewController即将显示时注入block的block */
@property (nonatomic, copy) _viewControllerWillAppearInjectBlock willAppearInjectBlock;
@end

@implementation UIViewController (JCExtensionPrivate)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzledMethod(self, @selector(viewWillAppear:), @selector(jc_viewWillAppear:));
    });
}

- (void)jc_viewWillAppear:(BOOL)animated {
    [self jc_viewWillAppear:animated];
    if (self.willAppearInjectBlock) { self.willAppearInjectBlock(self, animated); }
}

- (void)setWillAppearInjectBlock:(_viewControllerWillAppearInjectBlock)willAppearInjectBloc {
    objc_setAssociatedObject(self, @selector(willAppearInjectBlock), willAppearInjectBloc, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (_viewControllerWillAppearInjectBlock)willAppearInjectBlock {
    return objc_getAssociatedObject(self, _cmd);
}

@end

#pragma mark - UINavigationController

@implementation UINavigationController (JCExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzledMethod(self, @selector(pushViewController:animated:), @selector(jc_pushViewController:animated:));
        swizzledMethod(self, @selector(setViewControllers:animated:), @selector(jc_setViewControllers:animated:));
        swizzledMethod(self, @selector(viewDidLoad), @selector(jc_viewDidLoad));
    });
}

- (void)jc_viewDidLoad {
    if (!self.interactivePopGestureRecognizer.delegate) {
        self.interactivePopGestureRecognizer.delegate = self;
    }else {
        [self setInteractivePopGestureRecognizerShouldBegin];
    }
    
    [self jc_viewDidLoad];
}

- (void)setInteractivePopGestureRecognizerShouldBegin {
    Class cla = [self.interactivePopGestureRecognizer.delegate class];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id block = ^BOOL(id objSelf, id gestureRecognizer, id touch){
            UINavigationController *navigationController = [objSelf valueForKey:@"__parent"];
            if (navigationController.viewControllers.count > 1) {
                if (navigationController.visibleViewController.popGestureInvalid) { return NO; }
                return YES;
            }
            return NO;
        };
        
        IMP shouldBegin = imp_implementationWithBlock(block);
        SEL sel_shouldBegin = @selector(gestureRecognizer:shouldReceiveTouch:);
        Method method_shouldBegin = class_getInstanceMethod(cla, sel_shouldBegin);
        if (!class_addMethod(cla, sel_shouldBegin, shouldBegin, method_getTypeEncoding(method_shouldBegin))) {
            Method shouldBeginMethod = class_getInstanceMethod(cla, sel_shouldBegin);
            method_getImplementation(shouldBeginMethod);
            method_setImplementation(shouldBeginMethod, shouldBegin);
        }
    });
}

- (void)jc_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self _setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    if (![self.viewControllers containsObject:viewController]) { [self jc_pushViewController:viewController animated:animated]; }
}

- (void)jc_setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    for (UIViewController *viewController in viewControllers) {
        [self _setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    }
    [self jc_setViewControllers:viewControllers animated:animated];
}

- (void)_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)viewController {
    __weak typeof(self) weakSelf = self;
    _viewControllerWillAppearInjectBlock block = ^(UIViewController *vc, BOOL animated) {
        __weak typeof(weakSelf) self = weakSelf;
        if (self) { [self setNavigationBarHidden:vc.navigationBarHidden animated:animated]; }
    };
    
    viewController.willAppearInjectBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.willAppearInjectBlock) {
        disappearingViewController.willAppearInjectBlock = block;
    }
}

- (void)fullScreenInteractivePop:(BOOL)interactive {
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    UIPanGestureRecognizer *fullScreenGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    if (fullScreenGestureRecognizer && interactive) { return; }
    [self.interactivePopGestureRecognizer setEnabled:!interactive];
    
    if (!interactive) {
        [targetView removeGestureRecognizer:fullScreenGestureRecognizer];
        objc_setAssociatedObject(self, _cmd, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    
    if (!fullScreenGestureRecognizer) {
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id target = [internalTargets.firstObject valueForKey:@"target"];
        SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
        
        fullScreenGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
        fullScreenGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, fullScreenGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        fullScreenGestureRecognizer.delegate = self.interactivePopGestureRecognizer.delegate;
        
        [targetView addGestureRecognizer:fullScreenGestureRecognizer];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.viewControllers.count > 1;
}

@end
