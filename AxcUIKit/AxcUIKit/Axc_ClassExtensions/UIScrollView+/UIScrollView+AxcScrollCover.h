//
//  UIScrollView+AxcScrollCover.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (AxcScrollCover)



@property (nonatomic, strong) UIView *axcUI_CoverView;

/**
 *  此参数只有在类型为tableView时才能够生效，或者自定义tableHeaderView的高度即可
 *  默认值NO
 */
@property(nonatomic,assign)BOOL axcUI_AutomaticCoverHeight;

/**
 *  移除相关View（非特殊情况不必手动调用）
 */
- (void)AxcUIKit_removeCoverView;



@end
