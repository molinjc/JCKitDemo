//
//  UIView+JCScale.m
//
//  Created by 林建川 on 16/8/14.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIScreen+JCScreen.h"
#import <objc/runtime.h>

@implementation UIScreen (JCScreen)

- (CGRect)currentBounds {
    return [self boundsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (CGRect)boundsForOrientation:(UIInterfaceOrientation)orientation {
    CGRect bounds = [self bounds];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        CGFloat buffer = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = buffer;
    }
    return bounds;
}

- (CGSize)size {
    return self.bounds.size;
}

@end
