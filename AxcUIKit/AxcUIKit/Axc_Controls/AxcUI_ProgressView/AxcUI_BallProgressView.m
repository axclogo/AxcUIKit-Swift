//
//  AxcUI_BallProgressView.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/6/5.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_BallProgressView.h"

@implementation AxcUI_BallProgressView

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    [[UIColor whiteColor] set];
    
    CGFloat radius = MIN(rect.size.width * 0.5, rect.size.height * 0.5) - BaseProgressViewItemMargin;
    
    CGFloat w = radius * 2 + BaseProgressViewItemMargin;
    CGFloat h = w;
    CGFloat x = (rect.size.width - w) * 0.5;
    CGFloat y = (rect.size.height - h) * 0.5;
    CGContextAddEllipseInRect(ctx, CGRectMake(x, y, w, h));
    CGContextFillPath(ctx);
    
    [[UIColor grayColor] set];
    CGFloat startAngle = M_PI * 0.5 - self.axcUI_progress * M_PI;
    CGFloat endAngle = M_PI * 0.5 + self.axcUI_progress * M_PI;
    CGContextAddArc(ctx, xCenter, yCenter, radius, startAngle, endAngle, 0);
    CGContextFillPath(ctx);
    // 进度数字
    NSString *progressStr = [NSString stringWithFormat:@"%.0f%s", self.axcUI_progress * 100, "\%"];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:18 * BaseProgressViewFontScale];
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [self setCenterProgressText:progressStr withAttributes:attributes];
}

@end
