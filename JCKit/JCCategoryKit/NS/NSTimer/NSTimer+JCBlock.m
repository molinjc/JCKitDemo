//
//  NSTimer+JCBlock.m
//  JCKit
//
//  Created by 林建川 on 16/9/27.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSTimer+JCBlock.h"

@interface _JCWeakTarget : NSProxy
@property (nonatomic, weak) id target;
@end
@implementation _JCWeakTarget

- (instancetype)init {
    return self;
}

+ (instancetype)_weakTarget:(id)target {
    _JCWeakTarget *_weakTarget = [[self alloc] init];
    _weakTarget.target = target;
    return _weakTarget;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

@end

@implementation NSTimer (JCBlock)

+ (NSTimer *)weakTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    return [NSTimer timerWithTimeInterval:ti target:[_JCWeakTarget _weakTarget:aTarget] selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

+ (NSTimer *)weakScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    return [NSTimer scheduledTimerWithTimeInterval:ti target:[_JCWeakTarget _weakTarget:aTarget] selector:aSelector userInfo:userInfo repeats:yesOrNo];
}

/** 定时器的调用的方法 */
+ (void)timerExecuteBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:[_JCWeakTarget _weakTarget:self] selector:@selector(timerExecuteBlock:) userInfo:[block copy] repeats:repeats];
}


+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer timerWithTimeInterval:seconds target:[_JCWeakTarget _weakTarget:self] selector:@selector(timerExecuteBlock:) userInfo:[block copy] repeats:repeats];
}

- (void)pause {
    if (![self isValid]) { return; }
    [self setFireDate:[NSDate distantFuture]];
}

- (void)continuation {
    if (![self isValid]) { return; }
    [self setFireDate:[NSDate date]];
}

- (void)continuation:(NSTimeInterval)interval {
    if (![self isValid]) { return; }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
