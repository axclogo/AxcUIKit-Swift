//
//  AxcUI_BarrageScrollModel.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_BarrageModelBase.h"

typedef NS_ENUM(NSUInteger, AxcBarrageScrollDirectionStyle) {
    AxcBarrageScrollDirectionStyleR2L = 10,
    AxcBarrageScrollDirectionStyleL2R,
    AxcBarrageScrollDirectionStyleT2B,
    AxcBarrageScrollDirectionStyleB2T,
};


/** 滚动弹幕对象 */
@interface AxcUI_BarrageScrollModel : AxcUI_BarrageModelBase
/**
 *  初始化 阴影 字体
 *
 *  @param fontSize    文字大小(在font为空时有效)
 *  @param textColor   文字颜色(务必使用 colorWithRed:green:blue:alpha初始化)
 *  @param text        文本内容
 *  @param shadowStyle 阴影风格
 *  @param font        字体
 *  @param speed       弹幕速度
 *  @param direction   弹幕运动方向
 *
 *  @return self
 */
- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor text:(NSString *)text shadowStyle:(AxcBarrageShadowStyle)shadowStyle font:(UIFont *)font speed:(CGFloat)speed direction:(AxcBarrageScrollDirectionStyle)direction;
- (CGFloat)speed;
- (AxcBarrageScrollDirectionStyle)direction;
@end
