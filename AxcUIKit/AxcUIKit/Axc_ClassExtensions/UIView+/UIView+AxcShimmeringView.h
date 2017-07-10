//
//  UIView+AxcShimmeringView.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AxcUI_Label.h"

typedef NS_ENUM(NSUInteger, AxcShimmeringViewStyle) {
    AxcShimmeringViewStyleOverallFilling,   // 歌词模式
    AxcShimmeringViewStyleFadeLeftToRight,  // 从左到右解锁模式
    AxcShimmeringViewStyleFadeRightToLeft,  // 从右到左解锁模式
    AxcShimmeringViewStyleFadeAll           // 整体闪烁
};




@interface UIView (AxcShimmeringView)

/**
 *  准备shimmering的文字
 */
@property (nonatomic,strong) NSString *axcUI_shimmeringText;
/**
 *  shimmering文字的对其方式
 */
@property (nonatomic,assign) NSTextAlignment axcUI_shimmeringTextAlignment;
/**
 *  shimmering文字的底层颜色
 */
@property (nonatomic,strong) UIColor *axcUI_shimmeringBackColor;
/**
 *  shimmering文字的闪动颜色
 */
@property (nonatomic,strong) UIColor *axcUI_shimmeringForeColor;
/**
 *  shimmering文字的大小
 */
@property (nonatomic,strong) UIFont *axcUI_shimmeringTextfont;
/**
 *  shimmering文字的边距
 */
@property(nonatomic, assign) UIEdgeInsets axcUI_textEdgeInsets;

/**
 *  开始执行shimmering动画效果
 */
- (void)AxcUI_ShimmeringWithType:(AxcShimmeringViewStyle)type Duration:(NSTimeInterval)duration;


@property (nonatomic,strong) AxcUI_Label *AxcBackLabel;
@property (nonatomic,strong) AxcUI_Label *AxcfrontLabel;





@end



