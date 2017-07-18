//
//  AxcUI_NumberScrollView.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 数字滚动展示控件 */
@interface AxcUI_NumberScrollView : UIView
// 内容相关
/**
 *  展示的数字
 */
@property (nonatomic, strong) NSNumber *axcUI_number;
// 样式相关
/**
 *  颜色
 */
@property (nonatomic, strong) UIColor *axcUI_textColor;
/**
 *  字体大小
 */
@property (nonatomic, strong) UIFont *axcUI_font;
/**
 *  滚动数字的密度
 */
@property (nonatomic, assign) NSUInteger axcUI_density;
/**
 *  最小显示长度，不够补零
 */
@property (nonatomic, assign) NSUInteger axcUI_minLength;

// 动画相关
/**
 *  动画总持续时间
 */
@property (nonatomic, assign) NSTimeInterval axcUI_duration;
/**
 *  相邻两个数字动画持续时间间隔
 */
@property (nonatomic, assign) NSTimeInterval axcUI_durationOffset;
/**
 *  方向，默认为NO，向下
 */
@property (nonatomic, assign) BOOL axcUI_isAscending;

/**
 *  刷新
 */
- (void)AxcUI_reloadView;
/**
 *  开始动画
 */
- (void)AxcUI_startAnimation;
/**
 *  结束动画
 */
- (void)AxcUI_stopAnimation;

@end
