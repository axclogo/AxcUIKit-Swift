//
//  AxcBadgeView.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/14.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_BadgeView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AxcUI_BadgeView{
    BOOL autoSetCorner_Radius;
    CATextLayer *textLayer;
    CAShapeLayer *borderLayer;
    CAShapeLayer *backgroundLayer;
    CAShapeLayer *glossMaskLayer;
    CAGradientLayer *glossLayer;
}

- (id)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    // 设置视图的属性
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.clipsToBounds = NO;
    
    // 设置默认
    _axcUI_textColor = [UIColor whiteColor];
    _axcUI_textaxcUI_alignmentShift = CGSizeZero;
    _axcUI_font = [UIFont systemFontOfSize:16.0];
    _axcUI_badgeBackgroundColor = [UIColor redColor];
    _axcUI_showGloss = NO;
    _axcUI_cornerRadius = self.frame.size.height / 2;
    _axcUI_horizontalStyle = AxcBadgeViewHorizontalStyleRight;
    _axcUI_verticalStyle = AxcBadgeViewVerticalStyleTop;
    _axcUI_alignmentShift = CGSizeMake(0, 0);
    _axcUI_animateChanges = YES;
    _axcUI_animationDuration = 0.2;
    _axcUI_borderWidth = 0.0;
    _axcUI_borderColor = [UIColor whiteColor];
    _axcUI_shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    _axcUI_shadowOffset = CGSizeMake(1.0, 1.0);
    _axcUI_shadowRadius = 1.0;
    _axcUI_shadowText = NO;
    _axcUI_shadowBorder = NO;
    _axcUI_shadowBadge = NO;
    _axcUI_hidesWhenZero = NO;
    _axcUI_pixelPerfectText = YES;
    
    // 必要时设置最小宽度/高度
    if (self.frame.size.height == 0 ) {
        CGRect frame = self.frame;
        frame.size.height = 24.0;
        _axcUI_minimumWidth = 24.0;
        self.frame = frame;
    } else {
        _axcUI_minimumWidth = self.frame.size.height;
    }
    
    _axcUI_maximumWidth = CGFLOAT_MAX;
    
    // 创建文本图层
    textLayer = [CATextLayer layer];
    textLayer.foregroundColor = _axcUI_textColor.CGColor;
    textLayer.font = (__bridge CFTypeRef)(_axcUI_font.fontName);
    textLayer.fontSize = _axcUI_font.pointSize;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.truncationMode = kCATruncationEnd;
    textLayer.wrapped = NO;
    textLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    // 创建边界图层
    borderLayer = [CAShapeLayer layer];
    borderLayer.strokeColor = _axcUI_borderColor.CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.lineWidth = _axcUI_borderWidth;
    borderLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    borderLayer.contentsScale = [UIScreen mainScreen].scale;
    
    // 创建背景图层
    backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.fillColor = _axcUI_badgeBackgroundColor.CGColor;
    backgroundLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    backgroundLayer.contentsScale = [UIScreen mainScreen].scale;
    
    // 创建光泽层
    glossLayer = [CAGradientLayer layer];
    glossLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    glossLayer.contentsScale = [UIScreen mainScreen].scale;
    glossLayer.colors = @[(id)[UIColor colorWithWhite:1 alpha:.8].CGColor,(id)[UIColor colorWithWhite:1 alpha:.25].CGColor, (id)[UIColor colorWithWhite:1 alpha:0].CGColor];
    glossLayer.startPoint = CGPointMake(0, 0);
    glossLayer.endPoint = CGPointMake(0, .6);
    glossLayer.locations = @[@0, @0.8, @1];
    glossLayer.type = kCAGradientLayerAxial;
    
    // Ctreate光泽的屏蔽层
    glossMaskLayer = [CAShapeLayer layer];
    glossMaskLayer.fillColor = [UIColor blackColor].CGColor;
    glossMaskLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    glossMaskLayer.contentsScale = [UIScreen mainScreen].scale;
    glossLayer.mask = glossMaskLayer;
    
    [self.layer addSublayer:backgroundLayer];
    [self.layer addSublayer:borderLayer];
    [self.layer addSublayer:textLayer];
    
    // 设置动画
    CABasicAnimation *frameAnimation = [CABasicAnimation animation];
    frameAnimation.duration = _axcUI_animationDuration;
    frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSDictionary *actions = @{@"path": frameAnimation};
    
    // 动画路径变化
    backgroundLayer.actions = actions;
    borderLayer.actions = actions;
    glossMaskLayer.actions = actions;
}

#pragma mark layout

- (void)autoSetBadgeFrame{
    CGRect frame = self.frame;
    
    // 得到当前字符串的宽度
    frame.size.width = [self sizeForString:_axcUI_text includeBuffer:YES].width;
    if (frame.size.width < _axcUI_minimumWidth) {
        frame.size.width = _axcUI_minimumWidth;
    } else if (frame.size.width > _axcUI_maximumWidth) {
        frame.size.width = _axcUI_maximumWidth;
    }
    
    // 高度不需要改变
    
    // 必要时修正水平对齐
    if (_axcUI_horizontalStyle == AxcBadgeViewHorizontalStyleLeft) {
        frame.origin.x = 0 - (frame.size.width / 2) + _axcUI_alignmentShift.width;
    } else if (_axcUI_horizontalStyle == AxcBadgeViewHorizontalStyleCenter) {
        frame.origin.x = (self.superview.bounds.size.width / 2) - (frame.size.width / 2) + _axcUI_alignmentShift.width;
    } else if (_axcUI_horizontalStyle == AxcBadgeViewHorizontalStyleRight) {
        frame.origin.x = self.superview.bounds.size.width - (frame.size.width / 2) + _axcUI_alignmentShift.width;
    }
    
    // 必要时修正垂直对齐
    if (_axcUI_verticalStyle == AxcBadgeViewVerticalStyleTop) {
        frame.origin.y = 0 - (frame.size.height / 2) + _axcUI_alignmentShift.height;
    } else if (_axcUI_verticalStyle == AxcBadgeViewVerticalStyleMiddle) {
        frame.origin.y = (self.superview.bounds.size.height / 2) - (frame.size.height / 2.0) + _axcUI_alignmentShift.height;
    } else if (_axcUI_verticalStyle == AxcBadgeViewVerticalStyleBottom) {
        frame.origin.y = self.superview.bounds.size.height - (frame.size.height / 2.0) + _axcUI_alignmentShift.height;
    }
    
    // 设置圆角半径
    if (autoSetCorner_Radius) {
        _axcUI_cornerRadius = self.frame.size.height / 2;
    }
    
    // 如果我们像素完美,不去限制
    if (_axcUI_pixelPerfectText) {
        CGFloat roundScale = 1 / [UIScreen mainScreen].scale;
        frame = CGRectMake(roundf(frame.origin.x / roundScale) * roundScale,
                           roundf(frame.origin.y / roundScale) * roundScale,
                           roundf(frame.size.width / roundScale) * roundScale,
                           roundf(frame.size.height / roundScale) * roundScale);
    }
    
    // 改变frame
    self.frame = frame;
    CGRect tempFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    backgroundLayer.frame = tempFrame;
    CGRect textFrame;
    if (_axcUI_pixelPerfectText) {
        CGFloat roundScale = 1 / [UIScreen mainScreen].scale;
        textFrame = CGRectMake(self.axcUI_textaxcUI_alignmentShift.width,
                              (roundf(((self.frame.size.height - _axcUI_font.lineHeight) / 2) / roundScale) * roundScale) + self.axcUI_textaxcUI_alignmentShift.height,
                              self.frame.size.width,
                              _axcUI_font.lineHeight);
    } else {
        textFrame = CGRectMake(self.axcUI_textaxcUI_alignmentShift.width, ((self.frame.size.height - _axcUI_font.lineHeight) / 2) + self.axcUI_textaxcUI_alignmentShift.height, self.frame.size.width, _axcUI_font.lineHeight);
    }
    textLayer.frame = textFrame;
    glossLayer.frame = tempFrame;
    glossMaskLayer.frame = tempFrame;
    borderLayer.frame = tempFrame;
    // 更新层的路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tempFrame cornerRadius:_axcUI_cornerRadius];
    backgroundLayer.path = path.CGPath;
    borderLayer.path = path.CGPath;
    // 插图不显示掩盖边境
    glossMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, _axcUI_borderWidth / 2.0, _axcUI_borderWidth / 2.0) cornerRadius:_axcUI_cornerRadius].CGPath;
}

- (CGSize)sizeForString:(NSString *)string includeBuffer:(BOOL)include{
    if (!_axcUI_font) {
        return CGSizeMake(0, 0);
    }
    // 计算文本的宽度
    CGFloat widthPadding;
    if (_axcUI_pixelPerfectText) {
        CGFloat roundScale = 1 / [UIScreen mainScreen].scale;
        widthPadding = roundf((_axcUI_font.pointSize * .375) / roundScale) * roundScale;
    } else {
        widthPadding = _axcUI_font.pointSize * .375;
    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:(string ? string : @"") attributes:@{NSFontAttributeName : _axcUI_font}];
                                                                                                          
    CGSize textSize = [attributedString boundingRectWithSize:(CGSize){CGFLOAT_MAX, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    if (include) {
        textSize.width += widthPadding * 2;
    }
    // 约束到整数
    if (_axcUI_pixelPerfectText) {
        CGFloat roundScale = 1 / [UIScreen mainScreen].scale;
        textSize.width = roundf(textSize.width / roundScale) * roundScale;
        textSize.height = roundf(textSize.height / roundScale) * roundScale;
    }
    return textSize;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 更新层的frame
    CGRect textFrame;
    if (_axcUI_pixelPerfectText) {
        CGFloat roundScale = 1 / [UIScreen mainScreen].scale;
        textFrame = CGRectMake(self.axcUI_textaxcUI_alignmentShift.width,
                               (roundf(((self.frame.size.height - _axcUI_font.lineHeight) / 2) / roundScale) * roundScale) + self.axcUI_textaxcUI_alignmentShift.height,
                               self.frame.size.width,
                               _axcUI_font.lineHeight);
    } else {
        textFrame = CGRectMake(self.axcUI_textaxcUI_alignmentShift.width, ((self.frame.size.height - _axcUI_font.lineHeight) / 2) + self.axcUI_textaxcUI_alignmentShift.height, self.frame.size.width, _axcUI_font.lineHeight);
    }
    textLayer.frame = textFrame;
    backgroundLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    glossLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    glossMaskLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    borderLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);;
    
    // 更新层的路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_axcUI_cornerRadius];
    backgroundLayer.path = path.CGPath;
    borderLayer.path = path.CGPath;
    glossMaskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, _axcUI_borderWidth/2, _axcUI_borderWidth/2) cornerRadius:_axcUI_cornerRadius].CGPath;
}

#pragma mark 重写Set

- (void)setAxcUI_text:(NSString *)axcUI_text{
    _axcUI_text = axcUI_text;
    // 如果新的文本比较短,减少显示新的文本宽度
    if ([self sizeForString:textLayer.string includeBuffer:YES].width >=
        [self sizeForString:axcUI_text includeBuffer:YES].width) {
        textLayer.string = axcUI_text;
        [self setNeedsDisplay];
    } else {
        // 如果不再显示动画后新的文本
        if (_axcUI_animateChanges) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_axcUI_animationDuration * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                textLayer.string = axcUI_text;
            });
        } else {
            textLayer.string = axcUI_text;
        }
    }
    // 更新大小
    [self autoSetBadgeFrame];
    // 检测是否为0
    [self hideForZeroIfNeeded];
}

- (void)setAxcUI_textColor:(UIColor *)axcUI_textColor{
    _axcUI_textColor = axcUI_textColor;
    textLayer.foregroundColor = _axcUI_textColor.CGColor;
}

- (void)setAxcUI_font:(UIFont *)axcUI_font{
    _axcUI_font = axcUI_font;
    textLayer.fontSize = axcUI_font.pointSize;
    textLayer.font = (__bridge CFTypeRef)(axcUI_font.fontName);
    // 需要改变以匹配新的字体
    [self autoSetBadgeFrame];
}

- (void)setAxcUI_animateChanges:(BOOL)axcUI_animateChanges{
    _axcUI_animateChanges = axcUI_animateChanges;
    if (_axcUI_animateChanges) {
        // 设置动画
        CABasicAnimation *frameAnimation = [CABasicAnimation animation];
        frameAnimation.duration = _axcUI_animationDuration;
        frameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        NSDictionary *actions = @{@"path": frameAnimation};
        
        // 动画路径变化
        backgroundLayer.actions = actions;
        borderLayer.actions = actions;
        glossMaskLayer.actions = actions;
    } else {
        backgroundLayer.actions = nil;
        borderLayer.actions = nil;
        glossMaskLayer.actions = nil;
    }
}

- (void)setAxcUI_badgeBackgroundColor:(UIColor *)axcUI_badgeBackgroundColor{
    _axcUI_badgeBackgroundColor = axcUI_badgeBackgroundColor;
    backgroundLayer.fillColor = _axcUI_badgeBackgroundColor.CGColor;
}

- (void)setAxcUI_showGloss:(BOOL)axcUI_showGloss{
    _axcUI_showGloss = axcUI_showGloss;
    if (_axcUI_showGloss) {
        [self.layer addSublayer:glossLayer];
    } else {
        [glossLayer removeFromSuperlayer];
    }
}

- (void)setAxcUI_cornerRadius:(CGFloat)axcUI_cornerRadius{
    _axcUI_cornerRadius = axcUI_cornerRadius;
    autoSetCorner_Radius = NO;
    // 更新boackground
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_axcUI_cornerRadius];
    backgroundLayer.path = path.CGPath;
    glossMaskLayer.path = path.CGPath;
    borderLayer.path = path.CGPath;
}

- (void)setAxcUI_horizontalStyle:(AxcBadgeViewHorizontalStyle)axcUI_horizontalStyle{
    _axcUI_horizontalStyle = axcUI_horizontalStyle;
    [self autoSetBadgeFrame];
}

- (void)setAxcUI_verticalStyle:(AxcBadgeViewVerticalStyle)axcUI_verticalStyle{
    _axcUI_verticalStyle = axcUI_verticalStyle;
    [self autoSetBadgeFrame];
}

- (void)setAxcUI_alignmentShift:(CGSize)axcUI_alignmentShift{
    _axcUI_alignmentShift = axcUI_alignmentShift;
    [self autoSetBadgeFrame];
}

- (void)setAxcUI_minimumWidth:(CGFloat)axcUI_minimumWidth{
    _axcUI_minimumWidth = axcUI_minimumWidth;
    [self autoSetBadgeFrame];
}

- (void)setAxcUI_maximumWidth:(CGFloat)axcUI_maximumWidth{
    if (axcUI_maximumWidth < self.frame.size.height) {
        axcUI_maximumWidth = self.frame.size.height;
    }
    _axcUI_maximumWidth = axcUI_maximumWidth;
    [self autoSetBadgeFrame];
    [self setNeedsDisplay];
}

- (void)setAxcUI_hidesWhenZero:(BOOL)axcUI_hidesWhenZero{
    _axcUI_hidesWhenZero = axcUI_hidesWhenZero;
    [self hideForZeroIfNeeded];
}

- (void)setAxcUI_borderWidth:(CGFloat)axcUI_borderWidth{
    _axcUI_borderWidth = axcUI_borderWidth;
    borderLayer.lineWidth = axcUI_borderWidth;
    [self setNeedsLayout];
}

- (void)setAxcUI_borderColor:(UIColor *)axcUI_borderColor{
    _axcUI_borderColor = axcUI_borderColor;
    borderLayer.strokeColor = _axcUI_borderColor.CGColor;
}

- (void)setAxcUI_shadowColor:(UIColor *)axcUI_shadowColor{
    _axcUI_shadowColor = axcUI_shadowColor;
    self.axcUI_shadowBadge = _axcUI_shadowBadge;
    self.axcUI_shadowText = _axcUI_shadowText;
    self.axcUI_shadowBorder = _axcUI_shadowBorder;
}

- (void)setAxcUI_shadowOffset:(CGSize)axcUI_shadowOffset{
    _axcUI_shadowOffset = axcUI_shadowOffset;
    self.axcUI_shadowBadge = _axcUI_shadowBadge;
    self.axcUI_shadowText = _axcUI_shadowText;
    self.axcUI_shadowBorder = _axcUI_shadowBorder;
}

- (void)setAxcUI_shadowRadius:(CGFloat)axcUI_shadowRadius{
    _axcUI_shadowRadius = axcUI_shadowRadius;
    self.axcUI_shadowBadge = _axcUI_shadowBadge;
    self.axcUI_shadowText = _axcUI_shadowText;
    self.axcUI_shadowBorder = _axcUI_shadowBorder;
}

- (void)setAxcUI_shadowText:(BOOL)axcUI_shadowText{
    _axcUI_shadowText = axcUI_shadowText;
    if (_axcUI_shadowText) {
        textLayer.shadowColor = _axcUI_shadowColor.CGColor;
        textLayer.shadowOffset = _axcUI_shadowOffset;
        textLayer.shadowRadius = _axcUI_shadowRadius;
        textLayer.shadowOpacity = 1.0;
    } else {
        textLayer.shadowColor = nil;
        textLayer.shadowOpacity = 0.0;
    }
}

- (void)setAxcUI_shadowBorder:(BOOL)axcUI_shadowBorder{
    _axcUI_shadowBorder = axcUI_shadowBorder;
    
    if (_axcUI_shadowBorder) {
        borderLayer.shadowColor = _axcUI_shadowColor.CGColor;
        borderLayer.shadowOffset = _axcUI_shadowOffset;
        borderLayer.shadowRadius = _axcUI_shadowRadius;
        borderLayer.shadowOpacity = 1.0;
    } else {
        borderLayer.shadowColor = nil;
        borderLayer.shadowOpacity = 0.0;
    }
}

- (void)setAxcUI_shadowBadge:(BOOL)axcUI_shadowBadge{
    _axcUI_shadowBadge = axcUI_shadowBadge;
    if (_axcUI_shadowBadge) {
        backgroundLayer.shadowColor = _axcUI_shadowColor.CGColor;
        backgroundLayer.shadowOffset = _axcUI_shadowOffset;
        backgroundLayer.shadowRadius = _axcUI_shadowRadius;
        backgroundLayer.shadowOpacity = 1.0;
    } else {
        backgroundLayer.shadowColor = nil;
        backgroundLayer.shadowOpacity = 0.0;
    }
}

#pragma mark - 复用函数

- (void)hideForZeroIfNeeded{
    self.hidden = ([_axcUI_text isEqualToString:@"0"] && _axcUI_hidesWhenZero);
}

@end
