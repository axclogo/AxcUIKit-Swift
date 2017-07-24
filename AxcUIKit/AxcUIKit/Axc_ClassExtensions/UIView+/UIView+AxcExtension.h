
//  UIView+Extension.h
//  AxcUIKit
//
//  Created by axc_5324 on 17/4/19.
//  Copyright © 2017年 axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AxcExtension)
/**
 *  1.间隔X值
 */
@property (nonatomic, assign) CGFloat axcUI_X;

/**
 *  2.间隔Y值
 */
@property (nonatomic, assign) CGFloat axcUI_Y;

/**
 *  3.宽度
 */
@property (nonatomic, assign) CGFloat axcUI_Width;

/**
 *  4.高度
 */
@property (nonatomic, assign) CGFloat axcUI_Height;

/**
 *  5.中心点X值
 */
@property (nonatomic, assign) CGFloat axcUI_CenterX;

/**
 *  6.中心点Y值
 */
@property (nonatomic, assign) CGFloat axcUI_CenterY;

/**
 *  7.尺寸大小
 */
@property (nonatomic, assign) CGSize axcUI_Size;

/**
 *  8.起始点
 */
@property (nonatomic, assign) CGPoint axcUI_Origin;

/**
 *  9.上 < Shortcut for frame.origin.y
 */
@property (nonatomic) CGFloat axcUI_Top;

/**
 *  10.下 < Shortcut for frame.origin.y + frame.size.height
 */
@property (nonatomic) CGFloat axcUI_Bottom;

/**
 *  11.左 < Shortcut for frame.origin.x.
 */
@property (nonatomic) CGFloat axcUI_Left;

/**
 *  12.右 < Shortcut for frame.origin.x + frame.size.width
 */
@property (nonatomic) CGFloat axcUI_Right;


/** 以下为未开放测试的API，以后可能修改名称等参数，不推荐使用  */
/**
 *  13.设置镂空中间的视图
 *
 */
- (void)setHollowWithCenterFrame:(CGRect)centerFrame;
/**
 *  14.获取屏幕图片
 */
- (UIImage *)imageFromSelfView;


@end
