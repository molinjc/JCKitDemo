//
//  JCAttributed.m
//  JCAttributed
//
//  Created by molin.JC on 2017/9/22.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCAttributed.h"

@interface JCAttributed ()
@property (nonatomic, strong) NSMutableDictionary *attributed;
@property (nonatomic, strong) NSMutableArray *atts;
/** 总体的 */
@property (nonatomic, strong) NSMutableAttributedString *attributedString;
/** 此次要生成的富文本 */
@property (nonatomic, strong) NSMutableAttributedString *subattributed;
/** 此次要设置的字符串 */
@property (nonatomic, copy) NSString *string;
@end

@implementation JCAttributed

- (instancetype)init {
    if (self = [super init]) {
        _attributedString = [[NSMutableAttributedString alloc] init];
    }
    return self;
}

- (NSAttributedString *)attributedString {
    if (_subattributed) {
        [_attributedString appendAttributedString:_subattributed];
        _subattributed = nil;
    }
    return _attributedString.mutableCopy;
}

- (NSMutableAttributedString *)mutableAttributedString {
    if (_subattributed) {
        [_attributedString appendAttributedString:_subattributed];
        _subattributed = nil;
    }
    return _attributedString;
}

- (JCAttributed *(^)(NSString *))addString {
    return ^(NSString *string) {
        _string = string.copy;
        if (_subattributed) {
            [_attributedString appendAttributedString:_subattributed];
        }
        _subattributed = [[NSMutableAttributedString alloc] initWithString:string];
        return self;
    };
}

- (JCAttributed *(^)(NSTextAttachment *))attachment {
    return ^(NSTextAttachment *attachment) {
        if (_string.length) {
            [_subattributed setValue:attachment forKey:NSAttachmentAttributeName];
        }else {
            NSAttributedString *attributedString = [NSAttributedString attributedStringWithAttachment:attachment];
            [_attributedString appendAttributedString:attributedString];
        }
        return self;
    };
}

#define _JCAttributed_Get(cls, att, key) \
- (JCAttributed *(^)(cls))att { return ^(cls att) {  \
[_subattributed addAttribute:key value:att range:NSMakeRange(0, _string.length)]; return self; };}
#define _JCAttributed_Get_Value(cls, att, key) \
- (JCAttributed *(^)(cls))att { return ^(cls att) { \
[_subattributed addAttribute:key value:@(att) range:NSMakeRange(0, _string.length)]; return self; };}


_JCAttributed_Get(UIFont *, font, NSFontAttributeName)
_JCAttributed_Get(UIColor *, textColor, NSForegroundColorAttributeName)
_JCAttributed_Get(NSParagraphStyle *, paragraphStyle, NSParagraphStyleAttributeName)
_JCAttributed_Get(UIColor *, backgroundColor, NSBackgroundColorAttributeName)
_JCAttributed_Get_Value(NSInteger, ligature, NSLigatureAttributeName)
_JCAttributed_Get_Value(NSInteger, kern, NSKernAttributeName)
_JCAttributed_Get_Value(NSUnderlineStyle, strikethroughStyle, NSStrikethroughStyleAttributeName)
_JCAttributed_Get_Value(NSUnderlineStyle, underlineStyle, NSUnderlineStyleAttributeName)
_JCAttributed_Get(UIColor *,strokeColor, NSStrokeColorAttributeName)
_JCAttributed_Get_Value(NSInteger, strokeWidth, NSStrokeWidthAttributeName)
_JCAttributed_Get(NSShadow *, shadow, NSShadowAttributeName)
_JCAttributed_Get(NSString *, textEffect, NSTextEffectAttributeName)
_JCAttributed_Get(NSURL *, link, NSLinkAttributeName)
_JCAttributed_Get_Value(float, baselineOffset, NSBaselineOffsetAttributeName)
_JCAttributed_Get(UIColor *, underlineColor, NSUnderlineColorAttributeName)
_JCAttributed_Get(UIColor *, strikethroughColor, NSStrikethroughColorAttributeName)
_JCAttributed_Get_Value(float, obliqueness, NSObliquenessAttributeName)
_JCAttributed_Get_Value(float, expansion, NSExpansionAttributeName)
_JCAttributed_Get_Value(NSWritingDirectionFormatType, writingDirection, NSWritingDirectionAttributeName)
_JCAttributed_Get_Value(NSInteger, verticalGlyphForm, NSVerticalGlyphFormAttributeName)

@end
