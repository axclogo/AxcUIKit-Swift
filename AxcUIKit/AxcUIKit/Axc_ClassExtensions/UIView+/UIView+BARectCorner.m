//
//  UIView+BARectCorner.m
//  BAButton
//
//  Created by boai on 2017/5/19.
//  Copyright © 2017年 boai. All rights reserved.
//
#define AxcContentLayout_Objc_setObj(key, value) objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
#define AxcContentLayout_Objc_getObj objc_getAssociatedObject(self, _cmd)

#import "UIView+BARectCorner.h"
#import <objc/runtime.h>

@implementation UIView (BARectCorner)

- (void)AxcUI_view_setAxcViewRectCornerStyle:(AxcViewRectCornerStyle)type viewCornerRadius:(CGFloat)viewCornerRadius
{
    self.viewCornerRadius = viewCornerRadius;
    self.viewRectCornerType = type;
}

#pragma mark - view 的 角半径，默认 CGSizeMake(0, 0)
- (void)setupButtonCornerType
{
    UIRectCorner corners;
    CGSize cornerRadii;
    
    cornerRadii = CGSizeMake(self.viewCornerRadius, self.viewCornerRadius);
    if (self.viewCornerRadius == 0)
    {
        cornerRadii = CGSizeMake(0, 0);
    }
    
    switch (self.viewRectCornerType)
    {
        case AxcViewRectCornerStyleBottomLeft:
        {
            corners = UIRectCornerBottomLeft;
        }
            break;
        case AxcViewRectCornerStyleBottomRight:
        {
            corners = UIRectCornerBottomRight;
        }
            break;
        case AxcViewRectCornerStyleTopLeft:
        {
            corners = UIRectCornerTopLeft;
        }
            break;
        case AxcViewRectCornerStyleTopRight:
        {
            corners = UIRectCornerTopRight;
        }
            break;
        case AxcViewRectCornerStyleBottomLeftAndBottomRight:
        {
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }
            break;
        case AxcViewRectCornerStyleTopLeftAndTopRight:
        {
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
        }
            break;
        case AxcViewRectCornerStyleBottomLeftAndTopLeft:
        {
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
        }
            break;
        case AxcViewRectCornerStyleBottomRightAndTopRight:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
        }
            break;
        case AxcViewRectCornerStyleBottomRightAndTopRightAndTopLeft:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
        }
            break;
        case AxcViewRectCornerStyleBottomRightAndTopRightAndBottomLeft:
        {
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
        }
            break;
        case AxcViewRectCornerStyleAllCorners:
        {
            corners = UIRectCornerAllCorners;
        }
            break;
            
        default:
            break;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}

#pragma mark - setter / getter

- (void)setViewRectCornerType:(AxcViewRectCornerStyle)viewRectCornerType{
    AxcContentLayout_Objc_setObj(@selector(viewRectCornerType), @(viewRectCornerType));
    [self setupButtonCornerType];
}

- (AxcViewRectCornerStyle)viewRectCornerType
{
    return [AxcContentLayout_Objc_getObj integerValue];
}

- (void)setViewCornerRadius:(CGFloat)viewCornerRadius{
    AxcContentLayout_Objc_setObj(@selector(viewCornerRadius), @(viewCornerRadius));
}

- (CGFloat)viewCornerRadius
{
    return [AxcContentLayout_Objc_getObj floatValue];
}

@end
