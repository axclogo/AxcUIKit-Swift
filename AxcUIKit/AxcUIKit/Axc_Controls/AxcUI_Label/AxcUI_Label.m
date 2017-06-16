//
//  AxcUI_Label.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_Label.h"

#import "UIView+AxcExtension.h"

/*********************************************/
@implementation AxcUI_Label
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
