//
//  AxcUI_UserInteractionControl.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/25.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_UserInteractionControl.h"

@interface AxcUI_UserInteractionControl (){
    CAShapeLayer *_topLayer;
    CAShapeLayer *_middleLayer;
    CAShapeLayer *_bottomLayer;
}

@end


// 常数为动画和形状
static CGFloat AxcScaleForArrow = 0.7;
static NSString *AxcAnimationKey = @"AxcAnimationKey";
static CGFloat AxcFrameRate = 1.0/30.0;
static CGFloat AxcAnimationFrames = 10.0;

@interface AxcUI_UserInteractionControl ()
@property (nonatomic, assign) BOOL needsToUpdateAppearance;
@end

@implementation AxcUI_UserInteractionControl

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self commonInit];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self commonInit];
    return self;
}

// 默认配置
- (void)commonInit{
    self.axcUI_lineColor = [UIColor whiteColor];
    self.axcUI_lineHeight = 2.0;
    self.axcUI_lineSpacing = 8.0;
    self.axcUI_lineWidth = 30.0;
    self.axcUI_lineCap = AxcUserInteractionControlaxcUI_lineCapRound;
    self.axcUI_currentState = AxcUserInteractionControlStyleAdd;
    [self updateAppearance];
}

#pragma mark - Setter

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.needsToUpdateAppearance = YES;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.needsToUpdateAppearance = YES;
}

- (void)setAxcUI_lineCap:(AxcUserInteractionControlaxcUI_lineCap)axcUI_lineCap
{
    _axcUI_lineCap = axcUI_lineCap;
    self.needsToUpdateAppearance = YES;
}

- (void)setAxcUI_lineColor:(UIColor *)axcUI_lineColor
{
    _axcUI_lineColor = axcUI_lineColor;
    self.needsToUpdateAppearance = YES;
}

- (void)setAxcUI_lineHeight:(CGFloat)axcUI_lineHeight
{
    _axcUI_lineHeight = axcUI_lineHeight;
    self.needsToUpdateAppearance = YES;
}

- (void)setAxcUI_lineWidth:(CGFloat)axcUI_lineWidth
{
    _axcUI_lineWidth = axcUI_lineWidth;
    self.needsToUpdateAppearance = YES;
}

- (void)setAxcUI_lineSpacing:(CGFloat)axcUI_lineSpacing{
    _axcUI_lineSpacing = axcUI_lineSpacing;
    self.needsToUpdateAppearance = YES;
}

- (void)setAxcUI_currentState:(AxcUserInteractionControlStyle)axcUI_currentState{
    _axcUI_currentState = axcUI_currentState;
    [self transformToState:axcUI_currentState];
}

- (void)setNeedsToUpdateAppearance:(BOOL)needsToUpdateAppearance
{
    _needsToUpdateAppearance = needsToUpdateAppearance;
    
    if (_needsToUpdateAppearance) {
        [self setNeedsDisplay];
    }
}

#pragma mark - 动画&更新外观
- (void)drawRect:(CGRect)rect{
    if (self.needsToUpdateAppearance) {
        [self updateAppearance];
    }
    
    [super drawRect:rect];
}

#pragma mark - 更新

- (void)updateAppearance{
    self.needsToUpdateAppearance = NO;
    [_topLayer removeFromSuperlayer];
    [_middleLayer removeFromSuperlayer];
    [_bottomLayer removeFromSuperlayer];
    
    CGFloat x = CGRectGetWidth(self.bounds) / 2.0;
    CGFloat heightDiff = self.axcUI_lineHeight + self.axcUI_lineSpacing;
    CGFloat y = CGRectGetHeight(self.bounds) / 2.0 - heightDiff;
    
    _topLayer = [self createLayer];
    _topLayer.position = CGPointMake(x , y);
    y += heightDiff;
    
    _middleLayer = [self createLayer];
    _middleLayer.position = CGPointMake(x , y);
    y += heightDiff;
    
    _bottomLayer = [self createLayer];
    _bottomLayer.position = CGPointMake(x , y);
    [self transformToState:_axcUI_currentState];
}

#pragma mark - 改变 AxcUserInteractionControlStyle

- (void)transformToState:(AxcUserInteractionControlStyle)state{
    CATransform3D transform;
    switch (state) {
        case AxcUserInteractionControlStyleLeftArrow:{
            _topLayer.transform = [self arrowLineTransform:_topLayer];
            _middleLayer.transform = [self arrowLineTransform:_middleLayer];
            _bottomLayer.transform = [self arrowLineTransform:_bottomLayer];
        }break;
            
        case AxcUserInteractionControlStyleRightArrow:{
            _topLayer.transform = [self arrowLineTransform:_topLayer];
            _middleLayer.transform = [self arrowLineTransform:_middleLayer];
            _bottomLayer.transform = [self arrowLineTransform:_bottomLayer];
        }break;
        case AxcUserInteractionControlStyleCross:{
            transform = CATransform3DMakeTranslation(0.0, _middleLayer.position.y-_topLayer.position.y, 0.0);
            _topLayer.transform = CATransform3DRotate(transform, M_PI_4, 0.0, 0.0, 1.0);
            _middleLayer.transform = CATransform3DMakeScale(0., 0., 0.);
            transform = CATransform3DMakeTranslation(0.0, _middleLayer.position.y-_bottomLayer.position.y, 0.0);
            _bottomLayer.transform = CATransform3DRotate(transform, -M_PI_4, 0.0, 0.0, 1.0);
        }break;
        case AxcUserInteractionControlStyleMinusSign:{
            _topLayer.transform = CATransform3DMakeTranslation(0.0, _middleLayer.position.y-_topLayer.position.y, 0.0);
            _middleLayer.transform = CATransform3DMakeScale(0., 0., 0.);
            _bottomLayer.transform = CATransform3DMakeScale(0., 0., 0.);
        }break;
        case AxcUserInteractionControlStyleAdd:{
            transform = CATransform3DMakeTranslation(0.0, _middleLayer.position.y-_topLayer.position.y, 0.0);
            _topLayer.transform = transform;
            _middleLayer.transform = CATransform3DMakeScale(0., 0., 0.);
            transform = CATransform3DMakeTranslation(0.0, _middleLayer.position.y-_bottomLayer.position.y, 0.0);
            _bottomLayer.transform = CATransform3DRotate(transform, -M_PI_2, 0.0, 0.0, 1.0);
        }break;
        default:{
            // 默认 state is menu
            _topLayer.transform = CATransform3DIdentity;
            _middleLayer.transform = CATransform3DIdentity;
            _bottomLayer.transform = CATransform3DIdentity;
        }break;
    }
    _axcUI_currentState = state;
}


- (CATransform3D)arrowLineTransform:(CALayer *)line{
    CATransform3D transform;
    if (line == _middleLayer) {
        CGFloat middleLineXScale = self.axcUI_lineHeight/self.axcUI_lineWidth;
        transform = CATransform3DMakeScale(1.0 - middleLineXScale, 1.0, 1.0);
        transform = CATransform3DTranslate(transform, self.axcUI_lineWidth*middleLineXScale/2.0, 0.0, 0.0);
        return transform;
    }
    CGFloat lineMult = line == _topLayer ? 1.0 : -1.0;
    CGFloat yShift = 0.0;
    //    if (self.axcUI_lineCap == AxcUserInteractionControlaxcUI_lineCapButt) {
    //        yShift = sqrt(2)*self.axcUI_lineHeight/4.;
    //    }
    CGFloat lineShift = self.axcUI_lineWidth * (1.-AxcScaleForArrow)/2.;
    CGFloat LineX  = -lineShift;
    if (self.axcUI_currentState == AxcUserInteractionControlStyleRightArrow) {
        LineX = (self.axcUI_lineWidth - lineShift);
        lineMult = line == _topLayer ? -3.0 : 3.0;
    }
    transform = CATransform3DMakeTranslation(LineX, _middleLayer.position.y-line.position.y + yShift * lineMult, 0.0);
    CGFloat xTransform = self.axcUI_lineWidth/2. - lineShift;
    transform = CATransform3DTranslate(transform, -xTransform, 0 , 0.0);
    transform = CATransform3DRotate(transform, M_PI_4 * lineMult, 0.0, 0.0, -1.0);
    transform = CATransform3DTranslate(transform, xTransform, 0, 0.0);
    transform = CATransform3DScale(transform, AxcScaleForArrow, 1., 1.);
    return transform;
}

- (void)AxcUI_animationTransformToState:(AxcUserInteractionControlStyle)state
{
    if (_axcUI_currentState == state) {
        return;
    }
    BOOL findAnimationForTransition = NO;
    switch (_axcUI_currentState) {
        case AxcUserInteractionControlStyleLeftArrow:{
            if (state == AxcUserInteractionControlStyleMenu) {
                findAnimationForTransition = YES;
                [self animationTransitionFromMenuToArrow:YES];
            }
        }break;
        case AxcUserInteractionControlStyleCross:{
            if (state == AxcUserInteractionControlStyleMenu) {
                findAnimationForTransition = YES;
                [self animationTransitionFromMenuToCross:YES];
            } else if (state == AxcUserInteractionControlStyleAdd) {
                findAnimationForTransition = YES;
                [self animationTransitionFromCrossToPlus:NO];
            }
        }break;
        case AxcUserInteractionControlStyleMinusSign:{
            if (state == AxcUserInteractionControlStyleAdd) {
                findAnimationForTransition = YES;
                [self animationTransitionFromPLusToMinus:YES];
            }
        }break;
        case AxcUserInteractionControlStyleAdd:{
            if (state == AxcUserInteractionControlStyleCross) {
                findAnimationForTransition = YES;
                [self animationTransitionFromCrossToPlus:YES];
            } if (state == AxcUserInteractionControlStyleMinusSign) {
                findAnimationForTransition = YES;
                [self animationTransitionFromPLusToMinus:NO];
            }
        }break;
        default:{
            // 默认 state is menu
            if (state == AxcUserInteractionControlStyleLeftArrow) {
                findAnimationForTransition = YES;
                [self animationTransitionFromMenuToArrow:NO];
            } else if (state == AxcUserInteractionControlStyleCross) {
                findAnimationForTransition = YES;
                [self animationTransitionFromMenuToCross:NO];
            }
        }break;
    }
    if (!findAnimationForTransition) {
        NSLog(@"未找到相应动画展示！请核对Api进行入参");
        [self transformToState:state];
    } else {
        _axcUI_currentState = state;
    }
}

#pragma mark - 三道杠和箭头

- (void)animationTransitionFromMenuToArrow:(BOOL)reverse{
    NSArray *times = @[@(0.0), @(0.5), @(0.5), @(1.0)];
    
    NSArray *values = [self fromMenuToArrowAnimationValues:_topLayer
                                                   reverse:reverse];
    CAKeyframeAnimation *topAnimation = [self createKeyFrameAnimation];
    topAnimation.keyTimes = times;
    topAnimation.values = values;
    
    values = [self fromMenuToArrowAnimationValues:_bottomLayer
                                          reverse:reverse];
    CAKeyframeAnimation *bottomAnimation = [self createKeyFrameAnimation];
    bottomAnimation.keyTimes = times;
    bottomAnimation.values = values;
    
    CATransform3D middleTransform = [self arrowLineTransform:_middleLayer];
    values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
               [NSValue valueWithCATransform3D:CATransform3DIdentity],
               [NSValue valueWithCATransform3D:middleTransform],
               [NSValue valueWithCATransform3D:middleTransform]];
    if (reverse) {
        values = [[[values reverseObjectEnumerator] allObjects] mutableCopy];
    }
    times = @[@(0.0),@(0.4), @(0.4), @(1.0)];
    CAKeyframeAnimation *middleAnimation = [self createKeyFrameAnimation];
    middleAnimation.keyTimes = times;
    middleAnimation.values = values;
    [_middleLayer addAnimation:middleAnimation forKey:AxcAnimationKey];
    [_topLayer addAnimation:topAnimation forKey:AxcAnimationKey];
    [_bottomLayer addAnimation:bottomAnimation forKey:AxcAnimationKey];
}

- (NSArray *)fromMenuToArrowAnimationValues:(CALayer *)line
                                    reverse:(BOOL)reverse
{
    NSMutableArray *values = [NSMutableArray array];
    
    CGFloat lineMult = line == _topLayer ? 1.0 : -1.0;
    CGFloat yTransform = _middleLayer.position.y-line.position.y;
    CGFloat yShift = 0.0;
    //    if (self.axcUI_lineCap == AxcUserInteractionControlaxcUI_lineCapButt) {
    //        yShift = sqrt(2.0)*self.axcUI_lineHeight/4.0;
    //    }
    
    CATransform3D transform = CATransform3DIdentity;
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    
    CGFloat lineShift = self.axcUI_lineWidth * (1.0-AxcScaleForArrow)/2.0;
    transform = CATransform3DTranslate(transform, 0.0, yTransform, 0.0);
    
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    
    CATransform3D scaleTransform = CATransform3DScale(transform, AxcScaleForArrow, 1.0, 1.0);
    scaleTransform = CATransform3DTranslate(scaleTransform, -lineShift, 0.0, 0.0);
    
    [values addObject:[NSValue valueWithCATransform3D:scaleTransform]];
    
    transform = CATransform3DTranslate(transform, -lineShift, 0.0, 0.0);
    CGFloat xTransform = self.axcUI_lineWidth/2.0 - lineShift;
    
    transform = CATransform3DTranslate(transform, -xTransform, 0.0, 0.0);
    transform = CATransform3DRotate(transform, M_PI_4*lineMult, 0.0, 0.0, -1.0);
    transform = CATransform3DTranslate(transform, xTransform, 0.0, 0.0);
    
    transform = CATransform3DScale(transform, AxcScaleForArrow, 1.0, 1.0);
    transform = CATransform3DTranslate(transform, 0.0, yShift*lineMult, 0.0);
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    
    if (reverse) {
        values = [[[values reverseObjectEnumerator] allObjects] mutableCopy];
    }
    return values;
}

#pragma mark - 叉子

- (void)animationTransitionFromMenuToCross:(BOOL)reverse
{
    NSArray *times = @[@(0.0), @(0.5), @(1.0)];
    
    NSArray *values = [self fromMenuToCrossAnimationValues:_topLayer
                                                   reverse:reverse];
    CAKeyframeAnimation *topAnimation = [self createKeyFrameAnimation];
    topAnimation.keyTimes = times;
    topAnimation.values = values;
    
    values = [self fromMenuToCrossAnimationValues:_bottomLayer
                                          reverse:reverse];
    CAKeyframeAnimation *bottomAnimation = [self createKeyFrameAnimation];
    bottomAnimation.keyTimes = times;
    bottomAnimation.values = values;
    
    CATransform3D middleTransform = CATransform3DMakeScale(0., 0., 0.);
    values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
               [NSValue valueWithCATransform3D:CATransform3DIdentity],
               [NSValue valueWithCATransform3D:middleTransform],
               [NSValue valueWithCATransform3D:middleTransform]];
    if (reverse) {
        values = [[[values reverseObjectEnumerator] allObjects] mutableCopy];
    }
    times = @[@(0.0), @(0.5), @(0.5), @(1.0)];
    CAKeyframeAnimation *middleAnimation = [self createKeyFrameAnimation];
    middleAnimation.keyTimes = times;
    middleAnimation.values = values;
    [_middleLayer addAnimation:middleAnimation forKey:AxcAnimationKey];
    [_topLayer addAnimation:topAnimation forKey:AxcAnimationKey];
    [_bottomLayer addAnimation:bottomAnimation forKey:AxcAnimationKey];
}

- (NSArray *)fromMenuToCrossAnimationValues:(CALayer *)line
                                    reverse:(BOOL)reverse
{
    NSMutableArray *values = [NSMutableArray array];
    CGFloat lineMult = line == _topLayer ? 1.0 : -1.0;
    CGFloat yTransform = _middleLayer.position.y-line.position.y;
    
    CATransform3D transform = CATransform3DIdentity;
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    transform = CATransform3DTranslate(transform, 0, yTransform, 0.0);
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    
    transform = CATransform3DRotate(transform, M_PI_4*lineMult, 0.0, 0.0, 1.0);
    [values addObject:[NSValue valueWithCATransform3D:transform]];
    if (reverse) {
        values = [[[values reverseObjectEnumerator] allObjects] mutableCopy];
    }
    return values;
}

#pragma mark - 加号

- (void)animationTransitionFromCrossToPlus:(BOOL)reverse
{
    NSArray *times = @[@(0.0), @(1.0)];
    if (reverse) {
        times = @[@(1.0), @(0.0)];
    }
    CATransform3D transform = _topLayer.transform;
    NSArray *values = @[[NSValue valueWithCATransform3D:transform],
                        [NSValue valueWithCATransform3D:CATransform3DRotate(transform, M_PI_2 + M_PI_4, 0.0, 0.0, 1.0)]];
    CAKeyframeAnimation *topAnimation = [self createKeyFrameAnimation];
    topAnimation.keyTimes = times;
    topAnimation.values = values;
    
    transform = _bottomLayer.transform;
    values = @[[NSValue valueWithCATransform3D:transform],
               [NSValue valueWithCATransform3D:CATransform3DRotate(transform, M_PI_2 + M_PI_4, 0.0, 0.0, 1.0)]];
    CAKeyframeAnimation *bottomAnimation = [self createKeyFrameAnimation];
    bottomAnimation.keyTimes = times;
    bottomAnimation.values = values;
    
    [_topLayer addAnimation:topAnimation forKey:AxcAnimationKey];
    [_bottomLayer addAnimation:bottomAnimation forKey:AxcAnimationKey];
}

#pragma mark - 负号

- (void)animationTransitionFromPLusToMinus:(BOOL)reverse
{
    NSArray *times = @[@(0.0), @(1.0)];
    if (reverse) {
        times = @[@(1.0), @(0.0)];
    }
    CATransform3D transform = _topLayer.transform;
    NSArray *values = @[[NSValue valueWithCATransform3D:transform],
                        [NSValue valueWithCATransform3D:CATransform3DRotate(transform, -M_PI, 0.0, 0.0, 1.0)]];
    CAKeyframeAnimation *topAnimation = [self createKeyFrameAnimation];
    topAnimation.keyTimes = times;
    topAnimation.values = values;
    
    transform = _bottomLayer.transform;
    values = @[[NSValue valueWithCATransform3D:transform],
               [NSValue valueWithCATransform3D:CATransform3DRotate(transform, -M_PI_2, 0.0, 0.0, 1.0)]];
    CAKeyframeAnimation *bottomAnimation = [self createKeyFrameAnimation];
    bottomAnimation.keyTimes = times;
    bottomAnimation.values = values;
    
    [_topLayer addAnimation:topAnimation forKey:AxcAnimationKey];
    [_bottomLayer addAnimation:bottomAnimation forKey:AxcAnimationKey];
}

#pragma mark - 复用函数

- (CAShapeLayer *)createLayer
{
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.axcUI_lineWidth, 0)];
    
    layer.path = path.CGPath;
    layer.lineWidth = self.axcUI_lineHeight;
    layer.strokeColor = self.axcUI_lineColor.CGColor;
    layer.lineCap = [self axcUI_lineCapString:self.axcUI_lineCap];
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path,
                                                     nil,
                                                     layer.lineWidth,
                                                     kCGLineCapButt,
                                                     kCGLineJoinMiter,
                                                     layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    [self.layer addSublayer:layer];
    
    return layer;
}

- (CAKeyframeAnimation *)createKeyFrameAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = AxcFrameRate * AxcAnimationFrames;
    animation.removedOnCompletion = NO; // 保持变化
    animation.fillMode = kCAFillModeForwards; // 保持变化
    // 自定义时间函数让看起来平滑
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.60 :0.00 :0.40 :1.00];
    
    return animation;
}

- (NSString *)axcUI_lineCapString:(AxcUserInteractionControlaxcUI_lineCap)axcUI_lineCap{
    switch (axcUI_lineCap) {
        case AxcUserInteractionControlaxcUI_lineCapRound:
            return @"round";
        case AxcUserInteractionControlaxcUI_lineCapSquare:
            return @"square";
        default: // 此Butt的Api枚举已废弃
            return @"butt";
    }
}

@end
