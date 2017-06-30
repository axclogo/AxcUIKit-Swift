//
//  AxcUI_BarrageView.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/30.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AxcUI_BarrageView;

// 移动方向
typedef NS_ENUM(NSInteger, AxcBarrageMovementStyle) {
    AxcBarrageMovementStyleRightFromLeft       ,
    AxcBarrageMovementStyleLeftFromRight       ,
    AxcBarrageMovementStyleTopFromBottom,
    AxcBarrageMovementStyleBottomFromTop
};

@protocol AxcBarrageViewDelegate <NSObject>

@optional

/**
 *  每当一个周期停止运行
 */
- (void)AxcUI_barrageView:(AxcUI_BarrageView *)drawMarqueeView
         animationDidStop:(CAAnimation *)anim
                 Finished:(BOOL)finished;

/**
 *  每当一个周期开始运行
 */
- (void)AxcUI_barrageView:(AxcUI_BarrageView *)drawMarqueeView
        animationDidStart:(CAAnimation *)anim;

@end


@interface AxcUI_BarrageView : UIView

/**
 *  协议
 */
@property (nonatomic, weak) id <AxcBarrageViewDelegate> axcUI_barrageDelegate;
/**
 * 速度
 */
@property (nonatomic) CGFloat axcUI_barrageSpeed;
/**
 * 是否循环播放，默认是
 */
@property(nonatomic, assign)BOOL axcUI_barrageCycle;
/**
 *  方向
 */
@property (nonatomic) AxcBarrageMovementStyle axcUI_barrageMarqueeDirection;
/**
 * 容器
 */
- (void)AxcUI_addContentView:(UIView *)view;
/**
 *  开始
 */
- (void)AxcUI_startAnimation;
/**
 *  停止
 */
- (void)AxcUI_stopAnimation;
/**
 *  暂停
 */
- (void)AxcUI_pauseAnimation;
/**
 *  恢复
 */
- (void)AxcUI_resumeAnimation;
@end
