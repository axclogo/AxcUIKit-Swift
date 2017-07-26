//
//  AxcUI_Label.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_Label.h"

#import "UIView+AxcExtension.h"

@import CoreGraphics;


/*********************************************/
@implementation AxcUI_Label


- (void)drawRect:(CGRect)rect{
    if (self.axcUI_backGroundGradientColors.count) {
        [self backGroundRect:rect];
    }
    [super drawRect: rect];
}








- (void)setAxcUI_backGroundDrawDirectionStyle:(AxcBackGroundGradientStyle )axcUI_backGroundDrawDirectionStyle{
    if (_axcUI_backGroundDrawDirectionStyle != axcUI_backGroundDrawDirectionStyle) {
        _axcUI_backGroundDrawDirectionStyle = axcUI_backGroundDrawDirectionStyle;
        [self setNeedsDisplay]; // 动态重绘
    }
}

- (void)setAxcUI_backGroundGradientColors:(NSArray *)axcUI_backGroundGradientColors{
    if (_axcUI_backGroundGradientColors != axcUI_backGroundGradientColors) {
        _axcUI_backGroundGradientColors = axcUI_backGroundGradientColors;
        [self setNeedsDisplay];
    }
}

- (void)backGroundRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[self.axcUI_backGroundGradientColors count]];
    [self.axcUI_backGroundGradientColors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIColor class]]) {
            [colors addObject:(__bridge id)[obj CGColor]];
        } else if (CFGetTypeID((__bridge void *)obj) == CGColorGetTypeID()) {
            [colors addObject:obj];
        } else {
            @throw [NSException exceptionWithName:@"CRGradientLabelError"
                                           reason:@"对象数组gradientColors不是一个用户界面颜色或CGColorRef"
                                         userInfo:NULL];
        }
    }];
    CGContextSaveGState(context);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGGradientRef gradient = CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)colors, NULL);
    CGPoint startPoint;
    CGPoint endPoint;
    if (self.axcUI_backGroundDrawDirectionStyle == AxcBackGroundGradientStyleHorizontal) { // 水平梯度
        startPoint = CGPointMake(0, 0);
        endPoint = CGPointMake(rect.size.width, 0);
    }else{
        startPoint = CGPointMake(0, 0);
        endPoint = CGPointMake(0, rect.size.height );
    }
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation );
    
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
}










- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    UIEdgeInsets insets = self.axcUI_textEdgeInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}
- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.axcUI_textEdgeInsets)];
}
- (void)setAxcUI_textEdgeInsets:(UIEdgeInsets)axcUI_textEdgeInsets{
    _axcUI_textEdgeInsets = axcUI_textEdgeInsets;
    
    //    [self setNeedsLayout];  如果位置大小变换，则会调用此函数
    
    [self setNeedsDisplay];// 重新绘制
}











@end
