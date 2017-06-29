//
//  AxcUI_CtivityIndicatorView.m
//  AxcUI_CtivityIndicatorExample
//
//  Created by Danil Gontovnik on 5/23/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import "AxcUI_ActivityIndicatorView.h"

#import "Axc_ActivityIndicator.h"

static const CGFloat kAxcUI_CtivityIndicatorDefaultSize = 40.0f;

@interface AxcUI_ActivityIndicatorView () {
    CALayer *_animationLayer;
}

@end

@implementation AxcUI_ActivityIndicatorView


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _axcUI_tintColor = [UIColor whiteColor];
        _axcUI_size = kAxcUI_CtivityIndicatorDefaultSize;
        [self commonInit];
    }
    return self;
}

- (id)initWithType:(AxcActivityIndicatorAnimationStyle)type {
    return [self initWithType:type tintColor:[UIColor whiteColor] size:kAxcUI_CtivityIndicatorDefaultSize];
}

- (id)initWithType:(AxcActivityIndicatorAnimationStyle)type tintColor:(UIColor *)tintColor {
    return [self initWithType:type tintColor:tintColor size:kAxcUI_CtivityIndicatorDefaultSize];
}

- (id)initWithType:(AxcActivityIndicatorAnimationStyle)type tintColor:(UIColor *)tintColor size:(CGFloat)size {
    self = [super init];
    if (self) {
        _axcUI_type = type;
        _axcUI_size = size;
        _axcUI_tintColor = tintColor;
        [self commonInit];
    }
    return self;
}

#pragma mark -
#pragma mark Methods

- (void)commonInit {
    self.userInteractionEnabled = NO;
    self.hidden = YES;
    
    _animationLayer = [[CALayer alloc] init];
    [self.layer addSublayer:_animationLayer];

    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
}

- (void)setupAnimation {
    _animationLayer.sublayers = nil;
    
    id<AxcCtivityIndicatorAnimationProtocol> animation = [AxcUI_ActivityIndicatorView activityIndicatorAnimationForAnimationType:_axcUI_type];
    
    if ([animation respondsToSelector:@selector(setupAnimationInLayer:withSize:tintColor:)]) {
        [animation setupAnimationInLayer:_animationLayer withSize:CGSizeMake(_axcUI_size, _axcUI_size) tintColor:_axcUI_tintColor];
        _animationLayer.speed = 0.0f;
    }
}

- (void)AxcUI_startAnimating {
    if (!_animationLayer.sublayers) {
        [self setupAnimation];
    }
    self.hidden = NO;
    _animationLayer.speed = 1.0f;
    _axcUI_animating = YES;
}

- (void)AxcUI_stopAnimating {
    _animationLayer.speed = 0.0f;
    _axcUI_animating = NO;
    self.hidden = YES;
}

#pragma mark -
#pragma mark Setters

- (void)setType:(AxcActivityIndicatorAnimationStyle)type {
    if (_axcUI_type != type) {
        _axcUI_type = type;
        
        [self setupAnimation];
    }
}

- (void)setSize:(CGFloat)size {
    if (_axcUI_size != size) {
        _axcUI_size = size;
        
        [self setupAnimation];
        [self invalidateIntrinsicContentSize];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if (![_axcUI_tintColor isEqual:tintColor]) {
        _axcUI_tintColor = tintColor;
        
        CGColorRef tintColorRef = tintColor.CGColor;
        for (CALayer *sublayer in _animationLayer.sublayers) {
            sublayer.backgroundColor = tintColorRef;
            
            if ([sublayer isKindOfClass:[CAShapeLayer class]]) {
                CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
                shapeLayer.strokeColor = tintColorRef;
                shapeLayer.fillColor = tintColorRef;
            }
        }
    }
}

#pragma mark -
#pragma mark Getters

+ (id<AxcCtivityIndicatorAnimationProtocol>)activityIndicatorAnimationForAnimationType:(AxcActivityIndicatorAnimationStyle)type {
    switch (type) {
        case AxcActivityIndicatorAnimationStyleNineDots:
            return [[AxcUI_CtivityIndicatorNineDotsAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleTriplePulse:
            return [[AxcUI_CtivityIndicatorTriplePulseAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleFiveDots:
            return [[AxcUI_CtivityIndicatorFiveDotsAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleRotatingSquares:
            return [[AxcUI_CtivityIndicatorRotatingSquaresAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleDoubleBounce:
            return [[AxcUI_CtivityIndicatorDoubleBounceAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleTwoDots:
            return [[AxcUI_CtivityIndicatorTwoDotsAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleThreeDots:
            return [[AxcUI_CtivityIndicatorThreeDotsAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallPulse:
            return [[AxcUI_CtivityIndicatorBallPulseAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallClipRotate:
            return [[AxcUI_CtivityIndicatorBallClipRotateAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallClipRotatePulse:
            return [[AxcUI_CtivityIndicatorBallClipRotatePulseAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallClipRotateMultiple:
            return [[AxcUI_CtivityIndicatorBallClipRotateMultipleAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallRotate:
            return [[AxcUI_CtivityIndicatorBallRotateAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallZigZag:
            return [[AxcUI_CtivityIndicatorBallZigZagAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallZigZagDeflect:
            return [[AxcUI_CtivityIndicatorBallZigZagDeflectAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallTrianglePath:
            return [[AxcUI_CtivityIndicatorBallTrianglePathAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallScale:
            return [[AxcUI_CtivityIndicatorBallScaleAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleLineScale:
            return [[AxcUI_CtivityIndicatorLineScaleAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleLineScaleParty:
            return [[AxcUI_CtivityIndicatorLineScalePartyAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallScaleMultiple:
            return [[AxcUI_CtivityIndicatorBallScaleMultipleAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallPulseSync:
            return [[AxcUI_CtivityIndicatorBallPulseSyncAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallBeat:
            return [[AxcUI_CtivityIndicatorBallBeatAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleLineScalePulseOut:
            return [[AxcUI_CtivityIndicatorLineScalePulseOutAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleLineScalePulseOutRapid:
            return [[AxcUI_CtivityIndicatorLineScalePulseOutRapidAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallScaleRipple:
            return [[AxcUI_CtivityIndicatorBallScaleRippleAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallScaleRippleMultiple:
            return [[AxcUI_CtivityIndicatorBallScaleRippleMultipleAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleTriangleSkewSpin:
            return [[AxcUI_CtivityIndicatorTriangleSkewSpinAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallGridBeat:
            return [[AxcUI_CtivityIndicatorBallGridBeatAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleBallGridPulse:
            return [[AxcUI_CtivityIndicatorBallGridPulseAnimation alloc] init];
        case AxcActivityIndicatorAnimationStyleRotatingSandglass:
            return [[AxcUI_CtivityIndicatorRotatingSandglassAnimation alloc]init];
        case AxcActivityIndicatorAnimationStyleRotatingTrigons:
            return [[AxcUI_CtivityIndicatorRotatingTrigonAnimation alloc]init];
        case AxcActivityIndicatorAnimationStyleTripleRings:
            return [[AxcUI_CtivityIndicatorTripleRingsAnimation alloc]init];
        case AxcActivityIndicatorAnimationStyleCookieTerminator:
            return [[AxcUI_CtivityIndicatorCookieTerminatorAnimation alloc]init];
        case AxcActivityIndicatorAnimationStyleBallSpinFadeLoader:
            return [[AxcUI_CtivityIndicatorBallSpinFadeLoaderAnimation alloc] init];
    }
    return nil;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _animationLayer.frame = self.bounds;

    BOOL animating = _axcUI_animating;

    if (animating)
        [self AxcUI_stopAnimating];

    [self setupAnimation];

    if (animating)
        [self AxcUI_startAnimating];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(_axcUI_size, _axcUI_size);
}

@end
