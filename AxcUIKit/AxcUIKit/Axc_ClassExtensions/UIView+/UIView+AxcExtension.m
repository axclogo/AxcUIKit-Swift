
//  UIView+Extension.m
//  AxcUIKit
//
//  Created by axc_5324 on 17/4/19.
//  Copyright © 2017年 axc_5324. All rights reserved.
//

#import "UIView+AxcExtension.h"

@implementation UIView (AxcExtension)

- (void)setAxcUI_X:(CGFloat)axcUI_X
{
    CGRect frame = self.frame;
    frame.origin.x = axcUI_X;
    self.frame = frame;
}

- (void)setAxcUI_Y:(CGFloat)axcUI_Y
{
    CGRect frame = self.frame;
    frame.origin.y = axcUI_Y;
    self.frame = frame;
}

- (CGFloat)axcUI_X
{
    return self.frame.origin.x;
}

- (CGFloat)axcUI_Y
{
    return self.frame.origin.y;
}

- (void)setAxcUI_Width:(CGFloat)axcUI_Width
{
    CGRect frame = self.frame;
    frame.size.width = axcUI_Width;
    self.frame = frame;
}

- (void)setAxcUI_Height:(CGFloat)axcUI_Height
{
    CGRect frame = self.frame;
    frame.size.height = axcUI_Height;
    self.frame = frame;
}

- (CGFloat)axcUI_Height
{
    return self.frame.size.height;
}

- (CGFloat)axcUI_Width
{
    return self.frame.size.width;
}

- (UIView * (^)(CGFloat x))setX{
    return ^(CGFloat x) {
        self.axcUI_X = x;
        return self;
    };
}

- (void)setAxcUI_CenterX:(CGFloat)axcUI_CenterX
{
    CGPoint center = self.center;
    center.x = axcUI_CenterX;
    self.center = center;
}

- (CGFloat)axcUI_CenterX
{
    return self.center.x;
}

- (void)setAxcUI_CenterY:(CGFloat)axcUI_CenterY
{
    CGPoint center = self.center;
    center.y = axcUI_CenterY;
    self.center = center;
}

- (CGFloat)axcUI_CenterY
{
    return self.center.y;
}

- (void)setAxcUI_Size:(CGSize)axcUI_Size
{
    CGRect frame = self.frame;
    frame.size = axcUI_Size;
    self.frame = frame;
}

- (CGSize)axcUI_Size
{
    return self.frame.size;
}

- (void)setAxcUI_Origin:(CGPoint)axcUI_Origin
{
    CGRect frame = self.frame;
    frame.origin = axcUI_Origin;
    self.frame = frame;
}

- (CGPoint)axcUI_Origin
{
    return self.frame.origin;
}

- (CGFloat)axcUI_Left {
    return self.frame.origin.x;
}

- (void)setAxcUI_Left:(CGFloat)axcUI_Left {
    CGRect frame = self.frame;
    frame.origin.x = axcUI_Left;
    self.frame = frame;
}

- (CGFloat)axcUI_Top {
    return self.frame.origin.y;
}

- (void)setAxcUI_Top:(CGFloat)axcUI_Top {
    CGRect frame = self.frame;
    frame.origin.y = axcUI_Top;
    self.frame = frame;
}

- (CGFloat)axcUI_Right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setAxcUI_Right:(CGFloat)axcUI_Right {
    CGRect frame = self.frame;
    frame.origin.x = axcUI_Right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)axcUI_Bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setAxcUI_Bottom:(CGFloat)axcUI_Bottom {
    CGRect frame = self.frame;
    frame.origin.y = axcUI_Bottom - frame.size.height;
    self.frame = frame;
}


- (UIView *(^)(UIColor *color)) setColor{
    return ^ (UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (UIView *(^)(CGRect frame)) setFrame{
    return ^ (CGRect frame) {
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(CGSize size)) setSize
{
    return ^ (CGSize size) {
        self.bounds = CGRectMake(0, 0, size.width, size.height);
        return self;
    };
}

- (UIView *(^)(CGPoint point)) setCenter
{
    return ^ (CGPoint point) {
        self.center = point;
        return self;
    };
}

- (UIView *(^)(NSInteger tag)) setTag
{
    return ^ (NSInteger tag) {
        self.tag = tag;
        return self;
    };
}

- (void)setHollowWithCenterFrame:(CGRect)centerFrame{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.frame]];
    [path appendPath:[UIBezierPath bezierPathWithRect:centerFrame].bezierPathByReversingPath];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}

/**
 *  1.获取屏幕图片
 */
- (UIImage *)imageFromSelfView{
    return [self imageFromViewWithFrame:self.frame];
}

- (UIImage *)imageFromViewWithFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(frame);
    [self.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  theImage;
}

@end
