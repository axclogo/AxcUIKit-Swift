//
//  AxcUI_StarRatingView.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_StarRatingView.h"

@interface AxcUI_StarRatingView ()

@property (nonatomic, readonly) BOOL shouldUseImages;

@end

@implementation AxcUI_StarRatingView {
    CGFloat _axcUI_minimumValue;
    NSUInteger _axcUI_maximumValue;
    CGFloat _value;
    UIColor *_axcUI_starBorderColor;
}

@dynamic axcUI_minimumValue;
@dynamic axcUI_maximumValue;
@dynamic axcUI_value;
@dynamic shouldUseImages;
@dynamic axcUI_starBorderColor;

#pragma mark - Initialization

- (instancetype)init{
    if (self == [super init]) {
        [self _customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _customInit];
    }
    return self;
}

- (void)_customInit {
    self.exclusiveTouch = YES;
    _axcUI_minimumValue = 0;
    _axcUI_maximumValue = 5;
    _value = 0;
    _axcUI_spacing = 5.f;
    _axcUI_continuous = YES;
    _axcUI_starBorderWidth = 1.0f;
    _axcUI_emptyStarColor = [UIColor clearColor];
    
    [self _updateAppearanceForState:self.enabled];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setNeedsDisplay];
}

#pragma mark - Properties

- (UIColor *)backgroundColor {
    if ([super backgroundColor]) {
        return [super backgroundColor];
    } else {
        return self.isOpaque ? [UIColor whiteColor] : [UIColor clearColor];
    };
}

- (CGFloat)axcUI_minimumValue {
    return MAX(_axcUI_minimumValue, 0);
}

- (void)setAxcUI_minimumValue:(CGFloat)axcUI_minimumValue {
    if (_axcUI_minimumValue != axcUI_minimumValue) {
        _axcUI_minimumValue = axcUI_minimumValue;
        [self setNeedsDisplay];
    }
}

- (NSUInteger)axcUI_maximumValue {
    return MAX(_axcUI_minimumValue, _axcUI_maximumValue);
}

- (void)setAxcUI_maximumValue:(NSUInteger)axcUI_maximumValue {
    if (_axcUI_maximumValue != axcUI_maximumValue) {
        _axcUI_maximumValue = axcUI_maximumValue;
        [self setNeedsDisplay];
        [self invalidateIntrinsicContentSize];
    }
}

- (CGFloat)axcUI_value {
    return MIN(MAX(_value, _axcUI_minimumValue), _axcUI_maximumValue);
}

- (void)setAxcUI_value:(CGFloat)value {
    [self setValue:value sendValueChangedAction:NO];
}

- (void)setValue:(CGFloat)value sendValueChangedAction:(BOOL)sendAction {
    [self willChangeValueForKey:NSStringFromSelector(@selector(value))];
    if (_value != value && value >= _axcUI_minimumValue && value <= _axcUI_maximumValue) {
        _value = value;
        if (sendAction) [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self setNeedsDisplay];
    }
    [self didChangeValueForKey:NSStringFromSelector(@selector(value))];
}

- (void)setAxcUI_spacing:(CGFloat)axcUI_spacing {
    _axcUI_spacing = MAX(axcUI_spacing, 0);
    [self setNeedsDisplay];
}

- (void)setAxcUI_allowsHalfStars:(BOOL)axcUI_allowsHalfStars {
    if (_axcUI_allowsHalfStars != axcUI_allowsHalfStars) {
        _axcUI_allowsHalfStars = axcUI_allowsHalfStars;
        [self setNeedsDisplay];
    }
}

- (void)setAxcUI_accurateHalfStars:(BOOL)axcUI_accurateHalfStars {
    if (_axcUI_accurateHalfStars != axcUI_accurateHalfStars) {
        _axcUI_accurateHalfStars = axcUI_accurateHalfStars;
        self.axcUI_allowsHalfStars = YES;
        [self setNeedsDisplay];
    }
}

- (void)setAxcUI_emptyStarImage:(UIImage *)axcUI_emptyStarImage {
    if (_axcUI_emptyStarImage != axcUI_emptyStarImage) {
        _axcUI_emptyStarImage = axcUI_emptyStarImage;
        [self setNeedsDisplay];
    }
}

- (void)setAxcUI_halfStarImage:(UIImage *)axcUI_halfStarImage {
    if (_axcUI_halfStarImage != axcUI_halfStarImage) {
        _axcUI_halfStarImage = axcUI_halfStarImage;
        [self setNeedsDisplay];
    }
}

- (void)setAxcUI_filledStarImage:(UIImage *)axcUI_filledStarImage {
    if (_axcUI_filledStarImage != axcUI_filledStarImage) {
        _axcUI_filledStarImage = axcUI_filledStarImage;
        [self setNeedsDisplay];
    }
}

- (void)setAxcUI_emptyStarColor:(UIColor *)axcUI_emptyStarColor {
    if (_axcUI_emptyStarColor != axcUI_emptyStarColor) {
        _axcUI_emptyStarColor = axcUI_emptyStarColor;
        [self setNeedsDisplay];
    }
}

- (void)setAxcUI_starBorderColor:(UIColor *)axcUI_starBorderColor {
    if (_axcUI_starBorderColor != axcUI_starBorderColor) {
        _axcUI_starBorderColor = axcUI_starBorderColor;
        [self setNeedsDisplay];
    }
}

- (UIColor *)axcUI_starBorderColor {
    if (_axcUI_starBorderColor == nil) {
        return self.tintColor;
    } else {
        return _axcUI_starBorderColor;
    }
}

- (void)setAxcUI_starBorderWidth:(CGFloat)axcUI_starBorderWidth {
    _axcUI_starBorderWidth = MAX(0, axcUI_starBorderWidth);
    [self setNeedsDisplay];
}


- (BOOL)shouldUseImages {
    return (self.axcUI_emptyStarImage!=nil && self.axcUI_filledStarImage!=nil);
}

#pragma mark - State

- (void)setEnabled:(BOOL)enabled
{
    [self _updateAppearanceForState:enabled];
    [super setEnabled:enabled];
}

- (void)_updateAppearanceForState:(BOOL)enabled
{
    self.alpha = enabled ? 1.f : .5f;
}

#pragma mark - Image Drawing

- (void)_drawStarImageWithFrame:(CGRect)frame tintColor:(UIColor*)tintColor highlighted:(BOOL)highlighted {
    UIImage *image = highlighted ? self.axcUI_filledStarImage : self.axcUI_emptyStarImage;
    [self _drawImage:image frame:frame tintColor:tintColor];
}

- (void)_drawaxcUI_halfStarImageWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
    [self _drawAccurateaxcUI_halfStarImageWithFrame:frame tintColor:tintColor progress:.5f];
}

- (void)_drawAccurateaxcUI_halfStarImageWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor progress:(CGFloat)progress {
    UIImage *image = self.axcUI_halfStarImage;
    if (image == nil) {
        // first draw star outline
        [self _drawStarImageWithFrame:frame tintColor:tintColor highlighted:NO];
        
        image = self.axcUI_filledStarImage;
        CGRect imageFrame = CGRectMake(0, 0, image.size.width * image.scale * progress, image.size.height * image.scale);
        frame.size.width *= progress;
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, imageFrame);
        UIImage *halfImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
        image = [halfImage imageWithRenderingMode:image.renderingMode];
        CGImageRelease(imageRef);
    }
    [self _drawImage:image frame:frame tintColor:tintColor];
}

- (void)_drawImage:(UIImage *)image frame:(CGRect)frame tintColor:(UIColor *)tintColor {
    if (image.renderingMode == UIImageRenderingModeAlwaysTemplate) {
        [tintColor setFill];
    }
    [image drawInRect:frame];
}

#pragma mark - Shape Drawing

- (void)_drawStarShapeWithFrame:(CGRect)frame tintColor:(UIColor*)tintColor highlighted:(BOOL)highlighted {
    [self _drawaxcUI_accurateHalfStarshapeWithFrame:frame tintColor:tintColor progress:highlighted ? 1.f : 0.f];
}

- (void)_drawHalfStarShapeWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
    [self _drawaxcUI_accurateHalfStarshapeWithFrame:frame tintColor:tintColor progress:.5f];
}

- (void)_drawaxcUI_accurateHalfStarshapeWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor progress:(CGFloat)progress {
    UIBezierPath* starShapePath = UIBezierPath.bezierPath;
    [starShapePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62723 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.02500 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.37292 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.02500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39112 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.30504 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62908 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.20642 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.97500 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.78265 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.79358 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.97500 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.69501 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.62908 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.97500 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.39112 * CGRectGetHeight(frame))];
    [starShapePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.62723 * CGRectGetWidth(frame), CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame))];
    [starShapePath closePath];
    starShapePath.miterLimit = 4;
    
    CGFloat frameWidth = frame.size.width;
    CGRect rightRectOfStar = CGRectMake(frame.origin.x + progress * frameWidth, frame.origin.y, frameWidth - progress * frameWidth, frame.size.height);
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:CGRectInfinite];
    [clipPath appendPath:[UIBezierPath bezierPathWithRect:rightRectOfStar]];
    clipPath.usesEvenOddFillRule = YES;
    
    [_axcUI_emptyStarColor setFill];
    [starShapePath fill];
    
    CGContextSaveGState(UIGraphicsGetCurrentContext()); {
        [clipPath addClip];
        [tintColor setFill];
        [starShapePath fill];
    }
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
    
    [self.axcUI_starBorderColor setStroke];
    starShapePath.lineWidth = _axcUI_starBorderWidth;
    [starShapePath stroke];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    CGFloat availableWidth = rect.size.width - (_axcUI_spacing * (_axcUI_maximumValue - 1)) - 2;
    CGFloat cellWidth = (availableWidth / _axcUI_maximumValue);
    CGFloat starSide = (cellWidth <= rect.size.height) ? cellWidth : rect.size.height;
    starSide = (self.shouldUseImages) ? starSide : (starSide - _axcUI_starBorderWidth);
    
    for (int idx = 0; idx < _axcUI_maximumValue; idx++) {
        CGPoint center = CGPointMake(cellWidth*idx + cellWidth/2 + _axcUI_spacing*idx + 1, rect.size.height/2);
        CGRect frame = CGRectMake(center.x - starSide/2, center.y - starSide/2, starSide, starSide);
        BOOL highlighted = (idx+1 <= ceilf(_value));
        if (_axcUI_allowsHalfStars && highlighted && (idx+1 > _value)) {
            if (_axcUI_accurateHalfStars) {
                [self _drawAccurateStarWithFrame:frame tintColor:self.tintColor progress:_value - idx];
            }
            else {
                 [self _drawHalfStarWithFrame:frame tintColor:self.tintColor];
            }
        } else {
            [self _drawStarWithFrame:frame tintColor:self.tintColor highlighted:highlighted];
        }
    }
}

- (void)_drawStarWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor highlighted:(BOOL)highlighted {
    if (self.shouldUseImages) {
        [self _drawStarImageWithFrame:frame tintColor:tintColor highlighted:highlighted];
    } else {
        [self _drawStarShapeWithFrame:frame tintColor:tintColor highlighted:highlighted];
    }
}

- (void)_drawHalfStarWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
    if (self.shouldUseImages) {
        [self _drawaxcUI_halfStarImageWithFrame:frame tintColor:tintColor];
    } else {
        [self _drawHalfStarShapeWithFrame:frame tintColor:tintColor];
    }
}
- (void)_drawAccurateStarWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor progress:(CGFloat)progress {
    if (self.shouldUseImages) {
        [self _drawAccurateaxcUI_halfStarImageWithFrame:frame tintColor:tintColor progress:progress];
    } else {
        [self _drawaxcUI_accurateHalfStarshapeWithFrame:frame tintColor:tintColor progress:progress];
    }
}
#pragma mark - Touches

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.isEnabled) {
        [super beginTrackingWithTouch:touch withEvent:event];
        if (_axcUI_shouldBecomeFirstResponder && ![self isFirstResponder]) {
            [self becomeFirstResponder];
        }
        [self _handleTouch:touch];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.isEnabled) {
        [super continueTrackingWithTouch:touch withEvent:event];
        [self _handleTouch:touch];
        return YES;
    } else {
        return NO;
    }
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    if (_axcUI_shouldBecomeFirstResponder && [self isFirstResponder]) {
        [self resignFirstResponder];
    }
    [self _handleTouch:touch];
    if (!_axcUI_continuous) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    if (_axcUI_shouldBecomeFirstResponder && [self isFirstResponder]) {
        [self resignFirstResponder];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.view isEqual:self]) {
        return !self.isUserInteractionEnabled;
    }
    return NO;
}

- (void)_handleTouch:(UITouch *)touch {
    CGFloat cellWidth = self.bounds.size.width / _axcUI_maximumValue;
    CGPoint location = [touch locationInView:self];
    CGFloat value = location.x / cellWidth;
    if (_axcUI_allowsHalfStars) {
        if (_axcUI_accurateHalfStars) {
            value = value;
        }
        else {
            if (value+.5f < ceilf(value)) {
                value = floor(value)+.5f;
            } else {
                value = ceilf(value);
            }
        }
    } else {
        value = ceilf(value);
    }
    [self setValue:value sendValueChangedAction:_axcUI_continuous];
}

#pragma mark - First responder

- (BOOL)canBecomeFirstResponder {
    return _axcUI_shouldBecomeFirstResponder;
}

#pragma mark - Intrinsic Content Size

- (CGSize)intrinsicContentSize {
    CGFloat height = 44.f;
    return CGSizeMake(_axcUI_maximumValue * height + (_axcUI_maximumValue-1) * _axcUI_spacing, height);
}

#pragma mark - Accessibility

- (BOOL)isAccessibilityElement {
    return YES;
}

- (NSString *)accessibilityLabel {
    return [super accessibilityLabel] ?: NSLocalizedString(@"Rating", @"Accessibility label for star rating control.");
}

- (UIAccessibilityTraits)accessibilityTraits {
    return ([super accessibilityTraits] | UIAccessibilityTraitAdjustable);
}

- (NSString *)accessibilityValue {
    return [@(self.axcUI_value) description];
}

- (BOOL)accessibilityActivate {
    return YES;
}

- (void)accessibilityIncrement {
    CGFloat value = self.axcUI_value + (self.axcUI_allowsHalfStars ? .5f : 1.f);
    [self setValue:value sendValueChangedAction:YES];
}

- (void)accessibilityDecrement {
    CGFloat value = self.axcUI_value - (self.axcUI_allowsHalfStars ? .5f : 1.f);
    [self setValue:value sendValueChangedAction:YES];
}

@end
