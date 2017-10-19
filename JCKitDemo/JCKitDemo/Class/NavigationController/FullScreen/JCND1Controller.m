//
//  JCND1Controller.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/17.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCND1Controller.h"
#import "JCND2Controller.h"

@interface JCND1Controller ()

@end

@implementation JCND1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全屏侧滑";
    [self.navigationController fullScreenInteractivePop:YES];
    
    UILabel *label = [UILabel new];
    label.text = @"开启全屏侧滑返回，并停用系统的侧滑返回手势";
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, self.navigationHeight, self.view.width, 20);
    [self.view addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"push" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.frame =CGRectMake(10, 100, 100, 50);
}

- (void)push {
    JCND2Controller *vc = [[JCND2Controller alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![self.navigationController.viewControllers containsObject:self]) {
//        [self.navigationController fullScreenInteractivePop:NO];
    }
}

@end
