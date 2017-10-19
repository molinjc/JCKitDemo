//
//  JCNC1ViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCNC1Controller.h"
#import "JCNC2Controller.h"

@interface JCNC1Controller ()

@end

@implementation JCNC1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"透明导航栏";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"push" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.frame =CGRectMake(10, 100, 100, 50);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarTransparentGradient(0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarTransparentGradient(1);
}

- (void)push {
    JCNC2Controller *vc = [[JCNC2Controller alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
