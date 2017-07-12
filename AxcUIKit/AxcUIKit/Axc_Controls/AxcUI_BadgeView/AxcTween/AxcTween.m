//
//  AxcTween.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/12.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcTween.h"

#define kAxcTweenFramerate 1.0/60

@implementation AxcTweenPeriod
@synthesize startValue;
@synthesize endValue;
@synthesize tweenedValue;
@synthesize duration;
@synthesize delay;
@synthesize startOffset;

+ (id)periodWithStartValue:(CGFloat)aStartValue endValue:(CGFloat)anEndValue duration:(CGFloat)duration {
    AxcTweenPeriod *period = [AxcTweenPeriod new];
    
    period.startValue = period.tweenedValue = aStartValue;
    period.endValue = anEndValue;
    period.duration = duration;
    period.startOffset = [[AxcTween sharedInstance] timeOffset];
    
    return period ;
}

@end

@implementation AxcTweenLerpPeriod
@synthesize startLerp;
@synthesize endLerp;
@synthesize tweenedLerp;

+ (id)periodWithStartValue:(NSValue*)aStartValue endValue:(NSValue*)anEndValue duration:(CGFloat)duration {
    AxcTweenLerpPeriod *period = [[self class] new];
    period.startLerp = aStartValue;
    period.tweenedLerp = aStartValue;
    period.endLerp = anEndValue;
    period.duration = duration;
    period.startOffset = [[AxcTween sharedInstance] timeOffset];
    
    return period;
}

@end

@implementation AxcTweenCGPointLerpPeriod

+ (id)periodWithStartCGPoint:(CGPoint)aStartPoint endCGPoint:(CGPoint)anEndPoint duration:(CGFloat)duration {
    return [AxcTweenCGPointLerpPeriod periodWithStartValue:[NSValue valueWithCGPoint:aStartPoint] endValue:[NSValue valueWithCGPoint:anEndPoint] duration:duration];
}

- (CGPoint)startCGPoint { return [self.startLerp CGPointValue]; }
- (CGPoint)tweenedCGPoint { return [self.tweenedLerp CGPointValue]; }
- (CGPoint)endCGPoint { return [self.endLerp CGPointValue]; }

- (NSValue*)tweenedValueForProgress:(CGFloat)progress {
    
    CGPoint startPoint = self.startCGPoint;
    CGPoint endPoint = self.endCGPoint;
    CGPoint distance = CGPointMake(endPoint.x - startPoint.x, endPoint.y - startPoint.y);
    CGPoint tweenedPoint = CGPointMake(startPoint.x + distance.x * progress, startPoint.y + distance.y * progress);
    
    return [NSValue valueWithCGPoint:tweenedPoint];
    
}

- (void)setProgress:(CGFloat)progress {
    self.tweenedLerp = [self tweenedValueForProgress:progress];
}

@end

@implementation AxcTweenCGRectLerpPeriod

+ (id)periodWithStartCGRect:(CGRect)aStartRect endCGRect:(CGRect)anEndRect duration:(CGFloat)duration {
    return [AxcTweenCGRectLerpPeriod periodWithStartValue:[NSValue valueWithCGRect:aStartRect] endValue:[NSValue valueWithCGRect:anEndRect] duration:duration];
}

- (CGRect)startCGRect { return [self.startLerp CGRectValue]; }
- (CGRect)tweenedCGRect { return [self.tweenedLerp CGRectValue]; }
- (CGRect)endCGRect { return [self.endLerp CGRectValue]; }

- (NSValue *)tweenedValueForProgress:(CGFloat)progress {
    
    CGRect startRect = self.startCGRect;
    CGRect endRect = self.endCGRect;
    CGRect distance = CGRectMake(endRect.origin.x - startRect.origin.x, endRect.origin.y - startRect.origin.y, endRect.size.width - startRect.size.width, endRect.size.height - startRect.size.height);
    CGRect tweenedRect = CGRectMake(startRect.origin.x + distance.origin.x * progress, startRect.origin.y + distance.origin.y * progress, startRect.size.width + distance.size.width * progress, startRect.size.height + distance.size.height * progress);
    
    return [NSValue valueWithCGRect:tweenedRect];
    
}

- (void)setProgress:(CGFloat)progress {
    self.tweenedLerp = [self tweenedValueForProgress:progress];
}

@end

@interface AxcTweenOperation ()
@property (nonatomic) BOOL canUseBuiltAnimation;
@end

@implementation AxcTweenOperation
@synthesize period;
@synthesize target;
@synthesize updateSelector;
@synthesize completeSelector;
@synthesize timingFunction;
@synthesize boundRef;
@synthesize boundObject;
@synthesize boundGetter;
@synthesize boundSetter;
@synthesize canUseBuiltAnimation;
@synthesize override;

#if NS_BLOCKS_AVAILABLE
@synthesize updateBlock;
@synthesize completeBlock;
#endif


@end

@implementation AxcTweenCGPointLerp

+ (AxcTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector {
    return [AxcTween lerp:object property:property period:[AxcTweenCGPointLerpPeriod periodWithStartCGPoint:from endCGPoint:to duration:duration] timingFunction:timingFunction target:target completeSelector:selector];
}

+ (AxcTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration delay:(CGFloat)delay timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector {
    AxcTweenCGPointLerpPeriod *period = [AxcTweenCGPointLerpPeriod periodWithStartCGPoint:from endCGPoint:to duration:duration];
    period.delay = delay;
    return [AxcTween lerp:object property:property period:period timingFunction:timingFunction target:target completeSelector:selector];
}

+ (AxcTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration {
    return [AxcTweenCGPointLerp lerp:object property:property from:from to:to duration:duration timingFunction:NULL target:nil completeSelector:NULL];
}

#if NS_BLOCKS_AVAILABLE
+ (AxcTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction updateBlock:(AxcTweenUpdateBlock)updateBlock completeBlock:(AxcTweenCompleteBlock)completeBlock {
    return [AxcTween lerp:object property:property period:[AxcTweenCGPointLerpPeriod periodWithStartCGPoint:from endCGPoint:to duration:duration] timingFunction:timingFunction updateBlock:updateBlock completeBlock:completeBlock];
}
#endif

@end

@implementation AxcTweenCGRectLerp

+ (AxcTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector {
    return [AxcTween lerp:object property:property period:[AxcTweenCGRectLerpPeriod periodWithStartCGRect:from endCGRect:to duration:duration] timingFunction:timingFunction target:target completeSelector:selector];
}

+ (AxcTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration delay:(CGFloat)delay timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector {
    AxcTweenCGRectLerpPeriod *period = [AxcTweenCGRectLerpPeriod periodWithStartCGRect:from endCGRect:to duration:duration];
    period.delay = delay;
    return [AxcTween lerp:object property:property period:period timingFunction:timingFunction target:target completeSelector:selector];
}

+ (AxcTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration {
    return [AxcTweenCGRectLerp lerp:object property:property from:from to:to duration:duration timingFunction:NULL target:nil completeSelector:NULL];
}

#if NS_BLOCKS_AVAILABLE
+ (AxcTweenOperation *)lerp:(id)object property:(NSString *)property from:(CGRect)from to:(CGRect)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction updateBlock:(AxcTweenUpdateBlock)updateBlock completeBlock:(AxcTweenCompleteBlock)completeBlock { 
    return [AxcTweenCGRectLerp lerp:object property:property from:from to:to duration:duration timingFunction:NULL updateBlock:updateBlock completeBlock:completeBlock];
}
#endif

@end

@interface AxcTween ()
+ (SEL)setterFromProperty:(NSString *)property;
- (void)update;
@end

static AxcTween *instance = nil;
static NSArray *animationSelectorsForCoreAnimation = nil;
static NSArray *animationSelectorsForUIView = nil;

@implementation AxcTween
@synthesize timeOffset;
@synthesize defaultTimingFunction;
@synthesize useBuiltInAnimationsWhenPossible;

+ (AxcTween *)sharedInstance {
    if (instance == nil) {
        instance = [[AxcTween alloc] init];
        instance.useBuiltInAnimationsWhenPossible = YES;
    }
    return instance;
}

+ (AxcTweenOperation *)tween:(id)object property:(NSString*)property from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject*)target completeSelector:(SEL)selector {
    
    AxcTweenPeriod *period = [AxcTweenPeriod periodWithStartValue:from endValue:to duration:duration];
    AxcTweenOperation *operation = [AxcTweenOperation new] ;
    operation.period = period;
    operation.timingFunction = timingFunction;
    operation.target = target;
    operation.completeSelector = selector;
    operation.boundObject = object;
    operation.boundGetter = NSSelectorFromString([NSString stringWithFormat:@"%@", property]);
    operation.boundSetter = [AxcTween setterFromProperty:property];
    [operation addObserver:[AxcTween sharedInstance] forKeyPath:@"period.tweenedValue" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[AxcTween sharedInstance] performSelector:@selector(addTweenOperation:) withObject:operation afterDelay:0];
    return operation;
    
}

+ (AxcTweenOperation *)tween:(CGFloat *)ref from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject*)target completeSelector:(SEL)selector {
    
    AxcTweenPeriod *period = [AxcTweenPeriod periodWithStartValue:from endValue:to duration:duration];
    AxcTweenOperation *operation = [AxcTweenOperation new] ;
    operation.period = period;
    operation.timingFunction = timingFunction;
    operation.target = target;
    operation.completeSelector = selector;
    operation.boundRef = ref;
    [operation addObserver:[AxcTween sharedInstance] forKeyPath:@"period.tweenedValue" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[AxcTween sharedInstance] performSelector:@selector(addTweenOperation:) withObject:operation afterDelay:0];
    return operation;
    
}

+ (AxcTweenOperation *)tween:(id)object property:(NSString*)property from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration {
    return [AxcTween tween:object property:property from:from to:to duration:duration timingFunction:NULL target:nil completeSelector:NULL];
}

+ (AxcTweenOperation *)tween:(CGFloat *)ref from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration {
    return [AxcTween tween:ref from:from to:to duration:duration timingFunction:NULL target:nil completeSelector:NULL];
}

+ (AxcTweenOperation *)lerp:(id)object property:(NSString *)property period:(AxcTweenLerpPeriod <AxcTweenLerpPeriod> *)period  timingFunction:(AxcTweenTimingFunction)timingFunction target:(NSObject *)target completeSelector:(SEL)selector {
    
    //AxcTweenPeriod *period = [AxcTweenLerpPeriod periodWithStartValue:from endValue:to duration:duration];
    AxcTweenOperation *operation = [AxcTweenOperation new] ;
    operation.period = period;
    operation.timingFunction = timingFunction;
    operation.target = target;
    operation.completeSelector = selector;
    operation.boundObject = object;
    operation.boundGetter = NSSelectorFromString([NSString stringWithFormat:@"%@", property]);
    operation.boundSetter = [AxcTween setterFromProperty:property];
    [operation addObserver:[AxcTween sharedInstance] forKeyPath:@"period.tweenedLerp" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[AxcTween sharedInstance] performSelector:@selector(addTweenOperation:) withObject:operation afterDelay:0];
    return operation;
    
}

#if NS_BLOCKS_AVAILABLE
+ (AxcTweenOperation *)tween:(id)object property:(NSString*)property from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction updateBlock:(AxcTweenUpdateBlock)updateBlock completeBlock:(AxcTweenCompleteBlock)completeBlock {
    
    AxcTweenPeriod *period = [AxcTweenPeriod periodWithStartValue:from endValue:to duration:duration];
    AxcTweenOperation *operation = [AxcTweenOperation new] ;
    operation.period = period;
    operation.timingFunction = timingFunction;
    operation.updateBlock = updateBlock;
    operation.completeBlock = completeBlock;
    operation.boundObject = object;
    operation.boundGetter = NSSelectorFromString([NSString stringWithFormat:@"%@", property]);
    operation.boundSetter = [AxcTween setterFromProperty:property];
    [operation addObserver:[AxcTween sharedInstance] forKeyPath:@"period.tweenedValue" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[AxcTween sharedInstance] performSelector:@selector(addTweenOperation:) withObject:operation afterDelay:0];
    return operation;
    
}

+ (AxcTweenOperation *)tween:(CGFloat *)ref from:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration timingFunction:(AxcTweenTimingFunction)timingFunction updateBlock:(AxcTweenUpdateBlock)updateBlock completeBlock:(AxcTweenCompleteBlock)completeBlock {
    
    AxcTweenPeriod *period = [AxcTweenPeriod periodWithStartValue:from endValue:to duration:duration];
    AxcTweenOperation *operation = [AxcTweenOperation new];
    operation.period = period;
    operation.timingFunction = timingFunction;
    operation.updateBlock = updateBlock;
    operation.completeBlock = completeBlock;
    operation.boundRef = ref;
    [operation addObserver:[AxcTween sharedInstance] forKeyPath:@"period.tweenedValue" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[AxcTween sharedInstance] performSelector:@selector(addTweenOperation:) withObject:operation afterDelay:0];
    return operation;
    
}

+ (AxcTweenOperation *)lerp:(id)object property:(NSString *)property period:(AxcTweenLerpPeriod <AxcTweenLerpPeriod> *)period  timingFunction:(AxcTweenTimingFunction)timingFunction updateBlock:(AxcTweenUpdateBlock)updateBlock completeBlock:(AxcTweenCompleteBlock)completeBlock {
    
    //AxcTweenPeriod *period = [AxcTweenLerpPeriod periodWithStartValue:from endValue:to duration:duration];
    AxcTweenOperation *operation = [AxcTweenOperation new] ;
    operation.period = period;
    operation.timingFunction = timingFunction;
    operation.updateBlock = updateBlock;
    operation.completeBlock = completeBlock;
    operation.boundObject = object;
    operation.boundGetter = NSSelectorFromString([NSString stringWithFormat:@"%@", property]);
    operation.boundSetter = [AxcTween setterFromProperty:property];
    [operation addObserver:[AxcTween sharedInstance] forKeyPath:@"period.tweenedLerp" options:NSKeyValueObservingOptionNew context:NULL];
    
    [[AxcTween sharedInstance] performSelector:@selector(addTweenOperation:) withObject:operation afterDelay:0];
    return operation;
    
}
#endif

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    AxcTweenOperation *operation = (AxcTweenOperation*)object;
    
    if ([operation.period isKindOfClass:[AxcTweenLerpPeriod class]]) {
        AxcTweenLerpPeriod *lerpPeriod = (AxcTweenLerpPeriod*)operation.period;
        
        NSUInteger bufferSize = 0;
        NSGetSizeAndAlignment([lerpPeriod.tweenedLerp objCType], &bufferSize, NULL);
        void *tweenedValue = malloc(bufferSize);
        [lerpPeriod.tweenedLerp getValue:tweenedValue];
        
        if (operation.boundObject && [operation.boundObject respondsToSelector:operation.boundGetter] && [operation.boundObject respondsToSelector:operation.boundSetter]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[operation.boundObject class] instanceMethodSignatureForSelector:operation.boundSetter]];
            [invocation setTarget:operation.boundObject];
            [invocation setSelector:operation.boundSetter];
            [invocation setArgument:tweenedValue atIndex:2];
            [invocation invoke];
        }
        
        free(tweenedValue);
        
    } else {
        
        CGFloat tweenedValue = operation.period.tweenedValue;
        
        if (operation.boundObject && [operation.boundObject respondsToSelector:operation.boundGetter] && [operation.boundObject respondsToSelector:operation.boundSetter]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[operation.boundObject class] instanceMethodSignatureForSelector:operation.boundSetter]];
            [invocation setTarget:operation.boundObject];
            [invocation setSelector:operation.boundSetter];
            [invocation setArgument:&tweenedValue atIndex:2];
            [invocation invoke];
        } else if (operation.boundRef) {
            *operation.boundRef = tweenedValue;
        }
        
    }
    
}

- (id)init {
    self = [super init];
    if (self != nil) {
        tweenOperations = [[NSMutableArray alloc] init];
        expiredTweenOperations = [[NSMutableArray alloc] init];
        timeOffset = 0;
        if (timer == nil) {
            timer = [NSTimer scheduledTimerWithTimeInterval:kAxcTweenFramerate target:self selector:@selector(update) userInfo:nil repeats:YES];
        }
        self.defaultTimingFunction = &AxcTweenTimingFunctionQuadInOut;
    }
    return self;
}

- (AxcTweenOperation*)addTweenOperation:(AxcTweenOperation*)operation {
    
    if (useBuiltInAnimationsWhenPossible && !operation.override) {
    
        if (animationSelectorsForCoreAnimation == nil) {
            animationSelectorsForCoreAnimation = [[NSArray alloc] initWithObjects:
                                      @"setBounds:",            // CGRect
                                      @"setPosition:",          // CGPoint
                                      @"setZPosition:",         // CGFloat
                                      @"setAnchorPoint:",       // CGPoint
                                      @"setAnchorPointZ:",      // CGFloat
                                      //@"setTransform:",         // CATransform3D
                                      //@"setSublayerTransform:", // CATransform3D
                                      @"setFrame:",             // CGRect
                                      @"setContentsRect"        // CGRect
                                      @"setContentsScale:",     // CGFloat
                                      @"setContentsCenter:",    // CGPoint
                                      //@"setBackgroundColor:",   // CGColorRef
                                      @"setCornerRadius:",      // CGFloat
                                      @"setBorderWidth:",       // CGFloat
                                      @"setOpacity:",           // CGFloat
                                      //@"setShadowColor:",       // CGColorRef
                                      @"setShadowOpacity:",     // CGFloat
                                      @"setShadowOffset:",      // CGSize
                                      @"setShadowRadius:",      // CGFloat
                                      //@"setShadowPath:",
                                      nil];
        }
        
        if (animationSelectorsForUIView == nil) {
            animationSelectorsForUIView = [[NSArray alloc] initWithObjects:
                                        @"setFrame:",           // CGRect
                                        @"setBounds:",          // CGRect
                                        @"setCenter:",          // CGPoint
                                        @"setTransform:",       // CGAffineTransform
                                        @"setAlpha:",           // CGFloat
                                        //@"setBackgroundColor:", // UIColor
                                        @"setContentStretch:",  // CGRect
                                        nil];
        }
        
        if (operation.boundSetter && operation.boundObject && !(operation.timingFunction == &AxcTweenTimingFunctionCADefault ||
                                                                operation.timingFunction == &AxcTweenTimingFunctionCAEaseIn ||
                                                                operation.timingFunction == &AxcTweenTimingFunctionCAEaseOut ||
                                                                operation.timingFunction == &AxcTweenTimingFunctionCAEaseInOut ||
                                                                operation.timingFunction == &AxcTweenTimingFunctionCALinear ||
                                                                operation.timingFunction == &AxcTweenTimingFunctionUIViewEaseIn ||
                                                                operation.timingFunction == &AxcTweenTimingFunctionUIViewEaseOut ||
                                                                operation.timingFunction == &AxcTweenTimingFunctionUIViewEaseInOut ||
                                                                operation.timingFunction == &AxcTweenTimingFunctionUIViewLinear || 
                                                                operation.timingFunction == NULL)) {
            goto complete;
        }
                                                               
        
        if (operation.boundSetter && operation.boundObject && [operation.boundObject isKindOfClass:[CALayer class]]) {
            for (NSString *selector in animationSelectorsForCoreAnimation) {
                NSString *setter = NSStringFromSelector(operation.boundSetter);
                if ([selector isEqualToString:setter]) {
                    NSLog(@"Using Core Animation for %@", NSStringFromSelector(operation.boundSetter));
                    operation.canUseBuiltAnimation = YES;
                    
                    NSString *propertyUnformatted = [selector stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
                    NSString *propertyFormatted = [[propertyUnformatted stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[propertyUnformatted substringToIndex:1] lowercaseString]] substringToIndex:[propertyUnformatted length] - 1];
                    //NSLog(@"%@", propertyFormatted);
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:propertyFormatted];
                    animation.duration = operation.period.duration;
                    
                    if (![operation.period isKindOfClass:[AxcTweenLerpPeriod class]] && ![operation.period conformsToProtocol:@protocol(AxcTweenLerpPeriod)]) {
                        animation.fromValue = [NSNumber numberWithFloat:operation.period.startValue];
                        animation.toValue = [NSNumber numberWithFloat:operation.period.endValue];
                    } else {
                        AxcTweenLerpPeriod *period = (AxcTweenLerpPeriod*)operation.period;
                        animation.fromValue = period.startLerp;
                        animation.toValue = period.endLerp;
                    }
                    
                    if (operation.timingFunction == &AxcTweenTimingFunctionCAEaseIn) {
                        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                    } else if (operation.timingFunction == &AxcTweenTimingFunctionCAEaseOut) {
                        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                    } else if (operation.timingFunction == &AxcTweenTimingFunctionCAEaseInOut) {
                        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    } else if (operation.timingFunction == &AxcTweenTimingFunctionCALinear) {
                        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                    } else {
                        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
                    }
                    
                    [operation.boundObject setValue:animation.toValue forKeyPath:propertyFormatted];
                    [operation.boundObject addAnimation:animation forKey:@"AxcTweenCAAnimation"];
                    
                    goto complete;
                }
            }
        } else if (operation.boundSetter && operation.boundObject && [operation.boundObject isKindOfClass:[UIView class]]) {
            for (NSString *selector in animationSelectorsForUIView) {
                NSString *setter = NSStringFromSelector(operation.boundSetter);
                if ([selector isEqualToString:setter]) {
                    operation.canUseBuiltAnimation = YES;
                    
                    NSString *propertyUnformatted = [selector stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@""];
                    NSString *propertyFormatted = [[propertyUnformatted stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[propertyUnformatted substringToIndex:1] lowercaseString]] substringToIndex:[propertyUnformatted length] - 1];
                    
                    NSValue *fromValue = nil;
                    NSValue *toValue = nil;
                    
                    if (![operation.period isKindOfClass:[AxcTweenLerpPeriod class]] && ![operation.period conformsToProtocol:@protocol(AxcTweenLerpPeriod)]) {
                        fromValue = [NSNumber numberWithFloat:operation.period.startValue];
                        toValue = [NSNumber numberWithFloat:operation.period.endValue];
                    } else {
                        AxcTweenLerpPeriod *period = (AxcTweenLerpPeriod*)operation.period;
                        fromValue = period.startLerp;
                        toValue = period.endLerp;
                    }
                    
                    [operation.boundObject setValue:fromValue forKeyPath:propertyFormatted];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:operation.period.duration];
                    
                    if (operation.timingFunction == &AxcTweenTimingFunctionUIViewEaseIn) {
                        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                    } else if (operation.timingFunction == &AxcTweenTimingFunctionUIViewEaseOut) {
                        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                    } else if (operation.timingFunction == &AxcTweenTimingFunctionUIViewEaseInOut) {
                       [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    } else if (operation.timingFunction == &AxcTweenTimingFunctionUIViewLinear) {
                        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                    }
                    
                    [operation.boundObject setValue:toValue forKeyPath:propertyFormatted];
                    [UIView commitAnimations];
                    
                    goto complete;
                }
            }
        }
        
    }
    
complete:
    [tweenOperations addObject:operation];
    return operation;
}

#if NS_BLOCKS_AVAILABLE
- (AxcTweenOperation*)addTweenPeriod:(AxcTweenPeriod *)period 
                        updateBlock:(void (^)(AxcTweenPeriod *period))updateBlock 
                    completionBlock:(void (^)())completeBlock {
    return [self addTweenPeriod:period updateBlock:updateBlock completionBlock:completeBlock timingFunction:self.defaultTimingFunction];
}

- (AxcTweenOperation*)addTweenPeriod:(AxcTweenPeriod *)period 
                        updateBlock:(void (^)(AxcTweenPeriod *period))anUpdateBlock 
                    completionBlock:(void (^)())completeBlock 
                     timingFunction:(AxcTweenTimingFunction)timingFunction {
    
    AxcTweenOperation *tweenOperation = [AxcTweenOperation new] ;
    tweenOperation.period = period;
    tweenOperation.timingFunction = timingFunction;
    tweenOperation.updateBlock = anUpdateBlock;
    tweenOperation.completeBlock = completeBlock;
    return [self addTweenOperation:tweenOperation];
    
}
#endif

- (AxcTweenOperation*)addTweenPeriod:(AxcTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector {
    return [self addTweenPeriod:period target:target selector:selector timingFunction:self.defaultTimingFunction];
}

- (AxcTweenOperation*)addTweenPeriod:(AxcTweenPeriod *)period target:(NSObject *)target selector:(SEL)selector timingFunction:(AxcTweenTimingFunction)timingFunction {
    
    AxcTweenOperation *tweenOperation = [AxcTweenOperation new] ;
    tweenOperation.period = period;
    tweenOperation.target = target;
    tweenOperation.timingFunction = timingFunction;
    tweenOperation.updateSelector = selector;
    
    return [self addTweenOperation:tweenOperation];
    
}

- (void)removeTweenOperation:(AxcTweenOperation *)tweenOperation {
    if (tweenOperation != nil) {
        if ([tweenOperations containsObject:tweenOperation]) {
            [expiredTweenOperations addObject:tweenOperation];
        }
    }
}

+ (SEL)setterFromProperty:(NSString *)property {
    return NSSelectorFromString([NSString stringWithFormat:@"set%@:", [property stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[property substringToIndex:1] capitalizedString]]]);
}

- (void)update {
    timeOffset += kAxcTweenFramerate;
    
    for (AxcTweenOperation *tweenOperation in tweenOperations) {
        
        AxcTweenPeriod *period = tweenOperation.period;
        
        // if operation is delayed, pass over it for now
        if (timeOffset <= period.startOffset + period.delay) {
            continue;
        }
        
        CGFloat (*timingFunction)(CGFloat, CGFloat, CGFloat, CGFloat) = tweenOperation.timingFunction;
        if (timingFunction == NULL) {
            timingFunction = self.defaultTimingFunction;
        }
        
        if (timingFunction != NULL && tweenOperation.canUseBuiltAnimation == NO) {
            if (timeOffset <= period.startOffset + period.delay + period.duration) {
                if ([period isKindOfClass:[AxcTweenLerpPeriod class]]) {
                    if ([period conformsToProtocol:@protocol(AxcTweenLerpPeriod)]) {
                        AxcTweenLerpPeriod <AxcTweenLerpPeriod> *lerpPeriod = (AxcTweenLerpPeriod <AxcTweenLerpPeriod> *)period;
                        CGFloat progress = timingFunction(timeOffset - period.startOffset - period.delay, 0.0, 1.0, period.duration);
                        [lerpPeriod setProgress:progress];
                    } else {
                        // @TODO: Throw exception
                        NSLog(@"Class doesn't conform to AxcTweenLerp");
                    }
                } else {
                    // if tween operation is valid, calculate tweened value using timing function
                    period.tweenedValue = timingFunction(timeOffset - period.startOffset - period.delay, period.startValue, period.endValue - period.startValue, period.duration);
                }
            } else {
                // move expired tween operations to list for cleanup
                period.tweenedValue = period.endValue;
                [expiredTweenOperations addObject:tweenOperation];
            }
            
            NSObject *target = tweenOperation.target;
            SEL selector = tweenOperation.updateSelector;
            
            if (period != nil) {
                if (target != nil && selector != NULL) {
                    [target performSelector:selector withObject:period afterDelay:0];    
                }
                if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_4_0) {
                    if (tweenOperation.updateBlock != NULL) {
                        tweenOperation.updateBlock(period);
                    } 
                }
            }
        } else if (tweenOperation.canUseBuiltAnimation == YES) {
            if (timeOffset > period.startOffset + period.delay + period.duration) {
                [expiredTweenOperations addObject:tweenOperation];
            }
        }
    }
    for (AxcTweenOperation *tweenOperation in expiredTweenOperations) {
        
        if (tweenOperation.completeSelector) [tweenOperation.target performSelector:tweenOperation.completeSelector withObject:nil afterDelay:0];
        if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_4_0) {
            if (tweenOperation.completeBlock != NULL) {
                tweenOperation.completeBlock();
            }
        }
        [tweenOperations removeObject:tweenOperation];
    }
    [expiredTweenOperations removeAllObjects];
}


@end
