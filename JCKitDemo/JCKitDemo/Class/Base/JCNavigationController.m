//
//  JCNavigationController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCNavigationController.h"

@interface JCNavigationController ()

@end

@implementation JCNavigationController

#pragma mark - 控制屏幕旋转方法

- (BOOL)shouldAutorotate{
    return [self.viewControllers.lastObject shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

@end
