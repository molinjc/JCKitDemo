//
//  NSTimer+JCBlock.h
//  JCKit
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (JCBlock)

/** 弱引用了target得创建方法 */
+ (NSTimer *)weakTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

/** 弱引用了target得创建方法 */
+ (NSTimer *)weakScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

/** 创建并返回一个新的NSTimer对象，它在当前运行默认模式中的循环  */
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

/** 创建并返回一个新的NSTimer对象和指定的块进行初始化 */
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

/** 暂停 */
- (void)pause;

/** 继续 */
- (void)continuation;

/**
 interval秒后继续
 @param interval 秒
 */
- (void)continuation:(NSTimeInterval)interval;

@end
