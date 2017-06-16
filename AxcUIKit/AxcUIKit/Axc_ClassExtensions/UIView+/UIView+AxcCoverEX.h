//
//  UIView+AxcCoverEX.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface UIView (AxcCoverEX)

/**
 *  添加头图（非手动调用）
 */
- (void)setAxcUI_CoverScrollView:(UIScrollView *)axcUI_CoverScrollView;

/**
 *  移除头图（非手动调用）
 */
- (void)AxcUI_removeObserveCoverScrollView;

@end
