//
//  AxcBadgeView.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/14.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AxcBadgeViewHorizontalStyle) {
    AxcBadgeViewHorizontalStyleNone,
    AxcBadgeViewHorizontalStyleLeft,
    AxcBadgeViewHorizontalStyleCenter,
    AxcBadgeViewHorizontalStyleRight
} ;

typedef NS_ENUM(NSInteger, AxcBadgeViewVerticalStyle) {
    AxcBadgeViewVerticalStyleNone,
    AxcBadgeViewVerticalStyleTop,
    AxcBadgeViewVerticalStyleMiddle,
    AxcBadgeViewVerticalStyleBottom
} ;

/** 气泡badge视图类似于标准badge标签栏项目  */
@interface AxcUI_BadgeView : UIView

/** 文本显示徽章badge */
@property (nonatomic, retain) NSString *axcUI_text;
/** 文本颜色 */
@property (nonatomic, retain) UIColor *axcUI_textColor;
/** 文本字体 */
@property (nonatomic, retain) UIFont *axcUI_font;
/** 转移当水平/垂直对齐的文本，微调调整 */
@property (nonatomic, assign) CGSize axcUI_textaxcUI_alignmentShift;
/** 是否或不对齐文本是 Default is YES 如果文本对齐,它将为中心,四舍五入到完美的像素的位置 */
@property (nonatomic, assign) BOOL axcUI_pixelPerfectText;

/** 气泡背景色 */
@property (nonatomic, retain) UIColor *axcUI_badgeBackgroundColor;
/** 是否或不是badge有光滑叠加  光影特效 */
@property (nonatomic, assign) BOOL axcUI_showGloss;
/** 圆弧半径 */
@property (nonatomic, assign) CGFloat axcUI_cornerRadius;
/** 水平对齐方位，枚举 */
@property (nonatomic, assign) AxcBadgeViewHorizontalStyle axcUI_horizontalStyle;
/** 纵向对齐方位，枚举 */
@property (nonatomic, assign) AxcBadgeViewVerticalStyle axcUI_verticalStyle;
/** 转移的badge,当水平/垂直对齐  微调调整 */
@property (nonatomic, assign) CGSize axcUI_alignmentShift;
/** 是否开启不改变当前帧大小动画 */
@property (nonatomic, assign) BOOL axcUI_animateChanges;
/** 动画时间 */
@property (nonatomic, assign) CGFloat axcUI_animationDuration;
/** 最小宽度 */
@property (nonatomic, assign) CGFloat axcUI_minimumWidth;
/** 最大宽度 */
@property (nonatomic, assign) CGFloat axcUI_maximumWidth;
/** 文本为0时，是否隐藏 */
@property (nonatomic, assign) BOOL axcUI_hidesWhenZero;

/** 边线的宽度。如果设置为0,没有边线将显示 */
@property (nonatomic, assign) CGFloat axcUI_borderWidth;
/** 边线的颜色 */
@property (nonatomic, retain) UIColor *axcUI_borderColor;

/** 阴影颜色 */
@property (nonatomic, retain) UIColor *axcUI_shadowColor;
/** 阴影偏移量 */
@property (nonatomic, assign) CGSize axcUI_shadowOffset;
/** 阴影圆角 */
@property (nonatomic, assign) CGFloat axcUI_shadowRadius;
/** 是否开启文本阴影 */
@property (nonatomic, assign) BOOL axcUI_shadowText;
/** 是否开启边线阴影 */
@property (nonatomic, assign) BOOL axcUI_shadowBorder;
/** 是否开启气泡阴影 */
@property (nonatomic, assign) BOOL axcUI_shadowBadge;




@end
