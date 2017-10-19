//
//  NSObject+JCObject.m
//
//  Created by 林建川 on 16/10/2.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSObject+JCObject.h"
#import <objc/message.h>

void swizzledMethod(Class cls, SEL originalSEL, SEL swizzledSEL) {
    Method originalMethod = class_getInstanceMethod(cls, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSEL);
    
    BOOL success = class_addMethod(cls, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

void swizzledClassMethod(Class cls, SEL originalSEL, SEL swizzledSEL) {
    Method originalMethod = class_getClassMethod(cls, originalSEL);
    Method swizzledMethod = class_getClassMethod(cls, swizzledSEL);
    
    BOOL success = class_addMethod(cls, originalSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/** 持有弱引用对象的类 */
@interface _JCWeakAssociatedObject : NSObject
@property (nonatomic, weak) id value;
@end
@implementation _JCWeakAssociatedObject
@end

@implementation NSObject (JCObject)

/** 获取该类下的所有子类 */
- (NSArray *)allSubClasses {
    Class classObj = [self class];
    NSMutableArray *subClasses = [NSMutableArray new];
    unsigned int numOfClasses;
    Class *classes = objc_copyClassList(&numOfClasses);
    for (int i = 0; i < numOfClasses; i++) {
        Class superClass = classes[i];
        do {
            superClass = class_getSuperclass(superClass);
        } while (superClass && superClass != classObj);
        if (superClass) {
            [subClasses addObject:classes[i]];
        }
    }
    free(classes);
    return subClasses;
}

+ (NSString *)className {
    return NSStringFromClass(self);
}

- (NSString *)className {
    return [NSString stringWithUTF8String:class_getName([self class])];
}

+ (NSString *)superClassName {
    return NSStringFromClass([self superclass]);
}

- (NSString *)superClassName {
    return [NSString stringWithUTF8String:class_getName([self superclass])];
}

#pragma mark - exchange

+ (void)swizzledMethod:(SEL)swizzledSEL withMethod:(SEL)originalSEL {
    swizzledMethod([self class], originalSEL, swizzledSEL);
}

+ (void)swizzledClassMethod:(SEL)swizzledSEL withMethod:(SEL)originalSEL {
    swizzledClassMethod([self class], originalSEL, swizzledSEL);
}

#pragma mark - objc_AssociationPolicy

- (void)associateValue:(id)value withKey:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)associateCopyValue:(id)value withKey:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)associateAtomicallyAssignValue:(id)value withKey:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)associateAtomicallyValue:(id)value withKey:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

- (void)associateAtomicallyCopyValue:(id)value withKey:(const void *)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY);
}

- (void)associateWeaklyValue:(id)value withKey:(const void *)key {
    _JCWeakAssociatedObject *assoc = objc_getAssociatedObject(self, key);
    if (!assoc) {
        assoc = [_JCWeakAssociatedObject new];
        [self associateValue:assoc withKey:key];
    }
    assoc.value = value;
}

- (id)associatedValueForKey:(const void *)key {
    id value = objc_getAssociatedObject(self, key);
    if (value && [value isKindOfClass:[_JCWeakAssociatedObject class]]) {
        return [(_JCWeakAssociatedObject *)value value];
    }
    return value;
}

- (void)removeAllAssociatedObjects {
    objc_removeAssociatedObjects(self);
}

#pragma mark - performBlock

- (id)performBlock:(void (^)(id obj))block afterDelay:(NSTimeInterval)delay {
    return [self performBlock:block onQueue:dispatch_get_main_queue() afterDelay:delay];
}

- (id)performBlockInBackground:(void (^)(id obj))block afterDelay:(NSTimeInterval)delay {
    return [self performBlock:block onQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0) afterDelay:delay];
}

- (id)performBlock:(void (^)(id obj))block onQueue:(dispatch_queue_t)queue afterDelay:(NSTimeInterval)delay {
    NSParameterAssert(block != nil);
    __block BOOL cancelled = NO;
    void (^wrapper)(BOOL) = ^(BOOL cancel) {
        if (cancel) {
            cancelled = YES;
            return;
        }
        if (!cancelled) block(self);
    };
    
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(NSEC_PER_SEC * delay));
    dispatch_after(t, queue, ^{
        wrapper(NO);
    });
    
    return [wrapper copy];
}

- (void)cancelBlock:(id)block {
    NSParameterAssert(block != nil);
    void (^wrapper)(BOOL) = block;
    wrapper(YES);
}

#pragma mark - perform NSSelectorFromString()

- (void)performSelectorFromString:(NSString *)sel {
    [self performSelectorFromString:sel withObject:nil];
}

- (void)performSelectorFromString:(NSString *)sel withObject:(id)object {
    [self performSelectorFromString:sel withObject:object withObject:nil];
}

- (void)performSelectorFromString:(NSString *)sel withObject:(id)object1 withObject:(id)object2 {
    SEL selector = NSSelectorFromString(sel);
    IMP imp = [self methodForSelector:selector];

    int type = object2 ? 3 : object1 ? 2 : 1;
    switch (type) {
        case 3: {
            void (*func)(id, SEL, id, id) = (void *)imp;
            func(self, selector, object1, object2);
        } break;
        case 2: {
            void (*func)(id, SEL, id) = (void *)imp;
            func(self, selector, object1);
        } break;
        case 1: {
            void (*func)(id, SEL) = (void *)imp;
            func(self, selector);
        } break;
        default: break;
    }
}

#pragma mark -

- (void)deallocUsingBoloc:(void (^)(id))block {
    Class classToSwizzle = self.class;
    BOOL swizzle = [objc_getAssociatedObject(self, _cmd) boolValue];
    @synchronized (self) {
        if (!swizzle) {
            SEL deallocSelector = sel_registerName("dealloc");
            __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
            
            id newDealloc = ^(__unsafe_unretained id objSelf) {
                if (block) {  block(objSelf); }
                
                if (originalDealloc == NULL) {
                    struct objc_super superInfo = {
                        .receiver = objSelf,
                        .super_class = class_getSuperclass(classToSwizzle)
                    };
                    
                    void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                    msgSend(&superInfo, deallocSelector);
                } else {
                    originalDealloc(objSelf, deallocSelector);
                }
            };
            
            IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
            
            if (!class_addMethod(classToSwizzle, deallocSelector, newDeallocIMP, "v@:")) {
                Method deallocMethod = class_getInstanceMethod(classToSwizzle, deallocSelector);
                originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_getImplementation(deallocMethod);
                originalDealloc = (void(*)(__unsafe_unretained id, SEL))method_setImplementation(deallocMethod, newDeallocIMP);
            }
            
            objc_setAssociatedObject(self, _cmd, @(YES), OBJC_ASSOCIATION_ASSIGN);
        }
    };
}

@end
