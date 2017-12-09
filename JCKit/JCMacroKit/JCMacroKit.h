//
//  JCMacroKit.h
//  JCMacroKit
//
//  Created by molin.JC on 2017/6/12.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <sys/time.h>
#import <UIKit/UIKit.h>

#if DEBUG
/** 打印, 本质是NSLog() */
#define JCLog(string,...) NSLog(@"\n🛠 行号:%d\n🛠 类与方法:%s\n🛠 内容:%@ %@",__LINE__,__func__,[NSString stringWithFormat:(string), ##__VA_ARGS__],@"\n\n")

#define JCLog_cmd JCLog(@"%@",NSStringFromSelector(_cmd))

/**
 断言,断言为真，则表明程序运行正常，而断言为假，则意味着它已经在代码中发现了意料之外的错误
 @param condition 判定的条件
 */
#define JCAssert(condition) NSAssert((condition), @"\n🛠 行号:%d\n🛠 类与方法:%s\n😱😱不满足条件:%@☝️☝️ %@",__LINE__,__func__, @#condition,@"\n\n")

#else
#define JCLog(string,...)
#define JCAssert(condition)
#endif

/**
 弱引用、强引用，成对用于block
 @autoreleasepool {} 加在前面，其实啥事都没干，只为了可以加@，用来显眼
 @param obj  要引用的对象
 */
#define weakify(obj) autoreleasepool {} __weak typeof(obj) weak##obj = obj;
#define strongify(obj) autoreleasepool {} __strong typeof(weak##obj) obj = weak##obj;

/** 方法后面的注释 */
#define Note(...) NS_AVAILABLE_IOS(3_0)

/**
 简化CGRect创建
 Usages:
 CGRect rect = FRAME_XYWH(someView.frame);
 FRAME_XYWH(10, 10, 100, 100);
 FRAME_XYWH(CGPointMake(10, 10), 100, 100);
 FRAME_XYWH(CGPointMake(10, 10), CGSizeMake(100, 100));
 */
#define JCFRAME_XYWH(...) (CGRect){__VA_ARGS__}

#define JCSIZE_WH(...) (CGSize){__VA_ARGS__}

#define JCPOINT_XY(...) (CGPoint){__VA_ARGS__}

/** 简化stringWithFormat: */
#define JCString(...) [NSString stringWithFormat:__VA_ARGS__]

#define JCLocalizedString(key) [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:nil]

/** 单例声明 */
#define JCSingleton_interface +(instancetype)sharedInstance;   // .h的，声明单例方法
/** 单例实现 */
#define JCSingleton_implementation                     \
static id _instance;                                   \
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
static dispatch_once_t once;                       \
dispatch_once(&once, ^{                            \
_instance = [super allocWithZone:zone];        \
});                                                \
return _instance;                                  \
}                                                      \
+ (instancetype)sharedInstance {                       \
static dispatch_once_t once;                       \
dispatch_once(&once, ^{                            \
_instance = [[self alloc] init];               \
});                                                \
return _instance;                                  \
}                                                      \
- (id)copyWithZone:(NSZone *)zone {                    \
return _instance;                                  \
}

/**
 *  三目运算符
 *  @param condition  条件
 *  @param valueTrue  真的值
 *  @param valueFalse 假的值
 *  @return 所要的值
 */
#define JCTernary(condition, valueTrue, valueFalse) condition ? valueTrue : valueFalse


/**
 动态给一个类的属性添加setter/getter
 @param setter      setter方法名
 @param getter      getter方法名
 @param association 持有类型：ASSIGN / RETAIN / COPY / RETAIN_NONATOMIC / COPY_NONATOMIC
 @param type        返回类名
 
 @Example:
 @interface NSObject (add)
 @property (nonatomic, strong) UIColor *color;
 @end
 #import <objc/runtime.h>
 @implementation NSObject (add)
 JCSynthDynamicProperty(setColor, color, RETAIN, UIColor *)
 @end
 */
#ifndef JCSynthDynamicProperty
#define JCSynthDynamicProperty(setter, getter, association, type) \
- (void)setter : (type)object { \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_ ## association); \
} \
- (type)getter { \
return objc_getAssociatedObject(self, @selector(setter:)); \
}
#endif

#ifdef JCSynthDynamicProperty

/**
 JCSynthDynamicPropertyStrong 动态给一个类的强引用属性添加setter/getter
 JCSynthDynamicPropertyCopy 动态给一个类的copy属性添加setter/getter
 @param type   不用再'*'号
 JCSynthDynamicPropertyAssign 动态给一个类的assign属性添加setter/getter
 
 @Example:
 @interface NSObject (add)
 @property (nonatomic, strong) UIColor *color;
 @property (nonatomic, copy) NSString *string;
 @property (nonatomic, assign) NSInteger age;
 @end
 #import <objc/runtime.h>
 @implementation NSObject (add)
 JCSynthDynamicPropertyStrong(setColor, color, UIColor)
 JCSynthDynamicPropertyCopy(setString, string, NSString)
 JCSynthDynamicPropertyAssign(setAge, age, NSInteger)
 @end
 */
#define JCSynthDynamicPropertyStrong(setter, getter, type) JCSynthDynamicProperty(setter, getter, RETAIN_NONATOMIC, type *)

#define JCSynthDynamicPropertyCopy(setter, getter, type) JCSynthDynamicProperty(setter, getter, COPY_NONATOMIC, type *)

#define JCSynthDynamicPropertyAssign(setter, getter, type) JCSynthDynamicProperty(setter, getter, ASSIGN, type)

#endif

/**
 获取变量的名字
 @param variable 变量
 @return 变量名（字符串）
 */
#define JCGetVariableName(variable) [NSString stringWithFormat:@"%@",@"" # variable]

/**
 计算参数的个数
 @Example:
 int count = JCParamsCount(1, 2, 3, 4, 5);
 count => 5
 @end
 */
#define JCParamsCount(...) _paramsCount_at(__VA_ARGS__, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1)
#define _paramsCount_at(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, ...) _paramsCount_head(__VA_ARGS__)
#define _paramsCount_head(FIRST, ...) FIRST

/** 用于修饰一个变量, 在它的作用域结束时可以自动执行一个指定的方法 */
#define _cleanup(sel) __attribute__((cleanup(sel)))
/** onExit位于的作用域结束时自动调用executeCleanupBlock的方法, 执行block里的代码 */
#define onExit \
__strong void(^block)(void) __attribute__((cleanup(executeCleanupBlock), unused)) = ^

static inline void executeCleanupBlock (__strong void (^*block)()) {
    (*block)();
}

/**
 给定一个数据，转换成NSValue/NSNumber
 @param value 数据类型
 @return NSValue/NSNumber
 */
#define JCBoxValue(value) _JCBoxValue(@encode(__typeof__((value))), (value))
static inline id _JCBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets actual = (UIEdgeInsets)va_arg(v, UIEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    }
    return obj;
}

/** 将任意数据转换成字符串 */
#define JCValueTypeBuilder(value) valueTypeBuilder(@encode(__typeof__(value)), (__typeof__(value) []){value})

FOUNDATION_EXPORT double JCMacroKitVersionNumber;
FOUNDATION_EXPORT const unsigned char JCMacroKitVersionString[];
