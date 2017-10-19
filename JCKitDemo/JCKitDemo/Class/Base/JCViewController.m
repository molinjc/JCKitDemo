//
//  JCViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/10.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCViewController.h"

@interface JCViewController ()

@end

@implementation JCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    JCLog(@"<%@ %p> dealloc", [self class], self);
}

- (CGFloat)navigationHeight {
    if (self.navigationController) { return self.navigationController.navigationBar.bottom; }
    return 0;
}

- (CGFloat)navigationY {
    if (self.navigationController) {
        return self.navigationController.navigationBar.y;
    }
    return 0;
}

- (CGFloat)tabHeight {
    if (self.tabBarController) { return self.tabBarController.tabBar.height; }
    return 0;
}

- (CGFloat)tabBottom {
    if (self.tabBarController) { return self.view.height - self.tabBarController.tabBar.bottom; }
    return 0;
}

- (CGFloat)statusHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}


#pragma mark - 控制屏幕旋转方法

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


@end
