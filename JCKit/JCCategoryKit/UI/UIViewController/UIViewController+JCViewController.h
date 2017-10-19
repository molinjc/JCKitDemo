//
//  UIViewController+JCViewController.h
//
//  Created by molin.JC on 2016/12/16.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JCViewController)

/** Storyboard方式创建ViewController */
+ (instancetype)storyboardWithName:(NSString *)name storyboardID:(NSString *)sid;
+ (instancetype)storyboardWithName:(NSString *)name;

- (instancetype)viewControllerWithStoryboardID:(NSString *)sid;

/** 将UIViewController的类名作为NibName，使用initWithNibName方法，返回UIViewController对象 */
+ (instancetype)instance;

/** 判断当前ViewController是否在顶部显示 */
- (BOOL)isViewInBackground;

/** 把viewController的view作为子视图 */
- (void)addSubviewController:(UIViewController *)viewController;

/** 获取该控制器的层级(可以作用于打印执行次序) */
- (NSInteger)indexPath;

/** 强制转屏 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation;

@end

@interface UIViewController (JCTabBarControllerItem)
/** 获取UITabBar.items的item */
@property (nonatomic, readonly) UITabBarItem *jc_tabBarItem;
@end
