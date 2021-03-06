//
//  UIBezierPath+JCBezierPath.m
//
//  Created by molin.JC on 2017/4/15.
//  Copyright © 2017年 molin. All rights reserved.
//

#import "UIBezierPath+JCBezierPath.h"
#import <CoreText/CoreText.h>

@implementation UIBezierPath (JCBezierPath)

+ (UIBezierPath *)newPath {
    return [UIBezierPath bezierPath];
}

+ (UIBezierPath *(^)(CGRect))newPathRect {
    return ^(CGRect rect) {
        return [UIBezierPath bezierPathWithRect:rect];
    };
}

+ (UIBezierPath *(^)(CGRect))newPathOvalIn {
    return ^(CGRect rect) {
        return [UIBezierPath bezierPathWithOvalInRect:rect];
    };
}

+ (UIBezierPath *(^)(CGRect, CGFloat))newPathRounded {
    return ^(CGRect rect, CGFloat cornerRadius) {
        return [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    };
}

+ (UIBezierPath *(^)(CGRect, UIRectCorner, CGSize))newPathRoundingCorners {
    return ^(CGRect rect, UIRectCorner corners, CGSize cornerRadii) {
        return [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:cornerRadii];
    };
}

+ (UIBezierPath *(^)(CGPoint, CGFloat, CGFloat, CGFloat, BOOL))newPathArc {
    return ^(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle, BOOL clockwise) {
        return [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    };
}

+ (UIBezierPath *(^)(CGPathRef))newPathCGPath {
    return ^(CGPathRef CGPath) {
        return [UIBezierPath bezierPathWithCGPath:CGPath];
    };
}

- (UIBezierPath *(^)(CGFloat))pathLineWidth {
    return ^(CGFloat lineWidth) {
        self.lineWidth = lineWidth;
        return self;
    };
}

- (UIBezierPath *(^)(CGLineCap))pathLineCapStyle {
    return ^(CGLineCap lineCapStyle) {
        self.lineCapStyle = lineCapStyle;
        return self;
    };
}

- (UIBezierPath *(^)(CGLineJoin))pathLineJoinStyle {
    return ^(CGLineJoin lineJoinStyle) {
        self.lineJoinStyle = lineJoinStyle;
        return self;
    };
}

- (UIBezierPath *(^)(CGFloat))pathMiterLimit {
    return ^(CGFloat miterLimit) {
        self.miterLimit = miterLimit;
        return self;
    };
}

- (UIBezierPath *(^)(CGFloat))pathFlatness {
    return ^(CGFloat flatness) {
        self.flatness = flatness;
        return self;
    };
}

- (UIBezierPath *(^)(BOOL))pathUsesEvenOddFillRule {
    return ^(BOOL usesEvenOddFillRule) {
        self.usesEvenOddFillRule = usesEvenOddFillRule;
        return self;
    };
}

- (UIBezierPath *(^)(CGFloat *, NSInteger, CGFloat))setLineDash {
    return ^(CGFloat *pattern, NSInteger count,CGFloat phase) {
        [self setLineDash:pattern count:count phase:phase];
        return self;
    };
}

- (UIBezierPath *(^)(CGFloat *, NSInteger *, CGFloat *))getLineDash {
    return ^(CGFloat *pattern, NSInteger *count, CGFloat *phase) {
        [self getLineDash:pattern count:count phase:phase];
        return self;
    };
}

- (UIBezierPath *(^)(CGPoint))moveTo {
    return ^(CGPoint point) {
        [self moveToPoint:point];
        return self;
    };
}

- (UIBezierPath *(^)(CGPoint))addLineTo {
    return ^(CGPoint point) {
        [self addLineToPoint:point];
        return self;
    };
}

- (UIBezierPath *(^)(CGPoint, CGPoint))addQuadCurveTo {
    return ^(CGPoint endPoint, CGPoint controlPoint) {
        [self addQuadCurveToPoint:endPoint controlPoint:controlPoint];
        return self;
    };
}

- (UIBezierPath *(^)(CGPoint, CGPoint, CGPoint))addCurveTo {
    return ^(CGPoint endPoint, CGPoint controlPoint1, CGPoint controlPoint2) {
        [self addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
        return self;
    };
}

- (UIBezierPath *(^)(CGPoint, CGFloat, CGFloat, CGFloat, BOOL))addArcWith {
    return ^(CGPoint centerPoint, CGFloat radius,CGFloat startAngle, CGFloat endAngle, BOOL clockwise) {
        [self addArcWithCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
        return self;
    };
}

- (UIBezierPath *)pathClose {
    [self closePath];
    return self;
}

- (UIBezierPath *)pathRemoveAllPoints {
    [self removeAllPoints];
    return self;
}

- (UIBezierPath *(^)(UIBezierPath *))pathAppendPath {
    return ^(UIBezierPath *bezierPath) {
        [self appendPath:bezierPath];
        return self;
    };
}

- (UIBezierPath *)reverse {
    CGPoint reversePoint = [self bezierPathByReversingPath].currentPoint;
    self.moveTo(reversePoint);
    return self;
}

- (UIBezierPath *(^)(CGAffineTransform))applyTransform {
    return ^(CGAffineTransform transform) {
        [self applyTransform:transform];
        return self;
    };
}

- (UIBezierPath *)pathAddClip {
    [self addClip];
    return self;
}

- (UIBezierPath *(^)(UIColor *))strokePath {
    return ^(UIColor *color) {
        [color setStroke];
        [self stroke];
        return self;
    };
}

- (UIBezierPath *(^)(UIColor *))fillPath {
    return ^(UIColor *color) {
        [color setFill];
        [self fill];
        return self;
    };
}

- (UIBezierPath *(^)(CGBlendMode, CGFloat))strokeWith {
    return ^(CGBlendMode blendMode, CGFloat alpha) {
        [self strokeWithBlendMode:blendMode alpha:alpha];
        return self;
    };
}

- (UIBezierPath *(^)(CGBlendMode, CGFloat))fillWith {
    return ^(CGBlendMode blendMode, CGFloat alpha) {
        [self fillWithBlendMode:blendMode alpha:alpha];
        return self;
    };
}

+ (UIBezierPath *)bezierPathWithText:(NSString *)text attributes:(NSDictionary *)attrs {
    if (!attrs) return nil;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attrs];
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFTypeRef)attrString);
    if (!line) return nil;
    
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    for (CFIndex iRun = 0, iRunMax = CFArrayGetCount(runs); iRun < iRunMax; iRun++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runs, iRun);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex iGlyph = 0, iGlyphMax = CTRunGetGlyphCount(run); iGlyph < iGlyphMax; iGlyph++) {
            CFRange glyphRange = CFRangeMake(iGlyph, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, glyphRange, &glyph);
            CTRunGetPositions(run, glyphRange, &position);
            
            CGPathRef glyphPath = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            if (glyphPath) {
                CGAffineTransform transform = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(cgPath, &transform, glyphPath);
                CGPathRelease(glyphPath);
            }
        }
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:cgPath];
    CGRect boundingBox = CGPathGetPathBoundingBox(cgPath);
    CFRelease(cgPath);
    CFRelease(line);
    
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    
    return path;
}


@end
