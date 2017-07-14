//
//  AxcTweenTimingFunctions.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/12.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

// 这里面基本看不明白。。不过这些函数会用就行了

CGFloat AxcTweenTimingFunctionLinear (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat AxcTweenTimingFunctionBackOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionBackIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionBackInOut (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat AxcTweenTimingFunctionBounceOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionBounceIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionBounceInOut (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat AxcTweenTimingFunctionCircOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionCircIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionCircInOut (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat AxcTweenTimingFunctionCubicOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionCubicIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionCubicInOut (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat AxcTweenTimingFunctionElasticOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionElasticIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionElasticInOut (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat AxcTweenTimingFunctionExpoOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionExpoIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionExpoInOut (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat AxcTweenTimingFunctionQuadOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionQuadIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionQuadInOut (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat AxcTweenTimingFunctionQuartOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionQuartIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionQuartInOut (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat AxcTweenTimingFunctionQuintOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionQuintIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionQuintInOut (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat AxcTweenTimingFunctionSineOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionSineIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionSineInOut (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat AxcTweenTimingFunctionCALinear (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionCAEaseIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionCAEaseOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionCAEaseInOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionCADefault (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat AxcTweenTimingFunctionUIViewLinear (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionUIViewEaseIn (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionUIViewEaseOut (CGFloat, CGFloat, CGFloat, CGFloat);
CGFloat AxcTweenTimingFunctionUIViewEaseInOut (CGFloat, CGFloat, CGFloat, CGFloat);

CGFloat (*AxcTweenTimingFunctionCACustom(CAMediaTimingFunction *timingFunction))(CGFloat, CGFloat, CGFloat, CGFloat);


