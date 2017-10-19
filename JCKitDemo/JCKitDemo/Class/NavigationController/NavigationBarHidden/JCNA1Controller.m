//
//  JCNA1Controller.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCNA1Controller.h"
#import "JCNA2Controller.h"
#import "JCNA3Controller.h"

@interface JCNA1Controller ()

@end

@implementation JCNA1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航栏隐藏";
    self.navigationBarHidden = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"push" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.frame =CGRectMake(10, 100, 100, 50);
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"push" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(push2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    button1.frame =CGRectMake(10, 160, 100, 50);
}

- (void)push {
    JCNA2Controller *vc = [[JCNA2Controller alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)push2 {
    JCNA2Controller *vc1 = [[JCNA2Controller alloc] init];
    JCNA3Controller *vc2 = [[JCNA3Controller alloc] init];
    NSMutableArray *array = self.navigationController.viewControllers.mutableCopy;
    [array addObject:vc1];
    [array addObject:vc2];
    [self.navigationController setViewControllers:array animated:YES];
}

@end
