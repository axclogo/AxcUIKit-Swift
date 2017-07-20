//
//  AxcPlayerLoadingMask.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerLoadingMask.h"
#import "AxcUI_PlayerVideo.h"

@interface AxcPlayerLoadingMask ()

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation AxcPlayerLoadingMask

- (instancetype)initWithPlayerView:(AxcUI_PlayerView *)playerView {
    self = [super initWithPlayerView:playerView];
    if (self) {
        self.userInteractionEnabled = NO;
        [self addSubview:self.indicatorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.superview == nil) return;
    
    self.frame = self.superview.bounds;
    
    self.indicatorView.center = self.center;
    
    [self reload];
}

- (void)reload {
    if (self.currentPlayerView.currentPlayer.state == AxcPlayerStateInit ||
        self.currentPlayerView.currentPlayer.state == AxcPlayerStatePrepared ||
        self.currentPlayerView.currentPlayer.state == AxcPlayerStateBuffering) {
        self.indicatorView.hidden = NO;
        [self.indicatorView startAnimating];
    } else {
        self.indicatorView.hidden = YES;
        [self.indicatorView stopAnimating];
    }
}

- (void)playerDidChangedState {
    [self reload];
}

#pragma mark - getters setters

- (UIActivityIndicatorView *)indicatorView {
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.hidden = NO;
        [_indicatorView startAnimating];
    }
    return _indicatorView;
}
@end
