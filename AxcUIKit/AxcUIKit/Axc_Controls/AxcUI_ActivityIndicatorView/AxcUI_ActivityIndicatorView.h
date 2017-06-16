//
//  AxcUI_ActivityIndicatorView.h
//  DGActivityIndicatorExample
//
//  Created by Danil Gontovnik on 5/23/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AxcActivityIndicatorAnimationType) {
    AxcActivityIndicatorAnimationTypeNineDots,
    AxcActivityIndicatorAnimationTypeTriplePulse,
    AxcActivityIndicatorAnimationTypeFiveDots,
    AxcActivityIndicatorAnimationTypeRotatingSquares,
    AxcActivityIndicatorAnimationTypeDoubleBounce,
    AxcActivityIndicatorAnimationTypeTwoDots,
    AxcActivityIndicatorAnimationTypeThreeDots,
    AxcActivityIndicatorAnimationTypeBallPulse,
    AxcActivityIndicatorAnimationTypeBallClipRotate,
    AxcActivityIndicatorAnimationTypeBallClipRotatePulse,
    
    AxcActivityIndicatorAnimationTypeBallClipRotateMultiple,
    AxcActivityIndicatorAnimationTypeBallRotate,
    AxcActivityIndicatorAnimationTypeBallZigZag,
    AxcActivityIndicatorAnimationTypeBallZigZagDeflect,
    AxcActivityIndicatorAnimationTypeBallTrianglePath,
    AxcActivityIndicatorAnimationTypeBallScale,
    AxcActivityIndicatorAnimationTypeLineScale,
    AxcActivityIndicatorAnimationTypeLineScaleParty,
    AxcActivityIndicatorAnimationTypeBallScaleMultiple,
    AxcActivityIndicatorAnimationTypeBallPulseSync,
    
    AxcActivityIndicatorAnimationTypeBallBeat,
    AxcActivityIndicatorAnimationTypeLineScalePulseOut,
    AxcActivityIndicatorAnimationTypeLineScalePulseOutRapid,
    AxcActivityIndicatorAnimationTypeBallScaleRipple,
    AxcActivityIndicatorAnimationTypeBallScaleRippleMultiple,
    AxcActivityIndicatorAnimationTypeTriangleSkewSpin,
    AxcActivityIndicatorAnimationTypeBallGridBeat,
    AxcActivityIndicatorAnimationTypeBallGridPulse,
    AxcActivityIndicatorAnimationTypeRotatingSandglass,
    AxcActivityIndicatorAnimationTypeRotatingTrigons,
    
    AxcActivityIndicatorAnimationTypeTripleRings,
    AxcActivityIndicatorAnimationTypeCookieTerminator,
    AxcActivityIndicatorAnimationTypeBallSpinFadeLoader
};

@interface AxcUI_ActivityIndicatorView : UIView

- (id)initWithType:(AxcActivityIndicatorAnimationType)type;
- (id)initWithType:(AxcActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor;
- (id)initWithType:(AxcActivityIndicatorAnimationType)type tintColor:(UIColor *)tintColor size:(CGFloat)size;

@property (nonatomic) AxcActivityIndicatorAnimationType axcUI_type;
@property (nonatomic, strong) UIColor *axcUI_tintColor;
@property (nonatomic) CGFloat axcUI_size;

@property (nonatomic, readonly) BOOL axcUI_animating;

- (void)AxcUI_startAnimating;
- (void)AxcUI_stopAnimating;

@end
