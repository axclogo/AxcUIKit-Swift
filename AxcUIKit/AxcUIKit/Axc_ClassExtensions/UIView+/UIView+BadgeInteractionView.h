//
//  UIView+AxcBadgeView.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/14.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//  

#import <UIKit/UIKit.h>

#import "AxcUI_BadgeInteractionView.h"

@interface UIView (BadgeInteractionView)


/** 文本带交互badge */
@property(nonatomic,strong)AxcUI_BadgeInteractionView *axcUI_badgeInteractionView;

/** 交互badge坐标点 */
@property(nonatomic, assign)CGPoint axcUI_badgeInteractionPoint;

/** 交互badge文本 */
@property(nonatomic, strong)NSString *axcUI_badgeInteractionText;






@end
