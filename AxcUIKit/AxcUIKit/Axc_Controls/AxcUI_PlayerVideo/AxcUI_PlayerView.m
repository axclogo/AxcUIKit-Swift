//
//  AxcUI_PlayerView.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//
#import "AxcUI_PlayerView.h"
#import "AxcUI_PlayerVideo.h"
#import "AxcPlayerOrientationDmonitor.h"
#import "AxcPlayerChangeOrientationOperation.h"

#import "UIView+AxcAutoresizingMask.h"

NSString *const AxcUI_PlayerViewWillOrientationChangeNotificationName = @"AxcUI_PlayerViewWillOrientationChangeNotificationName";
NSString *const AxcUI_PlayerViewDidChangedOrientationNotificationName = @"AxcUI_PlayerViewDidChangedOrientationNotificationName";
NSString *const AxcUI_PlayerViewTapControlButtoneNotificationName = @"AxcUI_PlayerViewTapControlButtoneNotificationName";

NSString *const AxcUI_PlayerViewWillChangeOrientationKey = @"AxcUI_PlayerViewWillChangeOrientationKey";
NSString *const AxcUI_PlayerViewWillChangeFromOrientationKey = @"AxcUI_PlayerViewWillChangeFromOrientationKey";

@interface AxcUI_PlayerView ()<AxcBarrageScrollEngineDelegate>



@property (nonatomic, strong) AxcPlayerContainerView *containerView;

@property (nonatomic, weak) AxcUI_PlayerVideo *currentPlayer;

@property (nonatomic, strong) NSOperationQueue *changeOrientationQueue;
@property (nonatomic, strong) AxcPlayerOrientationDmonitor *orientationDmonitor;
@property (nonatomic) UIInterfaceOrientation axcUI_visibleInterfaceOrientation;

@property (nonatomic, strong) NSMutableArray *lockMasks;

@end

@implementation AxcUI_PlayerView

- (instancetype)initWithPlayer:(AxcUI_PlayerVideo *)player {
    self = [super init];
    if (self) {
        self.currentPlayer = player;
        self.lockMasks = [NSMutableArray array];
        
        self.axcUI_supportedOrientations = UIInterfaceOrientationMaskLandscape;
        self.axcUI_visibleInterfaceOrientation = UIInterfaceOrientationUnknown;
        self.axcUI_autoChangedOrientation = YES;
        self.axcUI_autoFullScreen = YES;
        
        [self addSubview:self.containerView];
        
        __weak typeof(self) weakSelf = self;
        self.orientationDmonitor = [[AxcPlayerOrientationDmonitor alloc] initWidthUpdateHandler:^(UIDeviceOrientation deviceOrientation) {
            [weakSelf orientationChanged:deviceOrientation];
        }];
        [self.orientationDmonitor startDmonitor];
        
        self.changeOrientationQueue = [[NSOperationQueue alloc] init];
        self.changeOrientationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)dealloc {
    [self.changeOrientationQueue cancelAllOperations];
    [self.orientationDmonitor stopDmonitor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.containerView.superview isEqual:self]) {
        self.containerView.frame = self.bounds;
    }
    // 此处非主动调用懒加载
    _axcUI_barrageEngine.axcUI_barrageCanvas.frame = self.containerView.maskContainerView.bounds;
}

- (void)AxcUI_addMask:(AxcPlayerViewMask *)mask animated:(BOOL)animated {
    if ([self containsMask:mask]) return;
    
    if ([self.axcUI_playerViewDelegate respondsToSelector:@selector(playerView:willAxcUI_addMask:animated:)]) {
        if (![self.axcUI_playerViewDelegate playerView:self willAxcUI_addMask:mask animated:animated]) {
            return;
        }
    }
    
    if ([mask respondsToSelector:@selector(willAddToPlayerView:animated:)]) {
        [mask willAddToPlayerView:self animated:animated];
    }
    
    [self.containerView.maskContainerView addSubview:mask];
    
    if (self.currentPlayer.state != AxcPlayerStateInit &&
        self.currentPlayer.state != AxcPlayerStateStoped &&
        self.currentPlayer.state != AxcPlayerStateError) {
        [mask reload];
    }
    
    void(^completionHanler)() = ^{
        if ([mask respondsToSelector:@selector(autoRemoveSeconds)] && [mask autoRemoveSeconds] > 0) {
            [self performSelector:@selector(delayRemoveMask:) withObject:mask afterDelay:[mask autoRemoveSeconds]];
        }
    };
    if (animated && [mask respondsToSelector:@selector(addAnimationWithCompletion:)]) {
        [mask addAnimationWithCompletion:completionHanler];
    } else {
        completionHanler();
    }
}

- (void)AxcUI_removeMask:(AxcPlayerViewMask *)mask animated:(BOOL)animated {
    
    if (![self containsMask:mask]) return;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayRemoveMask:) object:mask];
    
    if ([self.axcUI_playerViewDelegate respondsToSelector:@selector(playerView:willRemoveMask:animated:)]) {
        if (![self.axcUI_playerViewDelegate playerView:self willRemoveMask:mask animated:animated]) {
            return;
        }
    }
    
    if ([mask respondsToSelector:@selector(willRemoveFromPlayerView:animated:)]) {
        [mask willRemoveFromPlayerView:self animated:animated];
    }
    
    if (animated && [mask respondsToSelector:@selector(removeAnimationWithCompletion:)]) {
        [mask removeAnimationWithCompletion:^{
            [mask removeFromSuperview];
        }];
    } else {
        [mask removeFromSuperview];
    }
}

- (BOOL)containsMask:(AxcPlayerViewMask *)mask {
    return [self.masks containsObject:mask];
}

- (NSArray<AxcPlayerViewMask *> *)findMaskWithClass:(Class)maskClass {
    return [self.masks filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary<NSString *,id> *bindings) {
        return [evaluatedObject isKindOfClass:maskClass];
    }]];
}

- (void)AxcUI_lockAutoRemove:(BOOL)lock withMask:(AxcPlayerViewMask *)mask {
    if (lock) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayRemoveMask:) object:mask];
    } else {
        if ([mask respondsToSelector:@selector(autoRemoveSeconds)] && [mask autoRemoveSeconds] > 0) {
            [self performSelector:@selector(delayRemoveMask:) withObject:mask afterDelay:[mask autoRemoveSeconds]];
        }
    }
}

- (void)AxcUI_performOrientationChange:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    
    __weak typeof(self) weakSelf = self;
    [self.changeOrientationQueue cancelAllOperations];
    [self.changeOrientationQueue addOperation:[AxcPlayerChangeOrientationOperation blockOperationWithBlock:^(AxcPlayerChangeOrientationOperationCompletionHandler completionHandler) {
        
        if (weakSelf == nil || weakSelf.superview == nil) {
            completionHandler();
            return;
        }
        
        UIInterfaceOrientation fromOrientation = weakSelf.axcUI_visibleInterfaceOrientation;
        UIInterfaceOrientation changeToOrientation = orientation;
        
        if (!((1 << changeToOrientation) & weakSelf.axcUI_supportedOrientations)) {
            changeToOrientation = UIInterfaceOrientationUnknown;
        }
        
        if ([weakSelf.axcUI_playerViewDelegate respondsToSelector:@selector(playerView:willOrientationChange:)]) {
            if (![weakSelf.axcUI_playerViewDelegate playerView:weakSelf willOrientationChange:changeToOrientation]) {
                completionHandler();
                return;
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AxcUI_PlayerViewWillOrientationChangeNotificationName
                                                            object:weakSelf
                                                          userInfo:@{
                                                                     AxcUI_PlayerViewWillChangeOrientationKey: @(changeToOrientation),
                                                                     AxcUI_PlayerViewWillChangeFromOrientationKey: @(fromOrientation)
                                                                     }];
        
        CGFloat degrees = [weakSelf degreesForOrientation:changeToOrientation];
        CGFloat rotation = (M_PI * degrees / 180.0f);
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        BOOL isOriginalFullScreen = fromOrientation != UIInterfaceOrientationUnknown;
        BOOL isChangeFullScreen = changeToOrientation != UIInterfaceOrientationUnknown;
        
        weakSelf.axcUI_visibleInterfaceOrientation = changeToOrientation;
        
        CGRect containerViewFrame = CGRectZero;
        if (isChangeFullScreen) {
            
            if ([weakSelf.currentPlayer.fullScreenContainerView.superview isEqual:keyWindow]) {
                weakSelf.currentPlayer.fullScreenContainerView.frame = keyWindow.bounds;
            }
            
            if (!isOriginalFullScreen) {
                
                if (weakSelf.currentPlayer.fullScreenContainerView.superview == nil) {
                    weakSelf.currentPlayer.fullScreenContainerView.frame = keyWindow.bounds;
                    [keyWindow addSubview:weakSelf.currentPlayer.fullScreenContainerView];
                }
                
                [weakSelf.containerView removeFromSuperview];
                weakSelf.containerView.frame = [weakSelf.currentPlayer.fullScreenContainerView convertRect:weakSelf.frame fromView:weakSelf.superview];
                [weakSelf.currentPlayer.fullScreenContainerView addSubview:weakSelf.containerView];
            }
            
            containerViewFrame = weakSelf.currentPlayer.fullScreenContainerView.bounds;
        } else {
            if ([weakSelf.containerView.superview isEqual:weakSelf.currentPlayer.fullScreenContainerView]) {
                containerViewFrame = [weakSelf.currentPlayer.fullScreenContainerView convertRect:weakSelf.frame fromView:weakSelf.superview];
            } else {
                containerViewFrame = weakSelf.bounds;
            }
        }
        
        void(^completionBlock)() = ^{
            if (!isChangeFullScreen) {
                
                [weakSelf.containerView removeFromSuperview];
                weakSelf.containerView.frame = weakSelf.bounds;
                [weakSelf addSubview:weakSelf.containerView];
                
                if ([weakSelf.currentPlayer.fullScreenContainerView.superview isEqual:keyWindow]) {
                    [weakSelf.currentPlayer.fullScreenContainerView removeFromSuperview];
                }
            }
            
            if ([weakSelf.axcUI_playerViewDelegate respondsToSelector:@selector(playerView:didChangedOrientation:fromOrientation:)]) {
                [weakSelf.axcUI_playerViewDelegate playerView:weakSelf didChangedOrientation:changeToOrientation fromOrientation:fromOrientation];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:AxcUI_PlayerViewDidChangedOrientationNotificationName object:weakSelf];
        };
        
        if (animated) {
            [UIView animateWithDuration:0.3f animations:^{
                
                weakSelf.containerView.transform = CGAffineTransformMakeRotation(rotation);
                weakSelf.containerView.frame = containerViewFrame;
                
            } completion:^(BOOL finished) {
                
                completionBlock();
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    completionHandler();
                });
            }];
        } else {
            weakSelf.containerView.transform = CGAffineTransformMakeRotation(rotation);
            weakSelf.containerView.frame = containerViewFrame;
            
            completionBlock();
            completionHandler();
        }
    }]];
}

#pragma mark - selector

- (void)delayRemoveMask:(AxcPlayerViewMask *)mask {
    [self AxcUI_removeMask:mask animated:YES];
}

- (void)orientationChanged:(UIDeviceOrientation)deviceOrientation {
    if (!self.axcUI_autoChangedOrientation) {
        return;
    }
    
    UIInterfaceOrientation rotateToOrientation;
    switch(deviceOrientation) {
        case UIDeviceOrientationPortrait:
            rotateToOrientation = UIInterfaceOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            rotateToOrientation = UIInterfaceOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeLeft:
            rotateToOrientation = UIInterfaceOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            rotateToOrientation = UIInterfaceOrientationLandscapeLeft;
            break;
        default:
            return;
    }
    
    if ((!((1 << rotateToOrientation) & self.axcUI_supportedOrientations) || self.axcUI_visibleInterfaceOrientation == UIDeviceOrientationUnknown) && !self.axcUI_autoFullScreen) {
        return;
    }
    
    [self AxcUI_performOrientationChange:rotateToOrientation animated:YES];
}

- (CGFloat)degreesForOrientation:(UIInterfaceOrientation)orientation {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow.bounds.size.width > keyWindow.bounds.size.height) {
        switch (orientation) {
            case UIInterfaceOrientationUnknown:
                return 0;
            case UIInterfaceOrientationPortrait:
                return -90;
            case UIInterfaceOrientationLandscapeRight: {
                if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight) {
                    return -180;
                } else {
                    return 0;
                }
            }
            case UIInterfaceOrientationLandscapeLeft: {
                if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
                    return -180;
                } else {
                    return 0;
                }
            }
            case UIInterfaceOrientationPortraitUpsideDown:
                return 90;
        }
    } else {
        switch (orientation) {
            case UIInterfaceOrientationUnknown:
            case UIInterfaceOrientationPortrait:
                return 0;
            case UIInterfaceOrientationLandscapeRight:
                return 90;
            case UIInterfaceOrientationLandscapeLeft:
                return -90;
            case UIInterfaceOrientationPortraitUpsideDown:
                return 180;
        }
    }
}

#pragma mark - getters setters

- (BOOL)axcUI_isFullScreen {
    return self.axcUI_visibleInterfaceOrientation != UIDeviceOrientationUnknown;
}

- (void)setAxcUI_ignoreScreenSystemLock:(BOOL)axcUI_ignoreScreenSystemLock {
    self.orientationDmonitor.ignoreScreenSystemLock = axcUI_ignoreScreenSystemLock;
}

- (BOOL)axcUI_ignoreScreenSystemLock {
    return self.orientationDmonitor.ignoreScreenSystemLock;
}

- (NSArray<AxcPlayerViewMask *> *)masks {
    return [self.containerView.maskContainerView.subviews copy];
}

- (AxcPlayerContainerView *)containerView {
    if (_containerView == nil) {
        _containerView = [[AxcPlayerContainerView alloc] init];
    }
    return _containerView;
}

- (AxcUI_BarrageScrollEngine *)axcUI_barrageEngine{
    if (!_axcUI_barrageEngine) {
        _axcUI_barrageEngine = [[AxcUI_BarrageScrollEngine alloc] init];
        [_axcUI_barrageEngine.axcUI_barrageCanvas AxcUI_autoresizingMaskComprehensive];
        _axcUI_barrageEngine.axcUI_barrageCanvas.backgroundColor = [UIColor clearColor];
        // 代理
        _axcUI_barrageEngine.axcUI_barrageDelegate = self;
        // 计时器多少秒调用一次代理方法 默认1s
        _axcUI_barrageEngine.axcUI_barrageTimeInterval = 1;
        // 开始滚动弹幕
        _axcUI_barrageEngine.axcUI_barrageCanvas.autoresizesSubviews = YES;
        [self.containerView.maskContainerView addSubview:_axcUI_barrageEngine.axcUI_barrageCanvas];
    }
    return _axcUI_barrageEngine;
}

#pragma mark - AxcUI_BarrageScrollEngineDelegate
// 弹幕数据源方法转移到外部
- (NSArray <__kindof AxcUI_BarrageModelBase*>*)AxcUI_barrageScrollEngine:(AxcUI_BarrageScrollEngine *)barrageEngine
                                                    didSendBarrageAtTime:(NSUInteger)time {
    if ([_axcUI_playerViewBarrageDataSource
         respondsToSelector:@selector(AxcUI_playeBarrageScrollEngine:didSendBarrageAtTime:)]) {
        return [_axcUI_playerViewBarrageDataSource AxcUI_playeBarrageScrollEngine:barrageEngine didSendBarrageAtTime:time];
    }else{
        return nil;
    }
}
- (BOOL)AxcUI_barrageScrollEngine:(AxcUI_BarrageScrollEngine *)barrageEngine
                shouldSendBarrage:(__kindof AxcUI_BarrageModelBase *)barrage{
    if ([_axcUI_playerViewBarrageDataSource
         respondsToSelector:@selector(AxcUI_playeBarrageScrollEngine:shouldSendBarrage:)]) {
        return [_axcUI_playerViewBarrageDataSource AxcUI_playeBarrageScrollEngine:barrageEngine shouldSendBarrage:barrage];
    }else{
        return YES;
    }
}

@end
