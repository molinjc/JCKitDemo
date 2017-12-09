//
//  JCSkinSetupController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/20.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCSkinSetupController.h"

@interface JCSkinSetupController ()

@end

@implementation JCSkinSetupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"皮肤设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"day"] originalImage] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction:)];
}

#pragma mark - action 

- (void)rightBarAction:(UIBarButtonItem *)sender {
    [JCThemeManage themeManage].nightTheme = ![JCThemeManage themeManage].nightTheme;
    if ([JCThemeManage themeManage].nightTheme) {
        UIImage *img = [[UIImage imageNamed:@"night"] originalImage];
        [sender setImage:img];
    }else {
        [sender setImage:[[UIImage imageNamed:@"day"] originalImage]];
    }
}

@end
