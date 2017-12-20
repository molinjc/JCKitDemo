//
//  JCImageBrowseView.h
//
//  Created by molin.JC on 2017/5/3.
//  Copyright © 2017年 molin. All rights reserved.
//
//  v1.0 
#import <UIKit/UIKit.h>

@interface JCImageBrowseItem : NSObject
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIView *thumbView;
@end

@interface JCImageBrowseView : UIView
/** 浏览图片的item */
@property (nonatomic, readonly) NSArray <JCImageBrowseItem *> *imageBrowseItems;
/** 初始化方法 */
- (instancetype)initWithImageBrowseItems:(NSArray <JCImageBrowseItem *> *)items;
/** 显示在window上 */
- (void)showAtPresentWindow;
/** 初始化设置 */
- (void)browseViewInit;
/**
 显示ImageBrowseView
 @param fromView 选中的ImageView
 @param toContainer 当前显示最上层的容器view
 @param animated 是否动画
 @param completion 完成后的回调
 */
- (void)presentFromImageView:(UIView *)fromView toContainer:(UIView *)toContainer animated:(BOOL)animated completion:(void (^)(void))completion;

/** 消失 */
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
