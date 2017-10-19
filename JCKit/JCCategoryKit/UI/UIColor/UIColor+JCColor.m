//
//  UIColor+JCColor.m
//  JCKit
//
//  Created by 林建川 on 16/9/28.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIColor+JCColor.h"

JCRGB const JCRGBZero = {0, 0, 0, 0};

#define MaxRGB 255.0f

@implementation UIColor (JCColor)

// 十六进制
+ (UIColor *)colorWithRGB16:(uint32_t)value {
    return [UIColor colorWithRGB16:value alphe:1.0];
}

+ (UIColor *)colorWithRGB16:(uint32_t)value alphe:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0
                           green:((float)((value & 0xFF00) >> 8))/255.0
                            blue:((float)(value & 0xFF))/255.0
                           alpha:alpha];
}

- (CGFloat)RGB_red {
    // YYKit的UIColor+YYAdd.m -red方法的做法
    CGFloat r = 0, g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
    
    /**************  Wonderful的UIColor+Separate -red方法的做法 *******************
    const CGFloat *r = CGColorGetComponents(self.CGColor);
    return r[0];
     ****************************************************************************/
}

- (CGFloat)RGB_green {
    // YYKit的UIColor+YYAdd.m -green方法的做法
    CGFloat g = 0, r,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
    
    /*************  Wonderful的UIColor+Separate -green方法的做法  *******************
    const CGFloat *g = CGColorGetComponents(self.CGColor);
    if (CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor)) == kCGColorSpaceModelMonochrome) {
        return g[0];
    }
    return g[1];
     ****************************************************************************/
}

- (CGFloat)RGB_blue {
    // YYKit的UIColor+YYAdd.m -blue方法的做法
    CGFloat b = 0, r,g,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
    
    /*************  Wonderful的UIColor+Separate -blue方法的做法 *******************
    const CGFloat *b = CGColorGetComponents(self.CGColor);
    if (CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor)) == kCGColorSpaceModelMonochrome) {
        return b[0];
    }
    return b[2];
    ****************************************************************************/
}

- (JCRGB)rgb {
    JCRGB result = JCRGBZero;
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
    if (colorSpaceModel != kCGColorSpaceModelRGB && colorSpaceModel != kCGColorSpaceModelMonochrome) {
        return result;
    }
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    if (colorSpaceModel == kCGColorSpaceModelMonochrome) {
        result.red = result.green = result.blue = components[0];
        result.alpha = components[1];
    } else {
        result.red = components[0];
        result.green = components[1];
        result.blue = components[2];
        result.alpha = components[3];
    }
    return result;
}

- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

- (NSString *)colorSpaceString {
    CGColorSpaceModel model =  CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
    switch (model) {
        case kCGColorSpaceModelUnknown:
            return @"kCGColorSpaceModelUnknown";
            
        case kCGColorSpaceModelMonochrome:
            return @"kCGColorSpaceModelMonochrome";
            
        case kCGColorSpaceModelRGB:
            return @"kCGColorSpaceModelRGB";
            
        case kCGColorSpaceModelCMYK:
            return @"kCGColorSpaceModelCMYK";
            
        case kCGColorSpaceModelLab:
            return @"kCGColorSpaceModelLab";
            
        case kCGColorSpaceModelDeviceN:
            return @"kCGColorSpaceModelDeviceN";
            
        case kCGColorSpaceModelIndexed:
            return @"kCGColorSpaceModelIndexed";
            
        case kCGColorSpaceModelPattern:
            return @"kCGColorSpaceModelPattern";
            
        default:
            return @"ColorSpaceInvalid";
    }
}

/** 整数的RGB值转换成颜色类 */
+ (UIColor *)colorWithIntRed:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red/MaxRGB green:green/MaxRGB blue:blue/MaxRGB alpha:alpha];
}

+ (UIColor *)colorWithRGB:(JCRGB)rgb {
    return [UIColor colorWithRed:rgb.red green:rgb.green blue:rgb.blue alpha:rgb.alpha];
}

+ (UIColor *)colorWithHSB:(JCHSB)hsb {
    return [UIColor colorWithHue:hsb.hue saturation:hsb.saturation brightness:hsb.brightness alpha:hsb.alpha];
}

/** 将颜色转换成16进制的字符串 */
- (NSString *)stringForRGB16 {
    int r = (int)(self.RGB_red * 255);
    int g = (int)(self.RGB_green * 255);
    int b = (int)(self.RGB_blue * 255);
    NSString *webColor = [NSString stringWithFormat:@"#%02X%02X%02X", r, g, b];
    return webColor;
}

/** 随机颜色，透明度默认1 */
+ (UIColor *)randomColor {
    return [self randomColorWithAlpha:1.0f];
}

/** 随机颜色 */
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha {
    NSInteger redValue = arc4random() % 255;
    NSInteger greenValue = arc4random() % 255;
    NSInteger blueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:redValue / 255.0f green:greenValue / 255.0f blue:blueValue / 255.0f alpha:alpha];
    return randColor;
}

/** 渐变颜色 */
+ (UIColor*)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(CGFloat)height {
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (__bridge CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

/** object可以是UIColor对象、颜色单词、16进制、RGB值，根据这些创建对此 */
+ (UIColor *)colorWithColorObject:(id)object {
    if ([object isKindOfClass:UIColor.class]) {
        return object;
    }
    
    if ([object isKindOfClass:NSString.class]) {
        CGFloat alpha = 1;
        NSArray *componnets = [object componentsSeparatedByString:@","];
        
        //whether the color object contains alpha
        if (componnets.count == 2 || componnets.count == 4) {
            NSRange range = [object rangeOfString:@"," options:NSBackwardsSearch];
            alpha = [[object substringFromIndex:range.location + range.length] floatValue];
            alpha = MIN(alpha, 1);
            object = [object substringToIndex:range.location];
        }
        
        //system color
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", object]);
        if ([UIColor respondsToSelector:sel]) {
            UIColor *color = [UIColor performSelector:sel withObject:nil];
            if (alpha != 1) color = [color colorWithAlphaComponent:alpha];
            return color;
        }
        
        
        int r = 0, g = 0, b = 0;
        BOOL isRGBColor = NO;
        
        //random
        if ([object isEqualToString:@"random"]) {
            r = arc4random_uniform(256);
            g = arc4random_uniform(256);
            b = arc4random_uniform(256);
            isRGBColor = YES;
            
        } else {
            BOOL isHex = NO;
            
            if ([object hasPrefix:@"#"]) {
                object = [object substringFromIndex:1];
                isHex = YES;
            }
            if ([object hasPrefix:@"0x"]) {
                object = [object substringFromIndex:2];
                isHex = YES;
            }
            
            if (isHex) {
                int result = sscanf([object UTF8String], "%2x%2x%2x", &r, &g, &b);     //#FFFFFF
                
                if (result != 3) {
                    result = sscanf([object UTF8String], "%1x%1x%1x", &r, &g, &b);     //#FFF
                    
                    //convert #FFF to #FFFFFF
                    if (result == 3) {
                        r *= 17; g *= 17; b *= 17;
                    }
                }
                isRGBColor = (result == 3);
                
            } else {
                int result = sscanf([object UTF8String], "%d,%d,%d", &r, &g, &b);       //rgb
                isRGBColor = (result == 3);
            }
        }
        
        if (isRGBColor) {
            return [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:alpha];
        }
    } else if ([object isKindOfClass:[UIImage class]]) {
        return [UIColor colorWithPatternImage:object];
    }
    return nil;
}

- (BOOL)isEqualToColor:(UIColor *)color {
    return CGColorEqualToColor(self.CGColor, color.CGColor);
}
@end

JCHSB JCRGB2HSB(JCRGB rgb) {
    double rd = (double) rgb.red;
    double gd = (double) rgb.green;
    double bd = (double) rgb.blue;
    double max = fmax(rd, fmax(gd, bd));
    double min = fmin(rd, fmin(gd, bd));
    double h = 0, s, b = max;
    
    double d = max - min;
    s = max == 0 ? 0 : d / max;
    
    if (max == min) {
        h = 0; // achromatic
    } else {
        if (max == rd) {
            h = (gd - bd) / d + (gd < bd ? 6 : 0);
        } else if (max == gd) {
            h = (bd - rd) / d + 2;
        } else if (max == bd) {
            h = (rd - gd) / d + 4;
        }
        h /= 6;
    }
    return (JCHSB){ .hue = h, .saturation = s, .brightness = b, .alpha = rgb.alpha };
}

JCRGB JCHSB2RGB(JCHSB hsb) {
    double r, g, b;
    
    int i = hsb.hue * 6;
    double f = hsb.hue * 6 - i;
    double p = hsb.brightness * (1 - hsb.saturation);
    double q = hsb.brightness * (1 - f * hsb.saturation);
    double t = hsb.brightness * (1 - (1 - f) * hsb.saturation);
    
    switch (i % 6){
        case 0: r = hsb.brightness, g = t, b = p; break;
        case 1: r = q, g = hsb.brightness, b = p; break;
        case 2: r = p, g = hsb.brightness, b = t; break;
        case 3: r = p, g = q, b = hsb.brightness; break;
        case 4: r = t, g = p, b = hsb.brightness; break;
        case 5: r = hsb.brightness, g = p, b = q; break;
        default: r = g = b = 0; break;
    }
    
    return (JCRGB){ .red = r, .green = g, .blue = b, .alpha = hsb.alpha };
}
