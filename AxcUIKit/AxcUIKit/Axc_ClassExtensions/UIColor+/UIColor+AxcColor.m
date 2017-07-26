//
//  Axc框架封装工程
//
//  Created by ZhaoXin on 16/3/9.
//  Copyright © 2016年 Axc5324. All rights reserved.
//


#import "UIColor+AxcColor.h"


@implementation UIColor (AxcColor)

+ (UIColor *)AxcUI_ArcPresetColor{
    NSArray *arr = @[[UIColor AxcUI_CarrotColor],[UIColor AxcUI_CloudColor],[UIColor AxcUI_OrangeColor],[UIColor AxcUI_SilverColor],[UIColor AxcUI_EmeraldColor],[UIColor AxcUI_PumpkinColor],[UIColor AxcUI_AlizarinColor],[UIColor AxcUI_AmethystColor],[UIColor AxcUI_AsbestosColor],[UIColor AxcUI_ConcreteColor],[UIColor AxcUI_GreenSeaColor],[UIColor AxcUI_MidNightColor],[UIColor AxcUI_WisteriaColor],[UIColor AxcUI_NephritisColor],[UIColor AxcUI_SunFlowerColor],[UIColor AxcUI_TurquoiseColor],[UIColor AxcUI_BelizeHoleColor],[UIColor AxcUI_PeterRiverColor],[UIColor AxcUI_WetAsphaltColor]];
    return arr[arc4random()%arr.count];
}


+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)AxcUI_colorWithHexColor: (NSString *) AxcColor {
    NSString *colorString = [[AxcColor stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+(UIColor *)AxcUI_ArcColor{
    return [UIColor colorWithRed:arc4random()%255/255.f green:arc4random()%255/255.f blue:arc4random()%255/255.f alpha:1];
}


+ (UIColor*)AxcUI_TurquoiseColor {
    return [UIColor colorWithRed:26.0f/255.0f
                           green:188.0f/255.0f
                            blue:156.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_GreenSeaColor {
    return [UIColor colorWithRed:22.0f/255.0f
                           green:160.0f/255.0f
                            blue:133.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_EmeraldColor {
    return [UIColor colorWithRed:46.0f/255.0f
                           green:204.0f/255.0f
                            blue:113.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_NephritisColor {
    return [UIColor colorWithRed:39.0f/255.0f
                           green:174.0f/255.0f
                            blue:96.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_PeterRiverColor {
    return [UIColor colorWithRed:52.0f/255.0f
                           green:152.0f/255.0f
                            blue:219.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_BelizeHoleColor {
    return [UIColor colorWithRed:41.0f/255.0f
                           green:128.0f/255.0f
                            blue:185.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_AmethystColor {
    return [UIColor colorWithRed:155.0f/255.0f
                           green:89.0f/255.0f
                            blue:182.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_WisteriaColor {
    return [UIColor colorWithRed:142.0f/255.0f
                           green:68.0f/255.0f
                            blue:173.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_WetAsphaltColor {
    return [UIColor colorWithRed:52.0f/255.0f
                           green:73.0f/255.0f
                            blue:94.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_MidNightColor {
    return [UIColor colorWithRed:44.0f/255.0f
                           green:62.0f/255.0f
                            blue:80.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_SunFlowerColor {
    return [UIColor colorWithRed:241.0f/255.0f
                           green:196.0f/255.0f
                            blue:15.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_OrangeColor {
    return [UIColor colorWithRed:243.0f/255.0f
                           green:156.0f/255.0f
                            blue:18.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_CarrotColor {
    return [UIColor colorWithRed:230.0f/255.0f
                           green:126.0f/255.0f
                            blue:34.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_PumpkinColor {
    return [UIColor colorWithRed:211.0f/255.0f
                           green:84.0f/255.0f
                            blue:0.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_AlizarinColor {
    return [UIColor colorWithRed:231.0f/255.0f
                           green:76.0f/255.0f
                            blue:60.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_PomegranateColor {
    return [UIColor colorWithRed:192.0f/255.0f
                           green:57.0f/255.0f
                            blue:43.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_CloudColor {
    return [UIColor colorWithRed:236.0f/255.0f
                           green:240.0f/255.0f
                            blue:241.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_SilverColor {
    return [UIColor colorWithRed:189.0f/255.0f
                           green:195.0f/255.0f
                            blue:199.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_ConcreteColor {
    return [UIColor colorWithRed:149.0f/255.0f
                           green:165.0f/255.0f
                            blue:166.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_AsbestosColor {
    return [UIColor colorWithRed:127.0f/255.0f
                           green:140.0f/255.0f
                            blue:141.0f/255.0f
                           alpha:1.0f];
}

+ (UIColor*)AxcUI_R:(int )r G:(int )g B:(int )b{
    return [UIColor colorWithRed:r/255.f
                           green:g/255.f
                            blue:b/255.f alpha:1];
}

+ (UIColor *)AxcUI_InverseColorFor:(UIColor *)color {
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1.-r green:1.-g blue:1.-b alpha:a];
}
+(UIColor *)AxcUI_colorWithHexCode:(NSString *)hexCode{
    NSString *cleanString = [hexCode stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end


