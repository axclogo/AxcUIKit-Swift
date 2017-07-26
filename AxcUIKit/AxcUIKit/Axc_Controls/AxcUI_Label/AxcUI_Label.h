//
//  AxcUI_Label.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 背景颜色渐变的渲染方向 */
typedef NS_ENUM(NSUInteger, AxcBackGroundGradientStyle) {
    /** 水平 */
    AxcBackGroundGradientStyleHorizontal,
    /** 纵向 */
    AxcBackGroundGradientStyleVertical
};


/** 支持自定义文字内边距的Label */
@interface AxcUI_Label : UILabel

/** 自定义文字内边距 */
@property(nonatomic, assign) UIEdgeInsets axcUI_textEdgeInsets;

/** 背景梯度渲染色组 */
@property (nonatomic, strong) NSArray *axcUI_backGroundGradientColors;

/** 背景颜色渐变的渲染方向 */
@property(nonatomic, assign)AxcBackGroundGradientStyle axcUI_backGroundDrawDirectionStyle;




@end
