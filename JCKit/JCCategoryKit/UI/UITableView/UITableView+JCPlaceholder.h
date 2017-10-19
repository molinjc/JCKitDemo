//
//  UITableView+JCPlaceholder.h
//
//  Created by molin.JC on 2016/12/20.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (JCPlaceholder)

//**********************************
@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) void (^reload)();
//**********************************

/// 使用外部自定义占位View，那上面三个属性就不能用了
@property (nonatomic, strong) UIView *customPlaceholderView;

@end

@interface UITableView (JCTableView)

- (void)updateWithBlock:(void (^)(UITableView *tableView))block;

/** 获取UITableViewCell */
- (id)cellForRow:(NSInteger)row inSection:(NSInteger)section;

- (void)scrollToRow:(NSUInteger)row inSection:(NSUInteger)section atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

- (void)insertRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;

- (void)deleteRow:(NSUInteger)row inSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

- (void)insertSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

- (void)deleteSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadSection:(NSUInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

- (void)clearSelectedRowsAnimated:(BOOL)animated;

@end
