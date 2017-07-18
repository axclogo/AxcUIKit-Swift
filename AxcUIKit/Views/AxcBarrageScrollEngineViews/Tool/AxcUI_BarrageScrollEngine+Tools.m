//
//  JHDanmakuEngine+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AxcUI_BarrageScrollEngine+Tools.h"
#import "AxcUI_BarrageFloatModel.h"
#import "AxcUI_BarrageScrollModel.h"
#import "UIColor+Tools.h"

@implementation AxcUI_BarrageScrollEngine (Tools)
+ (AxcUI_BarrageModelBase *)barrageWithText:(NSString*)text
                                      color:(NSInteger)color
                                spiritStyle:(NSInteger)spiritStyle
                                shadowStyle:(AxcBarrageShadowStyle )shadowStyle1
                                   fontSize:(CGFloat)fontSize
                                       font:(UIFont *)font{
    if (spiritStyle == 4 || spiritStyle == 5) {
        return [[AxcUI_BarrageFloatModel alloc] initWithFontSize:fontSize
                                                       textColor:[UIColor colorWithRGB:(uint32_t)color]
                                                            text:text
                                                     shadowStyle:shadowStyle1
                                                            font:font during:3
                                                       direction:spiritStyle == 4 ?
                               AxcBarrageFloatDirectionStyleB2T : AxcBarrageFloatDirectionStyleT2B];
    }else{
        return [[AxcUI_BarrageScrollModel alloc] initWithFontSize:fontSize
                                                        textColor:[UIColor colorWithRGB:(uint32_t)color]
                                                             text:text
                                                      shadowStyle:shadowStyle1
                                                             font:font speed:arc4random()%100 + 50
                                                        direction:AxcBarrageScrollDirectionStyleR2L];
    }
}

@end
