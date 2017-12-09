//
//  JCAttributed.h
//  JCAttributed
//
//  Created by molin.JC on 2017/9/22.
//  Copyright © 2017年 molin. All rights reserved.

#import <UIKit/UIKit.h>

/** 简化NSAttributedString的创建 */
@interface JCAttributed : NSObject
- (instancetype)init;
/** 生成富文本 */
- (NSAttributedString *)attributedString;
/** 生成可变富文本 */
- (NSMutableAttributedString *)mutableAttributedString;
/** 添加字符串 */
@property (nonatomic, weak, readonly) JCAttributed *(^addString)(NSString *);
/** 字体 */
@property (nonatomic, weak, readonly) JCAttributed *(^font)(UIFont *);
/** 字体颜色 */
@property (nonatomic, weak, readonly) JCAttributed *(^textColor)(UIColor *);
/** 文本附件,常用于文字图片混排 */
@property (nonatomic, weak, readonly) JCAttributed *(^attachment)(NSTextAttachment *);
/** 链接属性,点击后调用浏览器打开指定URL地址 */
@property (nonatomic, weak, readonly) JCAttributed *(^link)(NSURL *);
/** 段落的风格(设置首行,行间距,对齐方式的等) */
@property (nonatomic, weak, readonly) JCAttributed *(^paragraphStyle)(NSParagraphStyle *);
/** 字体所在区域背景颜色 */
@property (nonatomic, weak, readonly) JCAttributed *(^backgroundColor)(UIColor *);
/** 连体属性, 0:表示没有连体字符, 1:表示使用默认的连体字符 */
@property (nonatomic, weak, readonly) JCAttributed *(^ligature)(NSInteger);
/** 字符间距, 正值间距加宽, 负值间距变窄 */
@property (nonatomic, weak, readonly) JCAttributed *(^kern)(NSInteger);
/** 删除线 */
@property (nonatomic, weak, readonly) JCAttributed *(^strikethroughStyle)(NSUnderlineStyle);
/** 下划线, 与删除线类似 */
@property (nonatomic, weak, readonly) JCAttributed *(^underlineStyle)(NSUnderlineStyle);
/** 填充部分颜色,不是字体颜色 */
@property (nonatomic, weak, readonly) JCAttributed *(^strokeColor)(UIColor *strokeColor);
/** 笔画宽度, 负值填充效果,正值中空效果  */
@property (nonatomic, weak, readonly) JCAttributed *(^strokeWidth)(NSInteger);
/** 阴影属性 */
@property (nonatomic, weak, readonly) JCAttributed *(^shadow)(NSShadow *);
/** 文本特殊效果,目前只有图版印刷效果可用 */
@property (nonatomic, weak, readonly) JCAttributed *(^textEffect)(NSString *);
/** 基线偏移值, 正值上偏,负值下偏 */
@property (nonatomic, weak, readonly) JCAttributed *(^baselineOffset)(float);
/** 下划线颜色, 默认值为黑色 */
@property (nonatomic, weak, readonly) JCAttributed *(^underlineColor)(UIColor *underlineColor);
/** 删除线颜色, 默认值为黑色 */
@property (nonatomic, weak, readonly) JCAttributed *(^strikethroughColor)(UIColor *strikethroughColor);
/** 字形倾斜度, 正值右倾,负值左倾  */
@property (nonatomic, weak, readonly) JCAttributed *(^obliqueness)(float);
/** 文本横向拉伸属性, 正值横向拉伸文本,负值横向压缩文本 */
@property (nonatomic, weak, readonly) JCAttributed *(^expansion)(float);
/** 文字书写方向,从左向右书写或者从右向左书写 */
@property (nonatomic, weak, readonly) JCAttributed *(^writingDirection)(NSWritingDirectionFormatType);
/** 文字排版方向, 0:表示横排文本, 1:表示竖排文本 */
@property (nonatomic, weak, readonly) JCAttributed *(^verticalGlyphForm)(NSInteger);
@end
