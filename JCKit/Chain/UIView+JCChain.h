//
//  UIView+JCChain.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/12/1.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JCChain)
+ (instancetype)init;
@property (nonatomic, weak, readonly) UIView *(^setBackgroundColor)(UIColor *backgroundColor);
@end

@interface UILabel (JCChain)
@property (nonatomic, weak, readonly) UILabel *(^setBackgroundColor)(UIColor *backgroundColor);
@property (nonatomic, weak, readonly) UILabel *(^setText)(NSString *text);
@property (nonatomic, weak, readonly) UILabel *(^setFont)(UIFont *font);
@property (nonatomic, weak, readonly) UILabel *(^setTextColor)(UIColor *textColor);
@property (nonatomic, weak, readonly) UILabel *(^setTextAlignment)(NSTextAlignment textAlignment);
@property (nonatomic, weak, readonly) UILabel *(^setNumberOfLines)(NSInteger numberOfLines);
@property (nonatomic, weak, readonly) UILabel *(^setAttributedText)(NSAttributedString *attributedText);
@end

@interface UITextField (JCChain)
@property (nonatomic, weak, readonly) UITextField *(^setDelegate)(id<UITextFieldDelegate>);
@property (nonatomic, weak, readonly) UITextField *(^setBackgroundColor)(UIColor *backgroundColor);
@property (nonatomic, weak, readonly) UITextField *(^setText)(NSString *text);
@property (nonatomic, weak, readonly) UITextField *(^setFont)(UIFont *font);
@property (nonatomic, weak, readonly) UITextField *(^setTextColor)(UIColor *textColor);
@property (nonatomic, weak, readonly) UITextField *(^setTextAlignment)(NSTextAlignment textAlignment);
@property (nonatomic, weak, readonly) UITextField *(^setAttributedText)(NSAttributedString *attributedText);
@property (nonatomic, weak, readonly) UITextField *(^setPlaceholder)(NSString *placeholder);
@property (nonatomic, weak, readonly) UITextField *(^setAttributedPlaceholder)(NSAttributedString *attributedPlaceholder);
@property (nonatomic, weak, readonly) UITextField *(^setDefaultTextAttributes)(NSDictionary *defaultTextAttributes);
@property (nonatomic, weak, readonly) UITextField *(^setBorderStyle)(UITextBorderStyle borderStyle);
@property (nonatomic, weak, readonly) UITextField *(^setClearButtonMode)(UITextFieldViewMode clearButtonMode);
@property (nonatomic, weak, readonly) UITextField *(^setKeyboardType)(UIKeyboardType keyboardType);
@property (nonatomic, weak, readonly) UITextField *(^setReturnKeyType)(UIReturnKeyType returnKeyType);
@property (nonatomic, weak, readonly) UITextField *(^setKeyboardAppearance)(UIKeyboardAppearance keyboardAppearance);
@property (nonatomic, weak, readonly) UITextField *(^setInputView)(UIView *inputView);
@property (nonatomic, weak, readonly) UITextField *(^setInputAccessoryView)(UIView *inputAccessoryView);
@end

@interface UITextView (JCChain)
@property (nonatomic, weak, readonly) UITextView *(^setDelegate)(id<UITextViewDelegate>);
@property (nonatomic, weak, readonly) UITextView *(^setBackgroundColor)(UIColor *backgroundColor);
@property (nonatomic, weak, readonly) UITextView *(^setText)(NSString *text);
@property (nonatomic, weak, readonly) UITextView *(^setFont)(UIFont *font);
@property (nonatomic, weak, readonly) UITextView *(^setTextColor)(UIColor *textColor);
@property (nonatomic, weak, readonly) UITextView *(^setTextAlignment)(NSTextAlignment textAlignment);
@property (nonatomic, weak, readonly) UITextView *(^setAttributedText)(NSAttributedString *attributedText);
@property (nonatomic, weak, readonly) UITextView *(^setLinkTextAttributes)(NSDictionary *linkTextAttributes);
@property (nonatomic, weak, readonly) UITextView *(^setKeyboardType)(UIKeyboardType keyboardType);
@property (nonatomic, weak, readonly) UITextView *(^setReturnKeyType)(UIReturnKeyType returnKeyType);
@property (nonatomic, weak, readonly) UITextView *(^setKeyboardAppearance)(UIKeyboardAppearance keyboardAppearance);
@property (nonatomic, weak, readonly) UITextView *(^setInputView)(UIView *inputView);
@property (nonatomic, weak, readonly) UITextView *(^setInputAccessoryView)(UIView *inputAccessoryView);
@end

@interface UIControl (JCChain)
@property (nonatomic, weak, readonly) UIControl *(^setBackgroundColor)(UIColor *backgroundColor);
@property (nonatomic, weak, readonly) UIControl *(^addTarget)(id target, SEL action, UIControlEvents event);
@end

@interface UIButton (JCChain)
@property (class, nonatomic, readonly) UIButton *(^buttonType)(UIButtonType);
@property (nonatomic, weak, readonly) UIButton *(^setBackgroundColor)(UIColor *backgroundColor);
@property (nonatomic, weak, readonly) UIButton *(^addTarget)(id target, SEL action, UIControlEvents event);
/** 设置标题，状态默认UIControlStateNormal */
@property (nonatomic, weak, readonly) UIButton *(^setTitle)(NSString *);
/** 设置标题和状态 */
@property (nonatomic, weak, readonly) UIButton *(^setTitleOrState)(NSString *, UIControlState);
/** 设置标题颜色 */
@property (nonatomic, weak, readonly) UIButton *(^setTitleColor)(UIColor *);
/** 设置标题颜色和状态 */
@property (nonatomic, weak, readonly) UIButton *(^setTitleColorOrState)(UIColor *, UIControlState);
/** 设置字体大小 */
@property (nonatomic, weak, readonly) UIButton *(^setFont)(UIFont *);
/** 设置标题富文本的样式 */
@property (nonatomic, weak, readonly) UIButton *(^setAttributedTitle)(NSAttributedString *);
/** 设置标题富文本的样式和状态 */
@property (nonatomic, weak, readonly) UIButton *(^setAttributedTitleOrState)(NSAttributedString *, UIControlState);
/** 设置图片 */
@property (nonatomic, weak, readonly) UIButton *(^setImage)(UIImage *);
/** 设置图片和状态 */
@property (nonatomic, weak, readonly) UIButton *(^setImageOrState)(UIImage *, UIControlState);
/** 设置背景图片 */
@property (nonatomic, weak, readonly) UIButton *(^setBackgroundImage)(UIImage *);
/** 设置背景图片和状态 */
@property (nonatomic, weak, readonly) UIButton *(^setBackgroundImageOrState)(UIImage *, UIControlState);
@end

@interface UIImageView (JCChain)
@property (class, nonatomic, readonly) UIImageView *(^initWithImage)(UIImage *);
@property (nonatomic, weak, readonly) UIImageView *(^setBackgroundColor)(UIColor *backgroundColor);
@property (nonatomic, weak, readonly) UIImageView *(^setImage)(UIImage *);
@end

@interface UIScrollView (JCChain)
@property (nonatomic, weak, readonly) UIScrollView *(^setDelegate)(id<UIScrollViewDelegate>);
@property (nonatomic, weak, readonly) UIScrollView *(^setBackgroundColor)(UIColor *backgroundColor);
@property (nonatomic, weak, readonly) UIScrollView *(^setOffset)(CGPoint);
@property (nonatomic, weak, readonly) UIScrollView *(^setOffsetX)(CGFloat);
@property (nonatomic, weak, readonly) UIScrollView *(^setOffsetY)(CGFloat);
@property (nonatomic, weak, readonly) UIScrollView *(^setContentSize)(CGSize);
@property (nonatomic, weak, readonly) UIScrollView *(^setContentWidth)(CGFloat);
@property (nonatomic, weak, readonly) UIScrollView *(^setContentHeight)(CGFloat);
@property (nonatomic, weak, readonly) UIScrollView *(^setInset)(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right);
@property (nonatomic, weak, readonly) UIScrollView *(^setBounces)(BOOL);
@property (nonatomic, weak, readonly) UIScrollView *(^setPagingEnabled)(BOOL);
@property (nonatomic, weak, readonly) UIScrollView *(^setScrollEnabled)(BOOL);
@property (nonatomic, weak, readonly) UIScrollView *(^setHorizontalScrollIndicator)(BOOL);
@property (nonatomic, weak, readonly) UIScrollView *(^setVerticalScrollIndicator)(BOOL);
@end

@interface UITableView (JCChain)
@property (class, nonatomic, readonly) UITableView *(^initWithStyle)(UITableViewStyle);
@property (nonatomic, weak, readonly) UITableView *(^setDelegate)(id<UITableViewDelegate>);
@property (nonatomic, weak, readonly) UITableView *(^setDataSource)(id<UITableViewDataSource>);
@property (nonatomic, weak, readonly) UITableView *(^setRowHeight)(CGFloat);
@property (nonatomic, weak, readonly) UITableView *(^setBackgroundColor)(UIColor *backgroundColor);
@property (nonatomic, weak, readonly) UITableView *(^setSeparatorStyle)(UITableViewCellSeparatorStyle);
@property (nonatomic, weak, readonly) UITableView *(^setSeparatorColor)(UIColor *);
@property (nonatomic, weak, readonly) UITableView *(^setTableHeaderView)(UIView *);
@property (nonatomic, weak, readonly) UITableView *(^setTableFooterView)(UIView *);
@end

@interface UICollectionView (JCChain)
@property (class, nonatomic, readonly) UICollectionView *(^initWithLayout)(UICollectionViewLayout *);
@property (nonatomic, weak, readonly) UICollectionView *(^setDelegate)(id<UICollectionViewDelegate>);
@property (nonatomic, weak, readonly) UICollectionView *(^setDataSource)(id<UICollectionViewDataSource>);
@property (nonatomic, weak, readonly) UICollectionView *(^setBackgroundColor)(UIColor *backgroundColor);
@end

@interface CALayer (JCChain)
@property (nonatomic, weak, readonly) CALayer *(^setBackgroundColor)(CGColorRef);
@property (nonatomic, weak, readonly) CALayer *(^setCornerRadius)(CGFloat);
@property (nonatomic, weak, readonly) CALayer *(^setBorderWidth)(CGFloat);
@property (nonatomic, weak, readonly) CALayer *(^setBorderColor)(CGColorRef);
@end
