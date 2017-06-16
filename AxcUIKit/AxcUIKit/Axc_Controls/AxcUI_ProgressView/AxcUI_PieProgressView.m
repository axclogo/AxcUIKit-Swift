//
//  AxcUI_PieProgressView.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/6/5.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_PieProgressView.h"

@implementation AxcUI_PieProgressView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    
    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - BaseProgressViewItemMargin;
    
    // 背景圆
    [BaseColorMaker(240, 240, 240, 1) set];
    CGFloat w = radius * 2 + 4;
    CGFloat h = w;
    CGFloat x = (rect.size.width - w) * 0.5;
    CGFloat y = (rect.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextFillPath(ctx);
    
    // 进程圆
    [BaseColorMaker(150, 150, 150, 0.8) set];
    CGContextMoveToPoint(ctx, xCenter, yCenter);
    CGContextAddLineToPoint(ctx, xCenter, 0);
    CGFloat to = - M_PI * 0.5 + self.axcUI_progress * M_PI * 2 + 0.001; // 初始值
    CGContextAddArc(ctx, xCenter, yCenter, radius, - M_PI * 0.5, to, 1);
    CGContextClosePath(ctx);
    
    CGContextFillPath(ctx);
}

@end
