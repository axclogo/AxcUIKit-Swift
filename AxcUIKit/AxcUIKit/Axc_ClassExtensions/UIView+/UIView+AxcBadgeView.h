//
//  UIView+AxcBadgeView.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/14.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AxcUI_BadgeView.h"

@interface UIView (AxcBadgeView)

@property(nonatomic,strong)AxcUI_BadgeView *axcUI_badgeView;

@property(nonatomic, assign)CGPoint axcUI_badgePoint;

@property(nonatomic, strong)NSString *axcUI_badgeText;






@end
