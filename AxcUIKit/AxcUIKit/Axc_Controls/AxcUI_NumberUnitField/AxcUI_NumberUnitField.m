//
//  AxcUI_NumberUnitField.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_NumberUnitField.h"

#define DEFAULT_CONTENT_SIZE_WITH_UNIT_COUNT(c) CGSizeMake(44 * c, 44)

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    NSNotificationName const NumberUnitFieldDidBecomeFirstResponderNotification = @"NumberUnitFieldDidBecomeFirstResponderNotification";
    NSNotificationName const NumberUnitFieldDidResignFirstResponderNotification = @"NumberUnitFieldDidResignFirstResponderNotification";
#else
    NSString *const NumberUnitFieldDidBecomeFirstResponderNotification = @"NumberUnitFieldDidBecomeFirstResponderNotification";
    NSString *const NumberUnitFieldDidResignFirstResponderNotification = @"NumberUnitFieldDidResignFirstResponderNotification";
#endif

@interface AxcUI_NumberUnitField () <UIKeyInput>

@property (nonatomic, strong) NSMutableArray *characterArray;
@property (nonatomic, strong) CALayer *cursorLayer;

@end

@implementation AxcUI_NumberUnitField
{
    UIColor *_backgroundColor;
    CGContextRef _ctx;
}

@dynamic axcUI_text;
@synthesize axcUI_secureTextEntry = _axcUI_secureTextEntry;
@synthesize enablesReturnKeyAutomatically = _enablesReturnKeyAutomatically;
@synthesize keyboardType = _keyboardType;
@synthesize returnKeyType = _returnKeyType;

#pragma mark - Life

- (instancetype)initWithInputUnitCount:(NSUInteger)count {
    if (self = [super initWithFrame:CGRectZero]) {
        NSCAssert(count > 0, @"AxcUI_NumberUnitField must have one or more input units.");
        NSCAssert(count <= 8, @"AxcUI_NumberUnitField can not have more than 8 input units.");
        
        _axcUI_inputUnitCount = count;
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _axcUI_inputUnitCount = 4;
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _axcUI_inputUnitCount = 4;
        [self initialize];
    }
    
    return self;
}

- (instancetype)init{
    if (self == [super init]) {
        _axcUI_inputUnitCount = 4;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [super setBackgroundColor:[UIColor clearColor]];
    _characterArray = [NSMutableArray array];
    _axcUI_secureTextEntry = NO;
    _axcUI_unitSpace = 12;
    _axcUI_borderRadius = 0;
    _axcUI_borderWidth = 1;
    _axcUI_textFont = [UIFont systemFontOfSize:22];
    _keyboardType = UIKeyboardTypeNumberPad;
    _returnKeyType = UIReturnKeyDone;
    _enablesReturnKeyAutomatically = YES;
    _axcUI_autoResignFirstResponderWhenInputFinished = NO;
    _axcUI_textColor = [UIColor darkGrayColor];
    _axcUI_tintColor = [UIColor lightGrayColor];
    _axcUI_trackTintColor = [UIColor orangeColor];
    _axcUI_cursorColor = [UIColor orangeColor];
    _backgroundColor = _backgroundColor ?: [UIColor clearColor];
    self.cursorLayer.backgroundColor = _axcUI_cursorColor.CGColor;
    

    [self.layer addSublayer:self.cursorLayer];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self setNeedsDisplay];
    }];
}

#pragma mark - Property

- (NSString *)axcUI_text {
    if (_characterArray.count == 0) return nil;
    return [_characterArray componentsJoinedByString:@""];
}

- (void)setAxcUI_text:(NSString *)text {
    
    [_characterArray removeAllObjects];
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (self.characterArray.count < self.axcUI_inputUnitCount)
            [self.characterArray addObject:substring];
        else
            *stop = YES;
    }];
    
    [self setNeedsDisplay];
}

- (CALayer *)cursorLayer {
    if (!_cursorLayer) {
        _cursorLayer = [CALayer layer];
        _cursorLayer.hidden = YES;
        _cursorLayer.opacity = 1;
        
        CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animate.fromValue = @(0);
        animate.toValue = @(1.5);
        animate.duration = 0.5;
        animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animate.autoreverses = YES;
        animate.removedOnCompletion = NO;
        animate.fillMode = kCAFillModeForwards;
        animate.repeatCount = HUGE_VALF;
        
        [_cursorLayer addAnimation:animate forKey:nil];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self layoutIfNeeded];
            
            _cursorLayer.position = CGPointMake(CGRectGetWidth(self.bounds) / _axcUI_inputUnitCount / 2, CGRectGetHeight(self.bounds) / 2);
        }];
    }
    
    return _cursorLayer;
}

- (void)setAxcUI_secureTextEntry:(BOOL)axcUI_secureTextEntry {
    _axcUI_secureTextEntry = axcUI_secureTextEntry;
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

#if TARGET_INTERFACE_BUILDER
- (void)setAxcUI_inputUnitCount:(NSUInteger)axcUI_inputUnitCount {
    if (axcUI_inputUnitCount < 1 || axcUI_inputUnitCount > 8) return;
    
    _axcUI_inputUnitCount = axcUI_inputUnitCount;
    [self setNeedsDisplay];
    [self _showOrHideCursorIfNeeded];
}
#endif

- (void)setAxcUI_unitSpace:(CGFloat)axcUI_unitSpace {
    if (axcUI_unitSpace < 0) return;
    if (axcUI_unitSpace < 2) axcUI_unitSpace = 0;
    
    _axcUI_unitSpace = axcUI_unitSpace;
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setAxcUI_textFont:(UIFont *)axcUI_textFont {
    if (axcUI_textFont == nil) {
        _axcUI_textFont = [UIFont systemFontOfSize:22];
    } else {
        _axcUI_textFont = axcUI_textFont;
    }
    
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setAxcUI_textColor:(UIColor *)axcUI_textColor {
    if (axcUI_textColor == nil) {
        _axcUI_textColor = [UIColor blackColor];
    } else {
        _axcUI_textColor = axcUI_textColor;
    }
    
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setAxcUI_borderRadius:(CGFloat)axcUI_borderRadius {
    if (axcUI_borderRadius < 0) return;
    
    _axcUI_borderRadius = axcUI_borderRadius;
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setAxcUI_borderWidth:(CGFloat)axcUI_borderWidth {
    if (axcUI_borderWidth < 0) return;
    
    _axcUI_borderWidth = axcUI_borderWidth;
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (backgroundColor == nil) {
        _backgroundColor = [UIColor blackColor];
    } else {
        _backgroundColor = backgroundColor;
    }
    
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setAxcUI_tintColor:(UIColor *)axcUI_tintColor {
    if (axcUI_tintColor == nil) {
        _axcUI_tintColor = [[UIView appearance] tintColor];
    } else {
        _axcUI_tintColor = axcUI_tintColor;
    }
    
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setAxcUI_trackTintColor:(UIColor *)axcUI_trackTintColor {
    _axcUI_trackTintColor = axcUI_trackTintColor;
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

- (void)setAxcUI_cursorColor:(UIColor *)axcUI_cursorColor {
    _axcUI_cursorColor = axcUI_cursorColor;
    _cursorLayer.backgroundColor = _axcUI_cursorColor.CGColor;
    [self _resetCursorStateIfNeeded];
}

#pragma mark- Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self becomeFirstResponder];
}

#pragma mark - Override

- (CGSize)intrinsicContentSize {
    [self layoutIfNeeded];
    CGSize size = self.bounds.size;
    
    if (size.width < DEFAULT_CONTENT_SIZE_WITH_UNIT_COUNT(_axcUI_inputUnitCount).width) {
        size.width = DEFAULT_CONTENT_SIZE_WITH_UNIT_COUNT(_axcUI_inputUnitCount).width;
    }
    
    CGFloat unitWidth = (size.width + _axcUI_unitSpace) / _axcUI_inputUnitCount - _axcUI_unitSpace;
    size.height = unitWidth;
    
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self intrinsicContentSize];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    BOOL result = [super becomeFirstResponder];
    [self _resetCursorStateIfNeeded];
    
    if (result ==  YES) {
        [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
        [[NSNotificationCenter defaultCenter] postNotificationName:NumberUnitFieldDidBecomeFirstResponderNotification
                                                            object:nil];
    }
    
    return result;
}

- (BOOL)canResignFirstResponder {
    return YES;
}

- (BOOL)resignFirstResponder {
    BOOL result = [super resignFirstResponder];
    [self _resetCursorStateIfNeeded];
    
    if (result) {
        [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
        [[NSNotificationCenter defaultCenter] postNotificationName:NumberUnitFieldDidResignFirstResponderNotification
                                                            object:nil];
    }
    
    return result;
}


- (void)drawRect:(CGRect)rect {
    /*
     *  绘制的线条具有宽度，因此在绘制时需要考虑该因素对绘制效果的影响。
     */
    CGSize unitSize = CGSizeMake((rect.size.width + _axcUI_unitSpace) / _axcUI_inputUnitCount - _axcUI_unitSpace, rect.size.height);
    
    _ctx = UIGraphicsGetCurrentContext();

    [self _fillRect:rect clip:YES];
    [self _drawBorder:rect unitSize:unitSize];
    [self _drawText:rect unitSize:unitSize];
    [self _drawTrackBorder:rect unitSize:unitSize];
    
    [self _resize];
}

#pragma mark- Private

/**
 在 AutoLayout 环境下重新指定控件本身的固有尺寸
 
 `-drawRect:`方法会计算控件完成自身的绘制所需的合适尺寸，完成一次绘制后会通知 AutoLayout 系统更新尺寸。
 */
- (void)_resize {
    [self invalidateIntrinsicContentSize];
}


/**
 绘制背景色，以及剪裁绘制区域

 @param rect 控件绘制的区域
 @param clip 剪裁区域同时被`axcUI_borderRadius`影响
 */
- (void)_fillRect:(CGRect)rect clip:(BOOL)clip {
    [_backgroundColor setFill];
    if (clip) {
        CGContextAddPath(_ctx, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_axcUI_borderRadius].CGPath);
        CGContextClip(_ctx);
    }
    CGContextAddPath(_ctx, [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, _axcUI_borderWidth * 0.75, _axcUI_borderWidth * 0.75) cornerRadius:_axcUI_borderRadius].CGPath);
    CGContextFillPath(_ctx);
}

/**
 绘制边框
 
 边框的绘制分为两种模式：连续和不连续。其模式的切换由`axcUI_unitSpace`属性决定。
 当`axcUI_unitSpace`值小于 2 时，采用的是连续模式，即每个 input unit 之间没有间隔。
 反之，每个 input unit 会被边框包围。
 
 @see axcUI_unitSpace
 
 @param rect 控件绘制的区域
 @param unitSize 单个 input unit 占据的尺寸
 */
- (void)_drawBorder:(CGRect)rect unitSize:(CGSize)unitSize {
    
    [self.axcUI_tintColor setStroke];
    CGContextSetLineWidth(_ctx, _axcUI_borderWidth);
    CGContextSetLineCap(_ctx, kCGLineCapRound);
    CGRect bounds = CGRectInset(rect, _axcUI_borderWidth * 0.5, _axcUI_borderWidth * 0.5);
    
    
    if (_axcUI_unitSpace < 2) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:_axcUI_borderRadius];
        CGContextAddPath(_ctx, bezierPath.CGPath);
        
        for (int i = 1; i < _axcUI_inputUnitCount; ++i) {
            CGContextMoveToPoint(_ctx, (i * unitSize.width), 0);
            CGContextAddLineToPoint(_ctx, (i * unitSize.width), (unitSize.height));
        }
        
    } else {
        for (int i = (int)_characterArray.count; i < _axcUI_inputUnitCount; i++) {
            CGRect unitRect = CGRectMake(i * (unitSize.width + _axcUI_unitSpace),
                                         0,
                                         unitSize.width,
                                         unitSize.height);
            unitRect = CGRectInset(unitRect, _axcUI_borderWidth * 0.5, _axcUI_borderWidth * 0.5);
            UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:unitRect cornerRadius:_axcUI_borderRadius];
            CGContextAddPath(_ctx, bezierPath.CGPath);
        }
    }
    CGContextDrawPath(_ctx, kCGPathStroke);
}


/**
 绘制文本
 
 当处于密文输入模式时，会用圆圈替代文本。

 @param rect 控件绘制的区域
 @param unitSize 单个 input unit 占据的尺寸
 */
- (void)_drawText:(CGRect)rect unitSize:(CGSize)unitSize {
    if ([self hasText] == NO) return;
    
    NSDictionary *attr = @{NSForegroundColorAttributeName: _axcUI_textColor,
                           NSFontAttributeName: _axcUI_textFont};
    
    for (int i = 0; i < _characterArray.count; i++) {
        
        CGRect unitRect = CGRectMake(i * (unitSize.width + _axcUI_unitSpace),
                                     0,
                                     unitSize.width,
                                     unitSize.height);
        
        
        if (_axcUI_secureTextEntry == NO) {
            NSString *subString = [_characterArray objectAtIndex:i];
            
            CGSize oneTextSize = [subString sizeWithAttributes:attr];
            CGRect drawRect = CGRectInset(unitRect,
                                   (unitRect.size.width - oneTextSize.width) / 2,
                                   (unitRect.size.height - oneTextSize.height) / 2);
            [subString drawInRect:drawRect withAttributes:attr];
        } else {
            CGRect drawRect = CGRectInset(unitRect,
                                          (unitRect.size.width - _axcUI_textFont.pointSize / 2) / 2,
                                          (unitRect.size.height - _axcUI_textFont.pointSize / 2) / 2);
            [_axcUI_textColor setFill];
            CGContextAddEllipseInRect(_ctx, drawRect);
            CGContextFillPath(_ctx);
        }
    }
    
}


/**
 绘制跟踪框，如果指定的`axcUI_trackTintColor`为 nil 则不绘制

 @param rect 控件绘制的区域
 @param unitSize 单个 input unit 占据的尺寸
 */
- (void)_drawTrackBorder:(CGRect)rect unitSize:(CGSize)unitSize {
    if (_axcUI_trackTintColor == nil) return;
    if (_axcUI_unitSpace < 2) return;
    
    
    [_axcUI_trackTintColor setStroke];
    CGContextSetLineWidth(_ctx, _axcUI_borderWidth);
    CGContextSetLineCap(_ctx, kCGLineCapRound);
    
    for (int i = 0; i < _characterArray.count; i++) {
        CGRect unitRect = CGRectMake(i * (unitSize.width + _axcUI_unitSpace),
                                     0,
                                     unitSize.width,
                                     unitSize.height);
        unitRect = CGRectInset(unitRect, _axcUI_borderWidth * 0.5, _axcUI_borderWidth * 0.5);
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:unitRect cornerRadius:_axcUI_borderRadius];
        CGContextAddPath(_ctx, bezierPath.CGPath);
    }
        
    CGContextDrawPath(_ctx, kCGPathStroke);
}

- (void)_resetCursorStateIfNeeded {
    _cursorLayer.hidden = !self.isFirstResponder || _axcUI_cursorColor == nil || _axcUI_inputUnitCount == _characterArray.count;
    
    if (_cursorLayer.hidden) return;
    
    CGSize unitSize = CGSizeMake((self.bounds.size.width + _axcUI_unitSpace) / _axcUI_inputUnitCount - _axcUI_unitSpace, self.bounds.size.height);
    
    CGRect unitRect = CGRectMake(_characterArray.count * (unitSize.width + _axcUI_unitSpace),
                                 0,
                                 unitSize.width,
                                 unitSize.height);
    unitRect = CGRectInset(unitRect,
                           unitRect.size.width / 2 - 1,
                           (unitRect.size.height - _axcUI_textFont.pointSize) / 2);
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationDuration:0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    _cursorLayer.frame = unitRect;
    [CATransaction commit];
}

#pragma mark - UIKeyInput

- (BOOL)hasText {
    return _characterArray != nil && _characterArray.count > 0;
}

- (void)insertText:(NSString *)text {
    if (_characterArray.count >= _axcUI_inputUnitCount) {
        if (_axcUI_autoResignFirstResponderWhenInputFinished == YES) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self resignFirstResponder];
            }];
        }
        return;
    }
    
    if ([text isEqualToString:@" "]) {
        return;
    }
    
    
    
    NSRange range;
    for (int i = 0; i < text.length; i += range.length) {
        range = [text rangeOfComposedCharacterSequenceAtIndex:i];
        [_characterArray addObject:[text substringWithRange:range]];
    }
    
    if (_characterArray.count >= _axcUI_inputUnitCount) {
        [_characterArray removeObjectsInRange:NSMakeRange(_axcUI_inputUnitCount, _characterArray.count - _axcUI_inputUnitCount)];
        [self sendActionsForControlEvents:UIControlEventEditingChanged];
        
        if (_axcUI_autoResignFirstResponderWhenInputFinished == YES) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self resignFirstResponder];
            }];
        }
    } else {
        [self sendActionsForControlEvents:UIControlEventEditingChanged];
    }
    
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
    if ([self.axcUI_numberFieldDelegate respondsToSelector:@selector(AxcUI_numberUnitField:shouldChangeCharactersInRange:replacementString:)]) {
        if ([self.axcUI_numberFieldDelegate AxcUI_numberUnitField:self shouldChangeCharactersInRange:NSMakeRange(_characterArray.count - 1, 1)
                   replacementString:text] == NO) {
            return;
        }
    }
}

- (void)deleteBackward {
    if ([self hasText] == NO)
        return;
    
    if ([self.axcUI_numberFieldDelegate respondsToSelector:@selector(AxcUI_numberUnitField:shouldChangeCharactersInRange:replacementString:)]) {
        if ([self.axcUI_numberFieldDelegate AxcUI_numberUnitField:self
       shouldChangeCharactersInRange:NSMakeRange(_characterArray.count - 1, 0)
                   replacementString:@""] == NO) {
            return;
        }
    }
    
    [_characterArray removeLastObject];
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    
    [self setNeedsDisplay];
    [self _resetCursorStateIfNeeded];
}

//- (UIKeyboardType)keyboardType {
//    return _defaultKeyboardType;
//    if (_defaultKeyboardType == WLKeyboardTypeASCIICapable) {
//        return UIKeyboardTypeASCIICapable;
//    }
//
//    return UIKeyboardTypeNumberPad;
//}
//
//- (UIReturnKeyType)returnKeyType {
//    return _defaultReturnKeyType;
//}

@end
