//
//  AxcUI_BannerView.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/17.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxcBannerFooter.h"

@protocol AxcBannerViewDataSource, AxcBannerViewDelegate;

/** 横幅式轮播图，可带左拉显示详情功能 */
@interface AxcUI_BannerView : UIView

/** 是否需要循环滚动, 默认为 NO */
@property (nonatomic, assign) IBInspectable BOOL axcUI_shouldLoop;

/** 是否显示 footer, 默认为 NO (此属性为 YES 时, axcUI_shouldLoop 会被置为 NO) */
@property (nonatomic, assign) IBInspectable BOOL axcUI_showFooter;

/** 是否自动滑动, 默认为 NO */
@property (nonatomic, assign) IBInspectable BOOL axcUI_autoScroll;

/** 自动滑动间隔时间(s), 默认为 3.0 */
@property (nonatomic, assign) IBInspectable CGFloat axcUI_scrollInterval;

/** pageControl, 可自由配置其属性 */
@property (nonatomic, strong, readonly) UIPageControl *axcUI_pageControl;
@property (nonatomic, assign, readwrite)  CGRect axcUI_pageControlFrame;

/** 跳转到当前 item 的 index */
@property (nonatomic, assign) NSInteger axcUI_currentIndex;
- (void)setAxcUI_currentIndex:(NSInteger)currentIndex animated:(BOOL)animated;

@property (nonatomic, weak) IBOutlet id<AxcBannerViewDataSource> axcUI_bannerDataSource;
@property (nonatomic, weak) IBOutlet id<AxcBannerViewDelegate> axcUI_bannerDelegate;

/** 刷新数据 */
- (void)AxcUI_reloadData;
/** 开始计时器（轮播） */
- (void)AxcUI_startTimer;
/** 关闭/停止计时器（轮播） */
- (void)AxcUI_stopTimer;

@end

@protocol AxcBannerViewDataSource <NSObject>
@required

- (NSInteger)AxcUI_numberOfItemsInBanner:(AxcUI_BannerView *)banner;
- (UIView *)AxcUI_banner:(AxcUI_BannerView *)banner viewForItemAtIndex:(NSInteger)index;

@optional

- (NSString *)AxcUI_banner:(AxcUI_BannerView *)banner titleForFooterWithState:(AxcBannerFooterState)footerState;

@end

@protocol AxcBannerViewDelegate <NSObject>
@optional

- (void)AxcUI_banner:(AxcUI_BannerView *)banner didSelectItemAtIndex:(NSInteger)index;
- (void)AxcUI_banner:(AxcUI_BannerView *)banner didScrollToItemAtIndex:(NSInteger)index;
- (void)AxcUI_bannerFooterDidTrigger:(AxcUI_BannerView *)banner;

@end
