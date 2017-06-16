//
//  UILabel+AxcShimmering.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/9.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UILabel+AxcShimmering.h"
#import "UIColor+AxcColor.h"

#import <objc/runtime.h>


static NSString * const kShimmeringColor = @"axcUI_ShimmeringColor";


@implementation UILabel (AxcShimmering)
- (void)AxcUI_shimmeringEffectStart{
    self.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    gradientMask.frame = self.bounds;
    CGFloat gradientSize = self.frame.size.width /6 / self.frame.size.width;
    UIColor *gradient = [UIColor colorWithWhite:1.0f alpha:0.4];
    NSArray *startLocations = @[[NSNumber numberWithFloat:0.0f], [NSNumber numberWithFloat:(gradientSize / 2)], [NSNumber numberWithFloat:gradientSize]];
    NSArray *endLocations = @[[NSNumber numberWithFloat:(1.0f - gradientSize)], [NSNumber numberWithFloat:(1.0f -(gradientSize / 2))], [NSNumber numberWithFloat:1.0f]];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    
    gradientMask.colors = @[(id)gradient.CGColor, (id)[UIColor whiteColor].CGColor, (id)gradient.CGColor];
    gradientMask.locations = startLocations;
    gradientMask.startPoint = CGPointMake(0 - (gradientSize * 2), .5);
    gradientMask.endPoint = CGPointMake(1 + gradientSize, .5);
    
    self.layer.mask = gradientMask;
    
    animation.fromValue = startLocations;
    animation.toValue = endLocations;
    animation.repeatCount = INFINITY;
    animation.duration  = 0.007*[UIScreen mainScreen].bounds.size.width/2.8;
    
    [gradientMask addAnimation:animation forKey:nil];
}



@end
