//
//  JCChainViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/12/1.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCChainViewController.h"
#import "UIView+JCChain.h"

@interface JCView : UIView
@end
@implementation JCView
@end

@interface JCChainViewController ()
@end

@implementation JCChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initView];
}

- (void)_initView {
    UILabel *label = UILabel.init.setBackgroundColor([UIColor waterPink]).setFont([UIFont systemFontOfSize:13]).setTextColor([UIColor floralWhite]).setTextAlignment(NSTextAlignmentCenter).setText(@"测试链式编程");
    label.frame = CGRectMake(0, self.navigationHeight, self.view.width, 20);
    [self.view addSubview:label];
    
    UITextField *textField = UITextField.init.setBackgroundColor([UIColor rosyBrown]).setFont([UIFont systemFontOfSize:15]).setTextColor([UIColor waterPink]);
    textField.frame = CGRectMake(20, label.bottom + 10, self.view.width - 40, 40);
    [self.view addSubview:textField];
    
    UIButton *button = UIButton.buttonType(UIButtonTypeRoundedRect).addTarget(self, @selector(buttonAction:), UIControlEventTouchUpInside).setTitle(@"按钮");
    button.backgroundColor = [UIColor goldenrod];
    button.frame = CGRectMake(100, textField.bottom + 10, self.view.width - 200, 45);
    [self.view addSubview:button];
    
    JCView *view = JCView.init;
    view.setBackgroundColor([UIColor waterPink]);
    [self.view addSubview:view];
//    UITableView *tableView = UITableView.init.setBackgroundColor(UIColor.waterPink).setRowHeight(20);
}

#pragma mark - action

- (void)buttonAction:(UIButton *)sender {
    JCLog(@"点击了<%@>", sender);
}

@end
