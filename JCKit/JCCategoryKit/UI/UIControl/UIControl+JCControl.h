//
//  UIControl+JCControl.h
//
//  Created by 林建川 on 16/10/10.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (JCControl)

/** 是否忽略点击事件,不响应点击事件 */
@property (nonatomic, weak, readonly) UIControl *(^buttonIgnoreEvent)(BOOL ignoreEvent);

/** 添加点击事件的间隔时间 */
@property (nonatomic, weak, readonly) UIControl *(^buttonAcceptEventInterval)(NSTimeInterval acceptEventInterval);

/** 用户交互暂停ti秒 */
@property (nonatomic, weak, readonly) UIControl *(^userInteractionSuspend)(NSTimeInterval ti);

/** 设置只有一个目标类 */
- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/** 添加事件block回调 */
- (void)addBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;
/** 移除block回调 */
- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;

/** 设置事件block回调 */
- (void)setBlockForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender))block;
/** 移除所有目标类 */
- (void)removeAllTargets;

/** 触摸回调 */
- (void)touchDown:(void (^)(void))eventBlock;
- (void)touchDownRepeat:(void (^)(void))eventBlock;
- (void)touchDragInside:(void (^)(void))eventBlock;
- (void)touchDragOutside:(void (^)(void))eventBlock;
- (void)touchDragEnter:(void (^)(void))eventBlock;
- (void)touchDragExit:(void (^)(void))eventBlock;
- (void)touchUpInside:(void (^)(void))eventBlock;
- (void)touchUpOutside:(void (^)(void))eventBlock;
- (void)touchCancel:(void (^)(void))eventBlock;

/** 值变化回调 */
- (void)valueChanged:(void (^)(void))eventBlock;

/** 编辑回调 */
- (void)editingDidBegin:(void (^)(void))eventBlock;
- (void)editingChanged:(void (^)(void))eventBlock;
- (void)editingDidEnd:(void (^)(void))eventBlock;
- (void)editingDidEndOnExit:(void (^)(void))eventBlock;


@end
