//
//  UIView+AxcShimmeringView.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIView+AxcShimmeringView.h"

#import <objc/runtime.h>


static NSString * const kshimmeringText = @"axcUI_shimmeringText";
static NSString * const kshimmeringTextfont = @"axcUI_shimmeringTextfont";
static NSString * const kshimmeringBackColor = @"axcUI_shimmeringBackColor";
static NSString * const kshimmeringForeColor = @"axcUI_shimmeringForeColor";
static NSString * const kshimmeringTextAlignment = @"axcUI_shimmeringTextAlignment";
static NSString * const kAxcBackLabel = @"AxcBackLabel";
static NSString * const kAxcfrontLabel = @"AxcfrontLabel";
static NSString * const ktextEdgeInsets = @"axcUI_textEdgeInsets";


@implementation UIView (AxcShimmeringView)

- (void)setAxcfrontLabel:(AxcUI_Label *)AxcfrontLabel{
    [self willChangeValueForKey:kAxcfrontLabel];
    objc_setAssociatedObject(self, &kAxcfrontLabel,
                             AxcfrontLabel,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kAxcfrontLabel];
}
- (AxcUI_Label *)AxcfrontLabel{
    AxcUI_Label *label = objc_getAssociatedObject(self, &kAxcfrontLabel);
    if (!label) {
        label = [[AxcUI_Label alloc] initWithFrame:self.bounds];
        [self setAxcfrontLabel:label];
        [self addSubview:label];
    }
    return label;
}

- (void)setAxcBackLabel:(AxcUI_Label *)AxcBackLabel{
    [self willChangeValueForKey:kAxcBackLabel];
    objc_setAssociatedObject(self, &kAxcBackLabel,
                             AxcBackLabel,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kAxcBackLabel];
}
- (AxcUI_Label *)AxcBackLabel{
    AxcUI_Label *label = objc_getAssociatedObject(self, &kAxcBackLabel);
    if (!label) {
        label = [[AxcUI_Label alloc] initWithFrame:self.bounds];
        [self setAxcBackLabel:label];
        [self addSubview:label];
    }
    return label;
}


- (void)setAxcUI_shimmeringTextAlignment:(NSTextAlignment)axcUI_shimmeringTextAlignment{
    [self willChangeValueForKey:kshimmeringTextAlignment];
    objc_setAssociatedObject(self, &kshimmeringTextAlignment,
                             @(axcUI_shimmeringTextAlignment),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kshimmeringTextAlignment];
    self.AxcBackLabel.textAlignment = axcUI_shimmeringTextAlignment;
    self.AxcfrontLabel.textAlignment = axcUI_shimmeringTextAlignment;
}
- (NSTextAlignment)axcUI_shimmeringTextAlignment{
    return [objc_getAssociatedObject(self, &kshimmeringTextAlignment) intValue];
}

- (void)setAxcUI_shimmeringForeColor:(UIColor *)axcUI_shimmeringForeColor{
    [self willChangeValueForKey:kshimmeringForeColor];
    objc_setAssociatedObject(self, &kshimmeringForeColor,
                             axcUI_shimmeringForeColor,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kshimmeringForeColor];
    self.AxcfrontLabel.textColor = axcUI_shimmeringForeColor;
}
- (UIColor *)axcUI_shimmeringForeColor{
    return objc_getAssociatedObject(self, &kshimmeringForeColor);
}

- (void)setAxcUI_shimmeringText:(NSString *)axcUI_shimmeringText{
    [self willChangeValueForKey:kshimmeringText];
    objc_setAssociatedObject(self, &kshimmeringText,
                             axcUI_shimmeringText,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kshimmeringText];
    self.AxcBackLabel.text = axcUI_shimmeringText;
    self.AxcfrontLabel.text = axcUI_shimmeringText;
}
- (NSString *)axcUI_shimmeringText{
    return objc_getAssociatedObject(self, &kshimmeringText);
}

- (void)setAxcUI_shimmeringTextfont:(UIFont *)axcUI_shimmeringTextfont{
    [self willChangeValueForKey:kshimmeringTextfont];
    objc_setAssociatedObject(self, &kshimmeringTextfont,
                             axcUI_shimmeringTextfont,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kshimmeringTextfont];
    self.AxcBackLabel.font = axcUI_shimmeringTextfont;
    self.AxcfrontLabel.font = axcUI_shimmeringTextfont;
}
- (UIFont *)axcUI_shimmeringTextfont{
    return objc_getAssociatedObject(self, &kshimmeringTextfont);
}

- (void)setAxcUI_shimmeringBackColor:(UIColor *)axcUI_shimmeringBackColor{
    [self willChangeValueForKey:kshimmeringBackColor];
    objc_setAssociatedObject(self, &kshimmeringBackColor,
                             axcUI_shimmeringBackColor,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kshimmeringBackColor];
    self.AxcBackLabel.textColor = axcUI_shimmeringBackColor;
}
- (UIColor *)axcUI_shimmeringBackColor{
    return objc_getAssociatedObject(self, &kshimmeringBackColor);
}


- (void)AxcUI_ShimmeringWithType:(AxcShimmeringViewStyle)type Duration:(NSTimeInterval)duration{
    [self.AxcfrontLabel.layer.mask removeAllAnimations];
    if (type == AxcShimmeringViewStyleOverallFilling) { // 第一个
        [self createFadeRightMask];
        CABasicAnimation *basicAnimation = [CABasicAnimation animation];
        basicAnimation.keyPath = @"transform.translation.x";
        basicAnimation.fromValue = @(0);
        basicAnimation.toValue = @(self.bounds.size.width);
        basicAnimation.duration = duration;
        basicAnimation.repeatCount = LONG_MAX;
        basicAnimation.removedOnCompletion = NO;
        basicAnimation.fillMode = kCAFillModeForwards;
        [self.AxcfrontLabel.layer.mask addAnimation:basicAnimation forKey:nil];
    }else if(type == AxcShimmeringViewStyleFadeLeftToRight){
        [self createiPhoneFadeMask];
        CABasicAnimation *basicAnimation = [CABasicAnimation animation];
        basicAnimation.keyPath = @"transform.translation.x";
        basicAnimation.fromValue = @(0);
        basicAnimation.toValue = @(self.bounds.size.width+self.bounds.size.width/2.0);
        basicAnimation.duration = duration;
        basicAnimation.repeatCount = LONG_MAX;
        basicAnimation.removedOnCompletion = NO;
        basicAnimation.fillMode = kCAFillModeForwards;
        [self.AxcfrontLabel.layer.mask addAnimation:basicAnimation forKey:nil];
    }else if(type == AxcShimmeringViewStyleFadeRightToLeft){
        [self createiPhoneFadeMask];
        CABasicAnimation *basicAnimation = [CABasicAnimation animation];
        basicAnimation.keyPath = @"transform.translation.x";
        basicAnimation.fromValue = @(self.bounds.size.width+self.bounds.size.width/2.0);;
        basicAnimation.toValue = @(0);
        basicAnimation.duration = duration;
        basicAnimation.repeatCount = LONG_MAX;
        basicAnimation.removedOnCompletion = NO;
        basicAnimation.fillMode = kCAFillModeForwards;
        [self.AxcfrontLabel.layer.mask addAnimation:basicAnimation forKey:nil];
    }else if(type == AxcShimmeringViewStyleFadeReverse){
        
        [self createiPhoneFadeMask];
        CABasicAnimation *basicAnimation = [CABasicAnimation animation];
        basicAnimation.keyPath = @"transform.translation.x";
        basicAnimation.fromValue = @(0);
        basicAnimation.toValue = @(self.bounds.size.width+self.bounds.size.width/2.0);
        basicAnimation.duration = duration;
        basicAnimation.repeatCount = LONG_MAX;
        basicAnimation.removedOnCompletion = NO;
        basicAnimation.autoreverses = YES;
        basicAnimation.fillMode = kCAFillModeForwards;
        [self.AxcfrontLabel.layer.mask addAnimation:basicAnimation forKey:nil];
        
    }else if(type == AxcShimmeringViewStyleFadeAll){
        [self createShimmerAllMask];
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        basicAnimation.repeatCount = MAXFLOAT;
        basicAnimation.autoreverses = true;
        basicAnimation.fromValue = @(0.0);
        basicAnimation.toValue = @(1.0);
        basicAnimation.duration = duration;
        
        [self.AxcfrontLabel.layer addAnimation:basicAnimation forKey:@"start"];
        [self.AxcfrontLabel.layer.mask addAnimation:basicAnimation forKey:nil];
    }
}

- (void)createShimmerAllMask{
    [self.AxcfrontLabel.layer removeAllAnimations];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    layer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor redColor].CGColor,(id)[UIColor clearColor].CGColor];
    layer.transform = CATransform3DIdentity;

    self.AxcfrontLabel.layer.mask = layer;
}

- (void)createiPhoneFadeMask{
    [self.AxcfrontLabel.layer removeAllAnimations];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    layer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor redColor].CGColor,(id)[UIColor clearColor].CGColor];
    layer.locations = @[@(0.25),@(0.5),@(0.75)];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1, 0);

    self.AxcfrontLabel.layer.mask = layer;
    
    layer.position = CGPointMake(-self.bounds.size.width/4.0, self.bounds.size.height/2.0);
}

- (void)createFadeRightMask{
    [self.AxcfrontLabel.layer removeAllAnimations];
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = self.bounds;
    layer.colors = @[(id)[UIColor clearColor],(id)[UIColor redColor].CGColor,(id)[UIColor blackColor].CGColor,(id)[UIColor clearColor].CGColor];
    layer.locations = @[@(0.01),@(0.1),@(0.9),@(0.99)];

    self.AxcfrontLabel.layer.mask = layer;
}

- (void)setAxcUI_textEdgeInsets:(UIEdgeInsets)axcUI_textEdgeInsets{
    self.AxcfrontLabel.axcUI_textEdgeInsets = axcUI_textEdgeInsets;
    self.AxcBackLabel.axcUI_textEdgeInsets = axcUI_textEdgeInsets;
    [self willChangeValueForKey:kshimmeringBackColor];
    objc_setAssociatedObject(self, &ktextEdgeInsets,
                             [NSValue valueWithUIEdgeInsets:axcUI_textEdgeInsets],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:ktextEdgeInsets];
}

- (UIEdgeInsets)axcUI_textEdgeInsets{
    return [objc_getAssociatedObject(self, &ktextEdgeInsets) UIEdgeInsetsValue];
}

@end
