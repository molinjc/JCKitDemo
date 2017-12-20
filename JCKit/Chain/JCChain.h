//
//  JCChain.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/12/19.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JCCHAIN_MSGSEND_SEL(s, v) [self msgSendSel:s valueRef:(__typeof__(v) []){v} valueType:@encode(__typeof__(v))]
#define JCCHAIN_BLOCK_PROP(sel, Clas) return ^(Clas cla) { JCCHAIN_MSGSEND_SEL(sel, cla); return self;};

@interface JCChain : NSObject
/** 创建并指定要赋值给的类 */
- (instancetype)initWithObject:(id)object;
@end

@interface JCChain (UIView)
@property (nonatomic, weak, readonly) JCChain *(^bgColor)(UIColor *);
@property (nonatomic, weak, readonly) JCChain *(^tintColor)(UIColor *);
@property (nonatomic, weak, readonly) JCChain *(^hidden)(BOOL);
@property (nonatomic, weak, readonly) JCChain *(^alpha)(CGFloat);
@property (nonatomic, weak, readonly) JCChain *(^tag)(NSInteger);
@property (nonatomic, weak, readonly) JCChain *(^userEnabled)(BOOL);
@property (nonatomic, weak, readonly) JCChain *(^contentMode)(UIViewContentMode);
@property (nonatomic, weak, readonly) JCChain *(^addSubview)(UIView *);
@end

/** 文本类型视图的链接式 */
@interface JCChain (JCText)
@property (nonatomic, weak, readonly) JCChain *(^text)(NSString *);
@property (nonatomic, weak, readonly) JCChain *(^font)(UIFont *);
@property (nonatomic, weak, readonly) JCChain *(^textColor)(UIColor *);
@property (nonatomic, weak, readonly) JCChain *(^textAlignment)(NSTextAlignment);
@property (nonatomic, weak, readonly) JCChain *(^numberOfLines)(NSInteger);
@property (nonatomic, weak, readonly) JCChain *(^attText)(NSAttributedString *);
/** 以下适用UITextField、UITextView */
@property (nonatomic, weak, readonly) JCChain *(^placeholder)(NSString *placeholder);
@property (nonatomic, weak, readonly) JCChain *(^attPlaceholder)(NSAttributedString *);
@property (nonatomic, weak, readonly) JCChain *(^defaultTextAtt)(NSDictionary *);
@property (nonatomic, weak, readonly) JCChain *(^borderStyle)(UITextBorderStyle);
@property (nonatomic, weak, readonly) JCChain *(^clearButtonMode)(UITextFieldViewMode);
@property (nonatomic, weak, readonly) JCChain *(^keyboardType)(UIKeyboardType);
@property (nonatomic, weak, readonly) JCChain *(^returnKeyType)(UIReturnKeyType);
@property (nonatomic, weak, readonly) JCChain *(^keyboardAppearance)(UIKeyboardAppearance);
@property (nonatomic, weak, readonly) JCChain *(^inputView)(UIView *);
@property (nonatomic, weak, readonly) JCChain *(^inputAccessoryView)(UIView *);
@property (nonatomic, weak, readonly) JCChain *(^linkTextAtt)(NSDictionary *);
@end

@interface JCChain (UIButton)
@property (nonatomic, weak, readonly) JCChain *(^title)(NSString *);
@property (nonatomic, weak, readonly) JCChain *(^titleOrState)(NSString *, UIControlState);
@property (nonatomic, weak, readonly) JCChain *(^color)(UIColor *);
@property (nonatomic, weak, readonly) JCChain *(^colorOrState)(UIColor *, UIControlState);
@property (nonatomic, weak, readonly) JCChain *(^shadowColor)(UIColor *);
@property (nonatomic, weak, readonly) JCChain *(^shadowColorOrState)(UIColor *, UIControlState);
/** 与JCChain (UIImageView)的image作区别 */
@property (nonatomic, weak, readonly) JCChain *(^_image)(UIImage *);
@property (nonatomic, weak, readonly) JCChain *(^imageOrState)(UIImage *, UIControlState);
@property (nonatomic, weak, readonly) JCChain *(^bgImage)(UIImage *);
@property (nonatomic, weak, readonly) JCChain *(^bgImageOrState)(UIImage *, UIControlState);
@end

@interface JCChain (UIImageView)
@property (nonatomic, weak, readonly) JCChain *(^image)(UIImage *);
@property (nonatomic, weak, readonly) JCChain *(^images)(NSArray <UIImage *> *);
@property (nonatomic, weak, readonly) JCChain *(^duration)(NSTimeInterval);
@property (nonatomic, weak, readonly) JCChain *(^repeat)(NSInteger);
@end

@interface JCChain (UIScrollView)
@property (nonatomic, weak, readonly) JCChain *(^delegate)(id);
@property (nonatomic, weak, readonly) JCChain *(^dataSource)(id);
@property (nonatomic, weak, readonly) JCChain *(^offset)(CGPoint);
@property (nonatomic, weak, readonly) JCChain *(^contentSize)(CGSize);
@property (nonatomic, weak, readonly) JCChain *(^inset)(UIEdgeInsets);
@property (nonatomic, weak, readonly) JCChain *(^bounces)(BOOL);
@property (nonatomic, weak, readonly) JCChain *(^pagingEnabled)(BOOL);
@property (nonatomic, weak, readonly) JCChain *(^scrollEnabled)(BOOL);
@property (nonatomic, weak, readonly) JCChain *(^horizontalIndicator)(BOOL);
@property (nonatomic, weak, readonly) JCChain *(^verticalIndicator)(BOOL);
@property (nonatomic, weak, readonly) JCChain *(^rowHeight)(CGFloat);
@property (nonatomic, weak, readonly) JCChain *(^sectionHeaderHeight)(CGFloat);
@property (nonatomic, weak, readonly) JCChain *(^sectionFooterHeight)(CGFloat);
@end

/** 对View的Frame等变量赋值, 需要引用UIView+JCLayout.h */
@interface JCChain (JCRect)
@property (nonatomic, weak, readonly) JCChain *(^frame)(CGRect);
@property (nonatomic, weak, readonly) JCChain *(^origin)(CGPoint);
@property (nonatomic, weak, readonly) JCChain *(^size)(CGSize);
@property (nonatomic, weak, readonly) JCChain *(^x)(CGFloat);
@property (nonatomic, weak, readonly) JCChain *(^y)(CGFloat);
@property (nonatomic, weak, readonly) JCChain *(^width)(CGFloat);
@property (nonatomic, weak, readonly) JCChain *(^height)(CGFloat);
@property (nonatomic, weak, readonly) JCChain *(^center)(CGPoint);
@property (nonatomic, weak, readonly) JCChain *(^centerX)(CGFloat);
@property (nonatomic, weak, readonly) JCChain *(^centerY)(CGFloat);
@property (nonatomic, weak, readonly) JCChain *(^right)(CGFloat);
@property (nonatomic, weak, readonly) JCChain *(^bottom)(CGFloat);
@end

@interface UIView (JCChain)
@property (nonatomic, weak, readonly) JCChain *chain;
@end
