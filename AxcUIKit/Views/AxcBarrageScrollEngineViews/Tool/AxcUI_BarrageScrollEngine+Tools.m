//
//  JHDanmakuEngine+Tools.m
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AxcUI_BarrageScrollEngine+Tools.h"
#import "AxcUI_FloatBarrageModel.h"
#import "AxcUI_ScrollBarrageModel.h"
#import "UIColor+Tools.h"

@implementation AxcUI_BarrageScrollEngine (Tools)
+ (AxcUI_BaseBarrageModel *)barrageWithText:(NSString*)text
                                      color:(NSInteger)color
                                spiritStyle:(NSInteger)spiritStyle
                                shadowStyle:(AxcBarrageShadowStyle )shadowStyle1
                                   fontSize:(CGFloat)fontSize
                                       font:(UIFont *)font{
    if (spiritStyle == 4 || spiritStyle == 5) {
        return [[AxcUI_FloatBarrageModel alloc] initWithFontSize:fontSize
                                                       textColor:[UIColor colorWithRGB:(uint32_t)color]
                                                            text:text
                                                     shadowStyle:shadowStyle1
                                                            font:font during:3
                                                       direction:spiritStyle == 4 ?
                               AxcFloatBarrageDirectionStyleB2T : AxcFloatBarrageDirectionStyleT2B];
    }else{
        return [[AxcUI_ScrollBarrageModel alloc] initWithFontSize:fontSize
                                                        textColor:[UIColor colorWithRGB:(uint32_t)color]
                                                             text:text
                                                      shadowStyle:shadowStyle1
                                                             font:font speed:arc4random()%100 + 50
                                                        direction:AxcScrollBarrageDirectionStyleB2TR2L];
    }
}

@end
