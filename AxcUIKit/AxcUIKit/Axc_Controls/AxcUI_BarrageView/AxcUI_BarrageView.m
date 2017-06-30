//
//  AxcUI_BarrageView.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/30.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_BarrageView.h"

#import "UIView+AxcAutoresizingMask.h"

@interface AxcUI_BarrageView ()<CAAnimationDelegate>
{
    BOOL    _stoped;
    UIView *_contentView;
}
@property (nonatomic, strong) UIView *animationView;
@end

@implementation AxcUI_BarrageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self InitializeDefaultParameters];
    }
    return self;
}

- (instancetype)init{
    if (self == [super init]) {
        [self InitializeDefaultParameters];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        [self InitializeDefaultParameters];
    }
    return self;
}

- (void)InitializeDefaultParameters{
    self.axcUI_barrageSpeed               = 1.f;
    self.axcUI_barrageMarqueeDirection    = AxcBarrageMovementStyleRightFromLeft;
    self.layer.masksToBounds = YES;
    self.axcUI_barrageCycle = YES;
}

- (void)AxcUI_addContentView:(UIView *)view {
    [_contentView removeFromSuperview];
    view.frame               = view.bounds;
    _contentView             = view;
    self.animationView.frame = view.bounds;
    [self.animationView addSubview:_contentView];
}

- (void)setAxcUI_barrageSpeed:(CGFloat)axcUI_barrageSpeed{
    if (_axcUI_barrageSpeed != axcUI_barrageSpeed) {
        _axcUI_barrageSpeed = axcUI_barrageSpeed;
        [self AxcUI_startAnimation];
    }
}

- (void)setAxcUI_barrageMarqueeDirection:(AxcBarrageMovementStyle)axcUI_barrageMarqueeDirection{
    if (_axcUI_barrageMarqueeDirection != axcUI_barrageMarqueeDirection) {
        _axcUI_barrageMarqueeDirection = axcUI_barrageMarqueeDirection;
        [self AxcUI_startAnimation];
    }
}

//MARK: 开始
- (void)AxcUI_startAnimation {
    CGFloat animationViewWidth  = self.animationView.frame.size.width;
    CGFloat animationViewHeight = self.animationView.frame.size.height;
    
    [self.animationView.layer removeAnimationForKey:@"animationViewPosition"];
    _stoped = NO;
    
    CGPoint pointRightCenter = CGPointMake(self.frame.size.width + animationViewWidth / 2.f,
                                           animationViewHeight / 2.f);
    CGPoint pointLeftCenter  = CGPointMake(-animationViewWidth / 2, animationViewHeight / 2.f);
    
    CGPoint pointBottomCenter  = CGPointMake(animationViewWidth / 2, animationViewHeight *2);
    CGPoint pointTopCenter  = CGPointMake(animationViewWidth / 2, -animationViewHeight);

    CGPoint fromPoint = CGPointMake(0, 0);
    CGPoint toPoint = CGPointMake(0, 0);
    if (self.axcUI_barrageMarqueeDirection == AxcBarrageMovementStyleRightFromLeft) {
        fromPoint = pointRightCenter;
        toPoint = pointLeftCenter;
    }else if (self.axcUI_barrageMarqueeDirection == AxcBarrageMovementStyleLeftFromRight){
        fromPoint = pointLeftCenter;
        toPoint = pointRightCenter;
    }else if (self.axcUI_barrageMarqueeDirection == AxcBarrageMovementStyleTopFromBottom){
        fromPoint = pointTopCenter;
        toPoint = pointBottomCenter;
    }else{
        fromPoint = pointBottomCenter;
        toPoint = pointTopCenter;
    }
    
    self.animationView.center = fromPoint;
    UIBezierPath *movePath    = [UIBezierPath bezierPath];
    [movePath moveToPoint:fromPoint];
    [movePath addLineToPoint:toPoint];
    
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnimation.path                 = movePath.CGPath;
    moveAnimation.removedOnCompletion  = YES;
    moveAnimation.duration             = animationViewWidth / 30.f * (1 / self.axcUI_barrageSpeed);
    moveAnimation.delegate             = self;
    [self.animationView.layer addAnimation:moveAnimation forKey:@"animationViewPosition"];
}

//MARK: 停止
- (void)AxcUI_stopAnimation {
    _stoped = YES;
    [self.animationView.layer removeAnimationForKey:@"animationViewPosition"];
}
//MARK: 暂停
- (void)AxcUI_pauseAnimation {
    [self pauseLayer:self.animationView.layer];
}
//MARK: 恢复
- (void)AxcUI_resumeAnimation {
    [self resumeLayer:self.animationView.layer];
}
//MARK: 暂停
- (void)pauseLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed               = 0.0;
    layer.timeOffset          = pausedTime;
}

//MARK: 恢复
- (void)resumeLayer:(CALayer*)layer {
    CFTimeInterval pausedTime     = layer.timeOffset;
    layer.speed                   = 1.0;
    layer.timeOffset              = 0.0;
    layer.beginTime               = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime               = timeSincePause;
}

#pragma mark - 懒加载
- (UIView *)animationView{
    if (!_animationView) {
        _animationView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width,
                                                                  self.frame.size.height)];
        [self addSubview:_animationView];
        [_animationView AxcUI_autoresizingMaskComprehensive];
    }
    return _animationView;
}

#pragma mark - 代理回调
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.axcUI_barrageDelegate &&
        [self.axcUI_barrageDelegate respondsToSelector:@selector(AxcUI_barrageView:animationDidStop:Finished:)]) {
        [self.axcUI_barrageDelegate AxcUI_barrageView:self animationDidStop:anim Finished:flag];
    }
    if (self.axcUI_barrageCycle) {
        if (flag && !_stoped) {
            [self AxcUI_startAnimation];
        }
    }
}
- (void)animationDidStart:(CAAnimation *)anim{
    if (self.axcUI_barrageDelegate &&
        [self.axcUI_barrageDelegate respondsToSelector:@selector(AxcUI_barrageView:animationDidStart:)]) {
        [self.axcUI_barrageDelegate AxcUI_barrageView:self animationDidStart:anim];
    }
}

@end
