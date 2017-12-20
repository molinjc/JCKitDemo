//
//  JCArchivedModel.m
//  JCKitDemo02
//
//  Created by molin.JC on 2017/5/14.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCArchivedModel.h"
#import "JCClassInfo.h"
#import <objc/message.h>

@implementation JCArchivedModel

#pragma mark - unarchived 解档

+ (instancetype)unarchivedModel {
    return [self unarchivedModelNamed:NSStringFromClass(self)];
}

+ (instancetype)unarchivedModelNamed:(NSString *)name {
    if (!name) { return nil; }
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivedPathWithName:name]];
}

#pragma mark - archived 归档

- (BOOL)archivedModel {
    return [self archivedModelNamed:NSStringFromClass([self class])];
}

- (BOOL)archivedModelNamed:(NSString *)name {
    return [NSKeyedArchiver archiveRootObject:self toFile:[self archivedPathWithName:name]];
}

- (void)asyncArchivedModel {
    [self asyncArchivedModelNamed:NSStringFromClass([self class]) result:nil];
}

- (void)asyncArchivedModelNamed:(NSString *)name result:(void (^)(BOOL rt))result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL _result = [self archivedModelNamed:name];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                result(_result);
            }
        });
    });
}

- (void)archivedNullValueModel {
    [self archivedNullValueModelNamed:NSStringFromClass([self class])];
}

- (void)archivedNullValueModelNamed:(NSString *)name {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self clearAllValue];
        [self archivedModelNamed:name];
    });
}

- (NSData *)archivedData {
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

#pragma mark - path

/** 归档路径 */
+ (NSString *)archivedPathWithName:(NSString *)name {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", name]];
    return path;
}

/** 归档路径 */
- (NSString *)archivedPathWithName:(NSString *)name {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", name]];
    return path;
}

#pragma mark - handle static

/** 处理Class */
static inline NSString * _handleClass(id model, NSString *sel) {
    Class cla = ((Class (*)(id, SEL)) objc_msgSend)(model, NSSelectorFromString(sel));
    return NSStringFromClass(cla);
}

/** 处理SEL */
static inline NSString * _handleSEL(id model, NSString *sel) {
    SEL _sel = ((SEL (*)(id, SEL)) objc_msgSend)(model, NSSelectorFromString(sel));
    return NSStringFromSelector(_sel);
}

/** 处理对象成字典 */
static inline NSData * _handleObjToData(id value) {
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

/** 处理字典成对象 */
static inline id _handleDataToObj(id value) {
    if (!value) { return nil; }
    if (![value isKindOfClass:[NSData class]]) { return value; }
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        NSDictionary *propertyInfos = [self propertyInfos];
        [propertyInfos enumerateKeysAndObjectsUsingBlock:^(NSString *key, JCClassPropertyInfo *obj, BOOL *stop) {
            id value = [decoder decodeObjectForKey:key];
            if (value) {
                if (obj.nsType || obj.isCNumber) {
                    [self setValue:value forKey:key];
                }else {
                    switch (obj.type & JCEncodingTypeMask) {
                        case JCEncodingTypeObject: {
                            [self setValue:_handleDataToObj(value) forKey:key];
                        } break;
                        case JCEncodingTypeClass: {
                            if (value) {
                                Class cla = NSClassFromString(value);
                                ((void (*)(id, SEL, Class))(void *) objc_msgSend)(self, NSSelectorFromString(obj.setter), (Class)cla);
                            }
                        } break;
                        case JCEncodingTypeSEL: {
                            if (value) {
                                SEL sel = NSSelectorFromString(value);
                                ((void (*)(id, SEL, SEL))(void *) objc_msgSend)(self, NSSelectorFromString(obj.setter), (SEL)sel);
                            }
                        } break;
                        case JCEncodingTypeStruct:
                        case JCEncodingTypeUnion:
                        case JCEncodingTypeCArray:
                        case JCEncodingTypePointer:
                        case JCEncodingTypeCString: {
                            [self setValue:value forKey:key];
                        } break;
                        case JCEncodingTypeBlock: {
                        } break;
                        default:
                            break;
                    }
                }
            }
        }];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSDictionary *propertyInfos = [self propertyInfos];
    NSArray *doNotArchiveds = nil;
    if ([self respondsToSelector:@selector(doNotArchived)]) {
        doNotArchiveds = [self doNotArchived];
    }
    [propertyInfos enumerateKeysAndObjectsUsingBlock:^(NSString *key, JCClassPropertyInfo *obj, BOOL * stop) {
        BOOL skip = NO;
        if (doNotArchiveds) {
            skip = [doNotArchiveds containsObject:key];
        }
        
        if (!skip) {
            if (obj.nsType || obj.isCNumber) {
                [aCoder encodeObject:[self valueForKey:key] forKey:key];
            }else {
                switch (obj.type & JCEncodingTypeMask) {
                    case JCEncodingTypeObject: {
                        [aCoder encodeObject:_handleObjToData([self valueForKey:key]) forKey:key];
//                        [aCoder encodeObject:[self valueForKey:key] forKey:key];
                    } break;
                    case JCEncodingTypeClass: {
                        [aCoder encodeObject:_handleClass(self, obj.getter) forKey:key];
                    } break;
                    case JCEncodingTypeSEL: {
                        [aCoder encodeObject:_handleSEL(self, obj.getter) forKey:key];
                    } break;
                    case JCEncodingTypeStruct:
                    case JCEncodingTypeUnion:
                    case JCEncodingTypeCArray:
                    case JCEncodingTypePointer:
                    case JCEncodingTypeCString: {
                        [aCoder encodeObject:[self valueForKey:key] forKey:key];
                    } break;
                    case JCEncodingTypeBlock: break;
                    default:
                        break;
                }
            }
        }
    }];
}

#pragma mark -

- (void)clearAllValue {
    NSDictionary *propertyInfos = [self propertyInfos];
    [propertyInfos enumerateKeysAndObjectsUsingBlock:^(NSString *key, JCClassPropertyInfo *obj, BOOL * stop) {
        ((void (*)(id, SEL, void *))(void *) objc_msgSend)(self, NSSelectorFromString(obj.setter), NULL);
    }];
}

/** 获取各个属性 */
- (NSDictionary *)propertyInfos {
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    if (propertyCount) {
        NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
        for (unsigned int i = 0; i < propertyCount; i++) {
            JCClassPropertyInfo *info = [[JCClassPropertyInfo alloc] initWithProperty:propertys[i]];
            if (info.name) {
                propertyInfos[info.name] = info;
            }
        }
        free(propertys);
        return propertyInfos.mutableCopy;
    }
    return nil;
}

@end
