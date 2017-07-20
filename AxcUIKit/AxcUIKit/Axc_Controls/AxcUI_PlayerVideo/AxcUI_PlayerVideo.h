//
//  AxcUI_PlayerVideo.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AxcPlayerItem.h"
#import "AxcUI_PlayerView.h"
#import "AxcPlayerSlider.h"
#import "AxcPlayerTopMask.h"
#import "AxcPlayerBottomMask.h"
#import "AxcPlayerControlMask.h"
#import "AxcPlayerLoadingMask.h"
#import "AxcPlayerItemAssetMenuMask.h"
#import "AxcPlayerBarrageMask.h"
#import "AxcPlayerControlPlayOrPauseButton.h"
#import "AxcPlayerControlRateButton.h"
#import "AxcPlayerControlItemAssetMenuButton.h"
#import "AxcPlayerControlFullScreenButton.h"
#import "AxcPlayerControlBackButton.h"
#import "AxcPlayerControlBarrageButton.h"


@class AxcUI_PlayerVideo;

extern NSString *const AxcPlayerPlayItemAssetNotificationName;
extern NSString *const AxcPlayerDidPlayToEndNotificationName;
extern NSString *const AxcPlayerDidStateChangeNotificationName;
extern NSString *const AxcPlayerUpdateCurrentSecondsNotificationName;
extern NSString *const AxcPlayerUpdateBufferedSecondsNotificationName;

/** 播放状态 */
typedef NS_ENUM(int, AxcPlayerState) {
    AxcPlayerStateInit,
    AxcPlayerStatePrepared,
    AxcPlayerStatePlaying,
    AxcPlayerStateBuffering,
    AxcPlayerStatePaused,
    AxcPlayerStateStoped,
    AxcPlayerStateError
};

@protocol AxcPlayerVideoDelegate <NSObject>

@optional

- (BOOL)AxcUI_player:(AxcUI_PlayerVideo *)player willPlayItemAsset:(AxcPlayerItemAsset *)itemAsset originalItemAsset:(AxcPlayerItemAsset *)originalItemAsset;
- (BOOL)AxcUI_willResumeInPlayer:(AxcUI_PlayerVideo *)player;
- (void)AxcUI_didPlayToEndInPlayer:(AxcUI_PlayerVideo *)player;

- (BOOL)AxcUI_player:(AxcUI_PlayerVideo *)player willSeekToSeconds:(NSUInteger)bufferingSeconds;

/** 播放状态改变 */
- (void)AxcUI_player:(AxcUI_PlayerVideo *)player didStateChanged:(AxcPlayerState)state;

- (void)AxcUI_player:(AxcUI_PlayerVideo *)player updateCurrentSeconds:(NSUInteger)currentSeconds;
- (void)AxcUI_player:(AxcUI_PlayerVideo *)player updateBufferedSeconds:(NSUInteger)bufferingSeconds;

@end

@interface AxcUI_PlayerVideo : NSObject

/** 回调代理 */
@property (nonatomic, weak) id<AxcPlayerVideoDelegate> axcUI_playerVideoDelegate;



/** 播放器画面View */
@property (nonatomic, strong, readonly) AxcUI_PlayerView *axcUI_playerView;
/** 顶部遮罩栏 */
@property (nonatomic, strong) AxcPlayerViewMask *axcUI_topMask;
/** 底部遮罩栏 */
@property (nonatomic, strong) AxcPlayerViewMask *axcUI_bottomMask;
/** 滑动控制器 */
@property (nonatomic, strong) AxcPlayerViewMask *axcUI_controlMask;
/** 加载小菊花的遮罩 */
@property (nonatomic, strong) AxcPlayerViewMask *axcUI_loadingMask;
/** 弹幕设置版面 */
@property (nonatomic, strong) AxcPlayerBarrageMask *axcUI_barrageMask;

/** 设置清晰度按钮组 */
- (void)AxcUI_replaceCurrentItemWithPlayerItem:(AxcPlayerItem *)playerItem;
/** 初始播放哪个清晰度 */
- (void)AxcUI_playWithItemAsset:(AxcPlayerItemAsset *)itemAsset;
/** 播放一个URL下的视频 */
- (void)AxcUI_playWithURL:(NSURL *)URL;
/** 恢复、暂停自动切换 */
- (void)AxcUI_resumeOrPause;
/** 恢复播放 */
- (void)AxcUI_resume;
/** 暂停播放 */
- (void)AxcUI_pause;
/** 停止播放 */
- (void)AxcUI_stop;

/** 清除播放器，需要在界面准备退出的时候调用，会清空对象持有，防止循环引用 */
- (void)AxcUI_emptyPlayer;

- (void)AxcUI_seekToSeconds:(NSUInteger)seconds;
- (void)AxcUI_seekToSeconds:(NSUInteger)seconds completionHandler:(void (^)(BOOL finished))completionHandler;


@property (nonatomic, strong, readonly) AxcPlayerItem *currentItem;
@property (nonatomic, strong, readonly) UIView *fullScreenContainerView;
@property (nonatomic, readonly) AxcPlayerState state;
@property (nonatomic, strong, readonly) NSError *error;

@property (nonatomic) float rate;
@property (nonatomic) NSUInteger playInMoreBufferSeconds;

@end

