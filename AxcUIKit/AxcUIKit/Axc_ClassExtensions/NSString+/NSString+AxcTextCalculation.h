//
//  NSString+AxcTextCalculation.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/30.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSString (AxcTextCalculation)

/**
 *  传入attribute计算文字宽度
 */
- (CGFloat)AxcUI_widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute;
/**
 *  传入attribute计算文字高度
 */
- (CGFloat)AxcUI_heightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute;

/**
 *  传入font数值计算文字宽度
 */
- (CGFloat)AxcUI_widthWithStringFontSize:(CGFloat )font;
/**
 *  传入font数值计算文字高度
 */
- (CGFloat)AxcUI_heightWithStringFontSize:(CGFloat )font;

/**
 *  传入font计算文字宽度
 */
- (CGFloat)AxcUI_widthWithStringFont:(UIFont *)font;
/**
 *  传入font计算文字高度
 */
- (CGFloat)AxcUI_heightWithStringFont:(UIFont *)font;

/**
 *  传入attribute计算文字rect的Size
 */
- (CGRect )AxcUI_rectWithStringAttribute:(NSDictionary <NSString *, id> *)attribute;
/**
 *  传入font计算文字rect的Size
 */
- (CGRect )AxcUI_rectWithStringFont:(CGFloat )font;

@end
