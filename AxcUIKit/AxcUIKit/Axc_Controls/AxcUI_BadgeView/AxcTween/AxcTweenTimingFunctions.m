//
//  AxcTweenTimingFunctions.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/12.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcTweenTimingFunctions.h"

CGFloat AxcTweenTimingFunctionLinear (CGFloat time, CGFloat begin, CGFloat change, CGFloat duration) {
    return change * time / duration + begin;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"
CGFloat AxcTweenTimingFunctionBackOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat s = 1.70158;

    return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;

}

CGFloat AxcTweenTimingFunctionBackIn (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat s = 1.70158;
    return c*(t/=d)*t*((s+1)*t - s) + b;
}

CGFloat AxcTweenTimingFunctionBackInOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat s = 1.70158; 
    if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
    return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
}

CGFloat AxcTweenTimingFunctionBounceOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d) < (1/2.75)) {
        return c*(7.5625*t*t) + b;
    } else if (t < (2/2.75)) {
        return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
    } else if (t < (2.5/2.75)) {
        return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
    } else {
        return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
    }
}

CGFloat AxcTweenTimingFunctionBounceIn (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c - AxcTweenTimingFunctionBounceOut(d-t, 0, c, d) + b;
}

CGFloat AxcTweenTimingFunctionBounceInOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if (t < d/2) return AxcTweenTimingFunctionBounceIn(t*2, 0, c, d) * .5 + b;
    else return AxcTweenTimingFunctionBounceOut(t*2-d, 0, c, d) * .5 + c*.5 + b;
}

CGFloat AxcTweenTimingFunctionCircOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c * sqrt(1 - (t=t/d-1)*t) + b;
}

CGFloat AxcTweenTimingFunctionCircIn (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return -c * (sqrt(1 - (t/=d)*t) - 1) + b;
}

CGFloat AxcTweenTimingFunctionCircInOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d/2) < 1) return -c/2 * (sqrt(1 - t*t) - 1) + b;
    return c/2 * (sqrt(1 - (t-=2)*t) + 1) + b;
}

CGFloat AxcTweenTimingFunctionCubicOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*((t=t/d-1)*t*t + 1) + b;
}

CGFloat AxcTweenTimingFunctionCubicIn (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*(t/=d)*t*t + b;
}

CGFloat AxcTweenTimingFunctionCubicInOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d/2) < 1) return c/2*t*t*t + b;
    return c/2*((t-=2)*t*t + 2) + b;
}

CGFloat AxcTweenTimingFunctionElasticOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat p = d*.3;
    CGFloat s = 0.0, a = 0.0;
    if (t==0) return b;  if ((t/=d)==1) return b+c;
    if (!a || a < ABS(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    return (a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p ) + c + b);
}

CGFloat AxcTweenTimingFunctionElasticIn (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat p = d*.3;
    CGFloat s = 0.0, a = 0.0;
    if (t==0) return b;  if ((t/=d)==1) return b+c;
    if (!a || a < ABS(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    return -(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
}

CGFloat AxcTweenTimingFunctionElasticInOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    CGFloat p = d*(.3*1.5);
    CGFloat s = 0.0, a = 0.0;
    if (t==0) return b;  if ((t/=d/2)==2) return b+c;
    if (!a || a < ABS(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    if (t < 1) return -.5*(a*pow(2,10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )) + b;
    return a*pow(2,-10*(t-=1)) * sin( (t*d-s)*(2*M_PI)/p )*.5 + c + b;
}

CGFloat AxcTweenTimingFunctionExpoOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b;
}

CGFloat AxcTweenTimingFunctionExpoIn (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b;
}

CGFloat AxcTweenTimingFunctionExpoInOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if (t==0) return b;
    if (t==d) return b+c;
    if ((t/=d/2) < 1) return c/2 * pow(2, 10 * (t - 1)) + b;
    return c/2 * (-pow(2, -10 * --t) + 2) + b;
}

CGFloat AxcTweenTimingFunctionQuadOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return -c *(t/=d)*(t-2) + b;
}

CGFloat AxcTweenTimingFunctionQuadIn (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*(t/=d)*t + b;
}

CGFloat AxcTweenTimingFunctionQuadInOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d/2) < 1) return c/2*t*t + b;
    return -c/2 * ((--t)*(t-2) - 1) + b;
}

CGFloat AxcTweenTimingFunctionQuartOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return -c * ((t=t/d-1)*t*t*t - 1) + b;
}

CGFloat AxcTweenTimingFunctionQuartIn (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*(t/=d)*t*t*t + b;
}

CGFloat AxcTweenTimingFunctionQuartInOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
    return -c/2 * ((t-=2)*t*t*t - 2) + b;
}

CGFloat AxcTweenTimingFunctionQuintOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*(t/=d)*t*t*t*t + b;
}

CGFloat AxcTweenTimingFunctionQuintIn (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c*((t=t/d-1)*t*t*t*t + 1) + b;
}

CGFloat AxcTweenTimingFunctionQuintInOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
    return c/2*((t-=2)*t*t*t*t + 2) + b;
}

CGFloat AxcTweenTimingFunctionSineOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return c * sin(t/d * (M_PI/2)) + b;
}

CGFloat AxcTweenTimingFunctionSineIn (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return -c * cos(t/d * (M_PI/2)) + c + b;
}

CGFloat AxcTweenTimingFunctionSineInOut (CGFloat t, CGFloat b, CGFloat c, CGFloat d) {
    return -c/2 * (cos(M_PI*t/d) - 1) + b;
}

#pragma clang diagnostic pop

CGFloat AxcTweenTimingFunctionCALinear       (CGFloat t, CGFloat b, CGFloat c, CGFloat d) { return 0; }
CGFloat AxcTweenTimingFunctionCAEaseIn       (CGFloat t, CGFloat b, CGFloat c, CGFloat d) { return 0; }
CGFloat AxcTweenTimingFunctionCAEaseOut      (CGFloat t, CGFloat b, CGFloat c, CGFloat d) { return 0; }
CGFloat AxcTweenTimingFunctionCAEaseInOut    (CGFloat t, CGFloat b, CGFloat c, CGFloat d) { return 0; }
CGFloat AxcTweenTimingFunctionCADefault      (CGFloat t, CGFloat b, CGFloat c, CGFloat d) { return 0; }

CGFloat AxcTweenTimingFunctionUIViewLinear       (CGFloat t, CGFloat b, CGFloat c, CGFloat d) { return 0; }
CGFloat AxcTweenTimingFunctionUIViewEaseIn       (CGFloat t, CGFloat b, CGFloat c, CGFloat d) { return 0; }
CGFloat AxcTweenTimingFunctionUIViewEaseOut      (CGFloat t, CGFloat b, CGFloat c, CGFloat d) { return 0; }
CGFloat AxcTweenTimingFunctionUIViewEaseInOut    (CGFloat t, CGFloat b, CGFloat c, CGFloat d) { return 0; }

CGFloat (*AxcTweenTimingFunctionCACustom(CAMediaTimingFunction *timingFunction))(CGFloat, CGFloat, CGFloat, CGFloat) {
    return &AxcTweenTimingFunctionLinear;
}
