//
//  UIBarItem+JCBarItem.m
//  JCCategoryKit
//
//  Created by molin.JC on 2017/6/28.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UIBarItem+JCBarItem.h"

@implementation UIBarItem (JCBarItem)

- (UIView *)barView {
    return [self valueForKey:@"_view"];
}

- (UIImageView *)imageView {
    for (UIView *subView in self.barView.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            return (UIImageView *)subView;
        }
    }
    return nil;
}

- (UILabel *)buttonLabel {
    for (UIView *subView in self.barView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
            return (UILabel *)subView;
        }
    }
    return nil;
}

@end
