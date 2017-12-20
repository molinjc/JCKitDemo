//
//  NSBundle+JCBundle.m
//
//  Created by molin.JC on 2016/12/8.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "NSBundle+JCBundle.h"

@implementation NSBundle (JCBundle)

- (NSString *)minimumOSVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MinimumOSVersion"];
}

- (NSString *)bundleName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

- (NSString *)displayName {
    return [self objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

- (NSString *)bundleShortVersionString {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)bundleIconFile {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIconFile"];
}

@end
