//
//  JCChain.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/12/19.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "JCChain.h"
#import <objc/message.h>

@interface JCChain ()
@property (nonatomic, weak) id object;
@end

@implementation JCChain

- (instancetype)initWithObject:(id)object {
    if (self = [super init]) {
        _object = object;
    }
    return self;
}

- (void)msgSendSel:(SEL)sel valueRef:(const void *)ref valueType:(const char *)type {
    if (strcmp(@encode(id), type) == 0) {
        __unsafe_unretained id object = *(__unsafe_unretained id *)ref;
         ((void (*)(id, SEL, id))(void *) objc_msgSend)(_object, sel, object);
        return;
    }
    if (strcmp(@encode(BOOL), type) == 0){
        BOOL b = *(BOOL *)ref;
        ((void (*)(id, SEL, BOOL))(void *) objc_msgSend)(_object, sel, b);
        return;
    }
    if (strcmp(@encode(int), type) == 0){
        int i = *(int *)ref;
        ((void (*)(id, SEL, int))(void *) objc_msgSend)(_object, sel, i);
        return;
    }
    if (strcmp(@encode(double), type) == 0){
        double d = *(double *)ref;
        ((void (*)(id, SEL, double))(void *) objc_msgSend)(_object, sel, d);
        return;
    }
    if (strcmp(@encode(float), type) == 0){
        float f = *(float *)ref;
        ((void (*)(id, SEL, float))(void *) objc_msgSend)(_object, sel, f);
        return;
    }
    if (strcmp(@encode(CGRect), type) == 0){
        CGRect rect = *(CGRect *)ref;
        ((void (*)(id, SEL, CGRect))(void *) objc_msgSend)(_object, sel, rect);
        return;
    }
    if (strcmp(@encode(CGPoint), type) == 0){
        CGPoint point = *(CGPoint *)ref;
        ((void (*)(id, SEL, CGPoint))(void *) objc_msgSend)(_object, sel, point);
        return;
    }
    if (strcmp(@encode(CGSize), type) == 0){
        CGSize size = *(CGSize *)ref;
        ((void (*)(id, SEL, CGSize))(void *) objc_msgSend)(_object, sel, size);
        return;
    }
    if (strcmp(@encode(Class), type) == 0){
        Class cla = *(Class *)ref;
        ((void (*)(id, SEL, Class))(void *) objc_msgSend)(_object, sel, cla);
        return;
    }
    if (strcmp(":", type) == 0){
        SEL s = *(SEL *)ref;
        ((void (*)(id, SEL, SEL))(void *) objc_msgSend)(_object, sel, s);
        return;
    }
    if (strcmp("@?", type) == 0) {
        __unsafe_unretained id value = *(__unsafe_unretained id *)ref;
       ((void (*)(id, SEL, void (^)()))(void *) objc_msgSend)(_object, sel, (void (^)())value);
        return;
    }
    if (strcmp(@encode(NSRange), type) == 0){
        NSRange range = *(NSRange *)ref;
        ((void (*)(id, SEL, NSRange))(void *) objc_msgSend)(_object, sel, range);
        return;
    }
    if (strcmp(@encode(CGAffineTransform), type) == 0){
        CGAffineTransform form = *(CGAffineTransform *)ref;
        ((void (*)(id, SEL, CGAffineTransform))(void *) objc_msgSend)(_object, sel, form);
        return;
    }
    if (strcmp(@encode(UIEdgeInsets), type) == 0){
        UIEdgeInsets insets = *(UIEdgeInsets *)ref;
        ((void (*)(id, SEL, UIEdgeInsets))(void *) objc_msgSend)(_object, sel, insets);
        return;
    }
    if (strcmp(@encode(UIOffset), type) == 0){
        UIOffset set = *(UIOffset *)ref;
        ((void (*)(id, SEL, UIOffset))(void *) objc_msgSend)(_object, sel, set);
        return;
    }
    if (strcmp(@encode(short), type) == 0){
        short s = *(short *)ref;
        ((void (*)(id, SEL, short))(void *) objc_msgSend)(_object, sel, s);
        return;
    }
    if (strcmp(@encode(long), type) == 0){
        long l = *(long *)ref;
        ((void (*)(id, SEL, long))(void *) objc_msgSend)(_object, sel, l);
        return;
    }
    if (strcmp(@encode(long long), type) == 0){
        long long ll = *(long long *)ref;
        ((void (*)(id, SEL, long long))(void *) objc_msgSend)(_object, sel, ll);
        return;
    }
    if (strcmp(@encode(signed char), type) == 0){
        signed char sc = *(signed char *)ref;
        ((void (*)(id, SEL, signed char))(void *) objc_msgSend)(_object, sel, sc);
        return;
    }
    if (strcmp(@encode(const char *), type) == 0){
        const char * cc = *(const char **)ref;
        ((void (*)(id, SEL, const char *))(void *) objc_msgSend)(_object, sel, cc);
        return;
    }
    if (strcmp(@encode(unsigned char), type) == 0){
        unsigned char uc = *(unsigned char *)ref;
        ((void (*)(id, SEL, unsigned char))(void *) objc_msgSend)(_object, sel, uc);
        return;
    }
    if (strcmp(@encode(unsigned int), type) == 0){
        unsigned int ui = *(unsigned int *)ref;
        ((void (*)(id, SEL, unsigned int))(void *) objc_msgSend)(_object, sel, ui);
        return;}
    if (strcmp(@encode(unsigned short), type) == 0){
        unsigned short us = *(unsigned short *)ref;
        ((void (*)(id, SEL, unsigned short))(void *) objc_msgSend)(_object, sel, us);
        return;}
    if (strcmp(@encode(unsigned long), type) == 0){
        unsigned long ul = *(unsigned long *)ref;
        ((void (*)(id, SEL, unsigned long))(void *) objc_msgSend)(_object, sel, ul);
        return;
    }
    if (strcmp(@encode(unsigned long long), type) == 0){
        unsigned long long ull = *(unsigned long long *)ref;
        ((void (*)(id, SEL, unsigned long long))(void *) objc_msgSend)(_object, sel, ull);
        return;
    }
}

@end

@implementation JCChain (UIView)

- (JCChain *(^)(UIColor *))bgColor {
    JCCHAIN_BLOCK_PROP(@selector(setBackgroundColor:), UIColor *)
}

- (JCChain *(^)(UIColor *))tintColor {
    JCCHAIN_BLOCK_PROP(@selector(setTintColor:), UIColor *)
}

- (JCChain *(^)(BOOL))hidden {
    JCCHAIN_BLOCK_PROP(@selector(setHidden:), BOOL)
}

- (JCChain *(^)(CGFloat))alpha {
    JCCHAIN_BLOCK_PROP(@selector(setAlpha:), CGFloat)
}

- (JCChain *(^)(NSInteger))tag {
    JCCHAIN_BLOCK_PROP(@selector(setTag:), NSInteger)
}

- (JCChain *(^)(BOOL))userEnabled {
    JCCHAIN_BLOCK_PROP(@selector(setUserInteractionEnabled:), BOOL)
}

- (JCChain *(^)(UIViewContentMode))contentMode {
    JCCHAIN_BLOCK_PROP(@selector(setContentMode:), UIViewContentMode)
}

- (JCChain *(^)(UIView *))addSubview {
    JCCHAIN_BLOCK_PROP(@selector(addSubview:), UIView *)
}

@end

@implementation JCChain (JCText)

- (JCChain *(^)(NSString *))text {
    JCCHAIN_BLOCK_PROP(@selector(setText:), NSString *);
}

- (JCChain *(^)(UIColor *))textColor {
    JCCHAIN_BLOCK_PROP(@selector(setTextColor:), UIColor *);
}

- (JCChain *(^)(UIFont *))font {
    JCCHAIN_BLOCK_PROP(@selector(setFont:), UIFont *)
}

- (JCChain *(^)(NSTextAlignment))textAlignment {
    JCCHAIN_BLOCK_PROP(@selector(setTextAlignment:), NSTextAlignment)
}

- (JCChain *(^)(NSInteger))numberOfLines {
    JCCHAIN_BLOCK_PROP(@selector(setNumberOfLines:), NSInteger)
}

- (JCChain *(^)(NSAttributedString *))attText {
    JCCHAIN_BLOCK_PROP(@selector(setAttributedText:), NSAttributedString *)
}

- (JCChain *(^)(NSString *))placeholder {
    JCCHAIN_BLOCK_PROP(@selector(setPlaceholder:), NSString *);
}

- (JCChain *(^)(NSAttributedString *))attPlaceholder {
    JCCHAIN_BLOCK_PROP(@selector(setAttributedPlaceholder:), NSAttributedString *);
}

- (JCChain *(^)(NSDictionary *))defaultTextAtt {
    JCCHAIN_BLOCK_PROP(@selector(setDefaultTextAttributes:), NSDictionary *)
}

- (JCChain *(^)(UITextBorderStyle))borderStyle {
    JCCHAIN_BLOCK_PROP(@selector(setBorderStyle:), UITextBorderStyle)
}

- (JCChain *(^)(UITextFieldViewMode))clearButtonMode {
    JCCHAIN_BLOCK_PROP(@selector(setClearButtonMode:), UITextFieldViewMode)
}

- (JCChain *(^)(UIKeyboardType))keyboardType {
    JCCHAIN_BLOCK_PROP(@selector(setKeyboardType:), UIKeyboardType)
}

- (JCChain *(^)(UIReturnKeyType))returnKeyType {
    JCCHAIN_BLOCK_PROP(@selector(setReturnKeyType:), UIReturnKeyType)
}

- (JCChain *(^)(UIKeyboardAppearance))keyboardAppearance {
    JCCHAIN_BLOCK_PROP(@selector(setKeyboardAppearance:), UIKeyboardAppearance);
}

- (JCChain *(^)(UIView *))inputView {
    JCCHAIN_BLOCK_PROP(@selector(setInputView:), UIView *)
}

- (JCChain *(^)(UIView *))inputAccessoryView {
    JCCHAIN_BLOCK_PROP(@selector(inputAccessoryView), UIView *)
}

- (JCChain *(^)(NSDictionary *))linkTextAtt {
    JCCHAIN_BLOCK_PROP(@selector(setLinkTextAttributes:), NSDictionary *)
}

@end

@implementation JCChain (UIButton)


#define JCCHAIN_BLOCK_BUTTON_PROP(sel, cla) \
return ^(cla *v, UIControlState s) { ((void (*)(id, SEL, id, NSUInteger))(void *) objc_msgSend)(_object, sel, v, s); return self;};

#define JCCHAIN_BLOCK_BUTTON_NORMAL(sel)  return ^(id t) { self.sel(t, UIControlStateNormal); return self; };


- (JCChain *(^)(NSString *, UIControlState))titleOrState {
    JCCHAIN_BLOCK_BUTTON_PROP(@selector(setTitle:forState:), NSString)
}

- (JCChain *(^)(UIColor *, UIControlState))colorOrState {
    JCCHAIN_BLOCK_BUTTON_PROP(@selector(setTitleColor:forState:), UIColor)
}

- (JCChain *(^)(UIColor *, UIControlState))shadowColorOrState {
    JCCHAIN_BLOCK_BUTTON_PROP(@selector(setTitleShadowColor:forState:), UIColor)
}

- (JCChain *(^)(UIImage *, UIControlState))imageOrState {
    JCCHAIN_BLOCK_BUTTON_PROP(@selector(setImage:forState:), UIImage)
}

- (JCChain *(^)(UIImage *, UIControlState))bgImageOrState {
    JCCHAIN_BLOCK_BUTTON_PROP(@selector(setBackgroundImage:forState:), UIImage)
}

- (JCChain *(^)(NSString *))title {
    JCCHAIN_BLOCK_BUTTON_NORMAL(titleOrState)
}

- (JCChain *(^)(UIColor *))color {
    JCCHAIN_BLOCK_BUTTON_NORMAL(colorOrState)
}

- (JCChain *(^)(UIColor *))shadowColor {
    JCCHAIN_BLOCK_BUTTON_NORMAL(shadowColorOrState)
}

- (JCChain *(^)(UIImage *))_image {
    JCCHAIN_BLOCK_BUTTON_NORMAL(imageOrState)
}

- (JCChain *(^)(UIImage *))bgImage {
    JCCHAIN_BLOCK_BUTTON_NORMAL(bgImageOrState)
}

@end

@implementation JCChain (UIImageView)

- (JCChain *(^)(UIImage *))image {
    JCCHAIN_BLOCK_PROP(@selector(setImage:), UIImage *)
}

- (JCChain *(^)(NSArray<UIImage *> *))images {
    JCCHAIN_BLOCK_PROP(@selector(setAnimationImages:), NSArray *)
}

- (JCChain *(^)(NSTimeInterval))duration {
    JCCHAIN_BLOCK_PROP(@selector(setAnimationDuration:), NSTimeInterval)
}

- (JCChain *(^)(NSInteger))repeat {
    JCCHAIN_BLOCK_PROP(@selector(setAnimationRepeatCount:), NSInteger)
}

@end

@implementation JCChain (UIScrollView)

- (JCChain *(^)(id))delegate {
    JCCHAIN_BLOCK_PROP(@selector(setDelegate:), id)
}

- (JCChain *(^)(id))dataSource {
    JCCHAIN_BLOCK_PROP(@selector(setDataSource:), id);
}

- (JCChain *(^)(CGPoint))offset {
    JCCHAIN_BLOCK_PROP(@selector(setContentOffset:), CGPoint)
}

- (JCChain *(^)(CGSize))contentSize {
    JCCHAIN_BLOCK_PROP(@selector(setContentSize:), CGSize)
}

- (JCChain *(^)(UIEdgeInsets))inset {
    JCCHAIN_BLOCK_PROP(@selector(setContentEdgeInsets:), UIEdgeInsets)
}

- (JCChain *(^)(BOOL))bounces {
    JCCHAIN_BLOCK_PROP(@selector(setBounces:), BOOL)
}

- (JCChain *(^)(BOOL))pagingEnabled {
    JCCHAIN_BLOCK_PROP(@selector(setPagingEnabled:), BOOL)
}

- (JCChain *(^)(BOOL))scrollEnabled {
    JCCHAIN_BLOCK_PROP(@selector(setScrollEnabled:), BOOL)
}

- (JCChain *(^)(BOOL))horizontalIndicator {
    JCCHAIN_BLOCK_PROP(@selector(setShowsHorizontalScrollIndicator:), BOOL)
}

- (JCChain *(^)(BOOL))verticalIndicator {
    JCCHAIN_BLOCK_PROP(@selector(setShowsVerticalScrollIndicator:), BOOL)
}

- (JCChain *(^)(CGFloat))rowHeight {
    JCCHAIN_BLOCK_PROP(@selector(setRowHeight:), CGFloat)
}

- (JCChain *(^)(CGFloat))sectionHeaderHeight {
    JCCHAIN_BLOCK_PROP(@selector(setSectionHeaderHeight:), CGFloat)
}

- (JCChain *(^)(CGFloat))sectionFooterHeight {
    JCCHAIN_BLOCK_PROP(@selector(setSectionFooterHeight:), CGFloat)
}

@end

@implementation JCChain (JCRect)

- (JCChain *(^)(CGRect))frame {
    JCCHAIN_BLOCK_PROP(@selector(setFrame:), CGRect)
}

- (JCChain *(^)(CGPoint))origin {
    JCCHAIN_BLOCK_PROP(@selector(setOrigin:), CGPoint)
}

- (JCChain *(^)(CGSize))size {
    JCCHAIN_BLOCK_PROP(@selector(setSize:), CGSize)
}

- (JCChain *(^)(CGFloat))x {
    JCCHAIN_BLOCK_PROP(@selector(setX:), CGFloat)
}

- (JCChain *(^)(CGFloat))y {
    JCCHAIN_BLOCK_PROP(@selector(setY:), CGFloat)
}

- (JCChain *(^)(CGFloat))width {
    JCCHAIN_BLOCK_PROP(@selector(setWidth:), CGFloat)
}

- (JCChain *(^)(CGFloat))height {
    JCCHAIN_BLOCK_PROP(@selector(setHeight:), CGFloat)
}

- (JCChain *(^)(CGPoint))center {
    JCCHAIN_BLOCK_PROP(@selector(setCenter:), CGPoint)
}

- (JCChain *(^)(CGFloat))centerX {
    JCCHAIN_BLOCK_PROP(@selector(setCenterX:), CGFloat)
}

- (JCChain *(^)(CGFloat))centerY {
    JCCHAIN_BLOCK_PROP(@selector(setCenterY:), CGFloat)
}

- (JCChain *(^)(CGFloat))right {
    JCCHAIN_BLOCK_PROP(@selector(setRight:), CGFloat)
}

- (JCChain *(^)(CGFloat))bottom {
    JCCHAIN_BLOCK_PROP(@selector(setBottom:), CGFloat)
}

@end

@implementation UIView (JCChain)

- (JCChain *)chain {
    return [[JCChain alloc] initWithObject:self];
}

@end
