//
//  NSParagraphStyle+JCText.h
//  JCKit
//
//  Created by molin.JC on 2017/5/26.
//  Copyright © 2017年 molin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSParagraphStyle (JCText)

+ (NSParagraphStyle *)styleWithCTStyle:(CTParagraphStyleRef)CTStyle;

- (CTParagraphStyleRef)CTStyle;

@end
