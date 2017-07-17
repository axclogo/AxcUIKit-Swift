//
//  Axc_ActivityIndicator.m
//  DGTest
//
//  Created by Axc on 2017/6/9.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "Axc_ActivityIndicator.h"

// 基类
@implementation AxcUI_CtivityIndicatorAnimation
- (CABasicAnimation *)createBasicAnimationWithKeyPath:(NSString *)keyPath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.removedOnCompletion = NO;
    return animation;
}
- (CAKeyframeAnimation *)createKeyframeAnimationWithKeyPath:(NSString *)keyPath {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.removedOnCompletion = NO;
    return animation;
}
- (CAAnimationGroup *)createAnimationGroup {
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.removedOnCompletion = NO;
    return animationGroup;
}
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {}
@end

#pragma mark - BallBeat动画
@implementation AxcUI_CtivityIndicatorBallBeatAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 0.7f;
    NSArray *beginTimes = @[@0.35f, @0.0f, @0.35f];
    CGFloat circleSpacing = 2.0f;
    CGFloat circleSize = (size.width - circleSpacing * 2) / 3;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - circleSize) / 2;
    // 规模动画
    CAKeyframeAnimation *scaleAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = duration;
    scaleAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    scaleAnimation.values = @[@1.0f, @0.75f, @1.0f];
    // 不透明animation
    CAKeyframeAnimation *opacityAnimation = [self createKeyframeAnimationWithKeyPath:@"opacity"];
    opacityAnimation.duration = duration;
    opacityAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    opacityAnimation.values = @[@1.0f, @0.2f, @1.0f];
    // Aniamtion
    CAAnimationGroup *animation = [self createAnimationGroup];;
    animation.duration = duration;
    animation.animations = @[scaleAnimation, opacityAnimation];
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    // 绘制周期
    for (int i = 0; i < 3; i++) {
        CAShapeLayer *circle = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, circleSize, circleSize) cornerRadius:circleSize / 2];
        animation.beginTime = [beginTimes[i] floatValue];
        circle.fillColor = tintColor.CGColor;
        circle.path = circlePath.CGPath;
        [circle addAnimation:animation forKey:@"animation"];
        circle.frame = CGRectMake(x + circleSize * i + circleSpacing * i, y, circleSize, circleSize);
        [layer addSublayer:circle];
    }
}

@end

#pragma mark - BallClipRotate动画
@implementation AxcUI_CtivityIndicatorBallClipRotateAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 0.75f;
    // 规模动画
    CAKeyframeAnimation *scaleAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 1.0f)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    scaleAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    // 旋转 animation
    CAKeyframeAnimation *rotateAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = @[@0, @M_PI, @(2 * M_PI)];
    rotateAnimation.keyTimes = scaleAnimation.keyTimes;
    // Animation
    CAAnimationGroup *animation = [self createAnimationGroup];;
    animation.animations = @[scaleAnimation, rotateAnimation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    // 画个球
    CAShapeLayer *circle = [CAShapeLayer layer];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(size.width / 2, size.height / 2) radius:size.width / 2 startAngle:1.5 * M_PI endAngle:M_PI clockwise:true];
    circle.path = circlePath.CGPath;
    circle.lineWidth = 2;
    circle.fillColor = nil;
    circle.strokeColor = tintColor.CGColor;
    circle.frame = CGRectMake((layer.bounds.size.width - size.width) / 2, (layer.bounds.size.height - size.height) / 2, size.width, size.height);
    [circle addAnimation:animation forKey:@"animation"];
    [layer addSublayer:circle];
}
@end

#pragma mark - BallClipRotateMultiple动画
@implementation AxcUI_CtivityIndicatorBallClipRotateMultipleAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat bigDuration = 1.0f;
    CGFloat smallDuration = bigDuration / 2;
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    { // 大圆
        CGFloat circleSize = size.width;
        CAShapeLayer *circle = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        
        [circlePath addArcWithCenter:CGPointMake(circleSize / 2, circleSize / 2) radius:circleSize / 2 startAngle:-3 * M_PI / 4 endAngle:-M_PI / 4 clockwise:true];
        [circlePath moveToPoint:CGPointMake(circleSize / 2 - circleSize / 2 * cosf(M_PI / 4), circleSize / 2 + circleSize / 2 * sinf(M_PI / 4))];
        [circlePath addArcWithCenter:CGPointMake(circleSize / 2, circleSize / 2) radius:circleSize / 2 startAngle:-5 * M_PI / 4 endAngle:-7 * M_PI / 4 clockwise:false];
        circle.path = circlePath.CGPath;
        circle.lineWidth = 2;
        circle.fillColor = nil;
        circle.strokeColor = tintColor.CGColor;
        
        circle.frame = CGRectMake((layer.bounds.size.width - circleSize) / 2, (layer.bounds.size.height - circleSize) / 2, circleSize, circleSize);
        [circle addAnimation: [self createAnimationInDuration:bigDuration withTimingFunction:timingFunction reverse:false] forKey:@"animation"];
        [layer addSublayer:circle];
    }
    // 小圆
    {
        CGFloat circleSize = size.width / 2;
        CAShapeLayer *circle = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        
        [circlePath addArcWithCenter:CGPointMake(circleSize / 2, circleSize / 2) radius:circleSize / 2 startAngle:3 * M_PI / 4 endAngle:5 * M_PI / 4 clockwise:true];
        [circlePath moveToPoint:CGPointMake(circleSize / 2 + circleSize / 2 * cosf(M_PI / 4), circleSize / 2 - circleSize / 2 * sinf(M_PI / 4))];
        [circlePath addArcWithCenter:CGPointMake(circleSize / 2, circleSize / 2) radius:circleSize / 2 startAngle:-M_PI / 4 endAngle:M_PI / 4 clockwise:true];
        circle.path = circlePath.CGPath;
        circle.lineWidth = 2;
        circle.fillColor = nil;
        circle.strokeColor = tintColor.CGColor;
        
        circle.frame = CGRectMake((layer.bounds.size.width - circleSize) / 2, (layer.bounds.size.height - circleSize) / 2, circleSize, circleSize);
        [circle addAnimation:[self createAnimationInDuration:smallDuration withTimingFunction:timingFunction reverse:true] forKey:@"animation"];
        [layer addSublayer:circle];
    }
}

- (CAAnimation *)createAnimationInDuration:(CGFloat) duration withTimingFunction:(CAMediaTimingFunction *) timingFunction reverse:(BOOL) reverse {
    // 规模 animation
    CAKeyframeAnimation *scaleAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.scale"];
    scaleAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 1.0f)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    scaleAnimation.duration = duration;
    scaleAnimation.timingFunctions = @[timingFunction, timingFunction];
    // 旋转 animation
    CAKeyframeAnimation *rotateAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.rotation.z"];
    if (!reverse) {rotateAnimation.values = @[@0, @M_PI, @(2 * M_PI)];
    } else {rotateAnimation.values = @[@0, @-M_PI, @(-2 * M_PI)];}
    rotateAnimation.keyTimes = scaleAnimation.keyTimes;
    rotateAnimation.duration = duration;
    rotateAnimation.timingFunctions = @[timingFunction, timingFunction];
    // Animation
    CAAnimationGroup *animation = [self createAnimationGroup];;
    animation.animations = @[scaleAnimation, rotateAnimation];
    animation.repeatCount = HUGE_VALF;
    animation.duration = duration;
    return animation;
}
@end

#pragma mark - BallClipRotatePulse动画
@implementation AxcUI_CtivityIndicatorBallClipRotatePulseAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 1.0f;
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.09f :0.57f :0.49f :0.9f];
    {
        CAKeyframeAnimation *scaleAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.scale"];
        scaleAnimation.keyTimes = @[@0.0f, @0.3f, @1.0f];
        scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3f, 0.3f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
        scaleAnimation.duration = duration;
        scaleAnimation.repeatCount = HUGE_VALF;
        scaleAnimation.timingFunctions = @[timingFunction, timingFunction];
        CGFloat circleSize = size.width / 2;
        CALayer *circle = [CALayer layer];
        circle.frame = CGRectMake((layer.bounds.size.width - circleSize) / 2, (layer.bounds.size.height - circleSize) / 2, circleSize, circleSize);
        circle.backgroundColor = tintColor.CGColor;
        circle.cornerRadius = circleSize / 2;
        [circle addAnimation:scaleAnimation forKey:@"animation"];
        [layer addSublayer:circle];
    }// Big circle
    {
        CAKeyframeAnimation *scaleAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.scale"];
        scaleAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
        scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 1.0f)],
                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
        scaleAnimation.duration = duration;
        scaleAnimation.timingFunctions = @[timingFunction, timingFunction];
        CAKeyframeAnimation *rotateAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.values = @[@0, @M_PI, @(2 * M_PI)];
        rotateAnimation.keyTimes = scaleAnimation.keyTimes;
        rotateAnimation.duration = duration;
        rotateAnimation.timingFunctions = @[timingFunction, timingFunction];
        CAAnimationGroup *animation = [self createAnimationGroup];;
        animation.animations = @[scaleAnimation, rotateAnimation];
        animation.duration = duration;
        animation.repeatCount = HUGE_VALF;
        CGFloat circleSize = size.width;
        CAShapeLayer *circle = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        [circlePath addArcWithCenter:CGPointMake(circleSize / 2, circleSize / 2) radius:circleSize / 2 startAngle:-3 * M_PI / 4 endAngle:-M_PI / 4 clockwise:true];
        [circlePath moveToPoint:CGPointMake(circleSize / 2 - circleSize / 2 * cosf(M_PI / 4), circleSize / 2 + circleSize / 2 * sinf(M_PI / 4))];
        [circlePath addArcWithCenter:CGPointMake(circleSize / 2, circleSize / 2) radius:circleSize / 2 startAngle:-5 * M_PI / 4 endAngle:-7 * M_PI / 4 clockwise:false];
        circle.path = circlePath.CGPath;
        circle.lineWidth = 2;
        circle.fillColor = nil;
        circle.strokeColor = tintColor.CGColor;
        circle.frame = CGRectMake((layer.bounds.size.width - circleSize) / 2, (layer.bounds.size.height - circleSize) / 2, circleSize, circleSize);
        [circle addAnimation:animation forKey:@"animation"];
        [layer addSublayer:circle];
    }
}
@end

#pragma mark - BallGridBeat动画
@implementation AxcUI_CtivityIndicatorBallGridBeatAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSArray *durations = @[@0.96f, @0.93f, @1.19f, @1.13f, @1.34f, @0.94f, @1.2f, @0.82f, @1.19f];
    NSArray *timeOffsets = @[@0.36f, @0.4f, @0.68f, @0.41f, @0.71f, @-0.15f, @-0.12f, @0.01f, @0.32f];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CGFloat circleSpacing = 2;
    CGFloat circleSize = (size.width - circleSpacing * 2) / 3;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - size.height) / 2;
    // Animation
    CAKeyframeAnimation *animation = [self createKeyframeAnimationWithKeyPath:@"opacity"];
    animation.beginTime = CACurrentMediaTime();
    animation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    animation.values = @[@1.0f, @0.7f, @1.0f];
    animation.repeatCount = HUGE_VALF;
    animation.timingFunctions = @[timingFunction, timingFunction];
    // Draw circle
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            CALayer *circle = [self createCirleWith:circleSize color:tintColor];
            animation.duration = [durations[3 * i + j] floatValue];
            animation.timeOffset = [timeOffsets[3 * i + j] floatValue];
            circle.frame = CGRectMake(x + circleSize * j + circleSpacing * j, y + circleSize * i + circleSpacing * i, circleSize, circleSize);
            [circle addAnimation:animation forKey:@"animation"];
            [layer addSublayer:circle];
        }
    }
}
- (CALayer *)createCirleWith:(CGFloat)size color:(UIColor *)color {
    CAShapeLayer *circle = [CAShapeLayer layer];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size, size) cornerRadius:size / 2];
    circle.fillColor = color.CGColor;
    circle.path = circlePath.CGPath;
    return circle;
}
@end

#pragma mark - BallGridPulse动画
@implementation AxcUI_CtivityIndicatorBallGridPulseAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSArray *durations = @[@0.72f, @1.02f, @1.28f, @1.42f, @1.45f, @1.18f, @0.87f, @1.45f, @1.06f];
    NSArray *timeOffsets = @[@-0.06f, @0.25f, @-0.17f, @0.48f, @0.31f, @0.03f, @0.46f, @0.78f, @0.45f];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CGFloat circleSpacing = 2;
    CGFloat circleSize = (size.width - circleSpacing * 2) / 3;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - size.height) / 2;
    CAKeyframeAnimation *scaleAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.scale"];
    scaleAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    scaleAnimation.values = @[@1.0f, @0.5f, @1.0f];
    scaleAnimation.timingFunctions = @[timingFunction, timingFunction];
    CAKeyframeAnimation *opacityAnimation = [self createKeyframeAnimationWithKeyPath:@"opacity"];
    opacityAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    opacityAnimation.values = @[@1.0f, @0.7f, @1.0f];
    opacityAnimation.timingFunctions = @[timingFunction, timingFunction];
    CAAnimationGroup *animation = [self createAnimationGroup];;
    animation.animations = @[scaleAnimation, opacityAnimation];
    animation.beginTime = CACurrentMediaTime();
    animation.repeatCount = HUGE_VALF;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            CALayer *circle = [self createCirleWith:circleSize color:tintColor];
            animation.duration = [durations[3 * i + j] floatValue];
            animation.timeOffset = [timeOffsets[3 * i + j] floatValue];
            circle.frame = CGRectMake(x + circleSize * j + circleSpacing * j, y + circleSize * i + circleSpacing * i, circleSize, circleSize);
            [circle addAnimation:animation forKey:@"animation"];
            [layer addSublayer:circle];
        }
    }
}
- (CALayer *)createCirleWith:(CGFloat)size color:(UIColor *)color {
    CAShapeLayer *circle = [CAShapeLayer layer];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size, size) cornerRadius:size / 2];
    circle.fillColor = color.CGColor;
    circle.path = circlePath.CGPath;
    return circle;
}
@end

#pragma mark - BallPulse动画
@implementation AxcUI_CtivityIndicatorBallPulseAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat circlePadding = 5.0f;
    CGFloat circleSize = (size.width - 2 * circlePadding) / 3;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - circleSize) / 2;
    CGFloat duration = 0.75f;
    NSArray *timeBegins = @[@0.12f, @0.24f, @0.36f];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.2f :0.68f :0.18f :1.08f];
    CAKeyframeAnimation *animation = [self createKeyframeAnimationWithKeyPath:@"transform"];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3f, 0.3f, 1.0f)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    animation.keyTimes = @[@0.0f, @0.3f, @1.0f];
    animation.timingFunctions = @[timingFunction, timingFunction];
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    for (int i = 0; i < 3; i++) {
        CALayer *circle = [CALayer layer];
        circle.frame = CGRectMake(x + i * circleSize + i * circlePadding, y, circleSize, circleSize);
        circle.backgroundColor = tintColor.CGColor;
        circle.cornerRadius = circle.bounds.size.width / 2;
        animation.beginTime = [timeBegins[i] floatValue];
        [circle addAnimation:animation forKey:@"animation"];
        [layer addSublayer:circle];
    }
}
@end

#pragma mark - BallPulseSync动画
@implementation AxcUI_CtivityIndicatorBallPulseSyncAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 0.6f;
    NSArray *beginTimes = @[@0.07f, @0.14f, @0.21f];
    CGFloat circleSpacing = 2.0f;
    CGFloat circleSize = (size.width - circleSpacing * 2) / 3;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - circleSize) / 2;
    CGFloat deltaY = (size.height / 2 - circleSize / 2) / 2;
    CAMediaTimingFunction *timingFunciton = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAKeyframeAnimation *animation = [self createKeyframeAnimationWithKeyPath:@"transform.translation.y"];
    animation.duration = duration;
    animation.keyTimes = @[@0.0f, @0.33f, @0.66f, @1.0f];
    animation.values = @[@0.0f, @(deltaY), @(-deltaY), @0.0f];
    animation.timingFunctions = @[timingFunciton, timingFunciton, timingFunciton];
    animation.repeatCount = HUGE_VALF;
    for (int i = 0; i < 3; i++) {
        CAShapeLayer *circle = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, circleSize, circleSize) cornerRadius:circleSize / 2];
        animation.beginTime = [beginTimes[i] floatValue];
        circle.fillColor = tintColor.CGColor;
        circle.path = circlePath.CGPath;
        [circle addAnimation:animation forKey:@"animation"];
        circle.frame = CGRectMake(x + circleSize * i + circleSpacing * i, y, circleSize, circleSize);
        [layer addSublayer:circle];
    }
}
@end

#pragma mark - BallRotate动画
@implementation AxcUI_CtivityIndicatorBallRotateAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 1.0f;
    CGFloat circleSize = size.width / 5;
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.7f :-0.13f :0.22f :0.86f];
    CAKeyframeAnimation *scaleAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.scale"];
    scaleAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6f, 0.6f, 1.0f)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
    scaleAnimation.duration = duration;
    scaleAnimation.timingFunctions = @[timingFunction, timingFunction];
    CAKeyframeAnimation *rotateAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    rotateAnimation.values = @[@0, @-M_PI, @(-2 * M_PI)];
    rotateAnimation.duration = duration;
    rotateAnimation.timingFunctions = @[timingFunction, timingFunction];
    CAAnimationGroup *animation = [self createAnimationGroup];;
    animation.animations = @[scaleAnimation, rotateAnimation];
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    CALayer *leftCircle = [CALayer layer];
    leftCircle.backgroundColor = tintColor.CGColor;
    leftCircle.opacity = 0.8f;
    leftCircle.cornerRadius = circleSize / 2;
    leftCircle.frame = CGRectMake(0, (size.height - circleSize) / 2, circleSize, circleSize);
    CALayer *rightCircle = [CALayer layer];
    rightCircle.backgroundColor = tintColor.CGColor;
    rightCircle.opacity = 0.8f;
    rightCircle.cornerRadius = circleSize / 2;
    rightCircle.frame = CGRectMake(size.width - circleSize, (size.height - circleSize) / 2, circleSize, circleSize);
    CALayer *centerCircle = [CALayer layer];
    centerCircle.backgroundColor = tintColor.CGColor;
    centerCircle.cornerRadius = circleSize / 2;
    centerCircle.frame = CGRectMake((size.width - circleSize) / 2, (size.height - circleSize) / 2, circleSize, circleSize);
    CALayer *circle = [CALayer layer];
    circle.frame = CGRectMake((layer.bounds.size.width - size.width) / 2, (layer.bounds.size.height - size.height) / 2, size.width, size.height);
    [circle addSublayer:leftCircle];
    [circle addSublayer:rightCircle];
    [circle addSublayer:centerCircle];
    [circle addAnimation:animation forKey:@"animation"];
    [layer addSublayer:circle];
}
@end

#pragma mark - BallScale动画
@implementation AxcUI_CtivityIndicatorBallScaleAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 1.0f;
    CABasicAnimation *scaleAnimation = [self createBasicAnimationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = duration;
    scaleAnimation.fromValue = @0.0f;
    scaleAnimation.toValue = @1.0f;
    CABasicAnimation *opacityAnimation = [self createBasicAnimationWithKeyPath:@"opacity"];
    opacityAnimation.duration = duration;
    opacityAnimation.fromValue = @1.0f;
    opacityAnimation.toValue = @0.0f;
    CAAnimationGroup *animation = [self createAnimationGroup];;
    animation.animations = @[scaleAnimation, opacityAnimation];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    CAShapeLayer *circle = [CAShapeLayer layer];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, size.width, size.height) cornerRadius:size.width / 2];
    circle.fillColor = tintColor.CGColor;
    circle.path = circlePath.CGPath;
    [circle addAnimation:animation forKey:@"animation"];
    circle.frame = CGRectMake((layer.bounds.size.width - size.width) / 2, (layer.bounds.size.height - size.height) / 2, size.width, size.height);
    [layer addSublayer:circle];
}
@end

#pragma mark -BallScaleMultiple动画
@implementation AxcUI_CtivityIndicatorBallScaleMultipleAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 1.0f;
    NSArray *beginTimes = @[@0.0f, @0.2f, @0.4f];
    CABasicAnimation *scaleAnimation = [self createBasicAnimationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.duration = duration;
    scaleAnimation.fromValue = @0.0f;
    scaleAnimation.toValue = @1.0f;
    CAKeyframeAnimation *opacityAnimation = [self createKeyframeAnimationWithKeyPath:@"opacity"];
    
    opacityAnimation.duration = duration;
    opacityAnimation.keyTimes = @[@0.0f, @0.05f, @1.0f];
    opacityAnimation.values = @[@0.0f, @1.0f, @0.0f];
    CAAnimationGroup *animation = [self createAnimationGroup];;
    
    animation.animations = @[scaleAnimation, opacityAnimation];
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    for (int i = 0; i < 3; i++) {
        CAShapeLayer *circle = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:size.width / 2];
        
        animation.beginTime = [beginTimes[i] floatValue];
        circle.fillColor = tintColor.CGColor;
        circle.path = circlePath.CGPath;
        circle.opacity = 0.0f;
        [circle addAnimation:animation forKey:@"animation"];
        circle.frame = CGRectMake((layer.bounds.size.width - size.width) / 2, (layer.bounds.size.height - size.height) / 2, size.width, size.height);
        [layer addSublayer:circle];
    }
}
@end

#pragma mark - BallScaleRipple动画
@implementation AxcUI_CtivityIndicatorBallScaleRippleAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 1.0f;
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.21f :0.53f :0.56f :0.8f];
    // Scale animation
    CAKeyframeAnimation *scaleAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = duration;
    scaleAnimation.keyTimes = @[@0.0f, @0.7f];
    scaleAnimation.values = @[@0.1f, @1.0f];
    scaleAnimation.timingFunction = timingFunction;
    // Opacity animation
    CAKeyframeAnimation *opacityAnimation = [self createKeyframeAnimationWithKeyPath:@"opacity"];
    opacityAnimation.duration = duration;
    opacityAnimation.keyTimes = @[@0.0f, @0.7f, @1.0f];
    opacityAnimation.values = @[@1.0f, @0.7f, @0.0f];
    opacityAnimation.timingFunctions = @[timingFunction, timingFunction];
    // Animation
    CAAnimationGroup *animation = [self createAnimationGroup];;
    animation.animations = @[scaleAnimation, opacityAnimation];
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    // Draw circle
    CAShapeLayer *circle = [CAShapeLayer layer];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:size.width / 2];
    circle.fillColor = nil;
    circle.lineWidth = 2;
    circle.strokeColor = tintColor.CGColor;
    circle.path = circlePath.CGPath;
    [circle addAnimation:animation forKey:@"animation"];
    circle.frame = CGRectMake((layer.bounds.size.width - size.width) / 2, (layer.bounds.size.height - size.height) / 2, size.width, size.height);
    [layer addSublayer:circle];
}
@end

#pragma mark - BallScaleRippleMultiple动画
@implementation AxcUI_CtivityIndicatorBallScaleRippleMultipleAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 1.25f;
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.21f :0.53f :0.56f :0.8f];
    NSArray *timeOffsets = @[@0.0f, @0.2f, @0.4f];
    CAKeyframeAnimation *scaleAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.duration = duration;
    scaleAnimation.keyTimes = @[@0.0f, @0.7f];
    scaleAnimation.values = @[@0.1f, @1.0f];
    scaleAnimation.timingFunction = timingFunction;
    CAKeyframeAnimation *opacityAnimation = [self createKeyframeAnimationWithKeyPath:@"opacity"];
    
    opacityAnimation.duration = duration;
    opacityAnimation.keyTimes = @[@0.0f, @0.7f, @1.0f];
    opacityAnimation.values = @[@1.0f, @0.7f, @0.0f];
    opacityAnimation.timingFunctions = @[timingFunction, timingFunction];
    CAAnimationGroup *animation = [self createAnimationGroup];;
    
    animation.animations = @[scaleAnimation, opacityAnimation];
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    animation.beginTime = CACurrentMediaTime();
    for (int i = 0; i < 3; i++) {
        CAShapeLayer *circle = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:size.width / 2];
        
        animation.timeOffset = [timeOffsets[i] floatValue];
        circle.fillColor = nil;
        circle.lineWidth = 2;
        circle.strokeColor = tintColor.CGColor;
        circle.path = circlePath.CGPath;
        [circle addAnimation:animation forKey:@"animation"];
        circle.frame = CGRectMake((layer.bounds.size.width - size.width) / 2, (layer.bounds.size.height - size.height) / 2, size.width, size.height);
        [layer addSublayer:circle];
    }
}
@end

#pragma mark - BallSpinFadeLoader动画
@implementation AxcUI_CtivityIndicatorBallSpinFadeLoaderAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    
    CGFloat circleSpacing = -2;
    CGFloat circleSize = (size.width - 4 * circleSpacing) / 5;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - size.height) / 2;
    
    CFTimeInterval duration = 1;
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    NSArray *beginTimes = @[@0, @0.12, @0.24, @0.36, @0.48, @0.6, @0.72, @0.84];
    
    CAKeyframeAnimation *scaleAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.scale"];
    
    scaleAnimation.keyTimes = @[@0, @0.5, @1];
    scaleAnimation.values = @[@1, @0.4, @1];
    scaleAnimation.duration = duration;
    
    
    CAKeyframeAnimation *opacityAnimaton = [self createKeyframeAnimationWithKeyPath:@"opacity"];
    
    
    opacityAnimaton.keyTimes = @[@0, @0.5, @1];
    opacityAnimaton.values = @[@1, @0.3, @1];
    opacityAnimaton.duration = duration;
    
    
    
    
    CAAnimationGroup *animationGroup = [self createAnimationGroup];;
    animationGroup.animations = @[scaleAnimation, opacityAnimaton];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.duration = duration;
    animationGroup.repeatCount = HUGE;
    
    
    for (int i = 0; i < 8; i++) {
        CALayer *circle = [self circleLayer:(M_PI_4 * i) size:circleSize origin:CGPointMake(x, y) containerSize:size color:tintColor];
        animationGroup.beginTime = beginTime + [beginTimes[i] doubleValue];
        
        [layer addSublayer:circle];
        [circle addAnimation:animationGroup forKey:@"animation"];
    }
    
}


- (CALayer *)circleLayer:(CGFloat)angle size:(CGFloat)size origin:(CGPoint)origin containerSize:(CGSize)containerSize color:(UIColor *)color{
    CGFloat radius = containerSize.width/2;
    CALayer *circle = [self createLayerWith:CGSizeMake(size, size) color:color];
    CGRect frame = CGRectMake((origin.x + radius * (cos(angle) + 1) - size / 2), origin.y + radius * (sin(angle) + 1) - size / 2, size, size);
    circle.frame = frame;
    
    return circle;
}

- (CALayer *)createLayerWith:(CGSize)size color:(UIColor *)color{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path addArcWithCenter:CGPointMake(size.width / 2,size.height / 2) radius:(size.width / 2) startAngle:0 endAngle:2 * M_PI clockwise:NO];
    layer.fillColor = color.CGColor;
    layer.backgroundColor = nil;
    layer.path = path.CGPath;
    
    return layer;
}

@end

#pragma mark - BallTrianglePath动画
@implementation AxcUI_CtivityIndicatorBallTrianglePathAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 2.0f;
    CGFloat circleSize = size.width / 5;
    CGFloat deltaX = size.width / 2 - circleSize / 2;
    CGFloat deltaY = size.height / 2 - circleSize / 2;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - size.height) / 2;
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // Animation
    CAKeyframeAnimation *animation = [self createKeyframeAnimationWithKeyPath:@"transform"];
    animation.keyTimes = @[@0.0f, @0.33f, @0.66f, @1.0f];
    animation.duration = duration;
    animation.timingFunctions = @[timingFunction, timingFunction, timingFunction];
    animation.repeatCount = HUGE_VALF;

    // Top-center circle
    CALayer *topCenterCircle = [self createCircleWithSize:circleSize color:tintColor];
    
    [self changeAnimation:animation values:@[@"{0,0}", @"{hx,fy}", @"{-hx,fy}", @"{0,0}"] deltaX:deltaX deltaY:deltaY];
    topCenterCircle.frame = CGRectMake(x + size.width / 2 - circleSize / 2, y, circleSize, circleSize);
    [topCenterCircle addAnimation:animation forKey:@"animation"];
    [layer addSublayer:topCenterCircle];
    
    // Bottom-left circle
    CALayer *bottomLeftCircle = [self createCircleWithSize:circleSize color:tintColor];
    
    [self changeAnimation:animation values:@[@"{0,0}", @"{hx,-fy}", @"{fx,0}", @"{0,0}"] deltaX:deltaX deltaY:deltaY];
    bottomLeftCircle.frame = CGRectMake(x, y + size.height - circleSize, circleSize, circleSize);
    [bottomLeftCircle addAnimation:animation forKey:@"animation"];
    [layer addSublayer:bottomLeftCircle];
    
    // Bottom-right circle
    CALayer *bottomRigthCircle = [self createCircleWithSize:circleSize color:tintColor];
    
    [self changeAnimation:animation values:@[@"{0,0}", @"{-fx,0}", @"{-hx,-fy}", @"{0,0}"] deltaX:deltaX deltaY:deltaY];
    bottomRigthCircle.frame = CGRectMake(x + size.width - circleSize, y + size.height - circleSize, circleSize, circleSize);
    [bottomRigthCircle addAnimation:animation forKey:@"animation"];
    [layer addSublayer:bottomRigthCircle];
}

- (CALayer *)createCircleWithSize:(CGFloat)size color:(UIColor *)color {
    CAShapeLayer *circle = [CAShapeLayer layer];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size, size) cornerRadius:size / 2];
    circle.fillColor = nil;
    circle.strokeColor = color.CGColor;
    circle.lineWidth = 1;
    circle.path = circlePath.CGPath;
    return circle;
}

- (CAAnimation *)changeAnimation:(CAKeyframeAnimation *)animation values:(NSArray *)rawValues deltaX:(CGFloat)deltaX
                          deltaY:(CGFloat)deltaY {
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:5];
    
    for (NSString *rawValue in rawValues) {
        CGPoint point = CGPointFromString([self translate:rawValue withDeltaX:deltaX deltaY:deltaY]);
        
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(point.x, point.y, 0)]];
    }
    animation.values = values;
    
    return animation;
}

- (NSString *)translate:(NSString *)valueString withDeltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY {
    NSMutableString *valueMutableString = [NSMutableString stringWithString:valueString];
    CGFloat fullDeltaX = 2 * deltaX;
    CGFloat fullDeltaY = 2 * deltaY;
    NSRange range;
    
    range.location = 0;
    range.length = valueString.length;
    
    [valueMutableString replaceOccurrencesOfString:@"hx" withString:[NSString stringWithFormat:@"%f", deltaX] options:NSCaseInsensitiveSearch range:range];
    range.length = valueMutableString.length;
    [valueMutableString replaceOccurrencesOfString:@"fx" withString:[NSString stringWithFormat:@"%f", fullDeltaX] options:NSCaseInsensitiveSearch range:range];
    range.length = valueMutableString.length;
    [valueMutableString replaceOccurrencesOfString:@"hy" withString:[NSString stringWithFormat:@"%f", deltaY] options:NSCaseInsensitiveSearch range:range];
    range.length = valueMutableString.length;
    [valueMutableString replaceOccurrencesOfString:@"fy" withString:[NSString stringWithFormat:@"%f", fullDeltaY] options:NSCaseInsensitiveSearch range:range];
    
    return valueMutableString;
}

@end

#pragma mark - BallZigZag动画
@implementation AxcUI_CtivityIndicatorBallZigZagAnimation

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 0.7f;
    CGFloat circleSize = size.width / 5;
    CGFloat deltaX = size.width / 2 - circleSize / 2;
    CGFloat deltaY = size.height / 2 - circleSize / 2;
    CAKeyframeAnimation *animation = [self createKeyframeAnimationWithKeyPath:@"transform"];
    
    animation.duration = duration;
    animation.keyTimes = @[@0.0f, @0.33f, @0.66f, @1.0f];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-deltaX, -deltaY, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(deltaX, -deltaY, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)]];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = HUGE_VALF;
    {
        CALayer *circle = [CALayer layer];
        
        circle.backgroundColor = tintColor.CGColor;
        circle.cornerRadius = circleSize / 2;
        circle.frame = CGRectMake((layer.bounds.size.width - circleSize) / 2, (layer.bounds.size.height - circleSize) / 2, circleSize, circleSize);
        [circle addAnimation:animation forKey:@"animation"];
        [layer addSublayer:circle];
    }
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(deltaX, deltaY, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-deltaX, deltaY, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)]];
    
    {
        CALayer *circle = [CALayer layer];
        
        circle.backgroundColor = tintColor.CGColor;
        circle.cornerRadius = circleSize / 2;
        circle.frame = CGRectMake((layer.bounds.size.width - circleSize) / 2, (layer.bounds.size.height - circleSize) / 2, circleSize, circleSize);
        [circle addAnimation:animation forKey:@"animation"];
        [layer addSublayer:circle];
    }
}
@end

#pragma mark - BallZigZagDeflect动画
@implementation AxcUI_CtivityIndicatorBallZigZagDeflectAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 0.75f;
    CGFloat circleSize = size.width / 5;
    CGFloat deltaX = size.width / 2 - circleSize / 2;
    CGFloat deltaY = size.height / 2 - circleSize / 2;
    // Circle 1 animation
    CAKeyframeAnimation *animation = [self createKeyframeAnimationWithKeyPath:@"transform"];
    animation.duration = duration;
    animation.keyTimes = @[@0.0f, @0.33f, @0.66f, @1.0f];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-deltaX, -deltaY, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(deltaX, -deltaY, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)]];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = true;
    // Draw circle 1
    {
        CALayer *circle = [CALayer layer];
        
        circle.backgroundColor = tintColor.CGColor;
        circle.cornerRadius = circleSize / 2;
        circle.frame = CGRectMake((layer.bounds.size.width - circleSize) / 2, (layer.bounds.size.height - circleSize) / 2, circleSize, circleSize);
        [circle addAnimation:animation forKey:@"animation"];
        [layer addSublayer:circle];
    }
    
    // Circle 2 animation
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(deltaX, deltaY, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-deltaX, deltaY, 0)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)]];
    
    // Draw circle 2
    {
        CALayer *circle = [CALayer layer];
        
        circle.backgroundColor = tintColor.CGColor;
        circle.cornerRadius = circleSize / 2;
        circle.frame = CGRectMake((layer.bounds.size.width - circleSize) / 2, (layer.bounds.size.height - circleSize) / 2, circleSize, circleSize);
        [circle addAnimation:animation forKey:@"animation"];
        [layer addSublayer:circle];
    }
}

@end

#pragma mark - CookieTerminator动画
@implementation AxcUI_CtivityIndicatorCookieTerminatorAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CGFloat cookieTerminatorSize =  ceilf(size.width / 3.0f);
    CGFloat oX = (layer.bounds.size.width - size.width) / 2.0f;
    CGFloat oY = layer.bounds.size.height / 2.0f;
    CGPoint cookieTerminatorCenter = CGPointMake(oX, oY);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:cookieTerminatorCenter radius:cookieTerminatorSize startAngle:M_PI_4 endAngle:M_PI * 1.75f clockwise:YES];
    [path addLineToPoint:cookieTerminatorCenter];
    [path closePath];
    
    CAShapeLayer *cookieTerminatorLayer = [CAShapeLayer layer];
    cookieTerminatorLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    cookieTerminatorLayer.fillColor = tintColor.CGColor;
    cookieTerminatorLayer.path = path.CGPath;
    [layer addSublayer:cookieTerminatorLayer];
    
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0.0f, 0.0f) radius:cookieTerminatorSize startAngle:M_PI_2 endAngle:M_PI * 1.5f clockwise:YES];
    [path closePath];
    for (int i = 0; i < 2; i++) {
        CAShapeLayer *jawLayer = [CAShapeLayer layer];
        jawLayer.path = path.CGPath;
        jawLayer.fillColor = tintColor.CGColor;
        jawLayer.position = cookieTerminatorCenter;
        jawLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
        jawLayer.opacity = 1.0f;
        jawLayer.transform = CATransform3DMakeRotation((1.0f - 2.0f * i) * M_PI_4, 0.0f, 0.0f, 1.0f);
        
        CABasicAnimation *transformAnimation = [self createBasicAnimationWithKeyPath:@"transform"];
        transformAnimation.beginTime = beginTime;
        transformAnimation.duration = 0.3f;
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation((1.0f - 2.0f * i) * M_PI_4, 0.0f, 0.0f, 1.0f)];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation((1.0f - 2.0f * i) * M_PI_2, 0.0f, 0.0f, 1.0f)];
        transformAnimation.autoreverses = YES;
        transformAnimation.repeatCount = HUGE_VALF;
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        
        [layer addSublayer:jawLayer];
        [jawLayer addAnimation:transformAnimation forKey:@"animation"];
    }
    
    CGFloat cookieSize = ceilf(size.width / 6.0f);
    CGFloat cookiePadding = cookieSize * 2.0f;
    for (int i = 0; i < 3; i++) {
        CALayer *cookieLayer = [CALayer layer];
        cookieLayer.frame = CGRectMake(cookieTerminatorCenter.x + (cookieSize + cookiePadding) * 3.0f - cookieTerminatorSize, oY - cookieSize / 2.0f, cookieSize, cookieSize);
        cookieLayer.backgroundColor = tintColor.CGColor;
        cookieLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
        cookieLayer.opacity = 1.0f;
        cookieLayer.cornerRadius = cookieSize / 2.0f;
        
        CABasicAnimation *transformAnimation = [self createBasicAnimationWithKeyPath:@"transform"];
        transformAnimation.duration = 1.8f;
        transformAnimation.beginTime = beginTime - (i * transformAnimation.duration / 3.0f);
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f)];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-3.0f * (cookieSize + cookiePadding), 0.0f, 0.0f)];
        transformAnimation.repeatCount = HUGE_VALF;
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
        
        [layer addSublayer:cookieLayer];
        [cookieLayer addAnimation:transformAnimation forKey:@"animation"];
    }
}
@end

#pragma mark - DoubleBounce动画
@implementation AxcUI_CtivityIndicatorDoubleBounceAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CGFloat oX = (layer.bounds.size.width - size.width) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - size.height) / 2.0f;
    for (int i = 0; i < 2; i++) {
        CALayer *circle = [CALayer layer];
        circle.frame = CGRectMake(oX, oY, size.width, size.height);
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.opacity = 0.5f;
        circle.cornerRadius = size.height / 2.0f;
        circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        circle.backgroundColor = tintColor.CGColor;
        
        CAKeyframeAnimation *transformAnimation = [self createKeyframeAnimationWithKeyPath:@"transform"];
        transformAnimation.repeatCount = HUGE_VALF;
        transformAnimation.duration = 2.0f;
        transformAnimation.beginTime = beginTime - (1.0f * i);
        transformAnimation.keyTimes = @[@(0.0f), @(0.5f), @(1.0f)];
        
        transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)]];
        
        [layer addSublayer:circle];
        [circle addAnimation:transformAnimation forKey:@"animation"];
    }
}
@end

#pragma mark - FiveDots动画
@implementation AxcUI_CtivityIndicatorFiveDotsAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CGFloat circleSize = size.width / 5.0f;
    
    CGFloat oX = (layer.bounds.size.width - circleSize * 5) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - circleSize) / 2.0f;
    for (int i = 0; i < 3; i++) {
        CALayer *circle = [CALayer layer];
        circle.frame = CGRectMake(oX + circleSize * 2 * i, oY, circleSize, circleSize);
        circle.backgroundColor = tintColor.CGColor;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.opacity = 1.0f;
        circle.cornerRadius = circle.bounds.size.height / 2.0f;
        
        CATransform3D t1 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t1 = CATransform3DScale(t1, 1.0f, 1.0f, 0.0f);
        
        CATransform3D t2 = CATransform3DMakeTranslation(0.0f, -2 * circleSize, 0.0f);
        t2 = CATransform3DScale(t2, 1.0f, 1.0f, 0.0f);
        
        CATransform3D t3 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t3 = CATransform3DScale(t3, 0.3f, 0.3f, 0.0f);
        
        CATransform3D t4 = CATransform3DMakeTranslation(0.0f, 2 * circleSize, 0.0f);
        t4 = CATransform3DScale(t4, 1.0f, 1.0f, 0.0f);
        
        CATransform3D t5 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t5 = CATransform3DScale(t5, 1.f, 1.0f, 0.0f);
        
        CAKeyframeAnimation *transformAnimation = [self createKeyframeAnimationWithKeyPath:@"transform"];
        transformAnimation.values = @[[NSValue valueWithCATransform3D:t1],
                                      [NSValue valueWithCATransform3D:t2],
                                      [NSValue valueWithCATransform3D:t3],
                                      [NSValue valueWithCATransform3D:t4],
                                      [NSValue valueWithCATransform3D:t5]];
        transformAnimation.beginTime = beginTime;
        transformAnimation.repeatCount = HUGE_VALF;
        transformAnimation.duration = 1.0f;
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [layer addSublayer:circle];
        [circle addAnimation:transformAnimation forKey:@"animation"];
    }
    
    for (int i = 0; i < 2; i++) {
        CALayer *circle = [CALayer layer];
        circle.frame = CGRectMake((layer.bounds.size.width - circleSize * 5) / 2.0f + circleSize + circleSize * 2 * i, (layer.bounds.size.height - circleSize) / 2.0f, circleSize, circleSize);
        circle.backgroundColor = tintColor.CGColor;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.opacity = 1.0f;
        circle.cornerRadius = circle.bounds.size.height / 2.0f;
        
        CATransform3D t1 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t1 = CATransform3DScale(t1, 0.3f, 0.3f, 0.0f);
        
        CATransform3D t2 = CATransform3DMakeTranslation(0.0f, 2 * circleSize, 0.0f);
        t2 = CATransform3DScale(t2, 1.0f, 1.0f, 0.0f);
        
        CATransform3D t3 = CATransform3DMakeTranslation(0.0f, -2 * circleSize, 0.0f);
        t3 = CATransform3DScale(t3, 1.f, 1.0f, 0.0f);
        
        CATransform3D t4 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t4 = CATransform3DScale(t4, 0.3f, 0.3f, 0.0f);
        
        CAKeyframeAnimation *transformAnimation = [self createKeyframeAnimationWithKeyPath:@"transform"];
        transformAnimation.values = @[[NSValue valueWithCATransform3D:t1],
                                      [NSValue valueWithCATransform3D:t2],
                                      [NSValue valueWithCATransform3D:t3],
                                      [NSValue valueWithCATransform3D:t4]];
        transformAnimation.keyTimes = @[@(0.0f), @(0.25f), @(0.75f), @(1.0f)];
        transformAnimation.beginTime = beginTime;
        transformAnimation.repeatCount = HUGE_VALF;
        transformAnimation.duration = 1.0f;
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [layer addSublayer:circle];
        [circle addAnimation:transformAnimation forKey:@"animation"];
    }
}
@end

#pragma mark - LineScale动画
@implementation AxcUI_CtivityIndicatorLineScaleAnimation

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 1.0f;
    NSArray *beginTimes = @[@0.1f, @0.2f, @0.3f, @0.4f, @0.5f];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.2f :0.68f :0.18f :1.08f];
    CGFloat lineSize = size.width / 9;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - size.height) / 2;
    
    // Animation
    CAKeyframeAnimation *animation = [self createKeyframeAnimationWithKeyPath:@"transform.scale.y"];
    
    animation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    animation.values = @[@1.0f, @0.4f, @1.0f];
    animation.timingFunctions = @[timingFunction, timingFunction];
    animation.repeatCount = HUGE_VALF;
    animation.duration = duration;
    
    for (int i = 0; i < 5; i++) {
        CAShapeLayer *line = [CAShapeLayer layer];
        UIBezierPath *linePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, lineSize, size.height) cornerRadius:lineSize / 2];
        
        animation.beginTime = [beginTimes[i] floatValue];
        line.fillColor = tintColor.CGColor;
        line.path = linePath.CGPath;
        [line addAnimation:animation forKey:@"animation"];
        line.frame = CGRectMake(x + lineSize * 2 * i, y, lineSize, size.height);
        [layer addSublayer:line];
    }
}

@end

#pragma mark - LineScaleParty动画
@implementation AxcUI_CtivityIndicatorLineScalePartyAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSArray *durations = @[@1.26f, @0.43f, @1.01f, @0.73f];
    NSArray *beginTimes = @[@0.77f, @0.29f, @0.28f, @0.74f];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CGFloat lineSize = size.width / 7;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - size.height) / 2;
    
    // Animation
    CAKeyframeAnimation *animation = [self createKeyframeAnimationWithKeyPath:@"transform.scale"];
    
    animation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    animation.values = @[@1.0f, @0.5f, @1.0f];
    animation.timingFunctions = @[timingFunction, timingFunction];
    animation.repeatCount = HUGE_VALF;
    
    for (int i = 0; i < 4; i++) {
        CAShapeLayer *line = [CAShapeLayer layer];
        UIBezierPath *linePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, lineSize, size.height) cornerRadius:lineSize / 2];
        
        animation.duration = [durations[i] floatValue];
        animation.beginTime = [beginTimes[i] floatValue];
        line.fillColor = tintColor.CGColor;
        line.path = linePath.CGPath;
        [line addAnimation:animation forKey:@"animation"];
        line.frame = CGRectMake(x + lineSize * 2 * i, y, lineSize, size.height);
        [layer addSublayer:line];
    }
}

@end

#pragma mark - LineScalePulseOut动画
@implementation AxcUI_CtivityIndicatorLineScalePulseOutAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 1.0f;
    NSArray *beginTimes = @[@0.4f, @0.2f, @0.0f, @0.2f, @0.4f];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.85f :0.25f :0.37f :0.85f];
    CGFloat lineSize = size.width / 9;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - size.height) / 2;
    
    // Animation
    CAKeyframeAnimation *animation = [self createKeyframeAnimationWithKeyPath:@"transform.scale.y"];
    
    animation.keyTimes = @[@0.0f, @0.5f, @1.0f];
    animation.values = @[@1.0f, @0.4f, @1.0f];
    animation.timingFunctions = @[timingFunction, timingFunction];
    animation.repeatCount = HUGE_VALF;
    animation.duration = duration;
    for (int i = 0; i < 5; i++) {
        CAShapeLayer *line = [CAShapeLayer layer];
        UIBezierPath *linePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, lineSize, size.height) cornerRadius:lineSize / 2];
        animation.beginTime = [beginTimes[i] floatValue];
        line.fillColor = tintColor.CGColor;
        line.path = linePath.CGPath;
        [line addAnimation:animation forKey:@"animation"];
        line.frame = CGRectMake(x + lineSize * 2 * i, y, lineSize, size.height);
        [layer addSublayer:line];
    }
}
@end

#pragma mark - LineScalePulseOutRapid动画
@implementation AxcUI_CtivityIndicatorLineScalePulseOutRapidAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 0.9f;
    NSArray *beginTimes = @[@0.5f, @0.25f, @0.0f, @0.25f, @0.5f];
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.11f :0.49f :0.38f :0.78f];
    CGFloat lineSize = size.width / 9;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - size.height) / 2;
    // Animation
    CAKeyframeAnimation *animation = [self createKeyframeAnimationWithKeyPath:@"transform.scale.y"];
    animation.keyTimes = @[@0.0f, @0.8f, @0.9f];
    animation.values = @[@1.0f, @0.3f, @1.0f];
    animation.timingFunctions = @[timingFunction, timingFunction];
    animation.repeatCount = HUGE_VALF;
    animation.duration = duration;
    for (int i = 0; i < 5; i++) {
        CAShapeLayer *line = [CAShapeLayer layer];
        UIBezierPath *linePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, lineSize, size.height) cornerRadius:lineSize / 2];
        
        animation.beginTime = [beginTimes[i] floatValue];
        line.fillColor = tintColor.CGColor;
        line.path = linePath.CGPath;
        [line addAnimation:animation forKey:@"animation"];
        line.frame = CGRectMake(x + lineSize * 2 * i, y, lineSize, size.height);
        [layer addSublayer:line];
    }
}
@end

#pragma mark - NineDots动画
@implementation AxcUI_CtivityIndicatorNineDotsAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CGFloat circleSize = size.width / 4.0f;
    CGFloat circlePadding = circleSize / 2.0f;
    
    CGFloat oX = (layer.bounds.size.width - circleSize * 3 - circlePadding * 2) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - circleSize * 3 - circlePadding * 2) / 2.0f;
    
    NSArray *timeOffsets = @[@(0.11f), @(0.42f), @(0.0f),
                             @(0.65f), @(0.48f), @(0.2f),
                             @(0.63f), @(0.95f), @(0.62f)];
    NSArray *durations = @[@(0.72f), @(1.02f), @(1.28f),
                           @(1.42f), @(1.45f), @(1.18f),
                           @(0.87f), @(1.45f), @(1.06f)];
    
    for (int i = 0; i < MIN(timeOffsets.count, durations.count); i++) {
        CALayer *circle = [CALayer layer];
        circle.frame = CGRectMake(oX + (circleSize + circlePadding) * (i % 3), oY + (circleSize + circlePadding) * (int)(i / 3), circleSize, circleSize);
        circle.backgroundColor = tintColor.CGColor;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.opacity = 1.0f;
        circle.cornerRadius = circle.bounds.size.height / 2.0f;
        
        CAKeyframeAnimation *transformAnimation = [self createKeyframeAnimationWithKeyPath:@"transform"];
        transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 0.0f)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 0.0f)]];
        
        CAKeyframeAnimation *opacityAnimation = [self createKeyframeAnimationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@(0.5f), @(1.0f), @(0.5f)];
        
        CAAnimationGroup *animationGroup = [self createAnimationGroup];;
        animationGroup.beginTime = beginTime;
        animationGroup.repeatCount = HUGE_VALF;
        animationGroup.duration = [durations[i] doubleValue];
        animationGroup.animations = @[transformAnimation, opacityAnimation];
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animationGroup.timeOffset = [timeOffsets[i] doubleValue];
        
        [layer addSublayer:circle];
        [circle addAnimation:animationGroup forKey:@"animation"];
    }
}
@end

#pragma mark - RotatingSandglass动画
@implementation AxcUI_CtivityIndicatorRotatingSandglassAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CGFloat circleSize = size.width / 4.0f;;
    CGFloat oX = (layer.bounds.size.width - size.width) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - size.width) / 2.0f;
    
    for (int i = 0; i < 2; i++) {
        CALayer *circle = [CALayer layer];
        circle.frame = CGRectMake(oX + i * (size.width - 2.0f * circleSize), (size.height - circleSize) * i + oY, circleSize, circleSize);
        circle.cornerRadius = circle.bounds.size.height / 2.0f;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        circle.backgroundColor = tintColor.CGColor;
        circle.shouldRasterize = YES;
        circle.rasterizationScale = [[UIScreen mainScreen] scale];
        
        CAKeyframeAnimation *transformAnimation = [self createKeyframeAnimationWithKeyPath:@"transform"];
        transformAnimation.repeatCount = HUGE_VALF;
        transformAnimation.duration = 0.8f;
        transformAnimation.beginTime = beginTime;
        transformAnimation.keyTimes = @[@(0.0f), @(1.0f / 3.0f), @(2.0f / 3.0f), @(1.0)];
        
        transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        
        CATransform3D t1 = CATransform3DMakeTranslation((1.0f - 2.0f * i) * (size.width - 2.0f * circleSize), 0.0f, 0.0f);
        
        CATransform3D t2 = CATransform3DMakeTranslation((1.0f - 2.0f * i) * (size.width - 2.0f * circleSize) / 2.0f, (1.0f - 2.0f * i) * (size.height - circleSize) / 2.0f, 0.0f);
        
        CATransform3D t3 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        
        
        transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                      [NSValue valueWithCATransform3D:t1],
                                      [NSValue valueWithCATransform3D:t2],
                                      [NSValue valueWithCATransform3D:t3]];
        
        [layer addSublayer:circle];
        [circle addAnimation:transformAnimation forKey:@"animation"];
    }
}
@end

#pragma mark - RotatingSquares动画
static CGFloat degreesToRadians(CGFloat degrees) { return (degrees) / 180.0 * M_PI; };

@implementation AxcUI_CtivityIndicatorRotatingSquaresAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CGFloat squareSize = floor(size.width / 4.0f);
    
    CGFloat oX = (layer.bounds.size.width - size.width) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - size.height) / 2.0f;
    for (int i = 0; i < 2; i++) {
        CALayer *square = [CALayer layer];
        square.frame = CGRectMake(oX, oY, squareSize, squareSize);
        square.anchorPoint = CGPointMake(0.5f, 0.5f);
        square.backgroundColor = tintColor.CGColor;
        square.shouldRasterize = YES;
        square.rasterizationScale = [[UIScreen mainScreen] scale];
        
        CAKeyframeAnimation *transformAnimation = [self createKeyframeAnimationWithKeyPath:@"transform"];
        transformAnimation.duration = 1.6f;
        transformAnimation.beginTime = beginTime - (i * transformAnimation.duration / 2.0f);
        transformAnimation.repeatCount = HUGE_VALF;
        
        transformAnimation.keyTimes = @[@(0.0f), @(0.25f), @(0.50f), @(0.75f), @(1.0f)];
        transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        CATransform3D t1 = CATransform3DMakeTranslation(size.width - squareSize, 0.0f, 0.0f);
        t1 = CATransform3DRotate(t1, degreesToRadians(-90.0f), 0.0f, 0.0f, 1.0f);
        t1 = CATransform3DScale(t1, 0.5f, 0.5f, 1.0f);
        
        CATransform3D t2 = CATransform3DMakeTranslation(size.width - squareSize, size.height - squareSize, 0.0f);
        t2 = CATransform3DRotate(t2, degreesToRadians(-180.0f), 0.0f, 0.0f, 1.0f);
        t2 = CATransform3DScale(t2, 1.0, 1.0, 1.0f);
        
        CATransform3D t3 = CATransform3DMakeTranslation(0.0f, size.height - squareSize, 0.0f);
        t3 = CATransform3DRotate(t3, degreesToRadians(-270.0f), 0.0f, 0.0f, 1.0f);
        t3 = CATransform3DScale(t3, 0.5f, 0.5f, 1.0f);
        
        CATransform3D t4 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t4 = CATransform3DRotate(t4, degreesToRadians(-360.0f), 0.0f, 0.0f, 1.0f);
        t4 = CATransform3DScale(t4, 1.0, 1.0, 1.0f);
        
        transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                      [NSValue valueWithCATransform3D:t1],
                                      [NSValue valueWithCATransform3D:t2],
                                      [NSValue valueWithCATransform3D:t3],
                                      [NSValue valueWithCATransform3D:t4]];
        
        [layer addSublayer:square];
        [square addAnimation:transformAnimation forKey:@"animation"];
    }
}
@end

#pragma mark - RotatingTrigon动画
@implementation AxcUI_CtivityIndicatorRotatingTrigonAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CGFloat circleSize = size.width / 4.0f;;
    CGFloat oX = (layer.bounds.size.width - size.width) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - size.width) / 2.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circleSize, circleSize)];
    CGPoint pointA = CGPointMake(oX + size.width / 2.0f, oY + circleSize / 2.0f);
    CGPoint pointB = CGPointMake(oX + circleSize / 2.0f, oY + circleSize / 2.0f + sqrtf(powf((size.width - circleSize), 2) - powf((size.width / 2.0f - circleSize / 2.0f), 2)));
    CGPoint pointC = CGPointMake(oX + size.width - circleSize / 2.0f, pointB.y);
    
    for (int i = 0; i < 3; i++) {
        CAShapeLayer *circle = [CAShapeLayer layer];
        circle.path = path.CGPath;
        circle.fillColor = [UIColor clearColor].CGColor;
        circle.strokeColor = tintColor.CGColor;
        circle.bounds = CGRectMake(0, 0, circleSize, circleSize);
        circle.position = pointA;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        circle.shouldRasterize = YES;
        circle.rasterizationScale = [[UIScreen mainScreen] scale];
        
        CAKeyframeAnimation *transformAnimation = [self createKeyframeAnimationWithKeyPath:@"transform"];
        transformAnimation.repeatCount = HUGE_VALF;
        transformAnimation.duration = 2.0f;
        transformAnimation.beginTime = beginTime - (i * transformAnimation.duration / 3.0f);;
        transformAnimation.keyTimes = @[@(0.0f), @(1.0f / 3.0f), @(2.0f / 3.0f), @(1.0)];
        
        transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        CATransform3D t1 = CATransform3DMakeTranslation(pointB.x - pointA.x, pointB.y - pointA.y, 0.0f);
        
        CATransform3D t2 = CATransform3DMakeTranslation(pointC.x - pointA.x, pointC.y - pointA.y, 0.0f);
        
        CATransform3D t3 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        
        transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                      [NSValue valueWithCATransform3D:t1],
                                      [NSValue valueWithCATransform3D:t2],
                                      [NSValue valueWithCATransform3D:t3]];
        
        [layer addSublayer:circle];
        [circle addAnimation:transformAnimation forKey:@"animation"];
    }
}
@end

#pragma mark - ThreeDots动画
@implementation AxcUI_CtivityIndicatorThreeDotsAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSTimeInterval beginTime = CACurrentMediaTime();
    NSTimeInterval duration = 0.5f;
    
    CGFloat circleSize = size.width / 4.0f;
    CGFloat circlePadding = circleSize / 2.0f;
    
    CGFloat oX = (layer.bounds.size.width - circleSize * 3 - circlePadding * 2) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - circleSize * 1) / 2.0f;
    
    for (int i = 0; i < 3; i++) {
        CALayer *circle = [CALayer layer];
        
        circle.frame = CGRectMake(oX + (circleSize + circlePadding) * (i % 3), oY, circleSize, circleSize);
        circle.backgroundColor = tintColor.CGColor;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.opacity = 1.0f;
        circle.cornerRadius = circle.bounds.size.width / 2.0f;
        
        CAKeyframeAnimation *tranformAnimation = [self createKeyframeAnimationWithKeyPath:@"transform"];
        
        tranformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 0.0f)],
                                     [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)]];
        
        CAKeyframeAnimation *opacityAnimation = [self createKeyframeAnimationWithKeyPath:@"opacity"];
        
        opacityAnimation.values = @[@(0.25f), @(1.0f)];
        
        CAAnimationGroup *animationGroup = [self createAnimationGroup];;
        
        animationGroup.autoreverses = YES;
        animationGroup.beginTime = beginTime;
        animationGroup.repeatCount = HUGE_VALF;
        animationGroup.duration = duration;
        animationGroup.animations = @[tranformAnimation, opacityAnimation];
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [layer addSublayer:circle];
        [circle addAnimation:animationGroup forKey:@"animation"];
    }
}

@end

#pragma mark - TriangleSkewSpin动画
@implementation AxcUI_CtivityIndicatorTriangleSkewSpinAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    CGFloat duration = 3.0f;
    CGFloat x = (layer.bounds.size.width - size.width) / 2;
    CGFloat y = (layer.bounds.size.height - size.height) / 2;
    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.09f :0.57f :0.49f :0.9f];
    
    // Rotation x animation
    CAKeyframeAnimation *rotationXAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.rotation.x"];
    
    rotationXAnimation.duration = duration;
    rotationXAnimation.keyTimes = @[@0.0f, @0.25f, @0.5f, @0.75f, @1.0f];
    rotationXAnimation.values = @[@0.0f, @M_PI, @M_PI, @0.0f, @0.0f];
    rotationXAnimation.timingFunctions = @[timingFunction, timingFunction, timingFunction, timingFunction];
    
    // Rotation x animation
    CAKeyframeAnimation *rotationYAnimation = [self createKeyframeAnimationWithKeyPath:@"transform.rotation.y"];
    
    rotationYAnimation.duration = duration;
    rotationYAnimation.keyTimes = @[@0.0f, @0.25f, @0.5f, @0.75f, @1.0f];
    rotationYAnimation.values = @[@0.0f, @0.0f, @M_PI, @M_PI, @0.0f];
    rotationYAnimation.timingFunctions = @[timingFunction, timingFunction, timingFunction, timingFunction];
    
    // Animation
    CAAnimationGroup *animation = [self createAnimationGroup];;
    
    animation.animations = @[rotationXAnimation, rotationYAnimation];
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    
    // Draw triangle
    CAShapeLayer *triangle = [CAShapeLayer layer];
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    CGFloat offsetY = size.height / 4;
    
    [trianglePath  moveToPoint:CGPointMake(0, size.height - offsetY)];
    [trianglePath addLineToPoint:CGPointMake(size.width / 2, size.height / 2 - offsetY)];
    [trianglePath addLineToPoint:CGPointMake(size.width, size.height - offsetY)];
    [trianglePath closePath];
    triangle.fillColor = tintColor.CGColor;
    triangle.path = trianglePath.CGPath;
    [triangle addAnimation:animation forKey:@"animation"];
    triangle.frame = CGRectMake(x, y, size.width, size.height);
    [layer addSublayer:triangle];
}
@end

#pragma mark - TriplePulse动画
@implementation AxcUI_CtivityIndicatorTriplePulseAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CGFloat oX = (layer.bounds.size.width - size.width) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - size.height) / 2.0f;
    for (int i = 0; i < 4; i++) {
        CALayer *circle = [CALayer layer];
        circle.frame = CGRectMake(oX, oY, size.width, size.height);
        circle.backgroundColor = tintColor.CGColor;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.opacity = 0.8f;
        circle.cornerRadius = circle.bounds.size.height / 2.0f;
        circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        
        CABasicAnimation *transformAnimation = [self createBasicAnimationWithKeyPath:@"transform"];
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)];
        
        CABasicAnimation *opacityAnimation = [self createBasicAnimationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @(0.8f);
        opacityAnimation.toValue = @(0.0f);
        
        CAAnimationGroup *animationGroup = [self createAnimationGroup];;
        animationGroup.beginTime = beginTime + i * 0.2f;
        animationGroup.repeatCount = HUGE_VALF;
        animationGroup.duration = 1.2f;
        animationGroup.animations = @[transformAnimation, opacityAnimation];
        
        [layer addSublayer:circle];
        [circle addAnimation:animationGroup forKey:@"animation"];
    }
}
@end

#pragma mark - TripleRings动画
@implementation AxcUI_CtivityIndicatorTripleRingsAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0f, 0.0f, size.width, size.width)];
    CGFloat oX = (layer.bounds.size.width - size.width) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - size.height) / 2.0f;
    for (int i = 0; i < 3; i++) {
        CAShapeLayer *circle = [CAShapeLayer layer];
        circle.path = path.CGPath;
        circle.fillColor = [UIColor clearColor].CGColor;
        circle.strokeColor = tintColor.CGColor;
        circle.frame = CGRectMake(oX, oY, size.width, size.height);
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.opacity = 1.0f;
        circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        
        CABasicAnimation *transformAnimation = [self createBasicAnimationWithKeyPath:@"transform"];
        transformAnimation.duration = 2.0f - i * 0.4f;
        transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1f, 0.1f, 0.0f)];
        transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)];
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        
        CABasicAnimation *opacityAnimation = [self createBasicAnimationWithKeyPath:@"opacity"];
        opacityAnimation.duration = transformAnimation.duration;
        opacityAnimation.fromValue = @(1.0f);
        opacityAnimation.toValue = @(0.8f);
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        
        CAAnimationGroup *animationGroup = [self createAnimationGroup];;
        animationGroup.beginTime = beginTime + i * 0.4f;
        animationGroup.repeatCount = HUGE_VALF;
        animationGroup.duration = 2.0f;
        animationGroup.animations = @[transformAnimation, opacityAnimation];
        
        [layer addSublayer:circle];
        [circle addAnimation:animationGroup forKey:@"animation"];
    }
}
@end

#pragma mark - TwoDots动画
@implementation AxcUI_CtivityIndicatorTwoDotsAnimation
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSTimeInterval beginTime = CACurrentMediaTime();
    
    CGFloat circleSize = size.width * 0.92f;
    CGFloat oX = (layer.bounds.size.width - size.width) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - circleSize) / 2.0f;
    for (int i = 0; i < 2; i++) {
        CALayer *circle = [CALayer layer];
        CGFloat offset = circleSize / 2.0f * i;
        circle.frame = CGRectMake((offset + size.width - circleSize) * i + oX, oY, circleSize, circleSize);
        circle.cornerRadius = circle.bounds.size.height / 2.0f;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.transform = CATransform3DMakeScale(0.0f, 0.0f, 0.0f);
        circle.backgroundColor = tintColor.CGColor;
        
        CAKeyframeAnimation *transformAnimation = [self createKeyframeAnimationWithKeyPath:@"transform"];
        transformAnimation.repeatCount = HUGE_VALF;
        transformAnimation.duration = 1.8f;
        transformAnimation.beginTime = beginTime - (transformAnimation.duration / 2.0f * i);
        transformAnimation.keyTimes = @[@(0.0), @(0.5), @(1.0)];
        
        transformAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        transformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 0.0f)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0f, 0.0f, 0.0f)]];
        
        [layer addSublayer:circle];
        [circle addAnimation:transformAnimation forKey:@"animation"];
    }
}
@end


