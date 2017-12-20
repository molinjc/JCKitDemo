//
//  NSDictionary+JCBlock.m
//
//  Created by 林建川 on 16/10/9.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSDictionary+JCBlock.h"
#import "NSObject+JCObject.h"

#if __has_include("NSException+JCException.h")
#import "NSException+JCException.h"
#define kLogException NSLog(@"\n1️⃣%@\n2️⃣%@\n3️⃣%@",exception.name,exception.reason,exception.mainCallStackSymbolMessage);
#else
#define kLogException \
__block NSString *mainCallStackSymbolMsg = nil;\
NSString *callStackSymbolString = [NSThread callStackSymbols][2];\
NSString *regularExpStr = @"[-\\+]\\[.+\\]";\
NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];\
[regularExp enumerateMatchesInString:callStackSymbolString options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbolString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {\
if (result) {\
mainCallStackSymbolMsg = [callStackSymbolString substringWithRange:result.range];\
*stop = YES;\
}\
}];\
NSLog(@"\n1️⃣%@\n2️⃣%@\n3️⃣%@",exception.name,exception.reason,mainCallStackSymbolMsg);\

#endif

#define kAssertBlock(block) NSParameterAssert(block != nil)

@implementation NSDictionary (JCBlock)

+ (void)load {
//    swizzledClassMethod([self class], @selector(dictionaryWithObjects:forKeys:count:), @selector(avoidCrashDictionaryWithObjects:forKeys:count:));
}

/**
 遍历每个元素
 */
- (void)each:(void (^)(id, id))block {
    kAssertBlock(block);
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        block(key, obj);
    }];
}

/**
 反序遍历每个元素
 */
- (void)reverseEach:(void (^)(id, id))block {
    kAssertBlock(block);
    [self enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        block(key, obj);
    }];
}

/**
 选择条件满足前的元素
 */
- (NSDictionary *)select:(BOOL (^)(id, id))block {
    kAssertBlock(block);
    NSArray *keys = [[self keysOfEntriesPassingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        return block(key, obj);
    }] allObjects];
    NSArray *objects = [self objectsForKeys:keys notFoundMarker:[NSNull null]];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

/**
 dictionaryWithObjects:forKeys:count:的替换方法
 @{}创建的字典实际调用的就是这个dictionaryWithObjects:forKeys:count:方法
 @param objects value
 @param keys    key
 @param cnt     count
 @return Dictionary
 */
+ (instancetype)avoidCrashDictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self avoidCrashDictionaryWithObjects:objects forKeys:keys count:cnt];
    } @catch (NSException *exception) {
        kLogException
        //处理错误的数据，然后重新初始化一个字典
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self avoidCrashDictionaryWithObjects:newObjects forKeys:newkeys count:index];
    } @finally {
        return instance;
    }
}

- (BOOL)containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}

- (NSDictionary *)entriesForKeys:(NSArray *)keys {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (id key in keys) {
        id value = self[key];
        if (value) dic[key] = value;
    }
    return [dic copy];
}

- (NSString *)jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

static NSNumber *NSNumberFromID(id value) {
    static NSCharacterSet *dot;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dot = [NSCharacterSet characterSetWithRange:NSMakeRange('.', 1)];
    });
    if (!value || value == [NSNull null]) return nil;
    if ([value isKindOfClass:[NSNumber class]]) return value;
    if ([value isKindOfClass:[NSString class]]) {
        NSString *lower = ((NSString *)value).lowercaseString;
        if ([lower isEqualToString:@"true"] || [lower isEqualToString:@"yes"]) return @(YES);
        if ([lower isEqualToString:@"false"] || [lower isEqualToString:@"no"]) return @(NO);
        if ([lower isEqualToString:@"nil"] || [lower isEqualToString:@"null"]) return nil;
        if ([(NSString *)value rangeOfCharacterFromSet:dot].location != NSNotFound) {
            return @(((NSString *)value).doubleValue);
        } else {
            return @(((NSString *)value).longLongValue);
        }
    }
    return nil;
}

#pragma mark - getObject

#define _Dictionary_GET_VALUE(_obj, _type, _def) \
- (_obj)_type ## ForKey:(id)key { \
 return [self _type ## ForKey:key default:_def]; \
} \
- (_obj)_type ## ForKey:(id)key default:(_obj)def { \
if (!key) { return def; } \
id value = [self objectForKey:key]; \
if (!value || value == [NSNull null]) { return def; } \
if ([value isKindOfClass:[NSNumber class]]) { return ((NSNumber *)value)._type; } \
if ([value isKindOfClass:[NSString class]]) { return NSNumberFromID(value)._type; } \
return def; \
}

_Dictionary_GET_VALUE(NSInteger, integerValue, 0)
_Dictionary_GET_VALUE(int, intValue, 0)
_Dictionary_GET_VALUE(float, floatValue, 0)
_Dictionary_GET_VALUE(double, doubleValue, 0)
_Dictionary_GET_VALUE(BOOL, boolValue, NO)
_Dictionary_GET_VALUE(char, charValue, 0)

- (NSString *)stringValueForKey:(id)key {
    return [self stringValueForKey:key default:nil];
}

- (NSString *)stringValueForKey:(id)key default:(NSString *)def {
    if (!key) { return def; }
    id value = self[key];
    if (!value || value == [NSNull null]) { return def; }
    if ([value isKindOfClass:[NSString class]]) { return value; }
    if ([value isKindOfClass:[NSNumber class]]) { return ((NSNumber *)value).description; }
    return nil;
}


- (NSNumber *)numberValueForKey:(id)key {
    return [self numberValueForKey:key default:nil];
}

- (NSNumber *)numberValueForKey:(id)key default:(NSNumber *)def {
    if (!key) { return def; }
    id value = self[key];
    if (!value || value == [NSNull null]) { return def; }
    if ([value isKindOfClass:[NSNumber class]]) { return value; }
    if ([value isKindOfClass:[NSString class]]) { return NSNumberFromID(value); }
    return nil;
}

- (NSArray *)arrayValueForKey:(id)key {
    return [self arrayValueForKey:key default:nil];
}

- (NSArray *)arrayValueForKey:(id)key default:(NSArray *)def {
    if (!key) { return def; }
    id value = self[key];
    if (!value || value == [NSNull null]) { return def; }
    if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSMutableArray class]]) {
        return value;
    }
    return nil;
}

- (NSMutableArray *)mutableArrayValueForKey:(id)key {
    return [self arrayValueForKey:key].mutableCopy;
}

- (NSMutableArray *)mutableArrayValueForKey:(id)key default:(NSArray *)def {
    return [self arrayValueForKey:key default:def].mutableCopy;
}

- (NSDictionary *)dictionaryValueForKey:(id)key {
    return [self dictionaryValueForKey:key default:nil];
}

- (NSDictionary *)dictionaryValueForKey:(id)key default:(NSDictionary *)def {
    if (!key) { return def; }
    id value = self[key];
    if (!value || value == [NSNull null]) { return def; }
    if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSMutableDictionary *)mutableDictionaryValueForKey:(id)key {
    return [self dictionaryValueForKey:key].mutableCopy;
}

- (NSMutableDictionary *)mutableDictionaryValueForKey:(id)key default:(NSDictionary *)def {
    return [self dictionaryValueForKey:key default:def].mutableCopy;
}

- (CGFloat)CGFloatValueForKey:(id)key {
    if (!key) { return 0; }
    CGFloat f = [self[key] doubleValue];
    return f;
}

- (CGSize)CGSizeValueForKey:(id)key {
    CGSize size = CGSizeFromString(self[key]);
    return size;
}

- (CGPoint)CGPointValueForKey:(id)key {
    CGPoint point = CGPointFromString(self[key]);
    return point;
}

- (CGRect)CGRectValueForKey:(id)key {
    CGRect rect = CGRectFromString(self[key]);
    return rect;
}

- (NSDictionary *)merging:(NSDictionary *)dic {
    NSMutableDictionary * result = [NSMutableDictionary dictionaryWithDictionary:dic];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![dic objectForKey:key]) {
            [result setObject:obj forKey:key];
        }
    }];
    return result;
}

@end

@implementation NSMutableDictionary (JCBlock)

+ (void)load {
//    Class dictionaryMClass = NSClassFromString(@"__NSDictionaryM");
//    swizzledMethod(dictionaryMClass, @selector(setObject:forKey:), @selector(avoidCrashSetObject:forKey:));
//    swizzledMethod(dictionaryMClass, @selector(removeObjectForKey:), @selector(avoidCrashRemoveObjectForKey:));
}

/**
 setObject:forKey:的替换方法
 dic[key] = value 实际调用的是setObject:forKey:
 @param anObject value
 @param aKey     key
 */
- (void)avoidCrashSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @try {
        [self avoidCrashSetObject:anObject forKey:aKey];
    } @catch (NSException *exception) { kLogException } @finally {}
}

/** removeObjectForKey:的替换方法 */
- (void)avoidCrashRemoveObjectForKey:(id)aKey {
    @try {
        [self avoidCrashRemoveObjectForKey:aKey];
    } @catch (NSException *exception) { kLogException } @finally {}
}

#pragma mark - weak Object

/** block弱引用anObject */
- (_weakReference)_makeWeakReference:(id)anObject {
    __weak id weakref = anObject;
    return ^{return weakref;};
}

- (void)setWeakObject:(id)anObject forKey:(id<NSCopying>)aKey {
    [self setObject:[self _makeWeakReference:anObject] forKey:aKey];
}

- (void)setWeakObjectWithDictionary:(NSDictionary *)dictionary {
    for (NSString *aKey in dictionary.allKeys) {
        [self setObject:[self _makeWeakReference:dictionary[aKey]] forKey:aKey];
    }
}

- (id)getWeakObjectForKey:(id<NSCopying>)aKey {
    _weakReference ref = self[aKey];
    return ref ? ref() : nil;
}

@end
