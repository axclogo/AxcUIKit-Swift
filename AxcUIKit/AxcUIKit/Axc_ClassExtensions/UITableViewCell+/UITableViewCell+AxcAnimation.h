//
//  UITableViewCell+AxcAnimation.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AxcUICellAppearAnimateStyle) {
    AxcUICellAppearAnimateStyleRightToLeft,   // 从左往右
    AxcUICellAppearAnimateStyleLeftToRight,   // 从右往左
    AxcUICellAppearAnimateStyleUnfoldRightLeft,    // 左右展开
    AxcUICellAppearAnimateStyleLeftAndRightInsert,    // 左右插入
    AxcUICellAppearAnimateStyleBottomToTop ,   // 从下往上
    AxcUICellAppearAnimateStyleTopToBottom,    // 从上往下
    AxcUICellAppearAnimateStyleOverturn,    // 翻转
    AxcUICellAppearAnimateStyleFanShape    // 扇形
    
};

@interface UITableViewCell (AxcAnimation)

- (void)AxcUI_cellAppearAnimateStyle:(AxcUICellAppearAnimateStyle )type indexPath:(NSIndexPath *)indexPath;

@end
