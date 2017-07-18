//
//  AxcUI_BarrageFloatModel.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//
#import "AxcUI_BarrageModelBase.h"

typedef NS_ENUM(NSUInteger, AxcBarrageFloatDirectionStyle) {
    AxcBarrageFloatDirectionStyleB2T = 100,
    AxcBarrageFloatDirectionStyleT2B
};


/** 悬浮弹幕对象 */
@interface AxcUI_BarrageFloatModel : AxcUI_BarrageModelBase
/**
 *  初始化 阴影 字体
 *
 *  @param fontSize    文字大小
 *  @param textColor   文字颜色(务必使用 colorWithRed:green:blue:alpha初始化)
 *  @param text        文本
 *  @param shadowStyle 阴影类型
 *  @param font        字体
 *  @param during      弹幕持续时间
 *  @param direction   弹幕方向
 *
 *  @return self
 */
- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor text:(NSString *)text shadowStyle:(AxcBarrageShadowStyle)shadowStyle font:(UIFont *)font during:(CGFloat)during direction:(AxcBarrageFloatDirectionStyle)direction;
- (CGFloat)during;
- (AxcBarrageFloatDirectionStyle)direction;
@end
