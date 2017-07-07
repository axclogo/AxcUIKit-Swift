//
//  UIView+AxcRectCorner.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/7.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 button 的样式，以图片为基准
 */
typedef NS_ENUM(NSInteger, AxcButtonContentLayoutStyle) {
    AxcButtonContentLayoutStyleNormal = 0,       // 内容居中-图左文右
    AxcButtonContentLayoutStyleCenterImageRight, // 内容居中-图右文左
    AxcButtonContentLayoutStyleCenterImageTop,   // 内容居中-图上文下
    AxcButtonContentLayoutStyleCenterImageBottom,// 内容居中-图下文上
    AxcButtonContentLayoutStyleLeftImageLeft,    // 内容居左-图左文右
    AxcButtonContentLayoutStyleLeftImageRight,   // 内容居左-图右文左
    AxcButtonContentLayoutStyleRightImageLeft,   // 内容居右-图左文右
    AxcButtonContentLayoutStyleRightImageRight,  // 内容居右-图右文左
};

@interface UIButton (AxcContentLayout)

/**
 button 的布局样式，文字、字体大小、图片等参数一定要在其之前设置，方便计算
 */
@property(nonatomic, assign) AxcButtonContentLayoutStyle axcUI_buttonContentLayoutType;

/*!
 *  图文间距，默认为：0
 */
@property (nonatomic, assign) CGFloat axcUI_padding;

/*!
 *  图文边界的间距，默认为：5
 */
@property (nonatomic, assign) CGFloat axcUI_paddingInset;





@end
NS_ASSUME_NONNULL_END


