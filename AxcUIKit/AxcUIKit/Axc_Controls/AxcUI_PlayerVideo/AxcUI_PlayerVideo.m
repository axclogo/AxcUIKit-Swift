//
//  AxcPlayer.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_PlayerVideo.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

NSString *const AxcPlayerPlayItemAssetNotificationName = @"AxcPlayerPlayItemAssetNotificationName";
NSString *const AxcPlayerDidPlayToEndNotificationName = @"AxcPlayerDidPlayToEndNotificationName";
NSString *const AxcPlayerDidStateChangeNotificationName = @"AxcPlayerDidStateChangeNotificationName";
NSString *const AxcPlayerUpdateCurrentSecondsNotificationName = @"AxcPlayerUpdateCurrentSecondsNotificationName";
NSString *const AxcPlayerUpdateBufferedSecondsNotificationName = @"AxcPlayerUpdateBufferedSecondsNotificationName";

@interface AxcPlayerItem (Update)

- (void)updateDuration:(NSUInteger)duration;
- (void)updateCurrentSeconds:(NSUInteger)currentSeconds;
- (void)updateBufferedSeconds:(NSUInteger)bufferedSeconds;
- (void)updatePlayingAsset:(AxcPlayerItemAsset *)playingAsset;

@end

@interface AxcUI_PlayerVideo ()

@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) id timeObserver;
@property (nonatomic) AVPlayerItemStatus lastPlayerItemStatus;

@property (nonatomic, strong) AxcPlayerItem *currentItem;
@property (nonatomic, strong) AxcUI_PlayerView *axcUI_playerView;
@property (nonatomic, strong) UIView *fullScreenContainerView;

@property (nonatomic) AxcPlayerState state;
@property (nonatomic) AxcPlayerState beforeEnterBackgroundState;

@property (nonatomic) NSInteger seekSeconds;
@property (nonatomic, copy) void (^seekCompletionHandler)(BOOL finished);

@end

@implementation AxcUI_PlayerVideo

@synthesize rate = _rate;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.playInMoreBufferSeconds = 10;
        self.state = AxcPlayerStateInit;
        self.rate = 1;
        
        self.axcUI_controlMask = [[AxcPlayerControlMask alloc] initWithPlayerView:self.axcUI_playerView];
        self.axcUI_topMask = [[AxcPlayerTopMask alloc] initWithPlayerView:self.axcUI_playerView];
        self.axcUI_bottomMask = [[AxcPlayerBottomMask alloc] initWithPlayerView:self.axcUI_playerView];
        self.axcUI_loadingMask = [[AxcPlayerLoadingMask alloc] initWithPlayerView:self.axcUI_playerView];
        self.axcUI_barrageMask = [[AxcPlayerBarrageMask alloc] initWithPlayerView:self.axcUI_playerView];
        
        /** 自带一个返回按键 */
        AxcPlayerTopMask *topMask = (AxcPlayerTopMask *)self.axcUI_topMask;
        AxcPlayerControlBackButton *backButton = [[AxcPlayerControlBackButton alloc] initWithMask:topMask mainBlock:nil];
        topMask.leftButtons = @[ backButton];
        
        
        [self addNotification];
    }
    return self;
}

- (void)dealloc {
    
    self.playerItem = nil;
    
    [self.axcUI_playerView removeFromSuperview];
    [self.axcUI_playerView.containerView.playerLayer removeFromSuperlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)AxcUI_replaceCurrentItemWithPlayerItem:(AxcPlayerItem *)playerItem {
    if (playerItem == nil) return;
    
    self.state = AxcPlayerStateStoped;
    self.currentItem = playerItem;
}

- (void)AxcUI_playWithItemAsset:(AxcPlayerItemAsset *)itemAsset {
    if (itemAsset == nil || itemAsset.URL == nil) return;
    
    if ([self.axcUI_playerVideoDelegate respondsToSelector:@selector(AxcUI_player:willPlayItemAsset:originalItemAsset:)]) {
        if (![self.axcUI_playerVideoDelegate AxcUI_player:self
                       willPlayItemAsset:itemAsset
                       originalItemAsset:self.currentItem.playingAsset]) {
            return;
        }
    }
    
    if (self.currentItem == nil || ![self.currentItem.assets containsObject:itemAsset]) {
        AxcPlayerItem *item = [[AxcPlayerItem alloc] init];
        item.assets = @[itemAsset];
        [self AxcUI_replaceCurrentItemWithPlayerItem:item];
    } else {
        self.state = AxcPlayerStateStoped;
    }
    
    self.lastPlayerItemStatus = AVPlayerItemStatusUnknown;
    [self.currentItem updatePlayingAsset:itemAsset];
    
    self.playerItem = [[AVPlayerItem alloc] initWithURL:itemAsset.URL];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AxcPlayerPlayItemAssetNotificationName object:self];
    
}

- (void)AxcUI_playWithURL:(NSURL *)URL {
    AxcPlayerItemAsset *itemAsset = [[AxcPlayerItemAsset alloc] initWithType:@"" URL:URL];
    
    AxcPlayerItem *item = [[AxcPlayerItem alloc] init];
    item.assets = @[itemAsset];
    
    [self AxcUI_replaceCurrentItemWithPlayerItem:item];
    [self AxcUI_playWithItemAsset:itemAsset];
}

- (void)AxcUI_resumeOrPause {
    if (self.state == AxcPlayerStatePlaying) {
        [self AxcUI_pause];
    } else {
        [self AxcUI_resume];
    }
}

- (void)AxcUI_resume {
    if (self.playerItem == nil) {
        if (self.currentItem != nil && self.currentItem.playingAsset != nil) {
            [self AxcUI_playWithItemAsset:self.currentItem.playingAsset];
        }
        return;
    } else if (self.playerItem.status != AVPlayerItemStatusReadyToPlay) {
        return;;
    }
    
    if (self.seekSeconds > -1) {
        __weak typeof(self) weaKSelf = self;
        [self AxcUI_seekToSeconds:self.seekSeconds completionHandler:^(BOOL finished) {
            if (weaKSelf.seekCompletionHandler != nil) {
                weaKSelf.seekCompletionHandler(finished);
            }
            weaKSelf.seekSeconds = -1;
            weaKSelf.seekCompletionHandler = nil;
        }];
    } else {
        self.state = AxcPlayerStatePlaying;
    }
}

- (void)AxcUI_pause {
    
    if (self.playerItem == nil || self.playerItem.status != AVPlayerItemStatusReadyToPlay) return;
    
    self.state = AxcPlayerStatePaused;
}

- (void)AxcUI_stop {
    self.state = AxcPlayerStateStoped;
}

- (void)AxcUI_seekToSeconds:(NSUInteger)seconds {
    [self AxcUI_seekToSeconds:seconds completionHandler:^(BOOL finished) {
        if (finished) {
            NSUInteger canPlaySeconds = self.currentItem.currentSeconds + self.playInMoreBufferSeconds;
            if (canPlaySeconds > self.currentItem.duration) {
                canPlaySeconds = self.currentItem.duration;
            }
            if (self.currentItem.bufferedSeconds >= canPlaySeconds) {
                self.state = AxcPlayerStatePlaying;
            } else {
                self.state = AxcPlayerStateBuffering;
            }
        }
    }];
}

- (void)AxcUI_seekToSeconds:(NSUInteger)seconds completionHandler:(void (^)(BOOL finished))completionHandler {
    if (self.playerItem.status != AVPlayerItemStatusReadyToPlay) {
        self.seekSeconds = seconds;
        self.seekCompletionHandler = completionHandler;
        return;
    }
    
    if ([self.axcUI_playerVideoDelegate respondsToSelector:@selector(AxcUI_player:willSeekToSeconds:)]) {
        if (![self.axcUI_playerVideoDelegate AxcUI_player:self willSeekToSeconds:seconds]) {
            if (completionHandler != nil) {
                completionHandler(NO);
            }
            return;
        }
    }
    
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(seconds, 1) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if (completionHandler != nil) {
            completionHandler(finished);
        }
    }];
}

#pragma mark - selector

- (void)playEnd:(NSNotification *)notification {
    
    if (![self.playerItem isEqual:notification.object]) return;
    
    self.state = AxcPlayerStateStoped;
    
    if ([self.axcUI_playerVideoDelegate respondsToSelector:@selector(AxcUI_didPlayToEndInPlayer:)]) {
        [self.axcUI_playerVideoDelegate AxcUI_didPlayToEndInPlayer:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AxcPlayerDidPlayToEndNotificationName object:self];
}

- (void)applicationDidEnterBackground {
    if (self.state != AxcPlayerStatePlaying) return;
    self.beforeEnterBackgroundState = self.state;
    self.state = AxcPlayerStatePaused;
}

- (void)applicationWillEnterForeground {
    if (self.beforeEnterBackgroundState == AxcPlayerStatePlaying) {
        self.state = AxcPlayerStatePlaying;
        self.beforeEnterBackgroundState = AxcPlayerStateInit;
    }
}

#pragma mark - KVO

- (void)addTimerObserver {
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        
        if (weakSelf == nil ||
            weakSelf.state == AxcPlayerStateInit || weakSelf.state == AxcPlayerStateError ||
            weakSelf.axcUI_playerView.superview == nil) return;
        
        NSUInteger currentSeconds = time.value * 1.0 / time.timescale;
        
        [weakSelf.currentItem updateCurrentSeconds:currentSeconds];
        
        if ([weakSelf.axcUI_playerVideoDelegate respondsToSelector:@selector(AxcUI_player:updateCurrentSeconds:)]) {
            [weakSelf.axcUI_playerVideoDelegate AxcUI_player:weakSelf updateCurrentSeconds:currentSeconds];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AxcPlayerUpdateCurrentSecondsNotificationName object:weakSelf];
    }];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSString*, id> *)change context:(nullable void *)context {
    
    if (self.axcUI_playerView.superview == nil) return;
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = self.playerItem.status;
        if (self.lastPlayerItemStatus == status) return;
        self.lastPlayerItemStatus = status;
        switch (status) {
            case AVPlayerItemStatusReadyToPlay: {
                
                NSUInteger duration = floor(self.playerItem.asset.duration.value * 1.0 / self.playerItem.asset.duration.timescale);
                [self.currentItem updateDuration:duration];
                
                self.state = AxcPlayerStatePrepared;
                [self AxcUI_resume];
                break;
            }
            case AVPlayerItemStatusFailed: {
                NSLog(@"%@", self.playerItem.error);
                self.state = AxcPlayerStateError;
                break;
            }
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        if (self.axcUI_playerView.superview == nil || self.state == AxcPlayerStateInit || self.state == AxcPlayerStateError) return;
        
        //缓冲进度
        NSArray *loadedTimeRanges = [self.playerItem loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSUInteger bufferedSeconds = startSeconds + durationSeconds;
        
        [self.currentItem updateBufferedSeconds:bufferedSeconds];
        
        if (self.state == AxcPlayerStateBuffering) {
            NSUInteger canPlaySeconds = self.currentItem.currentSeconds + self.playInMoreBufferSeconds;
            if (canPlaySeconds > self.currentItem.duration) {
                canPlaySeconds = self.currentItem.duration;
            }
            if (bufferedSeconds >= canPlaySeconds) {
                self.state = AxcPlayerStatePlaying;
            }
        }
        
        if ([self.axcUI_playerVideoDelegate respondsToSelector:@selector(AxcUI_player:updateBufferedSeconds:)]) {
            [self.axcUI_playerVideoDelegate AxcUI_player:self updateBufferedSeconds:bufferedSeconds];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AxcPlayerUpdateBufferedSecondsNotificationName object:self];
        
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        //播放未完成，但缓冲不足
        self.state = AxcPlayerStateBuffering;
    }
}

- (void)AxcUI_emptyPlayer{
    [self AxcUI_stop];
    [self.axcUI_playerView removeFromSuperview];
}

#pragma mark - Notification

- (void)addNotification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(playEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //[defaultCenter addObserver:self selector:@selector(jumped:) name:AVPlayerItemTimeJumpedNotification object:nil];
    //[defaultCenter addObserver:self selector:@selector(playbackStalled:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - getters setters

- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    if ([_playerItem isEqual:playerItem]) return;
    
    if (_playerItem != nil) {
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        
        [self.avPlayer pause];
        [self.avPlayer replaceCurrentItemWithPlayerItem:nil];
        [self.avPlayer removeTimeObserver:self.timeObserver];
        self.axcUI_playerView.containerView.playerLayer.player = nil;
        self.timeObserver = nil;
    }
    _playerItem = playerItem;
    if (_playerItem != nil) {
        self.avPlayer = [[AVPlayer alloc] init];
        self.axcUI_playerView.containerView.playerLayer.player = self.avPlayer;
        [self.avPlayer replaceCurrentItemWithPlayerItem:_playerItem];
        [self addTimerObserver];
        
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)setState:(AxcPlayerState)state {
    if (_state == state) return;
    if (_state == AxcPlayerStateInit && state != AxcPlayerStatePrepared) return;
    
    switch (state) {
        case AxcPlayerStatePlaying: {
            if ([self.axcUI_playerVideoDelegate respondsToSelector:@selector(AxcUI_willResumeInPlayer:)]) {
                if (![self.axcUI_playerVideoDelegate AxcUI_willResumeInPlayer:self]) {
                    return;
                }
            }
            break;
        }
        default:
            break;
    }
    
    _state = state;
    
    switch (_state) {
        case AxcPlayerStatePrepared: {
            break;
        }
        case AxcPlayerStatePlaying: {
            [self.avPlayer play];
            self.avPlayer.rate = self.rate;
            break;
        }
        case AxcPlayerStateBuffering:
        case AxcPlayerStatePaused: {
            [self.avPlayer pause];
            break;
        }
        case AxcPlayerStateError:
        case AxcPlayerStateStoped: {
            if (self.playerItem != nil) {
                [self.avPlayer pause];
                self.playerItem = nil;
            }
            break;
        }
        default:
            break;
    }
    
    if ([self.axcUI_playerVideoDelegate respondsToSelector:@selector(AxcUI_player:didStateChanged:)]) {
        [self.axcUI_playerVideoDelegate AxcUI_player:self didStateChanged:_state];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AxcPlayerDidStateChangeNotificationName object:self];
}

- (void)setRate:(float)rate {
    _rate = rate;
    self.avPlayer.rate = rate;
}

- (NSError *)error {
    return self.playerItem.error;
}

- (AxcUI_PlayerView *)axcUI_playerView {
    if (_axcUI_playerView == nil) {
        _axcUI_playerView = [[AxcUI_PlayerView alloc] initWithPlayer:self];
    }
    return _axcUI_playerView;
}

- (UIView *)fullScreenContainerView {
    if (_fullScreenContainerView == nil) {
        _fullScreenContainerView = [[UIView alloc] init];
        _fullScreenContainerView.backgroundColor = [UIColor clearColor];
        _fullScreenContainerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _fullScreenContainerView;
}

- (void)setAxcUI_controlMask:(AxcPlayerViewMask *)axcUI_controlMask {
    if (_axcUI_controlMask != nil) {
        [self.axcUI_playerView AxcUI_removeMask:_axcUI_controlMask animated:NO];
    }
    _axcUI_controlMask = axcUI_controlMask;
    [self.axcUI_playerView AxcUI_addMask:_axcUI_controlMask animated:NO];
    [self.axcUI_playerView.containerView.maskContainerView sendSubviewToBack:_axcUI_controlMask];
}

- (void)setAxcUI_bottomMask:(AxcPlayerViewMask *)axcUI_bottomMask {
    if (_axcUI_bottomMask != nil) {
        [self.axcUI_playerView AxcUI_removeMask:_axcUI_bottomMask animated:NO];
    }
    _axcUI_bottomMask = axcUI_bottomMask;
    [self.axcUI_playerView AxcUI_addMask:_axcUI_bottomMask animated:NO];
}

- (void)setAxcUI_loadingMask:(AxcPlayerViewMask *)axcUI_loadingMask {
    if (_axcUI_loadingMask != nil) {
        [self.axcUI_playerView AxcUI_removeMask:_axcUI_loadingMask animated:NO];
    }
    _axcUI_loadingMask = axcUI_loadingMask;
    [self.axcUI_playerView AxcUI_addMask:_axcUI_loadingMask animated:NO];
}

//- (void)setAxcUI_barrageMask:(AxcPlayerBarrageMask *)axcUI_barrageMask{
//    if (_axcUI_barrageMask != nil) {
//        [self.axcUI_playerView AxcUI_removeMask:_axcUI_barrageMask animated:NO];
//    }
//    _axcUI_barrageMask = axcUI_barrageMask;
//    [self.axcUI_playerView AxcUI_addMask:_axcUI_barrageMask animated:NO];
//}


@end

