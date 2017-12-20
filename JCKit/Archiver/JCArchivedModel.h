//
//  JCArchivedModel.h
//  JCKitDemo02
//
//  Created by molin.JC on 2017/5/14.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JCArchivedModel <NSObject>
@optional
/** 不归档的字段 */
- (NSArray <NSString *> *)doNotArchived;

@end

@interface JCArchivedModel : NSObject <NSCoding, JCArchivedModel>
/** 解档 */
+ (instancetype)unarchivedModel;
+ (instancetype)unarchivedModelNamed:(NSString *)name;

/** 归档 */
- (BOOL)archivedModel;
- (BOOL)archivedModelNamed:(NSString *)name;
/** 异步归档 */
- (void)asyncArchivedModel;
- (void)asyncArchivedModelNamed:(NSString *)name result:(void (^)(BOOL rt))result;

/** 清除所有数据 */
- (void)clearAllValue;

/** 异步清除所有数据并归档 */
- (void)archivedNullValueModel;
- (void)archivedNullValueModelNamed:(NSString *)name;

/** 归档数据 */
- (NSData *)archivedData;

@end
