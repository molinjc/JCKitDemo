//
//  NSDictionary+JCBlock.h
//
//  Created by 林建川 on 16/10/9.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary (JCBlock)

/** 遍历每个元素 */
- (void)each:(void (^)(id key, id obj))block;

/** 反序遍历每个元素 */
- (void)reverseEach:(void (^)(id key, id obj))block;

/** 选择条件满足前的元素 */
- (NSDictionary *)select:(BOOL (^)(id key, id obj))block;

/** 是否包含key对应的value */
- (BOOL)containsObjectForKey:(id)key;

/** 获取字典某些key的value */
- (NSDictionary *)entriesForKeys:(NSArray *)keys;

/** 将字典转换为JSON字符串。如果出现错误返回零。 */
- (NSString *)jsonStringEncoded;

#pragma mark - Dictionary Value Getter

- (NSInteger)integerValueForKey:(id)key;
- (NSInteger)integerValueForKey:(id)key default:(NSInteger)def;

- (int)intValueForKey:(id)key;
- (int)intValueForKey:(id)key default:(int)def;

- (float)floatValueForKey:(id)key;
- (float)floatValueForKey:(id)key default:(float)def;

- (double)doubleValueForKey:(id)key;
- (double)doubleValueForKey:(id)key default:(double)def;

- (BOOL)boolValueForKey:(id)key;
- (BOOL)boolValueForKey:(id)key default:(BOOL)def;

- (char)charValueForKey:(id)key;
- (char)charValueForKey:(id)key default:(char)def;

- (NSString *)stringValueForKey:(id)key;
- (NSString *)stringValueForKey:(id)key default:(NSString *)def;

- (NSNumber *)numberValueForKey:(id)key;
- (NSNumber *)numberValueForKey:(id)key default:(NSNumber *)def;

- (NSArray *)arrayValueForKey:(id)key;
- (NSArray *)arrayValueForKey:(id)key default:(NSArray *)def;

- (NSMutableArray *)mutableArrayValueForKey:(id)key;
- (NSMutableArray *)mutableArrayValueForKey:(id)key default:(NSArray *)def;

- (NSDictionary *)dictionaryValueForKey:(id)key;
- (NSDictionary *)dictionaryValueForKey:(id)key default:(NSDictionary *)def;

- (NSMutableDictionary *)mutableDictionaryValueForKey:(id)key;
- (NSMutableDictionary *)mutableDictionaryValueForKey:(id)key default:(NSDictionary *)def;

- (CGFloat)CGFloatValueForKey:(id)key;
- (CGSize)CGSizeValueForKey:(id)key;
- (CGPoint)CGPointValueForKey:(id)key;
- (CGRect)CGRectValueForKey:(id)key;

/** 两个字典合并 */
- (NSDictionary *)merging:(NSDictionary *)dic;

@end

typedef id (^_weakReference)(void);

@interface NSMutableDictionary (JCBlock)
/** 存储弱引用对象 */
- (void)setWeakObject:(id)anObject forKey:(id<NSCopying>)aKey;
/** 存储弱引用dictionary的all Value */
- (void)setWeakObjectWithDictionary:(NSDictionary *)dictionary;
/** 获取弱引用对象 */
- (id)getWeakObjectForKey:(id<NSCopying>)aKey;
@end
