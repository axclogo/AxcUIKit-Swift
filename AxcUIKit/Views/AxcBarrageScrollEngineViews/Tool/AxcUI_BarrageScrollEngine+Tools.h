//
//  JHDanmakuEngine+Tools.h
//  DanDanPlayForMac
//
//  Created by JimHuang on 16/2/24.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "AxcUI_BarrageScrollEngine.h"

@interface AxcUI_BarrageScrollEngine (Tools)

+ (AxcUI_BaseBarrageModel *)barrageWithText:(NSString*)text
                                      color:(NSInteger)color
                                spiritStyle:(NSInteger)spiritStyle
                                shadowStyle:(AxcBarrageShadowStyle)shadowStyle
                                   fontSize:(CGFloat)fontSize
                                       font:(UIFont *)font;
@end
