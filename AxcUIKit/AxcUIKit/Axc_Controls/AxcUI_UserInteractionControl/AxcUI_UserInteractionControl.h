//
//  AxcUI_UserInteractionControl.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/25.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 默认的图标
 Icon Style. Default: AxcUserInteractionControlStyleMenu.
 */
typedef NS_ENUM(NSInteger, AxcUserInteractionControlStyle) {
    /** 三道杠menu */
    AxcUserInteractionControlStyleMenu,
    /** 指向左的箭头 */
    AxcUserInteractionControlStyleLeftArrow,
    /** 指向右的箭头 */
    AxcUserInteractionControlStyleRightArrow,
    /** 交叉，错误的叉 */
    AxcUserInteractionControlStyleCross,
    /** 加号 */
    AxcUserInteractionControlStyleAdd,
    /** 负号 */
    AxcUserInteractionControlStyleMinusSign,
};

/**
 线段末端的形状 Default: AxcUserInteractionControlaxcUI_lineCapRound
 */
typedef NS_ENUM(NSInteger, AxcUserInteractionControlaxcUI_lineCap) {
    AxcUserInteractionControlaxcUI_lineCapRound,    // 圆角
    AxcUserInteractionControlaxcUI_lineCapSquare,   // 直角
    //    AxcUserInteractionControlaxcUI_lineCapButt,   // 已废弃的直角API
};

/** 交互动画控制器 */
@interface AxcUI_UserInteractionControl : UIControl

/** 线段的高度 */
@property (nonatomic) CGFloat axcUI_lineHeight;

/** 线段宽度 */
@property (nonatomic) CGFloat axcUI_lineWidth;

/** 线段间距 */
@property (nonatomic) CGFloat axcUI_lineSpacing;

/** 线段颜色 */
@property (nonatomic) UIColor *axcUI_lineColor;

/** 设置线段末端的形状 */
@property (nonatomic) AxcUserInteractionControlaxcUI_lineCap axcUI_lineCap;

/** 设置AxcUserInteractionControlStyle，图标的风格 */
@property (nonatomic) AxcUserInteractionControlStyle axcUI_currentState;

/** 可手动执行动画(预留API) */
- (void)AxcUI_animationTransformToState:(AxcUserInteractionControlStyle)state;

@end
