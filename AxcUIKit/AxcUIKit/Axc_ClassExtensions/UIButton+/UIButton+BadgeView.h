//
//  UIView+BadgeView.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/16.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AxcUI_BadgeView.h"

@interface UIButton (BadgeView)

/** 文本显示徽章badge */
@property(nonatomic, strong)AxcUI_BadgeView *axcUI_badgeView;

/** badge坐标点 */
@property(nonatomic, assign)CGPoint axcUI_badgePoint;

/** badge文本 */
@property(nonatomic, strong)NSString *axcUI_badgeText;

@end
