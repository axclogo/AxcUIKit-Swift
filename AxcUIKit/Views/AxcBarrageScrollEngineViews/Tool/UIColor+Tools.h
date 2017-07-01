//
//  UIColor+Tools.h
//  IOSDemo
//
//  Created by JimHuang on 16/3/8.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Tools)
+ (instancetype)colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;
+ (instancetype)colorWithRGB:(uint32_t)rgbValue;
@end
