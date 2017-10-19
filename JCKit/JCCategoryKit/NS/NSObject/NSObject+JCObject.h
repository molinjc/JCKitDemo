//
//  NSObject+JCObject.h
//
//  Created by 林建川 on 16/10/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 两方法交换 */
void swizzledMethod(Class cls, SEL originalSEL, SEL swizzledSEL);
/** 交换类方法 */
void swizzledClassMethod(Class cls, SEL originalSEL, SEL swizzledSEL);

@interface NSObject (JCObject)
/** 获取该类下的所有子类 */
- (NSArray *)allSubClasses;
/** 类名 */
+ (NSString *)className;
- (NSString *)className;
/** 父类名 */
- (NSString *)superClassName;
+ (NSString *)superClassName;

/** 交换实例方法 */
+ (void)swizzledMethod:(SEL)swizzledSEL withMethod:(SEL)originalSEL;
/** 交换类方法 */
+ (void)swizzledClassMethod:(SEL)swizzledSEL withMethod:(SEL)originalSEL;

/** 关联属性, OBJC_ASSOCIATION_RETAIN_NONATOMIC */
- (void)associateValue:(id)value withKey:(const void *)key;
/** 关联属性, OBJC_ASSOCIATION_COPY_NONATOMIC */
- (void)associateCopyValue:(id)value withKey:(const void *)key;
/** 关联属性, OBJC_ASSOCIATION_RETAIN */
- (void)associateAtomicallyValue:(id)value withKey:(const void *)key;
/** 关联属性, OBJC_ASSOCIATION_ASSIGN */
- (void)associateAtomicallyAssignValue:(id)value withKey:(const void *)key;
/** 关联属性, OBJC_ASSOCIATION_COPY */
- (void)associateAtomicallyCopyValue:(id)value withKey:(const void *)key;
/** 关联弱属性 */
- (void)associateWeaklyValue:(id)value withKey:(const void *)key;
/** 获取key对应的值 */
- (id)associatedValueForKey:(const void *)key;
/** 删除所有关联 */
- (void)removeAllAssociatedObjects;

/** 延迟delay秒执行block */
- (id)performBlock:(void (^)(id obj))block afterDelay:(NSTimeInterval)delay;
/** 延迟delay秒在后台线程(异步)执行block */
- (id)performBlockInBackground:(void (^)(id obj))block afterDelay:(NSTimeInterval)delay;
/** 延迟delay秒在指定线程下执行block */
- (id)performBlock:(void (^)(id obj))block onQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay;
/** 取消执行, block是performBlock的返回值 */
- (void)cancelBlock:(id)block;

/** 执行sel方法 */
- (void)performSelectorFromString:(NSString *)sel;
- (void)performSelectorFromString:(NSString *)sel withObject:(id)object;
- (void)performSelectorFromString:(NSString *)sel withObject:(id)object1 withObject:(id)object2;

/** 开启dealloc前的回调 */
- (void)deallocUsingBoloc:(void (^)(id))block;
@end


