//
//  JCKeyboardManager.h
//  JCKeyboardTest
//
//  Created by 林建川 on 16/10/11.
//  Copyright © 2016年 molin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCKeyboardManager : NSObject

+ (instancetype)shareManager;
/** 是否要键盘弹出时调整视图, 默认NO(不调整) */
@property (nonatomic, assign) BOOL enable;
/** 是否附加Toolbar, 默认NO(不附加) */
@property (nonatomic, assign) BOOL accompanyToolbar;
/** 统一的键盘工具条 */
@property (nonatomic, readwrite) UIToolbar *toolbar;
@end
