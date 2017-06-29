//
//  AxcUI_ActivityIndicatorView.h
//  DGActivityIndicatorExample
//
//  Created by Danil Gontovnik on 5/23/15.
//  Copyright (c) 2015 Danil Gontovnik. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AxcActivityIndicatorAnimationStyle) {
    AxcActivityIndicatorAnimationStyleNineDots,
    AxcActivityIndicatorAnimationStyleTriplePulse,
    AxcActivityIndicatorAnimationStyleFiveDots,
    AxcActivityIndicatorAnimationStyleRotatingSquares,
    AxcActivityIndicatorAnimationStyleDoubleBounce,
    AxcActivityIndicatorAnimationStyleTwoDots,
    AxcActivityIndicatorAnimationStyleThreeDots,
    AxcActivityIndicatorAnimationStyleBallPulse,
    AxcActivityIndicatorAnimationStyleBallClipRotate,
    AxcActivityIndicatorAnimationStyleBallClipRotatePulse,
    
    AxcActivityIndicatorAnimationStyleBallClipRotateMultiple,
    AxcActivityIndicatorAnimationStyleBallRotate,
    AxcActivityIndicatorAnimationStyleBallZigZag,
    AxcActivityIndicatorAnimationStyleBallZigZagDeflect,
    AxcActivityIndicatorAnimationStyleBallTrianglePath,
    AxcActivityIndicatorAnimationStyleBallScale,
    AxcActivityIndicatorAnimationStyleLineScale,
    AxcActivityIndicatorAnimationStyleLineScaleParty,
    AxcActivityIndicatorAnimationStyleBallScaleMultiple,
    AxcActivityIndicatorAnimationStyleBallPulseSync,
    
    AxcActivityIndicatorAnimationStyleBallBeat,
    AxcActivityIndicatorAnimationStyleLineScalePulseOut,
    AxcActivityIndicatorAnimationStyleLineScalePulseOutRapid,
    AxcActivityIndicatorAnimationStyleBallScaleRipple,
    AxcActivityIndicatorAnimationStyleBallScaleRippleMultiple,
    AxcActivityIndicatorAnimationStyleTriangleSkewSpin,
    AxcActivityIndicatorAnimationStyleBallGridBeat,
    AxcActivityIndicatorAnimationStyleBallGridPulse,
    AxcActivityIndicatorAnimationStyleRotatingSandglass,
    AxcActivityIndicatorAnimationStyleRotatingTrigons,
    
    AxcActivityIndicatorAnimationStyleTripleRings,
    AxcActivityIndicatorAnimationStyleCookieTerminator,
    AxcActivityIndicatorAnimationStyleBallSpinFadeLoader
};

@interface AxcUI_ActivityIndicatorView : UIView

- (id)initWithType:(AxcActivityIndicatorAnimationStyle)type;
- (id)initWithType:(AxcActivityIndicatorAnimationStyle)type tintColor:(UIColor *)tintColor;
- (id)initWithType:(AxcActivityIndicatorAnimationStyle)type tintColor:(UIColor *)tintColor size:(CGFloat)size;

@property (nonatomic) AxcActivityIndicatorAnimationStyle axcUI_type;
@property (nonatomic, strong) UIColor *axcUI_tintColor;
@property (nonatomic) CGFloat axcUI_size;

@property (nonatomic, readonly) BOOL axcUI_animating;

- (void)AxcUI_startAnimating;
- (void)AxcUI_stopAnimating;

@end
