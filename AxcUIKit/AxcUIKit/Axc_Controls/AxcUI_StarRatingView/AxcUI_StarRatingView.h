//
//  AxcUI_StarRatingView.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

@import UIKit;


IB_DESIGNABLE  // XIB老大，我干你先人。。api就不能详细点


@interface AxcUI_StarRatingView : UIControl

/**
 *  最大值
 */
@property (nonatomic) IBInspectable NSUInteger axcUI_maximumValue;

/**
 *  最小值
 */
@property (nonatomic) IBInspectable CGFloat axcUI_minimumValue;

/**
 *  当前值
 */
@property (nonatomic) IBInspectable CGFloat axcUI_value;

/**
 *  间距
 */
@property (nonatomic) IBInspectable CGFloat axcUI_spacing;

/**
 *  允许一半（.5）显示
 */
@property (nonatomic) IBInspectable BOOL axcUI_allowsHalfStars;

/**
 *  更精准显示
 */
@property (nonatomic) IBInspectable BOOL axcUI_accurateHalfStars;

/**
 *  边线颜色
 */
@property (nonatomic, strong) IBInspectable UIColor *axcUI_starBorderColor;
/**
 *  边线宽度
 */
@property (nonatomic) IBInspectable CGFloat axcUI_starBorderWidth;
/**
 *  填充宽度
 */
@property (nonatomic, strong) IBInspectable UIColor *axcUI_emptyStarColor;
/**
 *  未填充的图片
 */
@property (nonatomic, strong) IBInspectable UIImage *axcUI_emptyStarImage;
/**
 *  填充一半的图片
 */
@property (nonatomic, strong) IBInspectable UIImage *axcUI_halfStarImage;
/**
 *  填满的图片
 */
@property (nonatomic, strong) IBInspectable UIImage *axcUI_filledStarImage;

/**
 *  是否连续（默认无需设置）
 */
@property (nonatomic) IBInspectable BOOL axcUI_continuous;
/**
 *  第一响应者（默认无需设置）
 */
@property (nonatomic) BOOL axcUI_shouldBecomeFirstResponder;

@end

