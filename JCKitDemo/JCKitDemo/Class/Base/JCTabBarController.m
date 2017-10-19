//
//  TJTabBarController.m
//  TongJi
//
//  Created by molin.JC on 2017/8/21.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCTabBarController.h"

@interface JCTabBarController ()

@end

@implementation JCTabBarController

#pragma mark - 控制屏幕旋转方法

- (BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end
