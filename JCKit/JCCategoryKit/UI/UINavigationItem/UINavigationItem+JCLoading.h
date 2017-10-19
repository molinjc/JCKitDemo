//
//  UINavigationItem+JCLoading.h
//
//  Created by molin.JC on 2016/12/22.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (JCLoading)
/** 设置标题视图的image */
@property (nonatomic, strong) UIImage *image;

- (void)startLoadingAnimating;

- (void)stopLoadingAnimating;

@end
