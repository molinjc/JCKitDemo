//
//  JCQRCodeScanView.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/27.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCQRCodeScanViewDelegate <NSObject>
/** 相机权限 */
- (void)cameraAccessWithAuthorized:(BOOL)authorized;
@optional
/** 访问相机错误 */
- (void)cameraAccessWithError:(NSError *)error;
@end

@interface JCQRCodeScanView : UIView
@property (nonatomic, weak) id<JCQRCodeScanViewDelegate> delegate;
/** 设置在某个区域内扫描 */
@property (nonatomic, assign) CGRect rectOfInterest;
/** 开始扫描 */
- (void)startScan;
/** 结束扫描 */
- (void)stopScan;
@end
