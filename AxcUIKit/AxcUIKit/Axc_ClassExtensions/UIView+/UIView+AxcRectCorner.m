//
//  UIView+AxcRectCorner.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/12.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIView+AxcRectCorner.h"
#import <objc/runtime.h>

static NSString * const kcornerRadii = @"axcUI_cornerRadii";
static NSString * const krectCorner = @"axcUI_rectCorner";


@implementation UIView (AxcRectCorner)

- (void)setAxcUI_cornerRadii:(CGFloat)axcUI_cornerRadii{
    CGFloat Radii = [objc_getAssociatedObject(self, &kcornerRadii) floatValue];
    if (Radii != axcUI_cornerRadii) {
        [self willChangeValueForKey:kcornerRadii];
        objc_setAssociatedObject(self, &kcornerRadii,
                                 @(axcUI_cornerRadii),
                                 OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:kcornerRadii];
        [self AxcUI_rectCornerWithCornerRadii:axcUI_cornerRadii Corner:self.axcUI_rectCorner];
    }
    
    
}
- (CGFloat)axcUI_cornerRadii{
    if (!objc_getAssociatedObject(self, &kcornerRadii)) {
        [self setAxcUI_cornerRadii:5];
    }
    return [objc_getAssociatedObject(self, &kcornerRadii) floatValue];
}

- (void)setAxcUI_rectCorner:(UIRectCorner)axcUI_rectCorner{
    [self willChangeValueForKey:krectCorner];
    objc_setAssociatedObject(self, &krectCorner,
                             @(axcUI_rectCorner),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:krectCorner];
    
    [self AxcUI_rectCornerWithCornerRadii:self.axcUI_cornerRadii Corner:axcUI_rectCorner];
}
- (UIRectCorner)axcUI_rectCorner{
    return [objc_getAssociatedObject(self, &krectCorner) intValue];
}

- (void)AxcUI_rectCornerWithCornerRadii:(CGFloat )cornerRadii Corner:(UIRectCorner)corner{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corner
                                                         cornerRadii:CGSizeMake(cornerRadii,
                                                                                cornerRadii)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
