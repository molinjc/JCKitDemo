//
//  NSMutableAttributedString+JCAttributedString.m
//
//  Created by molin.JC on 2016/12/13.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSMutableAttributedString+JCAttributedString.h"
#import "NSString+JCString.h"
#import "NSParagraphStyle+JCText.h"

static NSString *kNSFont           = @"NSFont";
static NSString *kNSParagraphStyle = @"NSParagraphStyle";

@implementation NSAttributedString (JCAttributedString)

/**
 加载HTML的代码
 */
+ (NSAttributedString *)attributedStringWithHTML:(NSString *)html {
    return [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding]
                                            options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                 documentAttributes:nil
                                              error:nil];
}

@end

@implementation NSMutableAttributedString (JCAttributedString)

static inline NSRange StringRange(NSMutableAttributedString *attributedString) {
    return NSMakeRange(0, attributedString.string.length);
}

/**
 字体
 */
- (void)setFont:(UIFont *)font range:(NSRange)range {
    [self addAttribute:NSFontAttributeName value:font range:range];
}

- (void)setFont:(UIFont *)font {
    [self setFont:font range:StringRange(self)];
}

/**
 文本颜色
 */
- (void)setTextColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)setTextColor:(UIColor *)color {
    [self setTextColor:color range:StringRange(self)];
}

/**
 段落样式
 */
- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle range:(NSRange)range {
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
}

- (void)setParagraphStyle:(NSParagraphStyle *)paragraphStyle {
    [self setParagraphStyle:paragraphStyle range:StringRange(self)];
}

/**
 下划线
 @param number 样式，值为NSNumber类型
 */
- (void)setUnderlineStyle:(NSNumber *)number range:(NSRange)range {
    [self addAttribute:NSUnderlineStyleAttributeName value:number range:range];
}

- (void)setUnderlineStyle:(NSNumber *)number {
    [self setUnderlineStyle:number range:StringRange(self)];
}

/**
 下划线颜色
 */
- (void)setUnderlineColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSUnderlineColorAttributeName value:color range:range];
}

- (void)setUnderlineColor:(UIColor *)color {
    [self setUnderlineColor:color range:StringRange(self)];
}

/**
 链接
 @param setress 链接地址
 */
- (void)setLinkAddress:(NSString *)setress range:(NSRange)range {
    [self addAttribute:NSLinkAttributeName value:setress range:range];
}

- (void)setLinkAddress:(NSString *)setress {
    [self setLinkAddress:setress range:StringRange(self)];
}

/**
 文本的背景颜色
 */
- (void)setBackgroundColor:(UIColor *)color range:(NSRange)range {
    [self addAttribute:NSBackgroundColorAttributeName value:color range:range];
}

- (void)setBackgroundColor:(UIColor *)color {
    [self setBackgroundColor:color range:StringRange(self)];
}

/**
 字体阴影
 @param shadow 阴影
 */
- (void)setShadow:(NSShadow *)shadow range:(NSRange)range {
    if (!shadow) { return; }
    [self addAttribute:NSShadowAttributeName value:shadow range:range];
}

- (void)setShadow:(NSShadow *)shadow {
    [self setShadow:shadow range:StringRange(self)];
}

/**
 文件副本
 @param textAttachment 文件副本
 */
- (void)setTextAttachment:(NSTextAttachment *)textAttachment {
    NSAttributedString *subAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [self appendAttributedString:subAttributedString];
}


#define _ParagraphStyleSet(_attr_) \
[self enumerateAttribute:NSParagraphStyleAttributeName inRange:range options:kNilOptions usingBlock:^(NSParagraphStyle *value, NSRange subRange, BOOL *stop) { \
NSMutableParagraphStyle *style = nil; \
if (value) { \
    if (CFGetTypeID((__bridge CFTypeRef)(value)) == CTParagraphStyleGetTypeID()) { \
        value = [NSParagraphStyle styleWithCTStyle:(__bridge CTParagraphStyleRef)(value)]; \
    } \
    if (value._attr_ == _attr_) { return ; } \
    if ([value isKindOfClass:[NSMutableParagraphStyle class]]) { \
        style = (id)value; \
    }else { \
        style = value.mutableCopy; \
    } \
}else {  \
    if ([NSParagraphStyle defaultParagraphStyle]._attr_ == _attr_) { return; } \
    style = [NSParagraphStyle defaultParagraphStyle].mutableCopy; \
} \
style._attr_ = _attr_; \
[self setParagraphStyle:style range:subRange]; }];

- (void)setAlignment:(NSTextAlignment)alignment {
    [self setAlignment:alignment range:StringRange(self)];
}

- (void)setAlignment:(NSTextAlignment)alignment range:(NSRange)range  {
    _ParagraphStyleSet(alignment);
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    [self setLineBreakMode:lineBreakMode range:NSMakeRange(0, self.length)];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range {
    _ParagraphStyleSet(lineBreakMode);
}

/**
 计算文本大小
 */
- (CGFloat)widthForAttribute {
    return [self sizeForAttributeWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
}

- (CGFloat)heightForAttribute {
    return [self heightForAttributeWithWidth:MAXFLOAT];
}

- (CGFloat)heightForAttributeWithWidth:(CGFloat)width {
    return [self sizeForAttributeWithSize:CGSizeMake(width, MAXFLOAT)].height;
}

- (CGSize)sizeForAttributeWithSize:(CGSize)size {
    return [self sizeForAttributeWithSize:size mode:NSLineBreakByWordWrapping];
}

- (CGSize)sizeForAttributeWithSize:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    __block CGFloat width = 0;
    __block CGFloat height = 0;
    [self enumerateAttributesInRange:NSMakeRange(0, self.string.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *text = [self.string substringWithRange:range];
        UIFont *font = attrs[kNSFont];
        NSParagraphStyle *paragraphStyle = attrs[kNSParagraphStyle];
        CGSize textSize = [text sizeForFont:font size:size mode:lineBreakMode];
        if (paragraphStyle) {
            height += paragraphStyle.paragraphSpacing + paragraphStyle.paragraphSpacingBefore * 1.5 + paragraphStyle.lineSpacing;
        }
        width += textSize.width;
        height += textSize.height;
    }];
    return CGSizeMake(width, height);
}

@end
