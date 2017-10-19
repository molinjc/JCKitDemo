//
//  JCNC2Controller.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/16.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCNC2Controller.h"

@interface JCNC2Controller ()

@end

@implementation JCNC2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"不透明导航栏";
    self.navigationController.navigationBarTransparentGradient(1);
}

@end
