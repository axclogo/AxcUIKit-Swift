//
//  AxcPlayerControlButton.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerControlButton.h"
#import "AxcUI_PlayerVideo.h"

@interface AxcPlayerControlButton ()

@property (nonatomic, weak) AxcPlayerViewMask *currentMask;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, copy) void(^mainBlock)();

@end

@implementation AxcPlayerControlButton

- (instancetype)initWithMask:(AxcPlayerViewMask *)mask mainBlock:(void(^)())mainBlock {
    self = [self initWithMask:mask];
    if (self) {
        self.mainBlock = mainBlock;
    }
    return self;
}

- (instancetype)initWithMask:(AxcPlayerViewMask *)mask {
    self = [super init];
    if (self) {
        self.currentMask = mask;
        [self.button addTarget:self action:@selector(buttonTap) forControlEvents:UIControlEventTouchUpInside];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_playerDidChangedState:)
                                                     name:AxcPlayerDidStateChangeNotificationName
                                                   object:self.currentMask.currentPlayerView.currentPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_playerViewWillChangeOrientation:)
                                                     name:AxcUI_PlayerViewWillOrientationChangeNotificationName
                                                   object:self.currentMask.currentPlayerView];
    }
    return self;
}

- (void)dealloc {
    self.mainBlock = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AxcPlayerDidStateChangeNotificationName object:self.currentMask.currentPlayerView.currentPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AxcUI_PlayerViewWillOrientationChangeNotificationName object:self.currentMask.currentPlayerView];
}

- (void)reload {
    
}

- (void)main {
    
}


#pragma mark - selector

- (void)_playerDidChangedState:(NSNotification *)notification {
    
    if (self.currentMask.currentPlayerView.currentPlayer.state == AxcPlayerStatePrepared) {
        [self reload];
    }
    
    if ([self respondsToSelector:@selector(playerDidChangedState)]) {
        [self playerDidChangedState];
    }
}

- (void)_playerViewWillChangeOrientation:(NSNotification *)notification {
    UIInterfaceOrientation willChangeOrientation = [[notification.userInfo objectForKey:AxcUI_PlayerViewWillChangeOrientationKey] integerValue];
    UIInterfaceOrientation changeFromOrientation = [[notification.userInfo objectForKey:AxcUI_PlayerViewWillChangeFromOrientationKey] integerValue];
    if ([self respondsToSelector:@selector(playerViewWillChangeOrientation:fromOrientation:)]) {
        [self playerViewWillChangeOrientation:willChangeOrientation fromOrientation:changeFromOrientation];
    }
}

- (void)buttonTap {
    if ([self.currentMask.currentPlayerView.axcUI_playerViewDelegate respondsToSelector:@selector(playerView:willTapControlButton:)]) {
        if (![self.currentMask.currentPlayerView.axcUI_playerViewDelegate playerView:self.currentMask.currentPlayerView willTapControlButton:self]) {
            return;
        }
    }
    
    if (self.mainBlock != nil) {
        self.mainBlock();
    } else {
        [self main];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AxcUI_PlayerViewTapControlButtoneNotificationName object:self];
}

#pragma mark - getters setters 

- (UIButton *)button {
    if (_button == nil) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _button;
}

@end
