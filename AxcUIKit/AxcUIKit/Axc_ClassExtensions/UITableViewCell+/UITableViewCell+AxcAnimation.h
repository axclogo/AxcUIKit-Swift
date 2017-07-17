//
//  UITableViewCell+AxcAnimation.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AxcCellAppearAnimateStyle) {
    AxcCellAppearAnimateStyleRightToLeft,   // 从左往右
    AxcCellAppearAnimateStyleLeftToRight,   // 从右往左
    AxcCellAppearAnimateStyleUnfoldRightLeft,    // 左右展开
    AxcCellAppearAnimateStyleLeftAndRightInsert,    // 左右插入
    AxcCellAppearAnimateStyleBottomToTop ,   // 从下往上
    AxcCellAppearAnimateStyleTopToBottom,    // 从上往下
    AxcCellAppearAnimateStyleOverturn,    // 翻转
    AxcCellAppearAnimateStyleFanShape    // 扇形
    
};

@interface UITableViewCell (AxcAnimation)

/**
    此API尚未完善，仅能在示例中使用
 */
- (void)AxcUI_cellAppearAnimateStyle:(AxcCellAppearAnimateStyle )type indexPath:(NSIndexPath *)indexPath;

@end
