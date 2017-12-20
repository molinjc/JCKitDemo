//
//  JCChainViewController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/12/1.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCChainViewController.h"
#import "JCChain.h"

@interface JCView : UIView
@end
@implementation JCView
@end

@interface JCChainViewController ()
@property (nonatomic, strong) UIView *view1;
@end

@implementation JCChainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initView];
}

- (void)_initView {
    UILabel *label = [UILabel new];
    label.chain.textAlignment(NSTextAlignmentRight).bgColor([UIColor waterPink]).font([UIFont systemFontOfSize:13]).textColor([UIColor floralWhite]).frame(CGRectMake(0, self.navigationHeight, self.view.width, 20)).text(@"测试链式编程??????");
    [self.view addSubview:label];
    
    UITextField *textField = UITextField.new;
    textField.chain.bgColor([UIColor rosyBrown]).font([UIFont systemFontOfSize:15]).textColor([UIColor waterPink]);
    textField.frame = CGRectMake(20, label.bottom + 10, self.view.width - 40, 40);
    [self.view addSubview:textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.chain.bgColor([UIColor goldenrod]).title(@"按钮").frame(CGRectMake(100, textField.bottom + 10, self.view.width - 200, 45));
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    JCView *view = JCView.new;
    view.chain.bgColor([UIColor waterPink]);
    [self.view addSubview:view];
    
    _view1 = [UIView new];
    _view1.tag = 20003;
    _view1.chain.bgColor([UIColor waterPink]).origin(CGPointMake(10, button.bottom + 10)).size(CGSizeMake(100, 100));    
    self.view.chain.addSubview(_view1);
}

#pragma mark - action

- (void)buttonAction:(UIButton *)sender {
    JCLog(@"点击了<%@>", sender);
    _view1.chain.hidden(!_view1.hidden);
}

@end
