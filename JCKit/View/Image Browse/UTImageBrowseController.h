//
//  UTImageBrowseController.h
//  56Customer
//
//  Created by molin.JC on 2017/11/7.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCImageBrowseView.h"

@protocol UTImageBrowseControllerDelegate <NSObject>
@optional
- (void)didFinishPickingImage:(UIImage *)image;
@end

@interface UTImageBrowseController : UIViewController
/** 图片地址 */
@property (nonatomic, strong) NSArray *imageURLs;
/** 显示更新按钮, 若imageURLs.count>1则该值无效 */
@property (nonatomic, assign) BOOL showUpload;
@property (nonatomic, weak) id<UTImageBrowseControllerDelegate> deleagete;
@end
