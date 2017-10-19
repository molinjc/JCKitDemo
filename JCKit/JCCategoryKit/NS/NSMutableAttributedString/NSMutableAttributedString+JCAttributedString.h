//
//  NSMutableAttributedString+JCAttributedString.h
//
//  Created by molin.JC on 2016/12/13.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (JCAttributedString)

/**
 加载HTML的代码
 */
+ (NSAttributedString *)attributedStringWithHTML:(NSString *)html;

@end

@interface NSMutableAttributedString (JCAttributedString)

/**
 字体
 */
- (void)setFont:(UIFont *)font range:(NSRange)range;
- (void)setFont:(UIFont *)font;

/**
 文本颜色
 */
- (void)setTextColor:(UIColor *)color range:(NSRange)range;
- (void)setTextColor:(UIColor *)color;

/**
 段落样式
 */
- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range;
- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle;

/**
 下划线颜色
 */
- (void)setUnderlineColor:(UIColor *)color range:(NSRange)range;
- (void)setUnderlineStyle:(NSNumber *)number;

/**
 下划线
 @param number 样式，值为NSNumber类型
 */
- (void)setUnderlineStyle:(NSNumber *)number range:(NSRange)range;
- (void)setUnderlineColor:(UIColor *)color;

/**
 链接
 @param setress 链接地址
 */
- (void)setLinkAddress:(NSString *)setress range:(NSRange)range;
- (void)setLinkAddress:(NSString *)setress;

/**
 文本的背景颜色
 */
- (void)setBackgroundColor:(UIColor *)color range:(NSRange)range;
- (void)setBackgroundColor:(UIColor *)color;

/**
 字体阴影
 @param shadow 阴影
 */
- (void)setShadow:(NSShadow *)shadow range:(NSRange)range;
- (void)setShadow:(NSShadow *)shadow;

/**
 文件副本
 @param textAttachment 文件副本
 */
- (void)setTextAttachment:(NSTextAttachment *)textAttachment;

/** 对齐方向 */
- (void)setAlignment:(NSTextAlignment)alignment;
- (void)setAlignment:(NSTextAlignment)alignment range:(NSRange)range;

/** 省略号样式 */
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range;

/**
 计算文本大小
 */
- (CGFloat)widthForAttribute;
- (CGFloat)heightForAttribute;
- (CGFloat)heightForAttributeWithWidth:(CGFloat)width;
- (CGSize)sizeForAttributeWithSize:(CGSize)size;
- (CGSize)sizeForAttributeWithSize:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

@end
