// //
//  TestTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/7.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//


#import <UIKit/UIKit.h>

/*!
 *  设置 viewRectCornerType 样式，
 *  注意：AxcViewRectCornerStyle 必须要先设置 viewCornerRadius，才能有效，否则设置无效，
 */
typedef NS_ENUM(NSInteger, AxcViewRectCornerStyle) {
    /*!
     *  设置下左角 圆角半径
     */
    AxcViewRectCornerStyleBottomLeft = 0,
    /*!
     *  设置下右角 圆角半径
     */
    AxcViewRectCornerStyleBottomRight,
    /*!
     *  设置上左角 圆角半径
     */
    AxcViewRectCornerStyleTopLeft,
    /*!
     *  设置下右角 圆角半径
     */
    AxcViewRectCornerStyleTopRight,
    /*!
     *  设置下左、下右角 圆角半径
     */
    AxcViewRectCornerStyleBottomLeftAndBottomRight,
    /*!
     *  设置上左、上右角 圆角半径
     */
    AxcViewRectCornerStyleTopLeftAndTopRight,
    /*!
     *  设置下左、上左角 圆角半径
     */
    AxcViewRectCornerStyleBottomLeftAndTopLeft,
    /*!
     *  设置下右、上右角 圆角半径
     */
    AxcViewRectCornerStyleBottomRightAndTopRight,
    /*!
     *  设置上左、上右、下右角 圆角半径
     */
    AxcViewRectCornerStyleBottomRightAndTopRightAndTopLeft,
    /*!
     *  设置下右、上右、下左角 圆角半径
     */
    AxcViewRectCornerStyleBottomRightAndTopRightAndBottomLeft,
    /*!
     *  设置全部四个角 圆角半径
     */
    AxcViewRectCornerStyleAllCorners
};

@interface UIView (BARectCorner)

/*!
 *  设置 viewRectCornerType 样式，
 *  注意：AxcViewRectCornerStyle 必须要先设置 viewCornerRadius，才能有效，否则设置无效，
 */
@property (nonatomic, assign) AxcViewRectCornerStyle viewRectCornerType;

/*!
 *  设置 button 圆角，如果要全部设置四个角的圆角，可以直接用这个方法，必须要在设置 frame 之后
 */
@property (nonatomic, assign) CGFloat viewCornerRadius;

/**
 快速切圆角
 
 @param type 圆角样式
 @param viewCornerRadius 圆角角度
 */
- (void)AxcUI_view_setAxcViewRectCornerStyle:(AxcViewRectCornerStyle)type viewCornerRadius:(CGFloat)viewCornerRadius;

@end
