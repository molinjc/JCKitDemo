//
//  UIImage+JCImage.m
//
//  Created by 林建川 on 16/9/29.
//  Copyright © 2016年 molin. All rights reserved.
//

#import "UIImage+JCImage.h"
#import "NSData+JCData.h"
#import <ImageIO/ImageIO.h>
#import <Accelerate/Accelerate.h>
#import <CoreText/CoreText.h>

@implementation UIImage (JCImage)

static NSArray * _scaleArray() {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
    });
    return scales;
}


+ (UIImage *)imageWithName:(NSString *)name {
    if (!name.length) {
        return nil;
    }
    // 按屏幕的比例查找对应的几x图
    NSString *res = name.stringByDeletingPathExtension;
    NSString *ext = name.pathExtension;
    NSString *path = nil;
    NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp"];
    
    NSArray *scales = _scaleArray();
    
    for (int i = 0; i < scales.count; i++) {
        res = [name stringByAppendingFormat:@"@%@x", scales[i]];
        
        for (NSString *e in exts) {
            path = [[NSBundle mainBundle] pathForResource:res ofType:e];
            if (path) { break; }
        }
        
        if (path) { break; }
    }
    
    if (path) {
        return [UIImage imageWithContentsOfFile:path];
    }
    
    // 还是没查找到，就直接用系统
    return [UIImage imageNamed:name];
}

+ (UIImage *)decodedImageWithImage:(UIImage *)image {
    if (image.images) { return image; }
    
    CGImageRef imageRef = image.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    
    // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.
    // https://developer.apple.com/library/mac/#qa/qa1037/_index.html
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        
        // Set noneSkipFirst.
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    // It calculates the bytes-per-row based on the bitsPerComponent and width arguments.
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    // If failed, return undecompressed image
    if (!context) return image;
    
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}

/** 原图 */
- (UIImage *)originalImage {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

#pragma mark - 颜色

- (UIImage *)tintedImageWithColor:(UIColor *)color {
    return [self tintedImageWithColor:color rect:CGRectMake(0, 0, self.size.width, self.size.height) alpha:1.0];
}

- (UIImage *)tintedImageWithColor:(UIColor *)color rect:(CGRect)rect {
    return [self tintedImageWithColor:color rect:rect alpha:1.0];
}

- (UIImage *)tintedImageWithColor:(UIColor *)color alpha:(CGFloat)alpha {
    return [self tintedImageWithColor:color rect:CGRectMake(0, 0, self.size.width, self.size.height) alpha:alpha];
}

/**
 图片着色
 @param color 颜色
 @param rect  范围
 @param alpha 颜色的透明度 0~1
 */
- (UIImage *)tintedImageWithColor:(UIColor *)color rect:(CGRect)rect alpha:(CGFloat)alpha {
    CGRect imageRect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawInRect:imageRect];
    CGContextSetFillColorWithColor(ctx, [color CGColor]);
    CGContextSetAlpha(ctx, alpha);
    CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
    CGContextFillRect(ctx, rect);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *darkImage = [UIImage imageWithCGImage:imageRef
                                             scale:self.scale
                                       orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    return darkImage;
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor {
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor {
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

/** 生成一张纯色的图片 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(100, 100)];
}

/** 灰度图片 */
- (UIImage*)grayImage {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,self.size.width,self.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGContextRelease(context);
    CGImageRelease(contextRef);
    return grayImage;
}

/** 取图片某点像素的颜色 */
- (UIColor *)colorAtPixel:(CGPoint)point {
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    if (!CGRectContainsPoint(CGRectMake(0, 0, width, height), point)) {
        return nil;
    }
    
    CGFloat pointX = trunc(point.x);  // 取整，
    CGFloat pointY = trunc(point.y);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY- height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), self.CGImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/** 设置图片透明度 */
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageLinearGradientWithColors:(NSArray <UIColor *> *)colors directionType:(JCGradientDirection)directionType {
    return [self imageLinearGradientWithColors:colors directionType:directionType size:CGSizeMake(100, 100)];
}

+ (UIImage *)imageLinearGradientWithColors:(NSArray <UIColor *> *)colors directionType:(JCGradientDirection)directionType size:(CGSize)size {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    NSMutableArray *values = [NSMutableArray new];
    
    for (UIColor *color in colors) {
        [values addObject:(__bridge id)color.CGColor];
    }
    
    gradientLayer.colors = values;
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
    switch (directionType) {
        case JCLinearGradientDirectionLevel: {
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 0);
        }
            break;
        case JCLinearGradientDirectionVertical: {
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(0, 1);
        }
            break;
        case JCLinearGradientDirectionUpwardDiagonalLine: {
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 1);
        }
            break;
        case JCLinearGradientDirectionDownDiagonalLine: {
            gradientLayer.startPoint = CGPointMake(0, 1);
            gradientLayer.endPoint = CGPointMake(1, 0);
        }
            break;
    }
    
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, NO, 0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return gradientImage;
}

#pragma mark - Image Size

/** 等比例缩放图片 */
- (UIImage *)toScale:(CGFloat)scale {
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
    [self drawInRect:CGRectMake(0.0, 0.0, self.size.width * scale, self.size.height * scale)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage ;
}

/** 调整图片大小 */
- (UIImage *)resize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    
    //从当前context中创建一个改变大小后的图片
    UIImage *resizeImage =UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return resizeImage ;
}

/** 设置图片圆角 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius {
    CGRect rect = (CGRect){0.f,0.f,self.size};
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    return image;
}

/** 所占的内存大小 */
- (NSUInteger)memorySize {
    return CGImageGetHeight(self.CGImage) * CGImageGetBytesPerRow(self.CGImage);
}

/** 从中心向外拉伸 */
- (UIImage *)centerOutwardStretching {
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
}

#pragma mark - 截图

/** 将View转换成图片(截图) */
+ (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width, view.frame.size.height), NO, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 截取image里的rect区域内的图片 */
- (UIImage *)subimageInRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

#pragma mark - 方向

/** 根据图片名设置图片方向 */
+ (UIImage *)imageNamed:(NSString *)name orientation:(UIImageOrientation)orientation {
    UIImage *image = [UIImage imageNamed:name];
    return [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:orientation];
}

+ (UIImage *)imageNamed:(NSString *)name scale:(CGFloat)scale orientation:(UIImageOrientation)orientation {
    UIImage *image = [UIImage imageNamed:name];
    return [UIImage imageWithCGImage:image.CGImage scale:scale orientation:orientation];
}

/** 根据图片路径设置图片方向 */
+ (UIImage *)imageWithContentsOfFile:(NSString *)path orientation:(UIImageOrientation)orientation {
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:orientation];
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path scale:(CGFloat)scale orientation:(UIImageOrientation)orientation {
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return [UIImage imageWithCGImage:image.CGImage scale:scale orientation:orientation];
}

- (UIImage *)orientation:(UIImageOrientation)orientation {
    return [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:orientation];
}

- (UIImage *)orientationUp {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

/** 水平翻转 */
- (UIImage *)flipHorizontal {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, rect);
    CGContextRotateCTM(ctx, M_PI);
    CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height);
    CGContextDrawImage(ctx, rect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 垂直翻转 */
- (UIImage *)flipVertical {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, rect);
    CGContextDrawImage(ctx, rect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}

/** 将图片旋转弧度radians */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians {
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, radians);
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/** 将图片旋转角度degrees */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees {
    return [self imageRotatedByRadians:_JCDegreesToRadians(degrees)];
}

/** 由角度转换弧度 */
CGFloat _JCDegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;}

#pragma mark - 绘制

- (UIImage *)imageWithText:(NSString *)text fontSize:(CGFloat)fontSize {
    return [self imageWithText:text textColor:[UIColor whiteColor] fontSize:fontSize];
}

- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize {
    // 文字居中显示在画布上
    NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;   // 文字居中
    return [self imageWithText:text textColor:textColor fontSize:fontSize paragraphStyle:paragraphStyle];
}

/**
 图片上绘制文字
 @param text      所要绘制的文字
 @param textColor 文字的颜色
 @param fontSize  文字的大小，这里没有 * __scale，所以要文字适配，可能要在传入参数之前就要做适配了。
 @param paragraphStyle 文字的样式
 @return 返回新的图片
 */
- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize paragraphStyle:(NSParagraphStyle *)paragraphStyle {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return [self imageWithText:text textColor:textColor font:font paragraphStyle:paragraphStyle];
}

- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;   // 文字居中
    return [self imageWithText:text textColor:textColor font:font paragraphStyle:paragraphStyle];
}

- (UIImage *)imageWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font paragraphStyle:(NSParagraphStyle *)paragraphStyle {
    CGSize size = CGSizeMake(self.size.width, self.size.height);  // 画布大小
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);        // 创建一个基于位图的上下文
    [self drawAtPoint:CGPointMake(0.0, 0.0)];
    
    
    CGSize textSize = [text boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    CGRect rect = CGRectMake((size.width - textSize.width) / 2,
                             (size.height - textSize.height) / 2,
                             textSize.width,
                             textSize.height);
    // 绘制文字
    [text drawInRect:rect withAttributes:@{NSFontAttributeName:font,
                                           NSForegroundColorAttributeName:textColor,
                                           NSParagraphStyleAttributeName:paragraphStyle}];
    
    // 返回绘制的新图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSData *)compressedToSize:(NSInteger)size {
    NSInteger imagePixel = CGImageGetWidth(self.CGImage) * CGImageGetHeight(self.CGImage); // 图片像素
    NSInteger imageSize = imagePixel * CGImageGetBitsPerPixel(self.CGImage) / (8 * 1024);   // 图片大小
    if (imageSize > size) {
        float compressedParam = size / imageSize;
        return UIImageJPEGRepresentation(self, compressedParam);
    }
    return UIImagePNGRepresentation(self);
}

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile {
    return [UIImagePNGRepresentation(self) writeToFile:path atomically:useAuxiliaryFile];
}

@end

#pragma mark - GIF

@implementation UIImage (JCGIF)

/** 加载未知的Data(不知道是不是Gif)生成图片 */
+ (UIImage *)imageWithUnknownData:(NSData *)data {
    NSString *imageContentType = data.imageDataContentType;
    if ([imageContentType isEqualToString:@"image/gif"]) {
        return [UIImage animatedGIFWithData:data];
    }else {
        return [UIImage imageWithData:data];
    }
}

/** 根据Gif图片名生成UImage对象 */
+ (UIImage *)animatedGIFNamed:(NSString *)name {
    NSString *ext = name.pathExtension;
    if (!ext.length) {
        ext = @"gif";
    }else {
        ext = nil;
    }
    NSString *gifName = name;
    if ([UIScreen mainScreen].scale > 1.0f) {
        gifName = [name stringByAppendingString:@"@3x"];
    } else {
        gifName = [name stringByAppendingString:@"@2x"];
    }
    NSString *retinaPath = [[NSBundle mainBundle] pathForResource:gifName ofType:ext];
    if (!retinaPath) {
        retinaPath = [[NSBundle mainBundle] pathForResource:name ofType:ext];
    }
    NSData *data = [NSData dataWithContentsOfFile:retinaPath];
    if (data) {
        return [UIImage animatedGIFWithData:data];
    }
    return [UIImage imageNamed:name];
}

/** 根据Gif图片的data数据生成UIImage对象 */
+ (UIImage *)animatedGIFWithData:(NSData *)data {
    if (!data) { return nil; }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }else {
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0.0f;
        for (size_t i=0; i<count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self frameDurationAtIndex:i source:source];
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        if (!duration) {
            duration = (1.0 / 10.0) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
}

+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp != nil) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp != nil) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}

@end

@implementation UIImage (JCQRCode)

/**
 生成二维码图片
 @param string 信息
 @param size 大小
 */
+ (UIImage *)QRCodeImageWithString:(NSString *)string size:(CGFloat)size {
    NSData *stringData = [[string description] dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *QRFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [QRFilter setValue:stringData forKey:@"inputMessage"];
    [QRFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CGRect extent = CGRectIntegral(QRFilter.outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CGColorSpaceRelease(cs);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:QRFilter.outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *reusult = [UIImage imageWithCGImage:scaledImage];
    CGContextRelease(bitmapRef);
    CGImageRelease(scaledImage);
    CGImageRelease(bitmapImage);
    return reusult;
}

+ (UIImage *)QRCodeImageWithString:(NSString *)string size:(CGFloat)size image:(UIImage *)image {
    UIImage *QRCodeImage = [self QRCodeImageWithString:string size:size];
    if (!image) { return QRCodeImage; }
    CGRect rect = CGRectMake((QRCodeImage.size.width - image.size.width) * 0.5, (QRCodeImage.size.height - image.size.height) * 0.5, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(QRCodeImage.size);
    [QRCodeImage drawInRect:CGRectMake(0, 0, QRCodeImage.size.width, QRCodeImage.size.height)];
    [image drawInRect:rect];
    UIImage *resulImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resulImage;
}

/** 二维码图片内容信息 */
- (NSString *)QRCodeImageContext {
    CIContext *content = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:content options:nil];
    CIImage *cimage = [CIImage imageWithCGImage:self.CGImage];
    NSArray *features = [detector featuresInImage:cimage];
    CIQRCodeFeature *f = [features firstObject];
    return f.messageString;
}

@end

#ifndef JC_SWAP // swap two value
#define JC_SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)
#endif

@implementation UIImage (JCBlur)

/** 灰度模糊 */
- (UIImage *)imageByGrayscale {
    return [self imageByBlurRadius:0 tintColor:nil tintMode:0 saturation:0 maskImage:nil];
}

/** 柔软模糊 */
- (UIImage *)imageByBlurSoft {
    return [self imageByBlurRadius:60 tintColor:[UIColor colorWithWhite:0.84 alpha:0.36] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

/** 光线模糊 */
- (UIImage *)imageByBlurLight {
    return [self imageByBlurRadius:60 tintColor:[UIColor colorWithWhite:1.0 alpha:0.3] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

/** 额外光线模糊 */
- (UIImage *)imageByBlurExtraLight {
    return [self imageByBlurRadius:40 tintColor:[UIColor colorWithWhite:0.97 alpha:0.82] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

/** 黑暗模糊 */
- (UIImage *)imageByBlurDark {
    return [self imageByBlurRadius:40 tintColor:[UIColor colorWithWhite:0.11 alpha:0.73] tintMode:kCGBlendModeNormal saturation:1.8 maskImage:nil];
}

/** 设置图片模糊的颜色 */
- (UIImage *)imageByBlurWithTint:(UIColor *)tintColor {
    const CGFloat EffectColorAlpha = 0.6;
    UIColor *effectColor = tintColor;
    size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
    if (componentCount == 2) {
        CGFloat b;
        if ([tintColor getWhite:&b alpha:NULL]) {
            effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
        }
    } else {
        CGFloat r, g, b;
        if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
            effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
        }
    }
    return [self imageByBlurRadius:20 tintColor:effectColor tintMode:kCGBlendModeNormal saturation:-1.0 maskImage:nil];
}

/** 设置图片模糊 */
- (UIImage *)imageByBlurRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor tintMode:(CGBlendMode)tintBlendMode saturation:(CGFloat)saturation maskImage:(UIImage *)maskImage {
    if (self.size.width < 1 || self.size.height < 1) {
        return nil;
    }
    
    if (!self.CGImage) {
        return nil;
    }
    
    if (maskImage && !maskImage.CGImage) {
        return nil;
    }
    
    BOOL hasNewFunc = (long)vImageBuffer_InitWithCGImage != 0 && (long)vImageCreateCGImageFromBuffer != 0;
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturation = fabs(saturation - 1.0) > __FLT_EPSILON__;
    
    CGSize size = self.size;
    CGRect rect = (CGRect){CGPointZero, size};
    CGFloat scale = self.scale;
    CGImageRef imageRef = self.CGImage;
    BOOL opaque = NO;
    
    if (!hasBlur && !hasSaturation) {
        return [self _mergeImageRef:imageRef tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
    }
    
    vImage_Buffer effect = { 0 }, scratch = { 0 };
    vImage_Buffer *input = NULL, *output = NULL;
    
    vImage_CGImageFormat format = {
        .bitsPerComponent = 8,
        .bitsPerPixel = 32,
        .colorSpace = NULL,
        .bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little, //requests a BGRA buffer.
        .version = 0,
        .decode = NULL,
        .renderingIntent = kCGRenderingIntentDefault
    };
    
    if (hasNewFunc) {
        vImage_Error err;
        err = vImageBuffer_InitWithCGImage(&effect, &format, NULL, imageRef, kvImagePrintDiagnosticsToConsole);
        if (err != kvImageNoError) {
            return nil;
        }
        
        err = vImageBuffer_Init(&scratch, effect.height, effect.width, format.bitsPerPixel, kvImageNoFlags);
        if (err != kvImageNoError) {
            return nil;
        }
    }else {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
        CGContextRef effectCtx = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectCtx, 1.0, -1.0);
        CGContextTranslateCTM(effectCtx, 0, -size.height);
        CGContextDrawImage(effectCtx, rect, imageRef);
        effect.data     = CGBitmapContextGetData(effectCtx);
        effect.width    = CGBitmapContextGetWidth(effectCtx);
        effect.height   = CGBitmapContextGetHeight(effectCtx);
        effect.rowBytes = CGBitmapContextGetBytesPerRow(effectCtx);
        
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
        CGContextRef scratchCtx = UIGraphicsGetCurrentContext();
        scratch.data     = CGBitmapContextGetData(scratchCtx);
        scratch.width    = CGBitmapContextGetWidth(scratchCtx);
        scratch.height   = CGBitmapContextGetHeight(scratchCtx);
        scratch.rowBytes = CGBitmapContextGetBytesPerRow(scratchCtx);
    }
    
    input = &effect;
    output = &scratch;
    
    if (hasBlur) {
        CGFloat inputRadius = blurRadius * scale;
        if (inputRadius - 2.0 < __FLT_EPSILON__) inputRadius = 2.0;
        uint32_t radius = floor((inputRadius * 3.0 * sqrt(2 * M_PI) / 4 + 0.5) / 2);
        radius |= 1; // force radius to be odd so that the three box-blur methodology works.
        int iterations;
        if (blurRadius * scale < 0.5) iterations = 1;
        else if (blurRadius * scale < 1.5) iterations = 2;
        else iterations = 3;
        NSInteger tempSize = vImageBoxConvolve_ARGB8888(input, output, NULL, 0, 0, radius, radius, NULL, kvImageGetTempBufferSize | kvImageEdgeExtend);
        void *temp = malloc(tempSize);
        for (int i = 0; i < iterations; i++) {
            vImageBoxConvolve_ARGB8888(input, output, temp, 0, 0, radius, radius, NULL, kvImageEdgeExtend);
            JC_SWAP(input, output);
        }
        free(temp);
    }
    
    if (hasSaturation) {
        // These values appear in the W3C Filter Effects spec:
        // https://dvcs.w3.org/hg/FXTF/raw-file/default/filters/Publish.html#grayscaleEquivalent
        CGFloat s = saturation;
        CGFloat matrixFloat[] = {
            0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
            0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
            0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
            0,                    0,                    0,                    1,
        };
        const int32_t divisor = 256;
        NSUInteger matrixSize = sizeof(matrixFloat) / sizeof(matrixFloat[0]);
        int16_t matrix[matrixSize];
        for (NSUInteger i = 0; i < matrixSize; ++i) {
            matrix[i] = (int16_t)roundf(matrixFloat[i] * divisor);
        }
        vImageMatrixMultiply_ARGB8888(input, output, matrix, divisor, NULL, NULL, kvImageNoFlags);
        JC_SWAP(input, output);
    }
    
    UIImage *outputImage = nil;
    if (hasNewFunc) {
        CGImageRef effectCGImage = NULL;
        effectCGImage = vImageCreateCGImageFromBuffer(input, &format, &_cleanupBuffer, NULL, kvImageNoAllocate, NULL);
        if (effectCGImage == NULL) {
            effectCGImage = vImageCreateCGImageFromBuffer(input, &format, NULL, NULL, kvImageNoFlags, NULL);
            free(input->data);
        }
        free(output->data);
        outputImage = [self _mergeImageRef:effectCGImage tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
        CGImageRelease(effectCGImage);
    } else {
        CGImageRef effectCGImage;
        UIImage *effectImage;
        if (input != &effect) effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (input == &effect) effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        effectCGImage = effectImage.CGImage;
        outputImage = [self _mergeImageRef:effectCGImage tintColor:tintColor tintBlendMode:tintBlendMode maskImage:maskImage opaque:opaque];
    }
    return outputImage;
}

static void _cleanupBuffer(void *userData, void *buf_data) {
    free(buf_data);
}

- (UIImage *)_mergeImageRef:(CGImageRef)effectCGImage tintColor:(UIColor *)tintColor tintBlendMode:(CGBlendMode)tintBlendMode maskImage:(UIImage *)maskImage opaque:(BOOL)opaque {
    BOOL hasTint = tintColor != nil && CGColorGetAlpha(tintColor.CGColor) > __FLT_EPSILON__;
    BOOL hasMask = maskImage != nil;
    CGSize size = self.size;
    CGRect rect = { CGPointZero, size };
    CGFloat scale = self.scale;
    
    if (!hasTint && !hasMask) {
        return [UIImage imageWithCGImage:effectCGImage];
    }
    
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -size.height);
    if (hasMask) {
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextSaveGState(context);
        CGContextClipToMask(context, rect, maskImage.CGImage);
    }
    CGContextDrawImage(context, rect, effectCGImage);
    if (hasTint) {
        CGContextSaveGState(context);
        CGContextSetBlendMode(context, tintBlendMode);
        CGContextSetFillColorWithColor(context, tintColor.CGColor);
        CGContextFillRect(context, rect);
        CGContextRestoreGState(context);
    }
    if (hasMask) {
        CGContextRestoreGState(context);
    }
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

@end
