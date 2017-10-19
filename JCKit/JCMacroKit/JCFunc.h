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


