//
//  UIViewController+JCViewController.m
//
//  Created by molin.JC on 2016/12/16.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIViewController+JCViewController.h"

@implementation UIViewController (JCViewController)

/** Storyboard方式创建ViewController */
+ (instancetype)storyboardWithName:(NSString *)name storyboardID:(NSString *)sid {
    if (sid) {
        return [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:sid];
    }else if (name) {
        return [[UIStoryboard storyboardWithName:name bundle:nil] instantiateInitialViewController];
    }
    return nil;
}

+ (instancetype)storyboardWithName:(NSString *)name {
    return [self storyboardWithName:name storyboardID:nil];
}

- (instancetype)viewControllerWithStoryboardID:(NSString *)sid {
    return [self.storyboard instantiateViewControllerWithIdentifier:sid];
}

/** 将UIViewController的类名作为NibName，使用initWithNibName方法，返回UIViewController对象 */
+ (instancetype)instance; {
    return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

/** 判断当前ViewController是否在顶部显示 */
- (BOOL)isViewInBackground {
    return [self isViewLoaded] && self.view.window == nil;
}

- (void)addSubviewController:(UIViewController *)viewController {
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
}

- (NSInteger)indexPath {
    if (!self.parentViewController) {
        return 0;
    } else if ([self.parentViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.parentViewController;
        NSInteger integer = [[nav viewControllers] indexOfObject:self];
        return integer;
    }else if ([self.parentViewController isMemberOfClass:[UITabBarController class]]) {
        return 1;
    }else {
        return -1;
    }
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
    }
}

@end

@implementation UIViewController (JCTabBarControllerItem)

- (UITabBarItem *)jc_tabBarItem {
    if (!self.tabBarController) { return nil; }
    UIViewController *vc = nil;
    if ([self.tabBarController.childViewControllers containsObject:self]) {
        vc = self;
    } else if ([self.tabBarController.childViewControllers containsObject:self.navigationController]) {
        vc = self.navigationController;
    }
    
    NSInteger index = [self.tabBarController.childViewControllers indexOfObject:vc];
    return [self.tabBarController.tabBar.items objectAtIndex:index];
}

@end
