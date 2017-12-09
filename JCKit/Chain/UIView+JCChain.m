//
//  UIView+JCChain.m
//  JCKitDemo
//
//  Created by molin.JC on 2017/12/1.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UIView+JCChain.h"

#define _Chain_set(Cla, p, sel, r) \
- (Cla *(^)(r))sel { return ^(r p){self.p = p; return self;};}


@implementation UIView (JCChain)

+ (instancetype)init {
    return [[self alloc] init];
}

_Chain_set(UIView, backgroundColor, setBackgroundColor, UIColor *)
@end

@implementation UILabel (JCChain)
_Chain_set(UILabel, backgroundColor, setBackgroundColor, UIColor *)
_Chain_set(UILabel, text, setText, NSString *)
_Chain_set(UILabel, font, setFont, UIFont *)
_Chain_set(UILabel, textColor, setTextColor, UIColor *)
_Chain_set(UILabel, textAlignment, setTextAlignment, NSTextAlignment)
_Chain_set(UILabel, numberOfLines, setNumberOfLines, NSInteger)
_Chain_set(UILabel, attributedText, setAttributedText, NSAttributedString *)
@end

@implementation UITextField (JCChain)
_Chain_set(UITextField, delegate, setDelegate, id<UITextFieldDelegate>)
_Chain_set(UITextField, backgroundColor, setBackgroundColor, UIColor *)
_Chain_set(UITextField, text, setText, NSString *)
_Chain_set(UITextField, font, setFont, UIFont *)
_Chain_set(UITextField, textColor, setTextColor, UIColor *)
_Chain_set(UITextField, textAlignment, setTextAlignment, NSTextAlignment)
_Chain_set(UITextField, attributedText, setAttributedText, NSAttributedString *)
_Chain_set(UITextField, placeholder, setPlaceholder, NSString *)
_Chain_set(UITextField, attributedPlaceholder, setAttributedPlaceholder, NSAttributedString *)
_Chain_set(UITextField, defaultTextAttributes, setDefaultTextAttributes, NSDictionary *)
_Chain_set(UITextField, borderStyle, setBorderStyle, UITextBorderStyle)
_Chain_set(UITextField, clearButtonMode, setClearButtonMode, UITextFieldViewMode)
_Chain_set(UITextField, keyboardType, setKeyboardType, UIKeyboardType)
_Chain_set(UITextField, returnKeyType, setReturnKeyType, UIReturnKeyType)
_Chain_set(UITextField, keyboardAppearance, setKeyboardAppearance, UIKeyboardAppearance)
_Chain_set(UITextField, inputView, setInputView, UIView *)
_Chain_set(UITextField, inputAccessoryView, setInputAccessoryView, UIView *)
@end

@implementation UITextView (JCChain)
_Chain_set(UITextView, delegate, setDelegate, id<UITextViewDelegate>)
_Chain_set(UITextView, backgroundColor, setBackgroundColor, UIColor *)
_Chain_set(UITextView, text, setText, NSString *)
_Chain_set(UITextView, font, setFont, UIFont *)
_Chain_set(UITextView, textColor, setTextColor, UIColor *)
_Chain_set(UITextView, textAlignment, setTextAlignment, NSTextAlignment)
_Chain_set(UITextView, attributedText, setAttributedText, NSAttributedString *)
_Chain_set(UITextView, linkTextAttributes, setLinkTextAttributes, NSDictionary *)
_Chain_set(UITextView, keyboardType, setKeyboardType, UIKeyboardType)
_Chain_set(UITextView, returnKeyType, setReturnKeyType, UIReturnKeyType)
_Chain_set(UITextView, keyboardAppearance, setKeyboardAppearance, UIKeyboardAppearance)
_Chain_set(UITextView, inputView, setInputView, UIView *)
_Chain_set(UITextView, inputAccessoryView, setInputAccessoryView, UIView *)
@end

@implementation UIControl (JCChain)
_Chain_set(UIControl, backgroundColor, setBackgroundColor, UIColor *)

- (UIControl *(^)(id, SEL, UIControlEvents))addTarget {
    return ^(id target, SEL action, UIControlEvents event) {
        [self addTarget:target action:action forControlEvents:event]; return self;
    };
}
@end

@implementation UIButton (JCChain)

+ (UIButton *(^)(UIButtonType))buttonType {
    return ^(UIButtonType type) {
        return [UIButton buttonWithType:type];
    };
}

- (UIButton *(^)(id, SEL, UIControlEvents))addTarget {
    return ^(id target, SEL action, UIControlEvents event) {
        [self addTarget:target action:action forControlEvents:event]; return self;
    };
}

- (UIButton *(^)(UIFont *))setFont {
    return ^(UIFont *font) { self.titleLabel.font = font; return self; };
}

#define _Chain_buttonSet(sel, r) \
- (UIButton *(^)(r, UIControlState))sel##OrState {return ^(r p, UIControlState state){[self sel:p forState:state]; return self;}; } \
- (UIButton *(^)(r))sel {return ^(r p){self.sel##OrState(p, UIControlStateNormal); return self;};}

_Chain_buttonSet(setTitle, NSString *)
_Chain_buttonSet(setTitleColor, UIColor *)
_Chain_buttonSet(setAttributedTitle, NSAttributedString *)
_Chain_buttonSet(setImage, UIImage *)
_Chain_buttonSet(setBackgroundImage, UIImage *)
@end

@implementation UIImageView (JCChain)

+ (UIImageView *(^)(UIImage *))initWithImage {
    return ^(UIImage *image) { return [[UIImageView alloc] initWithImage:image]; };
}
_Chain_set(UIImageView, backgroundColor, setBackgroundColor, UIColor *)
_Chain_set(UIImageView, image, setImage, UIImage *)
@end

@implementation UIScrollView (JCChain)
_Chain_set(UIScrollView, delegate, setDelegate, id<UIScrollViewDelegate>)
_Chain_set(UIScrollView, backgroundColor, setBackgroundColor, UIColor *)
_Chain_set(UIScrollView, contentOffset, setOffset, CGPoint)
_Chain_set(UIScrollView, contentSize, setContentSize, CGSize)
_Chain_set(UIScrollView, bounces, setBounces, BOOL)
_Chain_set(UIScrollView, pagingEnabled, setPagingEnabled, BOOL)
_Chain_set(UIScrollView, scrollEnabled, setScrollEnabled, BOOL)
_Chain_set(UIScrollView, showsHorizontalScrollIndicator, setHorizontalScrollIndicator, BOOL)
_Chain_set(UIScrollView, showsVerticalScrollIndicator, setVerticalScrollIndicator, BOOL)

- (UIScrollView *(^)(CGFloat))setOffsetX {
    return ^(CGFloat x) {
        self.contentOffset = CGPointMake(x, self.contentOffset.y);
        return self;
    };
}

- (UIScrollView *(^)(CGFloat))setOffsetY {
    return ^(CGFloat y) {
        self.contentOffset = CGPointMake(self.contentOffset.x, y);
        return self;
    };
}

- (UIScrollView *(^)(CGFloat))setContentWidth {
    return ^(CGFloat width) {
        self.contentSize = CGSizeMake(width, self.contentSize.height);
        return self;
    };
}

- (UIScrollView *(^)(CGFloat))setContentHeight {
    return ^(CGFloat height) {
        self.contentSize = CGSizeMake(self.contentSize.width, height);
        return self;
    };
}

- (UIScrollView *(^)(CGFloat, CGFloat, CGFloat, CGFloat))setInset {
    return ^(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
        self.contentInset = UIEdgeInsetsMake(top, left, bottom, right);
        return self;
    };
}

@end

@implementation UITableView (JCChain)

+ (UITableView *(^)(UITableViewStyle))initWithStyle {
    return ^(UITableViewStyle style) { return [[UITableView alloc] initWithFrame:CGRectZero style:style];};
}
_Chain_set(UITableView, delegate, setDelegate, id<UITableViewDelegate>)
_Chain_set(UITableView, dataSource, setDataSource, id<UITableViewDataSource>)
_Chain_set(UITableView, rowHeight, setRowHeight, CGFloat)
_Chain_set(UITableView, backgroundColor, setBackgroundColor, UIColor *)
_Chain_set(UITableView, separatorStyle, setSeparatorStyle, UITableViewCellSeparatorStyle)
_Chain_set(UITableView, separatorColor, setSeparatorColor, UIColor *)
_Chain_set(UITableView, tableHeaderView, setTableHeaderView, UIView *)
_Chain_set(UITableView, tableFooterView, setTableFooterView, UIView *)
@end

@implementation UICollectionView (JCChain)

+ (UICollectionView *(^)(UICollectionViewLayout *))initWithLayout {
    return ^(UICollectionViewLayout *layout) { return [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout]; };
}
_Chain_set(UICollectionView, delegate, setDelegate, id<UICollectionViewDelegate>)
_Chain_set(UICollectionView, dataSource, setDataSource, id<UICollectionViewDataSource>)
_Chain_set(UICollectionView, backgroundColor, setBackgroundColor, UIColor *)
@end

@implementation CALayer (JCChain)
_Chain_set(CALayer, backgroundColor, setBackgroundColor, CGColorRef)
_Chain_set(CALayer, cornerRadius, setCornerRadius, CGFloat)
_Chain_set(CALayer, borderWidth, setBorderWidth, CGFloat)
_Chain_set(CALayer, borderColor, setBorderColor, CGColorRef)
@end
