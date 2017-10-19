//
//  UIView+JCLayout.m
//
//  Created by molin.JC on 2017/5/10.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UIView+JCLayout.h"
#import <objc/runtime.h>
#if __has_include(<JCMacroKit/JCMacro.h>)
#import <JCMacroKit/JCMath.h>
#else
#import "JCMath.h"
#endif

@interface UIView ()
/** 存储约束 */
@property (nonatomic, strong) NSMutableDictionary *layoutConstraints;
/** 记录当前约束的key */
@property (nonatomic, copy) NSString * currentKey;
/** 记录当前多个约束的key */
@property (nonatomic, strong) NSArray * currentKeys;
@end

@implementation UIView (JCLayout)

#pragma mark - UITemplate

+ (void)viewLayoutWithUITemplateSize:(CGSize)size {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGFloat width = screenSize.width;
        if (screenSize.width > screenSize.height) {
            width = screenSize.height;
        }
        scale = width / size.width;
        objc_setAssociatedObject([UIScreen mainScreen], _cmd, @(scale), OBJC_ASSOCIATION_COPY_NONATOMIC);
    });
}

+ (CGFloat)viewLayoutScale {
    CGFloat scale = [objc_getAssociatedObject([UIScreen mainScreen], @selector(viewLayoutWithUITemplateSize:)) doubleValue];
    return (scale ? scale : 1);
}

- (UIView *(^)())layoutScale {
    return ^() {
        return [self _layoutScale];
    };
}

- (UIView *)_layoutScale {
    if (!self.currentKey) {
        NSParameterAssert(self.currentKey);
        return self;
    }
    
    if (self.currentKeys && self.currentKeys.count > 0) {
        for (NSString *key in self.currentKeys) {
            [self _updateConstantWithKey:key];
        }
        self.currentKeys = nil;
    }else {
        [self _updateConstantWithKey:self.currentKey];
    }
    return self;
}

#pragma mark - layout

- (UIView *)removeAllLayout {
    [self.layoutConstraints enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSLayoutConstraint *constraint, BOOL * _Nonnull stop) {
        if ([self.superview.constraints containsObject:constraint]) {
            [self.superview removeConstraint:constraint];
        }else if ([self.constraints containsObject:constraint]) {
            [self removeConstraint:constraint];
        }
    }];
    [self.layoutConstraints removeAllObjects];
    [self.superview layoutIfNeeded];
    return self;
}

- (UIView *)refreshLayout {
    NSParameterAssert(self.superview);
    [self.superview layoutSubviews];
    return self;
}

#pragma marlk - convenient

- (UIView *(^)(CGFloat, CGFloat, CGFloat, CGFloat))layoutInsets {
    return ^(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right) {
        self.currentKeys = @[NSStringFromSelector(@selector(layoutTop)),
                             NSStringFromSelector(@selector(layoutLeft)),
                             NSStringFromSelector(@selector(layoutBottom)),
                             NSStringFromSelector(@selector(layoutRight))];
        self.layoutTop(top).layoutLeft(left).layoutBottom(bottom).layoutRight(right);
        return self;
    };
}

- (UIView *(^)(CGSize))layoutSize {
    return ^(CGSize size) {
        self.currentKeys = @[NSStringFromSelector(@selector(layoutWidth)),
                             NSStringFromSelector(@selector(layoutHeight))];
        self.layoutWidth(size.width).layoutHeight(size.height);
        return self;
    };
}

- (UIView *(^)(CGPoint))layoutOrigin {
    return ^(CGPoint origin) {
        self.currentKeys = @[NSStringFromSelector(@selector(layoutLeft)),
                             NSStringFromSelector(@selector(layoutTop))];
        self.layoutLeft(origin.x).layoutTop(origin.y);
        return self;
    };
}

#pragma mark - private

/** 更新根据key获取到的约束的constant */
- (void)_updateConstantWithKey:(NSString *)key {
    NSLayoutConstraint *constraint = self.layoutConstraints[key];
    if (constraint) {
        constraint.constant = holdDecimal((constraint.constant * __scale), 3);
    }
}

#define _layoutReferenceSuperviewBlock(attr, minus)                                                    \
return ^(CGFloat layout) {                                                                             \
self.currentKey = NSStringFromSelector(_cmd);                                                          \
NSLayoutConstraint *constraint = self.layoutConstraints[self.currentKey];                              \
if (!constraint) {                                                                                     \
constraint = [self referenceSuperviewWithEqualAttribute:attr constant:(minus?-layout:layout)];         \
self.layoutConstraints[self.currentKey] = constraint;                                                  \
}else {                                                                                                \
constraint.constant = (minus?-layout:layout);                                                          \
}                                                                                                      \
return self;                                                                                           \
};

#define _layoutReferenceSelfBlock(attr, minus)                                                         \
return ^(CGFloat layout) {                                                                             \
self.currentKey = NSStringFromSelector(_cmd);                                                          \
NSLayoutConstraint *constraint = self.layoutConstraints[self.currentKey];                              \
if (!constraint) {                                                                                     \
constraint  = [self referenceSelfWithEqualAttribute:attr constant:(minus?-layout:layout)];             \
self.layoutConstraints[self.currentKey] = constraint;                                                  \
}else {                                                                                                \
constraint.constant = (minus?-layout:layout);                                                          \
}                                                                                                      \
return self;                                                                                           \
};

#define _layoutReferenceSuperviewMultiplierBlock(attr, sel, minus)                                     \
return ^(CGFloat m, CGFloat l) {                                                                       \
self.currentKey = NSStringFromSelector(sel);                                                           \
NSLayoutConstraint *constraint = self.layoutConstraints[self.currentKey];                              \
if (constraint) {                                                                                      \
[self.superview removeConstraint:constraint];                                                          \
}                                                                                                      \
constraint = [self referenceSuperviewWithEqualAttribute:attr multiplier:m constant:(minus?-l:l)];      \
self.layoutConstraints[self.currentKey] = constraint;                                                  \
return self;                                                                                           \
};


#define _layoutReferenceSameLayerViewBlock(attr)                                                       \
return ^(UIView *sameLayerView, CGFloat layout) {                                                      \
self.currentKey = NSStringFromSelector(_cmd);                                                          \
NSLayoutConstraint *constraint = self.layoutConstraints[self.currentKey];                              \
if (!constraint) {                                                                                     \
constraint = [self referenceSameLayerView:sameLayerView withEqualAttribute:attr constant:layout];      \
self.layoutConstraints[self.currentKey] = constraint;                                                  \
}else {                                                                                                \
constraint.constant = layout;                                                                          \
}                                                                                                      \
return self;                                                                                           \
};

#define _layoutReferenceSameLayerViewMultiplierBlock(attr, sel)                                        \
return ^(UIView *view, CGFloat m, CGFloat layout) {                                                    \
self.currentKey = NSStringFromSelector(sel);                                                           \
NSLayoutConstraint *constraint = self.layoutConstraints[self.currentKey];                              \
if (constraint) {                                                                                      \
[self.superview removeConstraint:constraint];                                                          \
}                                                                                                      \
constraint = [self referenceSameLayerView:view withEqualAttribute:attr multiplier:m constant:layout];  \
self.layoutConstraints[self.currentKey] = constraint;                                                  \
return self;                                                                                           \
};

#define _layoutReferenceSameLayerViewOpposingBlock(attr1, attr2, minus)                                \
return ^(UIView *view, CGFloat l) {                                                                    \
self.currentKey = NSStringFromSelector(_cmd);                                                          \
NSLayoutConstraint *constraint = self.layoutConstraints[self.currentKey];                              \
if (!constraint) {                                                                                     \
constraint = [self referenceSameLayerView:view withAttribute:attr1  equalAttribute:attr2 multiplier:1.0f constant:(minus?-l:l)];                                                                            \
self.layoutConstraints[self.currentKey] = constraint;                                                  \
}else {                                                                                                \
constraint.constant = (minus?-l:l);                                                                    \
}                                                                                                      \
return self;                                                                                           \
};

#define _layoutReferenceSameLayerViewMultiplierOpposingBlock(attr1, attr2, sel)                        \
return ^(UIView *view, CGFloat m, CGFloat l) {                                                         \
self.currentKey = NSStringFromSelector(sel);                                                           \
NSLayoutConstraint *constraint = self.layoutConstraints[self.currentKey];                              \
if (constraint) {                                                                                      \
[self.superview removeConstraint:constraint];                                                          \
}                                                                                                      \
constraint = [self referenceSameLayerView:view withAttribute:attr1 equalAttribute:attr2 multiplier:m constant:l];                                                                                       \
self.layoutConstraints[self.currentKey] = constraint;                                                  \
return self;                                                                                           \
};

#pragma mark - 参照父视图属性

/** left，相当于x，参照俯视图的NSLayoutAttributeLeft */
- (UIView *(^)(CGFloat layoutLeft))layoutLeft {
    _layoutReferenceSuperviewBlock(NSLayoutAttributeLeft, NO)
}

/** right，与俯视图右边的间距，参照俯视图的NSLayoutAttributeRight */
- (UIView *(^)(CGFloat layoutRight))layoutRight {
    _layoutReferenceSuperviewBlock(NSLayoutAttributeRight, YES)
}

/** top，相当于y，参照俯视图的NSLayoutAttributeTop */
- (UIView *(^)(CGFloat layoutTop))layoutTop {
    _layoutReferenceSuperviewBlock(NSLayoutAttributeTop, NO)
}

/** bottom，与俯视图底边的间距，参照俯视图的NSLayoutAttributeBottom */
- (UIView *(^)(CGFloat layoutBottom))layoutBottom {
    _layoutReferenceSuperviewBlock(NSLayoutAttributeBottom, YES)
}

/** Width， 无参照物，设置自身的宽，NSLayoutAttributeWidth */
- (UIView *(^)(CGFloat layoutWidth))layoutWidth {
    _layoutReferenceSelfBlock(NSLayoutAttributeWidth, NO)
}

/** height，无参照物，设置自身的高，NSLayoutAttributeHeight */
- (UIView *(^)(CGFloat layoutHeight))layoutHeight {
    _layoutReferenceSelfBlock(NSLayoutAttributeHeight, NO)
}

/** CenterX，参照父视图的CenterX设置自身的CenterX，NSLayoutAttributeCenterX */
- (UIView *(^)(CGFloat layoutCenterX))layoutCenterX {
    _layoutReferenceSuperviewBlock(NSLayoutAttributeCenterX, NO)
}

/** CenterY，参照父视图的CenterY设置自身的CenterY，NSLayoutAttributeCenterY */
- (UIView *(^)(CGFloat layoutCenterY))layoutCenterY {
    _layoutReferenceSuperviewBlock(NSLayoutAttributeCenterY, NO)
}

#pragma mark - 参照父视图的属性，是父视图属性的multiplier倍

/** left，相当于x，参照俯视图的NSLayoutAttributeLeft的multiplier倍 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutLeft))layoutMultiplierLeft {
    _layoutReferenceSuperviewMultiplierBlock(NSLayoutAttributeLeft, @selector(layoutLeft), NO);
}

/** right，与俯视图右边的间距，参照俯视图的NSLayoutAttributeRight的multiplier倍 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutRight))layoutMultiplierRight {
    _layoutReferenceSuperviewMultiplierBlock(NSLayoutAttributeRight, @selector(layoutRight), YES);
}

/** top，相当于y，参照俯视图的NSLayoutAttributeTop的multiplier倍 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutTop))layoutMultiplierTop {
    _layoutReferenceSuperviewMultiplierBlock(NSLayoutAttributeTop, @selector(layoutTop), NO);
}

/** bottom，与俯视图底边的间距，参照俯视图的NSLayoutAttributeBottom的multiplier倍 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutBottom))layoutMultiplierBottom {
    _layoutReferenceSuperviewMultiplierBlock(NSLayoutAttributeBottom, @selector(layoutBottom), YES);
}

/** Width， 参照物，设置自身的宽，NSLayoutAttributeWidth的multiplier倍 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutWidth))layoutMultiplierWidth {
    _layoutReferenceSuperviewMultiplierBlock(NSLayoutAttributeWidth, @selector(layoutWidth), NO);
}

/** height，参照物，设置自身的高，NSLayoutAttributeHeight的multiplier倍 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutHeight))layoutMultiplierHeight {
    _layoutReferenceSuperviewMultiplierBlock(NSLayoutAttributeHeight, @selector(layoutHeight), NO);
}

/** CenterX，参照父视图的CenterX设置自身的CenterX，NSLayoutAttributeCenterX的multiplier倍 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutCenterX))layoutMultiplierCenterX {
    _layoutReferenceSuperviewMultiplierBlock(NSLayoutAttributeCenterX, @selector(layoutCenterX), NO);
}

/** CenterY，参照父视图的CenterY设置自身的CenterY，NSLayoutAttributeCenterY的multiplier倍 */
- (UIView *(^)(CGFloat multiplier, CGFloat layoutCenterY))layoutMultiplierCenterY {
    _layoutReferenceSuperviewMultiplierBlock(NSLayoutAttributeCenterY, @selector(layoutCenterY), NO)
}

#pragma mark - 参照同层级视图相同属性

/** 参照同层级view的left */
- (UIView *(^)(UIView *sameLayerView, CGFloat left))layoutEqualLeft {
    _layoutReferenceSameLayerViewBlock(NSLayoutAttributeLeft)
}

/** 参照同层级view的right */
- (UIView *(^)(UIView *sameLayerView, CGFloat right))layoutEqualRight {
    _layoutReferenceSameLayerViewBlock(NSLayoutAttributeRight)
}

/** 参照同层级view的top */
- (UIView *(^)(UIView *sameLayerView, CGFloat top))layoutEqualTop {
    _layoutReferenceSameLayerViewBlock(NSLayoutAttributeTop)
}

/** 参照同层级view的bottom */
- (UIView *(^)(UIView *sameLayerView, CGFloat bottom))layoutEqualBottom {
    _layoutReferenceSameLayerViewBlock(NSLayoutAttributeBottom)
}

/** 参照同层级view的width */
- (UIView *(^)(UIView *sameLayerView, CGFloat width))layoutEqualWidth {
    _layoutReferenceSameLayerViewBlock(NSLayoutAttributeWidth)
}

/** 参照同层级view的height */
- (UIView *(^)(UIView *sameLayerView, CGFloat height))layoutEqualHeight {
    _layoutReferenceSameLayerViewBlock(NSLayoutAttributeHeight)
}

/** 参照同层级view的centerX */
- (UIView *(^)(UIView *sameLayerView, CGFloat centerX))layoutEqualCenterX {
    _layoutReferenceSameLayerViewBlock(NSLayoutAttributeCenterX)
}

/** 参照同层级view的centerY */
- (UIView *(^)(UIView *sameLayerView, CGFloat centerY))layoutEqualCenterY {
    _layoutReferenceSameLayerViewBlock(NSLayoutAttributeCenterY)
}

#pragma mark - 参照同层级视图相同属性，是同层级视图的multiplier倍

/** 参照同层级view的left */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat left))layoutEqualMultiplierLeft {
    _layoutReferenceSameLayerViewMultiplierBlock(NSLayoutAttributeLeft, @selector(layoutEqualLeft));
}

/** 参照同层级view的right */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat right))layoutEqualMultiplierRight {
    _layoutReferenceSameLayerViewMultiplierBlock(NSLayoutAttributeRight, @selector(layoutEqualRight));
}

/** 参照同层级view的top */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat top))layoutEqualMultiplierTop {
    _layoutReferenceSameLayerViewMultiplierBlock(NSLayoutAttributeTop, @selector(layoutEqualTop));
}

/** 参照同层级view的bottom */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat bottom))layoutEqualMultiplierBottom {
    _layoutReferenceSameLayerViewMultiplierBlock(NSLayoutAttributeBottom, @selector(layoutEqualBottom));
}

/** 参照同层级view的width */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat width))layoutEqualMultiplierWidth {
    _layoutReferenceSameLayerViewMultiplierBlock(NSLayoutAttributeWidth, @selector(layoutEqualWidth));
}

/** 参照同层级view的height */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat height))layoutEqualMultiplierHeight {
    _layoutReferenceSameLayerViewMultiplierBlock(NSLayoutAttributeHeight, @selector(layoutEqualHeight));
}

/** 参照同层级view的centerX */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat centerX))layoutEqualMultiplierCenterX {
    _layoutReferenceSameLayerViewMultiplierBlock(NSLayoutAttributeCenterX, @selector(layoutEqualCenterX));
}

/** 参照同层级view的centerY */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat centerY))layoutEqualMultiplierCenterY {
    _layoutReferenceSameLayerViewMultiplierBlock(NSLayoutAttributeCenterY, @selector(layoutEqualCenterY));
}

#pragma mark - 参照同层级视图相反属性

/** 参照同层级view的left，在同层级view的左边（left），也就是同层级view在self的右边（right） */
- (UIView *(^)(UIView *sameLayerView, CGFloat constant))layoutAtSameLayerLeft {
    _layoutReferenceSameLayerViewOpposingBlock(NSLayoutAttributeRight, NSLayoutAttributeLeft, YES);
}

/** 参照同层级view的right，在同层级view的右边（right），也就是同层级view在self的左边（left） */
- (UIView *(^)(UIView *sameLayerView, CGFloat constant))layoutAtSameLayerRight {
    _layoutReferenceSameLayerViewOpposingBlock(NSLayoutAttributeLeft, NSLayoutAttributeRight, NO);
}

/** 参照同层级view的top，在同层级view的顶边（top），也就是同层级view在self的底边（bottom） */
- (UIView *(^)(UIView *sameLayerView, CGFloat constant))layoutAtSameLayerTop {
    _layoutReferenceSameLayerViewOpposingBlock(NSLayoutAttributeBottom, NSLayoutAttributeTop, YES);
}

/** 参照同层级view的bottom，在同层级view的底边（bottom），也就是同层级view在self的顶边（top） */
- (UIView *(^)(UIView *sameLayerView, CGFloat constant))layoutAtSameLayerBottom {
    _layoutReferenceSameLayerViewOpposingBlock(NSLayoutAttributeTop, NSLayoutAttributeBottom, NO);
}

#pragma mark - 参照同层级视图相反属性，是同层级视图相反属性的multiplier倍

/** 参照同层级view的left，在同层级view的左边（left），也就是同层级view在self的右边（right）*/
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat constant))layoutAtSameLayerMultiplierLeft {
    _layoutReferenceSameLayerViewMultiplierOpposingBlock(NSLayoutAttributeRight, NSLayoutAttributeLeft, @selector(layoutAtSameLayerLeft));
}

/** 参照同层级view的right，在同层级view的右边（right），也就是同层级view在self的左边（left）*/
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat constant))layoutAtSameLayerMultiplierRight {
    _layoutReferenceSameLayerViewMultiplierOpposingBlock(NSLayoutAttributeLeft, NSLayoutAttributeRight, @selector(layoutAtSameLayerRight));
}

/** 参照同层级view的top，在同层级view的顶边（top），也就是同层级view在self的底边（bottom） */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat constant))layoutAtSameLayerMultiplierTop {
    _layoutReferenceSameLayerViewMultiplierOpposingBlock(NSLayoutAttributeBottom, NSLayoutAttributeTop, @selector(layoutAtSameLayerTop));
}


/** 参照同层级view的bottom，在同层级view的底边（bottom），也就是同层级view在self的顶边（top） */
- (UIView *(^)(UIView *sameLayerView, CGFloat multiplier, CGFloat constant))layoutAtSameLayerMultiplierBottom {
    _layoutReferenceSameLayerViewMultiplierOpposingBlock(NSLayoutAttributeTop, NSLayoutAttributeBottom, @selector(layoutAtSameLayerTop));
}

#pragma mark - reference sameLayerView

/** 参照物为同层级view, 参照相同属性, 以Equal关联, multiplier默认为1 */
- (NSLayoutConstraint *)referenceSameLayerView:(UIView *)view withEqualAttribute:(NSLayoutAttribute)attr constant:(CGFloat)c{
    return [self referenceSameLayerView:view withEqualAttribute:attr multiplier:1.0f constant:c];
}

/** 参照物为同层级view, 参照相同属性, 以Equal关联 */
- (NSLayoutConstraint *)referenceSameLayerView:(UIView *)view withEqualAttribute:(NSLayoutAttribute)attr multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    return [self referenceSameLayerView:view withAttribute:attr equalAttribute:attr multiplier:multiplier constant:c];
}

/** 参照物为同层级view, 以Equal关联 */
- (NSLayoutConstraint *)referenceSameLayerView:(UIView *)view withAttribute:(NSLayoutAttribute)attr1 equalAttribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    return [self referenceSameLayerView:view withAttribute:attr1 relatedBy:NSLayoutRelationEqual attribute:attr2 multiplier:multiplier constant:c];
}

/** 参照物为同层级view */
- (NSLayoutConstraint *)referenceSameLayerView:(UIView *)view withAttribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    return [self addToSuperviewConstraintWithAttribute:attr1 relatedBy:relation toItem:view attribute:attr2 multiplier:multiplier constant:c];
}

#pragma mark - reference superview

/** 参照物为父视图, 参照相同属性, 以Equal关联, multiplier默认为1 */
- (NSLayoutConstraint *)referenceSuperviewWithEqualAttribute:(NSLayoutAttribute)attr constant:(CGFloat)c {
    return [self referenceSuperviewWithEqualAttribute:attr multiplier:1.0f constant:c];
}

/** 参照物为父视图, 参照相同属性, 以Equal关联 */
- (NSLayoutConstraint *)referenceSuperviewWithEqualAttribute:(NSLayoutAttribute)attr multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    return [self referenceSuperviewWithAttribute:attr equalAttribute:attr multiplier:multiplier constant:c];
}

/** 参照物为父视图, 以Equal关联 */
- (NSLayoutConstraint *)referenceSuperviewWithAttribute:(NSLayoutAttribute)attr1 equalAttribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    return [self referenceSuperviewWithAttribute:attr1 relatedBy:NSLayoutRelationEqual attribute:attr2 multiplier:multiplier constant:c];
}

/** 参照物为父视图 */
- (NSLayoutConstraint *)referenceSuperviewWithAttribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    return [self addToSuperviewConstraintWithAttribute:attr1 relatedBy:relation toItem:self.superview attribute:attr2 multiplier:multiplier constant:c];
}

#pragma mark - reference superview

/** 参照物为自身, 参照相同属性, 以Equal关联, multiplier默认为1 */
- (NSLayoutConstraint *)referenceSelfWithEqualAttribute:(NSLayoutAttribute)attr constant:(CGFloat)c {
    return [self referenceSelfWithEqualAttribute:attr multiplier:1.0f constant:c];
}

/** 参照物为自身, 参照相同属性, 以Equal关联 */
- (NSLayoutConstraint *)referenceSelfWithEqualAttribute:(NSLayoutAttribute)attr multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    return [self referenceSelfWithAttribute:attr equalAttribute:attr multiplier:multiplier constant:c];
}

/** 参照物为自身, 以Equal关联 */
- (NSLayoutConstraint *)referenceSelfWithAttribute:(NSLayoutAttribute)attr1 equalAttribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    return [self addToSelfConstraintWithAttribute:attr1 relatedBy:NSLayoutRelationEqual attribute:attr2 multiplier:multiplier constant:c];
}

#pragma mark - base

/** 该约束被添加到父视图 */
- (NSLayoutConstraint *)addToSuperviewConstraintWithAttribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    return [self constraintWithAttribute:attr1 relatedBy:relation toItem:view2 attribute:attr2 multiplier:multiplier constant:c];
}

/** 该约束被添加到自身 */
- (NSLayoutConstraint *)addToSelfConstraintWithAttribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    return [self constraintWithAttribute:attr1 relatedBy:relation toItem:nil attribute:attr2 multiplier:multiplier constant:c];
}

/** 添加约束(最基础) */
- (NSLayoutConstraint *)constraintWithAttribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c {
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSLayoutConstraint *layoutConstraint = [NSLayoutConstraint constraintWithItem:self attribute:attr1 relatedBy:relation toItem:view2 attribute:attr2 multiplier:multiplier constant:c];
    
    if (view2) {
        if (self.superview) {
            [self.superview addConstraint:layoutConstraint];
        }else {
            NSParameterAssert(self);
        }
    }else {
        [self addConstraint:layoutConstraint];
    }
    return layoutConstraint;
}

#pragma mark - Set/Get

- (NSMutableDictionary *)layoutConstraints {
    NSMutableDictionary *_layoutConstraints = objc_getAssociatedObject(self, _cmd);
    if (!_layoutConstraints) {
        _layoutConstraints = [NSMutableDictionary new];
        self.layoutConstraints = _layoutConstraints;
    }
    return _layoutConstraints;
}

- (void)setLayoutConstraints:(NSMutableDictionary *)layoutConstraints {
    objc_setAssociatedObject(self, @selector(layoutConstraints), layoutConstraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)currentKey {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentKey:(NSString *)currentKey {
    objc_setAssociatedObject(self, @selector(currentKey), currentKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)scale {
    return [UIView viewLayoutScale];
}

- (NSArray *)currentKeys {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentKeys:(NSArray *)currentKeys {
    objc_setAssociatedObject(self, @selector(currentKeys), currentKeys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIView (JCRect)

// @dynamic告诉编译器,属性的setter与getter方法由用户自己实现，不自动生成
@dynamic x;
@dynamic y;
@dynamic width;
@dynamic height;
@dynamic origin;
@dynamic size;
@dynamic centerX;
@dynamic centerY;
@dynamic right;
@dynamic bottom;

#pragma mark - Setters

- (void)setLeftSpacing:(CGFloat)leftSpacing {
    self.x = leftSpacing;
}

- (void)setRightSpacing:(CGFloat)rightSpacing {
    UIView *superView = self.superview;
    self.width = superView.width - rightSpacing - self.x;
}

- (void)setTopSpacing:(CGFloat)topSpacing {
    self.y = topSpacing;
}

- (void)setBottomSpacing:(CGFloat)bottomSpacing {
    UIView *superView = self.superview;
    self.height = superView.height - bottomSpacing - self.y;
}

- (void)setX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setSize:(CGSize)size {
    self.width = size.width;
    self.height = size.height;
}

- (void)setOrigin:(CGPoint)origin {
    self.x = origin.x;
    self.y = origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

#pragma mark - Getters

- (CGFloat)leftSpacing {
    return self.x;
}

- (CGFloat)rightSpacing {
    UIView *superView = self.superview;
    return superView.width - self.width - self.x;
}

- (CGFloat)topSpacing {
    return self.y;
}

- (CGFloat)bottomSpacing {
    UIView *superView = self.superview;
    return superView.height - self.height - self.y;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGSize)size {
    return CGSizeMake(self.width, self.height);
}

- (CGPoint)origin {
    return CGPointMake(self.x, self.y);;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

@end
