//
//  Axc_ActivityIndicator.h
//  DGTest
//
//  Created by Axc on 2017/6/9.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@protocol AxcCtivityIndicatorAnimationProtocol <NSObject>
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor;
@end

// 基类
@interface AxcUI_CtivityIndicatorAnimation : NSObject <AxcCtivityIndicatorAnimationProtocol>
- (CABasicAnimation *)createBasicAnimationWithKeyPath:(NSString *)keyPath;
- (CAKeyframeAnimation *)createKeyframeAnimationWithKeyPath:(NSString *)keyPath;
- (CAAnimationGroup *)createAnimationGroup;
@end

@interface AxcUI_CtivityIndicatorBallBeatAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallClipRotateAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallClipRotateMultipleAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallClipRotatePulseAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallGridBeatAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallGridPulseAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallPulseAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallPulseSyncAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallRotateAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallScaleAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallScaleMultipleAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallScaleRippleAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallScaleRippleMultipleAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallSpinFadeLoaderAnimation : AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallTrianglePathAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallZigZagAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorBallZigZagDeflectAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorCookieTerminatorAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorDoubleBounceAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorFiveDotsAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorLineScaleAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorLineScalePartyAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorLineScalePulseOutAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorLineScalePulseOutRapidAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorNineDotsAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorRotatingSandglassAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorRotatingSquaresAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorRotatingTrigonAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorThreeDotsAnimation : AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorTriangleSkewSpinAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorTriplePulseAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorTripleRingsAnimation: AxcUI_CtivityIndicatorAnimation
@end

@interface AxcUI_CtivityIndicatorTwoDotsAnimation: AxcUI_CtivityIndicatorAnimation
@end
























