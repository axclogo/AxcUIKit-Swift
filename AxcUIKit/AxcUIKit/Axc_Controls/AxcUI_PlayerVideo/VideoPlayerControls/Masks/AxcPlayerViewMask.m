//
//  AxcPlayerViewMask.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerViewMask.h"
#import "AxcUI_PlayerVideo.h"

@interface AxcPlayerViewMask ()

@property (nonatomic, weak) AxcUI_PlayerView *currentPlayerView;

@end

@implementation AxcPlayerViewMask

- (instancetype)initWithPlayerView:(AxcUI_PlayerView *)playerView {
    self = [super init];
    if (self) {
        self.currentPlayerView = playerView;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_playerDidChangedState:)
                                                     name:AxcPlayerDidStateChangeNotificationName
                                                   object:self.currentPlayerView.currentPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_playerViewWillChangeOrientation:)
                                                     name:AxcUI_PlayerViewWillOrientationChangeNotificationName
                                                   object:self.currentPlayerView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AxcPlayerDidStateChangeNotificationName object:self.currentPlayerView.currentPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AxcUI_PlayerViewWillOrientationChangeNotificationName object:self.currentPlayerView];
}

- (void)reload {
    
}

#pragma mark - selector

- (void)_playerDidChangedState:(NSNotification *)notification {
    if (self.currentPlayerView.currentPlayer.state == AxcPlayerStatePrepared) {
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

@end
