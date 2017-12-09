//
//  JCSRootController.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/20.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCSRootController.h"
#import "JCThemeManage.h"

@interface JCSRootController ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation JCSRootController

+ (JCNavigationController *)skinRootController {
    JCSRootController *vc = [[JCSRootController alloc] init];
    JCNavigationController *navigationController = [[JCNavigationController alloc] initWithRootViewController:vc];
    return navigationController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UI皮肤";
    [self _initView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"day"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnAction:)];
}

- (void)_initView {
    _textLabel = [UILabel new];
    _textLabel.theme_textColor = nil;
    _textLabel.text = @"看看Demo的效果";
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.frame = CGRectMake(10, self.navigationHeight, self.view.width - 20, 40);
    [self.view addSubview:_textLabel];
    
    _textView = [UITextView new];
    _textView.theme_textColor = [UIColor lawnGreen];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.text = @"试试UITextView的textColor, 以下是胡说: \n 就好撒绝好的哈数据库的哈克斯几点回家爱上的空间哈司机导航家圣诞节卡是很大声接电话啊事件回调";
    _textView.layer.borderColor = [UIColor waterPink].CGColor;
    _textView.layer.borderWidth = 1;
    _textView.frame = CGRectMake(10, _textLabel.bottom + 10, self.view.width - 20, 100);
    [self.view addSubview:_textView];
    
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:@"ic_friends"];
    _imageView.size = _imageView.image.size;
    _imageView.centerX = self.view.width * 0.5;
    _imageView.y = _textView.bottom + 10;
    [self.view addSubview:_imageView];
}

#pragma mark - action 

- (void)rightBarBtnAction:(UIBarButtonItem *)sender {
    [JCThemeManage themeManage].nightTheme = ![JCThemeManage themeManage].nightTheme;
    if ([JCThemeManage themeManage].nightTheme) {
        [sender setImage:[[UIImage imageNamed:@"night"] originalImage]];
    }else {
        [sender setImage:[[UIImage imageNamed:@"day"] originalImage]];
    }
}

@end
