//
//  AxcBarrageContainer.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBarrageContainer.h"
#import "AxcUI_BarrageScrollEngine.h"
#define zx_AxcColorBrightness(color) ({ \
CGFloat b;\
[color getHue:nil saturation:nil brightness:&b alpha:nil];\
b;\
})
@implementation AxcBarrageContainer
{
    AxcUI_BaseBarrageModel *_danmaku;
}

- (instancetype)initWithDanmaku:(AxcUI_BaseBarrageModel *)danmaku {
    if (self = [super init]) {
        [self setWithDanmaku:danmaku];
    }
    return self;
}

- (void)setWithDanmaku:(AxcUI_BaseBarrageModel *)danmaku {
    _danmaku = danmaku;
    self.textColor = danmaku.textColor;
    self.text = danmaku.text ? danmaku.text : @"";
    self.attributedText = danmaku.attributedString;
    [self updateAttributed];
}

- (BOOL)updatePositionWithTime:(NSTimeInterval)time {
    return [_danmaku updatePositonWithTime:time container:self];
}

- (AxcUI_BaseBarrageModel *)danmaku {
    return _danmaku;
}

- (void)setOriginalPosition:(CGPoint)originalPosition {
    _originalPosition = originalPosition;
    CGRect rect = self.frame;
    rect.origin = originalPosition;
    self.frame = rect;
}

- (void)updateAttributed {
    
    NSDictionary *globalAttributed = [self.danmakuEngine axcUI_barrageGlobalAttributedDic];
    if (globalAttributed && self.text.length) {
        self.attributedText = [[NSMutableAttributedString alloc] initWithString:self.attributedText.string attributes:globalAttributed];
    }
    
    NSMutableDictionary *originalAttributed = nil;
    if (self.attributedText.length) {
        originalAttributed = [self.attributedText attributesAtIndex:0 effectiveRange:nil].mutableCopy;
    }
    else {
        originalAttributed = [NSMutableDictionary dictionary];
    }
    
    UIFont *font = [self.danmakuEngine axcUI_barrageGlobalFont];
    if (font) {
        originalAttributed[NSFontAttributeName] = font;
        self.attributedText = [[NSMutableAttributedString alloc] initWithString:self.attributedText.string attributes:originalAttributed];
    }
    
    
    AxcBarrageShadowStyle shadowStyle = [self.danmakuEngine axcUI_barrageGlobalShadowStyle];
    if (shadowStyle >= AxcBarrageShadowStyleNone) {
        UIColor *textColor = originalAttributed[NSForegroundColorAttributeName];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = originalAttributed[NSFontAttributeName];
        dic[NSForegroundColorAttributeName] = textColor;
        
        switch (shadowStyle) {
            case AxcBarrageShadowStyleGlow:
            {
                NSShadow *shadow = [self shadowWithTextColor:textColor];
                shadow.shadowBlurRadius = 3;
                dic[NSShadowAttributeName] = shadow;
            }
                break;
            case AxcBarrageShadowStyleShadow:
            {
                dic[NSShadowAttributeName] = [self shadowWithTextColor:textColor];
            }
                break;
            case AxcBarrageShadowStyleStroke:
            {
                dic[NSStrokeColorAttributeName] = [self shadowColorWithTextColor:textColor];
                dic[NSStrokeWidthAttributeName] = @-3;
            }
                break;
            default:
                break;
        }
        
        self.attributedText = [[NSMutableAttributedString alloc] initWithString:self.attributedText.string attributes:dic];
    }
    
    [self sizeToFit];
}

#pragma mark - 私有方法
- (NSShadow *)shadowWithTextColor:(UIColor *)textColor {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(1, -1);
    shadow.shadowColor = [self shadowColorWithTextColor:textColor];
    return shadow;
}

- (UIColor *)shadowColorWithTextColor:(UIColor *)textColor {
    if (zx_AxcColorBrightness(textColor) > 0.5) {
        return [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }
    return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

@end
