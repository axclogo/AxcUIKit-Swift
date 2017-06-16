//
//  AxcBaseProgressView.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/5/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBaseProgressView.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation AxcBaseProgressView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = BaseProgressViewBackgroundColor;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setAxcUI_progress:(CGFloat)axcUI_progress
{
    _axcUI_progress = axcUI_progress;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (axcUI_progress >= 1.0) {
            if (self.axcUI_removeAnimation) {
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     self.alpha = 0;
                                     self.transform = CGAffineTransformMakeScale(2,2);
                                 }completion:^(BOOL finished) {
                                     [self removeFromSuperview];
                                 }];
            }else{
                [self removeFromSuperview];
            }
        } else {
            [self setNeedsDisplay];
        }
    });
}

- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes
{
    CGFloat xCenter = self.frame.size.width * 0.5;
    CGFloat yCenter = self.frame.size.height * 0.5;
    
    // 判断系统版本
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        CGSize strSize = [text sizeWithAttributes:attributes];
        CGFloat strX = xCenter - strSize.width * 0.5;
        CGFloat strY = yCenter - strSize.height * 0.5;
        [text drawAtPoint:CGPointMake(strX, strY) withAttributes:attributes];
    } else {
        CGSize strSize;
        NSAttributedString *attrStr = nil;
        if (attributes[NSFontAttributeName]) {
            strSize = [text sizeWithFont:attributes[NSFontAttributeName]];
            attrStr = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        } else {
            strSize = [text sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
            attrStr = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]}];
        }
        
        CGFloat strX = xCenter - strSize.width * 0.5;
        CGFloat strY = yCenter - strSize.height * 0.5;
        
        [attrStr drawAtPoint:CGPointMake(strX, strY)];
    }
    
    
    
}

// 清除指示器
- (void)dismiss{
    self.axcUI_progress = 1.0;
}

+ (id)progressView{
    return [[self alloc] init];
}

@end
#pragma clang diagnostic pop
