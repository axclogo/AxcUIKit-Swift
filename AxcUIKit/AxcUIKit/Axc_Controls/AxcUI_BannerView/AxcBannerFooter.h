//
//  AxcBannerFooter.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/17.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AxcBannerFooterState) {
    AxcBannerFooterStateIdle = 0,    // 正常状态下的footer提示
    AxcBannerFooterStateTrigger,     // 被拖至触发点的footer提示
};

@interface AxcBannerFooter : UICollectionReusableView

@property (nonatomic, assign) AxcBannerFooterState state;

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, copy) NSString *idleTitle;
@property (nonatomic, copy) NSString *triggerTitle;

@end
