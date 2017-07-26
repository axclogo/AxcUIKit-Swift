//
//  Axc框架封装工程
//
//  Created by ZhaoXin on 16/3/9.
//  Copyright © 2016年 Axc5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AxcColor)

/**
 *  在扩展随机一个颜色
 */
+ (UIColor*)AxcUI_ArcPresetColor;

/**
 *  随机色
 */
+ (UIColor*)AxcUI_ArcColor;

/**
 *  绿松石
 */
+ (UIColor*)AxcUI_TurquoiseColor;
/**
 *  深绿色
 */
+ (UIColor*)AxcUI_GreenSeaColor;
/**
 *  翡翠绿
 */
+ (UIColor*)AxcUI_EmeraldColor;
/**
 *  中性绿
 */
+ (UIColor*)AxcUI_NephritisColor;
/**
 *  河水蓝
 */
+ (UIColor*)AxcUI_PeterRiverColor;
/**
 *  暴雪蓝
 */
+ (UIColor*)AxcUI_BelizeHoleColor;
/**
 *  紫水晶
 */
+ (UIColor*)AxcUI_AmethystColor;
/**
 *  紫藤
 */
+ (UIColor*)AxcUI_WisteriaColor;
/**
 *  湿沥青藏蓝
 */
+ (UIColor*)AxcUI_WetAsphaltColor;
/**
 *  午夜
 */
+ (UIColor*)AxcUI_MidNightColor;
/**
 *  太阳花
 */
+ (UIColor*)AxcUI_SunFlowerColor;
/**
 *  橘色
 */
+ (UIColor*)AxcUI_OrangeColor;
/**
 *  胡萝卜
 */
+ (UIColor*)AxcUI_CarrotColor;
/**
 *  南瓜
 */
+ (UIColor*)AxcUI_PumpkinColor;
/**
 *  茜素红
 */
+ (UIColor*)AxcUI_AlizarinColor;
+ (UIColor*)AxcUI_PomegranateColor;
/**
 *  云色
 */
+ (UIColor*)AxcUI_CloudColor;
/**
 *  石榴红
 */
+ (UIColor*)AxcUI_SilverColor;
/**
 *  混凝土
 */
+ (UIColor*)AxcUI_ConcreteColor;
+ (UIColor*)AxcUI_AsbestosColor;

/**
 *  RGB
 */
+ (UIColor*)AxcUI_R:(int )r G:(int )g B:(int )b;

+ (UIColor *)AxcUI_colorWithHexCode:(NSString *)hexCode;
+ (UIColor *)AxcUI_colorWithHexColor: (NSString *) AxcColor;
+ (UIColor *)AxcUI_InverseColorFor:(UIColor *)color ;


@end

