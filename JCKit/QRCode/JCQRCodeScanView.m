//
//  JCQRCodeScanView.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/27.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCQRCodeScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface JCQRCodeScanView ()<AVCaptureMetadataOutputObjectsDelegate>
/** 显示扫描出的图像的视图 */
@property (nonatomic, strong) UIView *imageView;
/** 蒙版视图 */
@property (nonatomic, strong) UIView *maskView;
/** 横扫的横线视图 */
@property (nonatomic, strong) UIImageView *sweepLineView;
/** 定时器 */
@property (nonatomic, strong) CADisplayLink *displayLink;
/** 摄像服务 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 摄像设备 */
@property (nonatomic, strong) AVCaptureDevice  *device;
@end

@implementation JCQRCodeScanView

- (instancetype)init {
    if (self = [super init]) {
        [self requestCameraAccessAuthorized];
        [self _init];
    }
    return self;
}

- (void)_init {
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _imageView = [UIView new];
    [self addSubview:_imageView];
    
    _maskView = [UIView new];
    _maskView.backgroundColor = _RGBA16(0x000000, 0.3);
    [self addSubview:_maskView];
}

- (void)startScan {
    NSError *error = nil;
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (!input) {
        if ([_delegate respondsToSelector:@selector(cameraAccessWithError:)]) { [_delegate cameraAccessWithError:error]; }
    }else {
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        _session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [_session addInput:input];
        [_session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.layer.bounds;
        [_imageView.layer insertSublayer:layer atIndex:0];
        //开始捕获
        [_session startRunning];
        
        if (CGRectEqualToRect(_rectOfInterest, CGRectZero)) {
            output.rectOfInterest = CGRectMake(0.1, 0, 0.9, 1);
        }else {
            output.rectOfInterest = [layer metadataOutputRectOfInterestForRect:_rectOfInterest];
        }
    }
}

- (void)stopScan {
    [self.session stopRunning];
}

#pragma mark - Camera Access Authorized

/** 请求相机权限 */
- (void)requestCameraAccessAuthorized {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        @weakify(self);
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self callbackCameraAccessAuthorized:granted];
            });
        }];
    } else if (status == AVAuthorizationStatusAuthorized) {
        [self callbackCameraAccessAuthorized:YES];
    } else {
        [self callbackCameraAccessAuthorized:NO];
    }
}

/** 回调相机权限的情况 */
- (void)callbackCameraAccessAuthorized:(BOOL)authorized {
    if (_delegate) { [_delegate cameraAccessWithAuthorized:authorized]; }
}

#pragma mark - Notification

/** 设置通知 */
- (void)setApplicationNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)_applicationWillEnterForeground:(id)sender {
    [_session startRunning];
}

- (void)_applicationDidEnterBackground:(id)sender {
    [_session stopRunning];
}


@end
