//
//  JCRootNavigationController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCRootNavigationController.h"

@interface JCRootNavigationController ()

@end

@implementation JCRootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.theme_backgroundColor = [UIColor whiteColor];
    self.navigationBar.theme_barTintColor = [UIColor whiteColor];
    self.navigationBar.theme_tintColor = [UIColor blueColor];
}

@end
