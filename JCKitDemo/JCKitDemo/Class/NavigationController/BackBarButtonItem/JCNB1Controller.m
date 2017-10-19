//
//  JCNB1Controller.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCNB1Controller.h"

@interface JCNB1Controller ()

@end

@implementation JCNB1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"leftBarButtonItem返回";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    JCLog(@"%@, %zd", self.navigationController.interactivePopGestureRecognizer.view, self.navigationController.interactivePopGestureRecognizer.enabled);
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
