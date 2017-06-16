//
//  UIView+AutoresizingMask.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/4/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AxcAutoresizingMask)

/**
 *  左右距离按比例增减
 */
- (void)AxcUI_autoresizingMaskLeftAndRight;

/**
 *  上下距离按比例增减
 */
- (void)AxcUI_autoresizingMaskTopAndBottom;

/**
 *  上下左右全方位按比例增减
 */
- (void)AxcUI_autoresizingMaskComprehensive;

/**
 *  宽高按比例增减
 */
- (void)AxcUI_autoresizingMaskWideAndHigh;


@end
