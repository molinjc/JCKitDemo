//
//  Header.h
//
//  Created by molin.JC on 2017/6/15.
//  Copyright © 2017年 molin. All rights reserved.
//

/** block */
typedef void (^block_t)();

/** 获取编译的时间 */
static inline NSDate *JCCompileTime() {
    NSString *timeStr = [NSString stringWithFormat:@"%s %s",__DATE__, __TIME__];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd yyyy HH:mm:ss"];
    [formatter setLocale:locale];
    return [formatter dateFromString:timeStr];
}

/**
 运行时间差
 @param block 所要得知时间差的代码
 @param complete 时间差(double)
 Usage:
 JCBenchmark(^{
 // code
 }, ^(double ms) {
 NSLog("time cost: %.2f ms",ms);
 });
 */
static inline void JCBenchmark(void (^block)(void), void (^complete)(double ms)) {
    struct timeval t0, t1;
    gettimeofday(&t0, NULL);
    block();
    gettimeofday(&t1, NULL);
    double ms = (double)(t1.tv_sec - t0.tv_sec) * 1e3 + (double)(t1.tv_usec - t0.tv_usec) * 1e-3;
    complete(ms);
}

/**
 上取整
 ceil()：取不小于给定实数的最小整数
 */
static inline CGRect CGRectCeli(CGRect rect) {
    return CGRectMake(ceil(rect.origin.x), ceil(rect.origin.y), ceil(rect.size.width), ceil(rect.size.height));
}

static inline CGSize CGSizeCeli(CGSize size) {
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

static inline CGPoint CGPointCeli(CGPoint origin) {
    return CGPointMake(ceil(origin.x), ceil(origin.y));
}

/**
 下取整
 floor(): 取不大于给定实数的最大整数
 */
static inline CGRect CGRectFloor(CGRect rect) {
    return CGRectMake(floor(rect.origin.x), floor(rect.origin.y), floor(rect.size.width), floor(rect.size.height));
}

static inline CGSize CGSizeFloor(CGSize size) {
    return CGSizeMake(floor(size.width), floor(size.height));
}

static inline CGPoint CGPointFloor(CGPoint origin) {
    return CGPointMake(floor(origin.x), floor(origin.y));
}

/** 将origin和size合成CGRect */
static inline CGRect CGRectSynth(CGPoint origin, CGSize size) {
    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

/** 获取rect里的中心 */
static inline CGPoint CGRectCenter(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/** 获取size里最大的那个数 */
static inline CGFloat CGSizeMax(CGSize size) {
    return MAX(size.width, size.height);
}

/** 获取size里最小的那个数 */
static inline CGFloat CGSizeMin(CGSize size) {
    return MIN(size.width, size.height);
}

/** 点转换成像素 */
static inline CGFloat CGFloatToPixel(CGFloat value) {
    return value * [UIScreen mainScreen].scale;
}

/** 像素转换成点 */
static inline CGFloat CGFloatFromPixel(CGFloat value) {
    return value / [UIScreen mainScreen].scale;
}

/** 由角度转换弧度 */
static inline CGFloat JCDegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

/** 由弧度转换角度 */
static inline CGFloat JCRadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}

static NSString *typeMatch(NSString *type, NSString *pattern){
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionAnchorsMatchLines
                                  error:&error];
    NSCAssert(nil == error, @"TypeMatch error is not nil");
    NSTextCheckingResult *match = [regex
                                   firstMatchInString:type
                                   options:0
                                   range:NSMakeRange(0, [type length])];
    if (match && [match numberOfRanges] > 1) {
        return [type substringWithRange:[match rangeAtIndex:1]];
    }
    return nil;
}

/** 将任意数据转换成字符串, valueTypeBuilder(/@/encode(__typeof__(value)), (__typeof__(value) []){value}) */
static inline NSString *valueTypeBuilder(const char *type, const void *value) {
    if (strcmp(@encode(id), type) == 0){
        __unsafe_unretained id object = *(__unsafe_unretained id *)value;
        
        if (nil == object) return @"(nil)";
        
        if ([object isKindOfClass:[NSString class]]) {
            return [object copy];
        }
        
        if ([object isKindOfClass:NSClassFromString(@"Protocol")]) {
            return NSStringFromProtocol(object);
        }
        
        return [NSString stringWithFormat:@"%@",object];
    }
    
    if (strcmp(@encode(Class), type) == 0){
        return NSStringFromClass(*(Class *)value);
    }
    
    if (strcmp(":", type) == 0){
        return NSStringFromSelector(*(SEL *)value);
    }
    
    if (strcmp(@encode(NSRange), type) == 0){
        return NSStringFromRange(*(NSRange *)value);
    }
    
    // CoreGraphics
    if (strcmp(@encode(CGRect), type) == 0){
        return NSStringFromCGRect(*(CGRect *)value);
    }
    
    if (strcmp(@encode(CGPoint), type) == 0){
        return NSStringFromCGPoint(*(CGPoint *)value);
    }
    
    if (strcmp(@encode(CGSize), type) == 0){
        return NSStringFromCGSize(*(CGSize *)value);
    }
    
    if (strcmp(@encode(CGAffineTransform), type) == 0){
        return NSStringFromCGAffineTransform(*(CGAffineTransform *)value);
    }
    
    // UIKit
    if (strcmp(@encode(UIEdgeInsets), type) == 0){
        return NSStringFromUIEdgeInsets(*(UIEdgeInsets *)value);
    }
    
    if (strcmp(@encode(UIOffset), type) == 0){
        return NSStringFromUIOffset(*(UIOffset *)value);
    }
    
    // BOOL
    if (strcmp(@encode(BOOL), type) == 0){
        if (strcmp(@encode(BOOL), @encode(signed char)) == 0){
            // 32 bit
            char ch = *(signed char *)value;
            if ((char)YES == ch) return @"YES";
            if ((char)NO == ch) return @"NO";
        }else if (strcmp(@encode(BOOL), @encode(bool)) == 0){
            // 64 bit
            bool boolValue = *(bool *)value;
            if (boolValue) {
                return @"YES";
            }else{
                return @"NO";
            }
        }
    }
    
    if (strcmp(@encode(bool), type) == 0){
        // 32 bit
        bool boolValue = *(bool *)value;
        if (boolValue) { return @"true"; }
        else{ return @"false"; }
    }
    
    // Primitives
    if (strcmp(@encode(void *), type) == 0){
        void *pointer = *(void **)value;
        if (NULL == pointer) return @"(NULL)";
        return [NSString stringWithFormat:@"%p",pointer];
    }
    
    if (strcmp(@encode(double), type) == 0){
        return [NSString stringWithFormat:@"%f",*(double *)value];
    }
    
    if (strcmp(@encode(float), type) == 0){
        return [NSString stringWithFormat:@"%f",*(float *)value];
    }
    
    if (strcmp(@encode(int), type) == 0){
        return [NSString stringWithFormat:@"%d",*(int *)value];
    }
    
    if (strcmp(@encode(short), type) == 0){
        return [NSString stringWithFormat:@"%d",*(short *)value];
    }
    
    if (strcmp(@encode(long), type) == 0){
        return [NSString stringWithFormat:@"%ld",*(long *)value];
    }
    
    if (strcmp(@encode(long long), type) == 0){
        return [NSString stringWithFormat:@"%lld",*(long long *)value];
    }
    
    if (strcmp(@encode(signed char), type) == 0){
        char ch = *(char *)value;
        return [NSString stringWithFormat:@"%c",ch];
    }
    
    if (strcmp(@encode(const char *), type) == 0){
        return [NSString stringWithFormat:@"%s",*(const char **)value];
    }
    
    if (strcmp(@encode(unsigned char), type) == 0){
        return [NSString stringWithFormat:@"%c",*(unsigned char *)value];
    }
    
    if (strcmp(@encode(unsigned int), type) == 0){
        return [NSString stringWithFormat:@"%u",*(unsigned int *)value];
    }
    
    if (strcmp(@encode(unsigned short), type) == 0){
        return [NSString stringWithFormat:@"%u",*(unsigned short *)value];
    }
    
    if (strcmp(@encode(unsigned long), type) == 0){
        return [NSString stringWithFormat:@"%lu",*(unsigned long *)value];
    }
    
    if (strcmp(@encode(unsigned long long), type) == 0){
        return [NSString stringWithFormat:@"%llu",*(unsigned long long *)value];
    }
    
    NSString *typeString = [NSString stringWithUTF8String:type];
    NSString *matchedType = nil;
    
    // C string literals
    if ((matchedType = typeMatch(typeString, @"^\\[([0-9_]+)c\\]$"))) {
        int num = [matchedType intValue];
        return [NSString stringWithFormat:@"%s", ((char (*)[num])value)[0] ];
    }
    
    // Structure
    if ((matchedType = typeMatch(typeString, @"^\\{([A-Za-z0-9_]+)\\="))) {
        return [NSString stringWithFormat:@"{%@}",matchedType];
    }
    
    // Structure reference
    if ((matchedType = typeMatch(typeString, @"^\\^\\{([A-Za-z0-9_]+)\\="))) {
        return [NSString stringWithFormat:@"{%@: %p}",matchedType,*(void **)value];
    }
    
    return [NSString stringWithFormat:@"String not supported type (%s)", type];
}
