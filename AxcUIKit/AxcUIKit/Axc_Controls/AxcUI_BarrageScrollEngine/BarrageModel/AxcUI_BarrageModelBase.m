//
//  abstractDanmaku.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_BarrageModelBase.h"

#define zx_AxcColorBrightness(color) ({ \
CGFloat b;\
[color getHue:nil saturation:nil brightness:&b alpha:nil];\
b;\
})
@implementation AxcUI_BarrageModelBase

- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor text:(NSString *)text shadowStyle:(AxcBarrageShadowStyle)shadowStyle font:(UIFont *)font{
    if (self = [super init]) {
        //字体为空根据fontSize初始化
        if (!font) font = [UIFont systemFontOfSize: fontSize];
        if (!text) text = @"";
        if (!textColor) textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = font;
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
        self.attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
    }
    return self;
}

- (BOOL)updatePositonWithTime:(NSTimeInterval)time container:(AxcBarrageContainer *)container {
    return NO;
}

/**
 *  获取当前弹幕初始位置
 *
 *  @param arr            所有弹幕容器的数组
 *  @param channelCount   平分窗口的个数
 *  @param rect           窗口大小
 *  @param danmakuSize    弹幕尺寸
 *  @param timeDifference 弹幕出现时间与当前时间的时间差 回退功能需要使用
 *
 *  @return 弹幕初始位置
 */
- (CGPoint)originalPositonWithContainerArr:(NSArray <AxcBarrageContainer *>*)arr channelCount:(NSInteger)channelCount contentRect:(CGRect)rect danmakuSize:(CGSize)danmakuSize timeDifference:(NSTimeInterval)timeDifference {
    return CGPointZero;
}

- (NSString *)text {
    return _attributedString.string;
}

- (UIColor *)textColor {
    if (!_attributedString.length) return nil;
    
    return [_attributedString attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
}
- (NSAttributedString *)attributedString {
    return _attributedString;
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
