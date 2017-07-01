//
//  UIColor+Tools.m
//  IOSDemo
//
//  Created by JimHuang on 16/3/8.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "UIColor+Tools.h"

@implementation UIColor (Tools)
+ (instancetype)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00) >> 8) / 255.0f
                            blue:(rgbValue & 0xFF) / 255.0f
                           alpha:alpha];
}
+ (instancetype)colorWithRGB:(uint32_t)rgbValue{
    return [UIColor colorWithRGB:rgbValue alpha: 1];
}
@end
