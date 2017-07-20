//
//  AxcUI_PlayerView.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxcPlayerViewMask.h"
#import "AxcPlayerContainerView.h"
#import "AxcPlayerControlButton.h"

extern NSString *const AxcUI_PlayerViewWillOrientationChangeNotificationName;
extern NSString *const AxcUI_PlayerViewDidChangedOrientationNotificationName;
extern NSString *const AxcUI_PlayerViewTapControlButtoneNotificationName;

extern NSString *const AxcUI_PlayerViewWillChangeOrientationKey;
extern NSString *const AxcUI_PlayerViewWillChangeFromOrientationKey;


@class AxcUI_PlayerVideo;
@class AxcUI_PlayerView;

@protocol AxcPlayerViewDelegate <NSObject>

@optional

/** 方向切换/变化时候调用 */
- (BOOL)playerView:(AxcUI_PlayerView *)playerView willOrientationChange:(UIInterfaceOrientation)orientation;
/** 方向切换/变化之后调用 */
- (void)playerView:(AxcUI_PlayerView *)playerView didChangedOrientation:(UIInterfaceOrientation)orientation fromOrientation:(UIInterfaceOrientation)fromOrientation;
/** 点击屏幕遮罩/进度以及相关控制准备出现 */
- (BOOL)playerView:(AxcUI_PlayerView *)playerView willAxcUI_addMask:(AxcPlayerViewMask *)mask animated:(BOOL)animated;
/** 点击屏幕遮罩/进度以及相关控制准备消失/移除 */
- (BOOL)playerView:(AxcUI_PlayerView *)playerView willRemoveMask:(AxcPlayerViewMask *)mask animated:(BOOL)animated;
/** 点击控制按钮 */
- (BOOL)playerView:(AxcUI_PlayerView *)playerView willTapControlButton:(AxcPlayerControlButton *)controlButton;

@end

@interface AxcUI_PlayerView : UIView

@property (nonatomic, weak) id<AxcPlayerViewDelegate> axcUI_playerViewDelegate;
/** 当前的播放器 */
@property (nonatomic, weak, readonly) AxcUI_PlayerVideo *currentPlayer;
/** 自适配/适应屏幕转向 */
@property (nonatomic) BOOL axcUI_autoChangedOrientation;
/** 自适配/自动填充屏幕 */
@property (nonatomic) BOOL axcUI_autoFullScreen;
/** 忽略系统锁定屏幕 */
@property (nonatomic) BOOL axcUI_ignoreScreenSystemLock;
/** 屏幕转向 */
@property (nonatomic) UIInterfaceOrientationMask axcUI_supportedOrientations;
/** 屏幕转向，获得当前设备方向时候用 */
@property (nonatomic, readonly) UIInterfaceOrientation axcUI_visibleInterfaceOrientation;
/** 当前是否填充屏幕 */
@property (nonatomic, readonly) BOOL axcUI_isFullScreen;



- (instancetype)initWithPlayer:(AxcUI_PlayerVideo *)player;

/** 添加一个遮罩/动画 */
- (void)AxcUI_addMask:(AxcPlayerViewMask *)mask animated:(BOOL)animated;
/** 移除一个遮罩/动画 */
- (void)AxcUI_removeMask:(AxcPlayerViewMask *)mask animated:(BOOL)animated;
/** 判断是否包含/显示一个遮罩 */
- (BOOL)containsMask:(AxcPlayerViewMask *)mask;

/** 锁定一个遮罩 */
- (void)AxcUI_lockAutoRemove:(BOOL)lock withMask:(AxcPlayerViewMask *)mask;
/** 改变视频的朝向 */
- (void)AxcUI_performOrientationChange:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

// 内部API 作用是快速枚举当前的遮罩控件组 理解透彻的同学也可以调用修改
- (NSArray<AxcPlayerViewMask *> *)findMaskWithClass:(Class)maskClass;
@property (nonatomic, strong, readonly) AxcPlayerContainerView *containerView;
@property (nonatomic, strong, readonly) NSArray<AxcPlayerViewMask *> *masks;
@end
