//
//  UIView+JCSkin.h
//  JCKitDemo
//
//  Created by molin.JC on 2017/10/30.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCThemeManage.h"

@interface UINavigationBar (JCTheme)
@property (nonatomic, readwrite) UIColor *theme_tintColor;
@property (nonatomic, readwrite) UIColor *theme_barTintColor;
@end

//@interface UINavigationItem (JCTheme)
//@property (nonatomic, readwrite) UIColor *theme_textColor;
//@end

@interface UIView (JCTheme)
@property (nonatomic, readwrite) UIColor *theme_backgroundColor;
@end

@interface UILabel (JCTheme)
@property (nonatomic, readwrite) UIColor *theme_textColor;
@end

@interface UITextField (JCTheme)
@property (nonatomic, readwrite) UIColor *theme_textColor;
@end

@interface UITextView (JCTheme)
@property (nonatomic, readwrite) UIColor *theme_textColor;
@end
