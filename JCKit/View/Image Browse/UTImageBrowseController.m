//
//  UTImageBrowseController.m
//  56Customer
//
//  Created by molin.JC on 2017/11/7.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UTImageBrowseController.h"

@interface UTImageBrowseController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIButton *uploadButton;
@property (nonatomic, strong) JCImageBrowseView *imageBrowseView;
@end

@implementation UTImageBrowseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    self.popGestureInvalid = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self _initView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self _imageBrowseViewWithItems:_imageURLs];
}

- (void)_initView {
    self.view.backgroundColor = [UIColor blackColor];
    
    _uploadButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _uploadButton.titleSet(@"重新上传").titleColorSet([UIColor whiteColor]);
    [_uploadButton addTarget:self action:@selector(uploadEvent:) forControlEvents:UIControlEventTouchUpInside];
    _uploadButton.layer.borderWidth = 0.5;
    _uploadButton.layer.borderColor = _RGB16(0xCCCCCC).CGColor;
    _uploadButton.size = CGSizeMake(90, 30);
    _uploadButton.hidden = _imageURLs.count > 1 ? YES : !_showUpload;
    [self.view addSubview:_uploadButton];
}

- (void)_imageBrowseViewWithItems:(NSArray *)items {
    if (_imageBrowseView) { [_imageBrowseView removeFromSuperview]; }
    _imageBrowseView = [[JCImageBrowseView alloc] initWithImageBrowseItems:items];
    [_imageBrowseView browseViewInit];
    [self.view addSubview:_imageBrowseView];
    [self.view bringSubviewToFront:_uploadButton];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScroll)];
    [_imageBrowseView addGestureRecognizer:tapGR];
}


#pragma mark - action

- (void)tapScroll {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:NO];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)uploadEvent:(UIButton *)sender {
//    [JCAlertController imagePickerAlertControllerWithTitle:nil viewController:self];
}

#pragma mark - 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    JCImageBrowseItem *item = [JCImageBrowseItem new];
    item.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_imageBrowseView removeFromSuperview];
    _imageURLs = @[item];
    [self _imageBrowseViewWithItems:_imageURLs];
    if (_deleagete && [_deleagete respondsToSelector:@selector(didFinishPickingImage:)]) {
        [_deleagete didFinishPickingImage:item.image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

@end
