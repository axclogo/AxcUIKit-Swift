//
//  AxcTween.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/12.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AxcTweenTimingFunctions.h"


// 其实这是一个动画辅助库，轻量级的，反正都看不懂这些函数，全部复制过来好了  =。=
typedef CGFloat(*AxcTweenTimingFunction)(CGFloat, CGFloat, CGFloat, CGFloat);
#if NS_BLOCKS_AVAILABLE
@class AxcTweenPeriod;
typedef void (^AxcTweenUpdateBlock)(AxcTweenPeriod *period);
typedef void (^AxcTweenCompleteBlock)();
#endif

@interface AxcTweenPeriod : NSObject {
    CGFloat duration;
    CGFloat delay;
    CGFloat startOffset;
    CGFloat startValue;
    CGFloat endValue;
    CGFloat tweenedValue;
}

@property (nonatomic) CGFloat startValue;
@property (nonatomic) CGFloat endValue;
@property (nonatomic) CGFloat tweenedValue;
@property (nonatomic) CGFloat duration;
@property (nonatomic) CGFloat delay;
@property (nonatomic) CGFloat startOffset;

+ (id)periodWithStartValue:(CGFloat)aStartValue endValue:(CGFloat)anEndValue duration:(CGFloat)duration;

@end

@protocol AxcTweenLerpPeriod

- (NSValue*)tweenedValueForProgress:(CGFloat)progress;
- (void)setProgress:(CGFloat)progress;

@end

@interface AxcTweenLerpPeriod : AxcTweenPeriod {
    NSValue *startLerp;
    NSValue *endLerp;
    NSValue *tweenedLerp;
}

@property (nonatomic, copy) NSValue *startLerp;
@property (nonatomic, copy) NSValue *endLerp;
@property (nonatomic, copy) NSValue *tweenedLerp;

+ (id)periodWithStartValue:(NSValue*)aStartValue endValue:(NSValue*)anEndValue duration:(CGFloat)duration;

@end

@interface AxcTweenCGPointLerpPeriod : AxcTweenLerpPeriod <AxcTweenLerpPeriod>
+ (id)periodWithStartCGPoint:(CGPoint)aStartPoint endCGPoint:(CGPoint)anEndPoint duration:(CGFloat)duration;
- (CGPoint)startCGPoint;
- (CGPoint)tweenedCGPoint;
- (CGPoint)endCGPoint;
@end

@interface AxcTweenCGRectLerpPeriod : AxcTweenLerpPeriod <AxcTweenLerpPeriod>
+ (id)periodWithStartCGRect:(CGRect)aStartRect endCGRect:(CGRect)anEndRect duration:(CGFloat)duration;
- (CGRect)startCGRect;
- (CGRect)tweenedCGRect;
- (CGRect)endCGRect;
@end

@interface AxcTweenOperation : NSObject {
    AxcTweenPeriod *period;
    NSObject *target;
    SEL updateSelector;
    SEL completeSelector;
    AxcTweenTimingFunction timingFunction;
    
    CGFloat *boundRef;
    SEL boundGetter;
    SEL boundSetter;
    
    BOOL override;
    
#if NS_BLOCKS_AVAILABLE
    AxcTweenUpdateBlock updateBlock;
    AxcTweenCompleteBlock completeBlock; 
#endif
    
    @private
    BOOL canUseBuiltAnimation;
}

@property (nonatomic, retain) AxcTweenPeriod *period;
@property (nonatomic, retain) NSObject *target;
@property (nonatomic) SEL updateSelector;
@property (nonatomic) SEL completeSelector;
@property (nonatomic, assign) AxcTweenTimingFunction timingFunction;

#if NS_BLOCKS_AVAILABLE
@property (nonatomic, copy) AxcTweenUpdateBlock updateBlock;
@property (nonatomic, copy) AxcTweenCompleteBlock completeBlock;
#endif

@property (nonatomic, assign) CGFloat *boundRef;
@property (nonatomic, retain) id boundObject;
@property (nonatomic) SEL boundGetter;
@property (nonatomic) SEL boundSetter;
@property (nonatomic) BOOL override;

@end

@interface AxcTweenCGPointLerp : NSObject
+ (AxcTweenOperation *)lerp:(id)object property:(NSString*)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector;
+ (AxcTweenOperation *)lerp:(id)object property:(NSString*)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration delay:(CGFloat)delay timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector;
+ (AxcTweenOperation *)lerp:(id)object property:(NSString*)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration;
#if NS_BLOCKS_AVAILABLE
+ (AxcTweenOperation *)lerp:(id)object property:(NSString*)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction updateBlock:(AxcTweenUpdateBlock)updateBlock completeBlock:(AxcTweenCompleteBlock)completeBlock;
#endif
@end

@interface AxcTweenCGRectLerp : NSObject
+ (AxcTweenOperation *)lerp:(id)object property:(NSString*)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector;
+ (AxcTweenOperation *)lerp:(id)object property:(NSString*)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration delay:(CGFloat)delay timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector;
+ (AxcTweenOperation *)lerp:(id)object property:(NSString*)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration;
#if NS_BLOCKS_AVAILABLE
+ (AxcTweenOperation *)lerp:(id)object property:(NSString*)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction updateBlock:(AxcTweenUpdateBlock)updateBlock completeBlock:(AxcTweenCompleteBlock)completeBlock;
#endif
@end

@interface AxcTween : NSObject {
    NSMutableArray *tweenOperations;
    NSMutableArray *expiredTweenOperations;
    NSTimer *timer;
    CGFloat timeOffset;
    
    AxcTweenTimingFunction defaultTimingFunction;
    BOOL useBuiltInAnimationsWhenPossible;
}

@property (nonatomic, readonly) CGFloat timeOffset;
@property (nonatomic, assign) AxcTweenTimingFunction defaultTimingFunction;
@property (nonatomic, assign) BOOL useBuiltInAnimationsWhenPossible;

+ (AxcTween *)sharedInstance;

+ (AxcTweenOperation *)tween:(id)object property:(NSString*)property from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject*)target completeSelector:(SEL)selector;

+ (AxcTweenOperation *)tween:(CGFloat*)ref from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject*)target completeSelector:(SEL)selector;

+ (AxcTweenOperation *)tween:(id)object property:(NSString*)property from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration;

+ (AxcTweenOperation *)tween:(CGFloat*)ref from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration;

+ (AxcTweenOperation *)lerp:(id)object property:(NSString*)property period:(AxcTweenLerpPeriod <AxcTweenLerpPeriod> *)period timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector;

- (AxcTweenOperation *)addTweenOperation:(AxcTweenOperation*)operation;
- (AxcTweenOperation *)addTweenPeriod:(AxcTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector;
- (AxcTweenOperation *)addTweenPeriod:(AxcTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector timingFunction:(AxcTweenTimingFunction)timingFunction;
- (void)removeTweenOperation:(AxcTweenOperation*)tweenOperation;

#if NS_BLOCKS_AVAILABLE
+ (AxcTweenOperation *)tween:(id)object property:(NSString*)property from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction updateBlock:(AxcTweenUpdateBlock)updateBlock completeBlock:(AxcTweenCompleteBlock)completeBlock;

+ (AxcTweenOperation *)tween:(CGFloat*)ref from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction updateBlock:(AxcTweenUpdateBlock)updateBlock completeBlock:(AxcTweenCompleteBlock)completeBlock;

+ (AxcTweenOperation *)lerp:(id)object property:(NSString*)property period:(AxcTweenLerpPeriod <AxcTweenLerpPeriod> *)period timingFunction:(AxcTweenTimingFunction)timingFunction updateBlock:(AxcTweenUpdateBlock)updateBlock completeBlock:(AxcTweenCompleteBlock)completeBlock;

- (AxcTweenOperation *)addTweenPeriod:(AxcTweenPeriod *)period updateBlock:(AxcTweenUpdateBlock)updateBlock completionBlock:(AxcTweenCompleteBlock)completeBlock;
- (AxcTweenOperation *)addTweenPeriod:(AxcTweenPeriod *)period updateBlock:(AxcTweenUpdateBlock)updateBlock completionBlock:(AxcTweenCompleteBlock)completionBlock timingFunction:(AxcTweenTimingFunction)timingFunction;
#endif

@end
