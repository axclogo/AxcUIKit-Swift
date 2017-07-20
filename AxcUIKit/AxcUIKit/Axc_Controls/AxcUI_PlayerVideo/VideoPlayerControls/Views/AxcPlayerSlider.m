//
//  AxcPlayerTimeSlider.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerSlider.h"

static NSArray *AxcPlayerTimeSliderObservedKeyPaths() {
    static NSArray *_AxcPlayerTimeSliderObservedKeyPaths = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _AxcPlayerTimeSliderObservedKeyPaths = @[NSStringFromSelector(@selector(maximumTrackTintColor)),
                                                NSStringFromSelector(@selector(loadedTrackTintColor)),
                                                NSStringFromSelector(@selector(tintColor)),
                                                NSStringFromSelector(@selector(thumbTintColor)),
                                                NSStringFromSelector(@selector(thumbSize)),
                                                NSStringFromSelector(@selector(trackSize))];
    });
    
    return _AxcPlayerTimeSliderObservedKeyPaths;
}

static void *AxcPlayerTimeSliderObserverContext = &AxcPlayerTimeSliderObserverContext;

@interface AxcPlayerSlider ()

@property (nonatomic, strong) CALayer *thumbLayer;
@property (nonatomic, strong) CALayer *valueLayer;
@property (nonatomic, strong) CALayer *maxValueLayer;
@property (nonatomic, strong) CALayer *loadedValueLayer;

@end

@implementation AxcPlayerSlider

- (instancetype)init {
    self = [super init];
    if (self) {
        _value = 0;
        _loadedValue = 0;
        _maximumValue = 1;
        
        _maximumTrackTintColor = [UIColor colorWithWhite:0.5 alpha:1];
        _loadedTrackTintColor = [UIColor colorWithWhite:0.8 alpha:1];
        _tintColor = [UIColor whiteColor];
        _thumbTintColor = [UIColor whiteColor];
        _thumbSize = 8;
        _trackSize = 2;
        
        _continuous = YES;
        
        self.userInteractionEnabled = YES;
        
        [self updateDisplay];
        
        [self.layer addSublayer:self.maxValueLayer];
        [self.layer addSublayer:self.loadedValueLayer];
        [self.layer addSublayer:self.valueLayer];
        [self.layer addSublayer:self.thumbLayer];
        
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
        
        for (NSString *keyPath in AxcPlayerTimeSliderObservedKeyPaths()) {
            if ([self respondsToSelector:NSSelectorFromString(keyPath)]) {
                [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:AxcPlayerTimeSliderObserverContext];
            }
        }
    }
    return self;
}

- (void)dealloc {
    for (NSString *keyPath in AxcPlayerTimeSliderObservedKeyPaths()) {
        if ([self respondsToSelector:NSSelectorFromString(keyPath)]) {
            [self removeObserver:self forKeyPath:keyPath context:AxcPlayerTimeSliderObserverContext];
        }
    }
}

#pragma mark - NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(__unused id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AxcPlayerTimeSliderObserverContext) {
        if ([keyPath hasSuffix:@"Color"]) {
            [self updateDisplay];
        } else if ([keyPath hasSuffix:@"Size"]) {
            [self setNeedsLayout];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [CATransaction setDisableActions:YES];
    
    self.maxValueLayer.frame = CGRectMake(0, self.bounds.size.height/2 - self.trackSize/2, self.bounds.size.width, self.trackSize);
    self.maxValueLayer.cornerRadius = self.trackSize/2;
    
    CGRect loadedValueLayerFrame = self.loadedValueLayer.frame;
    loadedValueLayerFrame.origin.y = self.bounds.size.height/2 - self.trackSize/2;
    loadedValueLayerFrame.size.width = self.bounds.size.width * (self.loadedValue / self.maximumValue);
    loadedValueLayerFrame.size.height = self.trackSize;
    self.loadedValueLayer.frame = loadedValueLayerFrame;
    self.loadedValueLayer.cornerRadius = self.trackSize/2;
    
    CGRect valueLayerFrame = self.valueLayer.frame;
    valueLayerFrame.origin.y = self.bounds.size.height/2 - self.trackSize/2;
    valueLayerFrame.size.width = self.bounds.size.width * (self.value / self.maximumValue);
    valueLayerFrame.size.height = self.trackSize;
    self.valueLayer.frame = valueLayerFrame;
    self.valueLayer.cornerRadius = self.trackSize/2;
    
    CGRect thumbLayerFrame = self.thumbLayer.frame;
    thumbLayerFrame.origin.y = self.bounds.size.height/2 - self.thumbSize/2;
    thumbLayerFrame.size = CGSizeMake(self.thumbSize, self.thumbSize);
    self.thumbLayer.frame = thumbLayerFrame;
    self.thumbLayer.cornerRadius = self.thumbSize/2;
    
    CGPoint thumbLayerPosition = self.thumbLayer.position;
    thumbLayerPosition.x = self.bounds.size.width * (self.value / self.maximumValue);
    self.thumbLayer.position = thumbLayerPosition;
    
    [CATransaction setDisableActions:NO];
}

- (void)setValue:(float)value animated:(BOOL)animated {
    if (!animated) {
        [CATransaction setDisableActions:YES];
    }
    
    self.value = value;
    
    [CATransaction setDisableActions:NO];
}

- (void)updateDisplay {
    self.maxValueLayer.backgroundColor = self.maximumTrackTintColor.CGColor;
    self.loadedValueLayer.backgroundColor = self.loadedTrackTintColor.CGColor;
    self.valueLayer.backgroundColor = self.tintColor.CGColor;
    self.thumbLayer.backgroundColor = self.thumbTintColor.CGColor;
}

#pragma mark - selector

- (void)tap:(UITapGestureRecognizer *)gr {
    CGFloat locationX = [gr locationInView:self].x;
    [CATransaction setDisableActions:YES];
    self.value = locationX / self.bounds.size.width * self.maximumValue;
    [CATransaction setDisableActions:NO];
    
    [self sendActionsForControlEvents:UIControlEventTouchDown];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)pan:(UIPanGestureRecognizer *)gr {
    
    CGFloat locationX = [gr locationInView:self].x;
    if (locationX < 0) locationX = 0;
    if (locationX > self.bounds.size.width) locationX = self.bounds.size.width;
    
    [CATransaction setDisableActions:YES];
    self.value = locationX / self.bounds.size.width * self.maximumValue;
    [CATransaction setDisableActions:NO];
    
    if (gr.state == UIGestureRecognizerStateBegan) {
        [self sendActionsForControlEvents:UIControlEventTouchDown];
    } else if (gr.state == UIGestureRecognizerStateChanged) {
        if (self.continuous) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    } else {
        if (!self.continuous) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - getters setters

- (void)setValue:(float)value {
    _value = value;
    
    [CATransaction setDisableActions:YES];
    
    CGRect valueLayerFrame = self.valueLayer.frame;
    valueLayerFrame.size.width = self.bounds.size.width * (value / self.maximumValue);
    self.valueLayer.frame = valueLayerFrame;
    
    CGPoint thumbLayerPosition = self.thumbLayer.position;
    thumbLayerPosition.x = self.bounds.size.width * (self.value / self.maximumValue);
    self.thumbLayer.position = thumbLayerPosition;
    
    [CATransaction setDisableActions:NO];
}

- (void)setLoadedValue:(float)loadedValue {
    _loadedValue = loadedValue;
    
    [CATransaction setDisableActions:YES];
    
    CGRect loadedValueLayerFrame = self.loadedValueLayer.frame;
    loadedValueLayerFrame.size.width = self.bounds.size.width * (loadedValue / self.maximumValue);
    self.loadedValueLayer.frame = loadedValueLayerFrame;
    
    [CATransaction setDisableActions:NO];
}

- (CALayer *)valueLayer {
    if (_valueLayer == nil) {
        _valueLayer = [CALayer layer];
    }
    return _valueLayer;
}

- (CALayer *)maxValueLayer {
    if (_maxValueLayer == nil) {
        _maxValueLayer = [CALayer layer];
    }
    return _maxValueLayer;
}

- (CALayer *)loadedValueLayer {
    if (_loadedValueLayer == nil) {
        _loadedValueLayer = [CALayer layer];
    }
    return _loadedValueLayer;
}

- (CALayer *)thumbLayer {
    if (_thumbLayer == nil) {
        _thumbLayer = [CALayer layer];
        _thumbLayer.cornerRadius = self.thumbSize/2;
        _thumbLayer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return _thumbLayer;
}

@end
