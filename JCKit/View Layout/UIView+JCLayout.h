//
//  UIView+JCLayout.h
//
//  Created by molin.JC on 2017/5/10.
//  Copyright © 2017年 molin. All rights reserved.
//  v2.0

#import <UIKit/UIKit.h>

/**
 对于不同屏幕的适配，我的想法是这样的：美工一般以某个屏幕尺寸做设计，只给我们一套效果图，按这套图
 做，做出来只在这屏幕上显示与效果图差不多一样。但iPhone现在有多中屏幕尺寸，我想就按比例来适配不同
 的屏幕。以我们效果图的宽与实际运行的屏幕宽比较，计算出scale，left、right、width、height等等
 就剩以scale来布局
  viewLayoutWithUITemplateSize: 指定UI设计原型图所用的设备尺寸。请在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions方法的开始处调用这个方法，比如
 当UI设计人员用iPhone6作为界面的原型尺寸则将size设置为375,667。
 @param size UI设计原型图所用的设备尺寸
 */

#define __scale [UIView viewLayoutScale]

@interface UIView (JCLayout)
/** 设置UI模型的尺寸, 以便计算出比例 */
+ (void)viewLayoutWithUITemplateSize:(CGSize)size;
/** 与UI模型的比例 */
+ (CGFloat)viewLayoutScale;
/** 与UI模型的比例 */
@property (nonatomic, readonly) CGFloat scale;
/** 对约束进行比例换算 */
@property (nonatomic, weak, readonly) UIView *(^layoutScale)();

/** 删除所有约束 */
- (UIView *)removeAllLayout;
/** 刷新约束 */
- (UIView *)refreshLayout;

#pragma mark - convenient

/** 设置四周(top, left, bottom, right) */
@property (nonatomic, weak, readonly) UIView *(^layoutInsets)(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);
/** 设置size(width-height) */
@property (nonatomic, weak, readonly) UIView *(^layoutSize)(CGSize size);
/** 设置origin(left-top) */
@property (nonatomic, weak, readonly) UIView *(^layoutOrigin)(CGPoint origin);

#pragma mark - 参照父视图属性

/** left，相当于x，参照俯视图的NSLayoutAttributeLeft */
@property (nonatomic, weak, readonly) UIView *(^layoutLeft)(CGFloat layoutLeft);

/** right，与俯视图右边的间距，参照俯视图的NSLayoutAttributeRight */
@property (nonatomic, weak, readonly) UIView *(^layoutRight)(CGFloat layoutRight);

/** top，相当于y，参照俯视图的NSLayoutAttributeTop */
@property (nonatomic, weak, readonly) UIView *(^layoutTop)(CGFloat layoutTop);

/** bottom，与俯视图底边的间距，参照俯视图的NSLayoutAttributeBottom */
@property (nonatomic, weak, readonly) UIView *(^layoutBottom)(CGFloat layoutBottom);

/** Width， 无参照物，设置自身的宽，NSLayoutAttributeWidth */
@property (nonatomic, weak, readonly) UIView *(^layoutWidth)(CGFloat layoutWidth);

/** height，无参照物，设置自身的高，NSLayoutAttributeHeight */
@property (nonatomic, weak, readonly) UIView *(^layoutHeight)(CGFloat layoutHeight);

/** CenterX，参照父视图的CenterX设置自身的CenterX，NSLayoutAttributeCenterX */
@property (nonatomic, weak, readonly) UIView *(^layoutCenterX)(CGFloat layoutCenterX);

/** CenterY，参照父视图的CenterY设置自身的CenterY，NSLayoutAttributeCenterY */
@property (nonatomic, weak, readonly) UIView *(^layoutCenterY)(CGFloat layoutCenterY);

#pragma mark - 参照父视图的属性，是父视图属性的multiplier倍

/** left，相当于x，参照俯视图的NSLayoutAttributeLeft的multiplier倍 */
@property (nonatomic, weak, readonly) UIView  *(^layoutMultiplierLeft)(CGFloat multiplier, CGFloat layoutLeft);

/** right，与俯视图右边的间距，参照俯视图的NSLayoutAttributeRight的multiplier倍 */
@property (nonatomic, weak, readonly) UIView *(^layoutMultiplierRight)(CGFloat multiplier, CGFloat layoutRight);

/** top，相当于y，参照俯视图的NSLayoutAttributeTop的multiplier倍 */
@property (nonatomic, weak, readonly) UIView *(^layoutMultiplierTop)(CGFloat multiplier, CGFloat layoutTop);

/** bottom，与俯视图底边的间距，参照俯视图的NSLayoutAttributeBottom的multiplier倍 */
@property (nonatomic, weak, readonly) UIView *(^layoutMultiplierBottom)(CGFloat multiplier, CGFloat layoutBottom);

/** Width， 无参照物，设置自身的宽，NSLayoutAttributeWidth的multiplier倍 */
@property (nonatomic, weak, readonly) UIView *(^layoutMultiplierWidth)(CGFloat multiplier, CGFloat layoutWidth);

/** height，无参照物，设置自身的高，NSLayoutAttributeHeight的multiplier倍 */
@property (nonatomic, weak, readonly) UIView *(^layoutMultiplierHeight)(CGFloat multiplier, CGFloat layoutHeight);

/** CenterX，参照父视图的CenterX设置自身的CenterX，NSLayoutAttributeCenterX的multiplier倍 */
@property (nonatomic, weak, readonly) UIView *(^layoutMultiplierCenterX)(CGFloat multiplier, CGFloat layoutCenterX);

/** CenterY，参照父视图的CenterY设置自身的CenterY，NSLayoutAttributeCenterY的multiplier倍 */
@property (nonatomic, weak, readonly) UIView *(^layoutMultiplierCenterY)(CGFloat multiplier, CGFloat layoutCenterY);

#pragma mark - 参照同层级视图相同属性

/** 参照同层级view的left */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualLeft)(UIView *equalView,CGFloat left);

/** 参照同层级view的right */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualRight)(UIView *equalView,CGFloat right);

/** 参照同层级view的top */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualTop)(UIView *equalView,CGFloat top);

/** 参照同层级view的bottom */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualBottom)(UIView *equalView,CGFloat bottom);

/** 参照同层级view的width */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualWidth)(UIView *equalView,CGFloat width);

/** 参照同层级view的height */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualHeight)(UIView *equalView,CGFloat height);

/** 参照同层级view的centerX */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualCenterX)(UIView *equalView,CGFloat centerX);

/** 参照同层级view的centerY */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualCenterY)(UIView *equalView,CGFloat centerY);

#pragma mark - 参照同层级视图相同属性，是同层级视图相同属性的multiplier倍

/** 参照同层级view的left，left * multiplier */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualMultiplierLeft)(UIView *equalView,CGFloat multiplier, CGFloat left);

/** 参照同层级view的right，right * multiplier */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualMultiplierRight)(UIView *equalView,CGFloat multiplier, CGFloat right);

/** 参照同层级view的top，top * multiplier */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualMultiplierTop)(UIView *equalView,CGFloat multiplier, CGFloat top);

/** 参照同层级view的bottom，bottom * multiplier */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualMultiplierBottom)(UIView *equalView,CGFloat multiplier, CGFloat bottom);

/** 参照同层级view的bottom，width * multiplier */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualMultiplierWidth)(UIView *equalView,CGFloat multiplier, CGFloat width);

/** 参照同层级view的bottom，height * multiplier */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualMultiplierHeight)(UIView *equalView,CGFloat multiplier, CGFloat height);

/** 参照同层级view的centerX，centerX * multiplier */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualMultiplierCenterX)(UIView *equalView,CGFloat multiplier, CGFloat centerX);

/** 参照同层级view的centerY，centerY * multiplier */
@property (nonatomic, weak, readonly) UIView *(^layoutEqualMultiplierCenterY)(UIView *equalView,CGFloat multiplier, CGFloat centerY);

#pragma mark - 参照同层级视图相反属性

/** 参照同层级view的left，在同层级view的左边（left），也就是同层级view在self的右边（right） */
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerLeft)(UIView *sameLayerView,CGFloat constant);

/** 参照同层级view的right，在同层级view的右边（right），也就是同层级view在self的左边（left） */
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerRight)(UIView *sameLayerView,CGFloat constant);

/** 参照同层级view的top，在同层级view的顶边（top），也就是同层级view在self的底边（bottom） */
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerTop)(UIView *sameLayerView,CGFloat constant);

/** 参照同层级view的bottom，在同层级view的底边（bottom），也就是同层级view在self的顶边(top) */
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerBottom)(UIView *sameLayerView,CGFloat constant);

#pragma mark - 参照同层级视图相反属性，是同层级视图相反属性的multiplier倍

/** 参照同层级view的left，在同层级view的左边（left），也就是同层级view在self的右边（right），self.right = 同层级view.left * multiplier + constant */
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerMultiplierLeft)(UIView *sameLayerView,CGFloat multiplier, CGFloat constant);

/** 参照同层级view的right，在同层级view的右边（right），也就是同层级view在self的左边（left），self.left = 同层级view.right * multiplier + constant */
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerMultiplierRight)(UIView *sameLayerView,CGFloat multiplier, CGFloat constant);

/** 参照同层级view的top，在同层级view的顶边（top），也就是同层级view在self的底边（bottom），self.bottom = 同层级view.top * multiplier + constant */
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerMultiplierTop)(UIView *sameLayerView,CGFloat multiplier, CGFloat constant);

/** 参照同层级view的bottom，在同层级view的底边（bottom），也就是同层级view在self的顶边（top），self.top = 同层级view.bottom * multiplier + constant */
@property (nonatomic, weak, readonly) UIView *(^layoutAtSameLayerMultiplierBottom)(UIView *sameLayerView, CGFloat multiplier, CGFloat constant);

@end

@interface UIView (JCRect)
@property (nonatomic, assign) CGFloat x;             // frame.origin.x
@property (nonatomic, assign) CGFloat y;             // frame.origin.y
@property (nonatomic, assign) CGFloat width;         // frame.size.width
@property (nonatomic, assign) CGFloat height;        // frame.size.height
@property (nonatomic, assign) CGPoint origin;        // frame.origin
@property (nonatomic, assign) CGSize  size;          // frame.size
@property (nonatomic, assign) CGFloat centerX;       // center.x
@property (nonatomic, assign) CGFloat centerY;       // center.y
@property (nonatomic, assign) CGFloat right;         // frame.origin.x + frame.size.width
@property (nonatomic, assign) CGFloat bottom;        // frame.origin.y + frame.size.height
@property (nonatomic, assign) CGFloat leftSpacing;   // 左间距
@property (nonatomic, assign) CGFloat rightSpacing;  // 右间距
@property (nonatomic, assign) CGFloat topSpacing;    // 上间距
@property (nonatomic, assign) CGFloat bottomSpacing; // 下间距
@end
