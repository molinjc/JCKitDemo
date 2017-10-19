//
//  UINavigationItem+JCLoading.m
//
//  Created by molin.JC on 2016/12/22.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UINavigationItem+JCLoading.h"
#import <objc/runtime.h>

@implementation UINavigationItem (JCLoading)

- (void)startLoadingAnimating {
    [self stopLoadingAnimating];
    objc_setAssociatedObject(self, @selector(stopLoadingAnimating), self.titleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIActivityIndicatorView* loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.titleView = loader;
    [loader startAnimating];
}

- (void)stopLoadingAnimating {
    id componentToRestore = objc_getAssociatedObject(self, _cmd);
    self.titleView = componentToRestore;
    objc_setAssociatedObject(self, _cmd, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - set/get

- (void)setImage:(UIImage *)image {
    self.titleView = [[UIImageView alloc] initWithImage:image];
}

- (UIImage *)image {
    return ((UIImageView *)self.titleView).image;
}
@end
