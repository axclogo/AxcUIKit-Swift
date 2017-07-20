//
//  AxcPlayerBottomMask.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerBottomMask.h"
#import "AxcUI_PlayerVideo.h"



@interface AxcPlayerBottomMask ()

@property (nonatomic, strong) AxcPlayerSlider *timeSlider;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic) BOOL removeAnimcating;

@end

@implementation AxcPlayerBottomMask

- (instancetype)initWithPlayerView:(AxcUI_PlayerView *)playerView {
    self = [super initWithPlayerView:playerView];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        self.leftButtons = @[
                              [[AxcPlayerControlPlayOrPauseButton alloc] initWithMask:self]
                              ];
        self.rightButtons = @[
                              [[AxcPlayerControlFullScreenButton alloc] initWithMask:self],
                              [[AxcPlayerControlRateButton alloc] initWithMask:self],
                              [[AxcPlayerControlItemAssetMenuButton alloc] initWithMask:self]
                              ];
       
        [self addSubview:self.timeSlider];
        [self addSubview:self.timeLabel];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerUpdateCurrentSeconds)
                                                     name:AxcPlayerUpdateCurrentSecondsNotificationName
                                                   object:self.currentPlayerView.currentPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerUpdateBufferedSeconds)
                                                     name:AxcPlayerUpdateBufferedSecondsNotificationName
                                                   object:self.currentPlayerView.currentPlayer];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AxcPlayerUpdateCurrentSecondsNotificationName object:self.currentPlayerView.currentPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AxcPlayerUpdateBufferedSecondsNotificationName object:self.currentPlayerView.currentPlayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.superview == nil) return;
    
    CGRect superviewFrame = self.superview.frame;
    CGFloat height = self.currentPlayerView.currentPlayer.axcUI_playerView.axcUI_isFullScreen ? kAxcPlayerBottomFullScreenHeight : kAxcPlayerBottomHeight;
    CGRect frame = CGRectMake(0, superviewFrame.size.height - height, superviewFrame.size.width, height);
    
    self.frame = frame;
    
    __block CGFloat leftButtonX = 0;
    [self.leftButtons enumerateObjectsUsingBlock:^(AxcPlayerControlButton *obj, NSUInteger idx, BOOL *stop) {
        if (!obj.button.hidden)  {
            obj.button.frame = CGRectMake(leftButtonX, 0, kAxcPlayerBottomButtonWidth, height);
            leftButtonX = leftButtonX + kAxcPlayerBottomButtonWidth;
        }
    }];
    
    __block CGFloat rightButtonX = frame.size.width;
    [self.rightButtons enumerateObjectsUsingBlock:^(AxcPlayerControlButton *obj, NSUInteger idx, BOOL *stop) {
        if (!obj.button.hidden)  {
            rightButtonX = rightButtonX - kAxcPlayerBottomButtonWidth;
            obj.button.frame = CGRectMake(rightButtonX, 0, kAxcPlayerBottomButtonWidth, height);
        }
    }];
    
    CGFloat timeLabelX;
    if (self.currentPlayerView.currentPlayer.axcUI_playerView.axcUI_isFullScreen) {
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        [self.timeLabel sizeToFit];
        timeLabelX = leftButtonX;
    } else {
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        [self.timeLabel sizeToFit];
        timeLabelX = rightButtonX - self.timeLabel.frame.size.width;
    }
    self.timeLabel.frame = CGRectMake(timeLabelX, 0, self.timeLabel.frame.size.width + 2, height);
    
    if (self.currentPlayerView.currentPlayer.axcUI_playerView.axcUI_isFullScreen) {
        self.timeSlider.frame = CGRectMake(0, -3, frame.size.width, 8);
    } else {
        self.timeSlider.frame = CGRectMake(leftButtonX, 0, self.timeLabel.frame.origin.x - 10 - leftButtonX, height);
    }
}

#pragma mark - selector

- (void)playerUpdateCurrentSeconds {
    self.timeSlider.value = (double)self.currentPlayerView.currentPlayer.currentItem.currentSeconds / (double)self.currentPlayerView.currentPlayer.currentItem.duration;
    [self setCurrentDisplayTime:self.currentPlayerView.currentPlayer.currentItem.currentSeconds];
}

- (void)playerUpdateBufferedSeconds {
    self.timeSlider.loadedValue = (double)self.currentPlayerView.currentPlayer.currentItem.bufferedSeconds / (double)self.currentPlayerView.currentPlayer.currentItem.duration;
}

- (void)scrubbingBegin {
    [self.currentPlayerView.currentPlayer AxcUI_pause];
    [self.currentPlayerView.currentPlayer.axcUI_playerView AxcUI_lockAutoRemove:YES withMask:self];
}

- (void)scrubbingChanged {
    NSUInteger time = (self.timeSlider.value / self.timeSlider.maximumValue) * self.currentPlayerView.currentPlayer.currentItem.duration;
    [self setCurrentDisplayTime:time];
}

- (void)scrubbingEnd {
    [self.currentPlayerView.currentPlayer AxcUI_seekToSeconds:self.timeSlider.value*self.currentPlayerView.currentPlayer.currentItem.duration];
    [self.currentPlayerView.currentPlayer.axcUI_playerView AxcUI_lockAutoRemove:NO withMask:self];
}

#pragma mark - mask

- (void)reload {
    [self setCurrentDisplayTime:0];
    [self.timeLabel sizeToFit];
}

- (NSTimeInterval)autoRemoveSeconds {
    return 5;
}

- (void)willAddToPlayerView:(AxcUI_PlayerView *)playerView animated:(BOOL)animated {
    AxcUI_PlayerVideo *player = (AxcUI_PlayerVideo *)playerView.currentPlayer;
    if (player.axcUI_playerView.axcUI_isFullScreen) {
        [player.axcUI_playerView AxcUI_addMask:player.axcUI_topMask animated:YES];
    }
}

- (void)willRemoveFromPlayerView:(AxcUI_PlayerView *)playerView animated:(BOOL)animated {
    AxcUI_PlayerVideo *player = (AxcUI_PlayerVideo *)playerView.currentPlayer;
    [player.axcUI_playerView AxcUI_removeMask:player.axcUI_topMask animated:YES];
}

- (void)addAnimationWithCompletion:(void(^)())completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)removeAnimationWithCompletion:(void(^)())completion {
    
    self.removeAnimcating = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 40);
    } completion:^(BOOL finished) {
        
        self.removeAnimcating = NO;
        
        if (completion) {
            completion();
        }
    }];
}

- (void)playerDidChangedState {
    
    if (self.currentPlayerView.currentPlayer.state != AxcPlayerStatePlaying &&
        self.currentPlayerView.currentPlayer.state != AxcPlayerStateBuffering &&
        self.currentPlayerView.currentPlayer.state != AxcPlayerStatePaused) {
        self.timeSlider.value = 0;
        self.timeSlider.loadedValue = 0;
        self.timeSlider.userInteractionEnabled = NO;
    } else {
        self.timeSlider.userInteractionEnabled = YES;
    }
    
    [self setNeedsLayout];
}

- (void)playerViewWillChangeOrientation:(UIInterfaceOrientation)orientation fromOrientation:(UIInterfaceOrientation)fromOrientation {

    AxcUI_PlayerVideo *player = (AxcUI_PlayerVideo *)self.currentPlayerView.currentPlayer;
    
    if (orientation != UIInterfaceOrientationUnknown) {
        if ([player.axcUI_playerView containsMask:self] && !self.removeAnimcating) {
            [player.axcUI_playerView AxcUI_addMask:player.axcUI_topMask animated:NO];
        }
    } else {
        [player.axcUI_playerView AxcUI_removeMask:player.axcUI_topMask animated:NO];
    }
}

#pragma mark - private

- (void)setCurrentDisplayTime:(NSUInteger)currentSeconds {
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ / %@",
                           [self timeShowTextWithPlaySeconds:currentSeconds],
                           [self timeShowTextWithPlaySeconds:self.currentPlayerView.currentPlayer.currentItem.duration]];
}

- (NSString*)timeShowTextWithPlaySeconds:(Float64)playSeconds {
    NSInteger nPlaySeconds = (NSInteger)playSeconds;
    NSInteger hour = nPlaySeconds / 3600;
    NSInteger minute = (nPlaySeconds - hour * 3600) / 60;
    NSInteger seconds = nPlaySeconds - hour * 3600 - minute * 60;
    NSString *timeText;
    if (hour > 0) {
        timeText = [NSString stringWithFormat:@"%.02zd:%.02zd:%.02zd", hour, minute, seconds];
    } else {
        timeText = [NSString stringWithFormat:@"%.02zd:%.02zd", minute, seconds];
    }
    return timeText;
}

#pragma mark - getters setters

- (void)setLeftButtons:(NSArray<AxcPlayerControlButton *> *)leftButtons {
    if ([_leftButtons isEqual:leftButtons]) return;
    
    [_leftButtons enumerateObjectsUsingBlock:^(AxcPlayerControlButton *obj, NSUInteger idx, BOOL *stop) {
        [obj.button removeFromSuperview];
    }];
    
    _leftButtons = leftButtons;
    
    [_leftButtons enumerateObjectsUsingBlock:^(AxcPlayerControlButton *obj, NSUInteger idx, BOOL *stop) {
        [self addSubview:obj.button];
    }];
}

- (void)setRightButtons:(NSArray<AxcPlayerControlButton *> *)rightButtons {
    if ([_rightButtons isEqual:rightButtons]) return;
    
    [_rightButtons enumerateObjectsUsingBlock:^(AxcPlayerControlButton *obj, NSUInteger idx, BOOL *stop) {
        [obj.button removeFromSuperview];
    }];
    
    _rightButtons = rightButtons;
    
    [_rightButtons enumerateObjectsUsingBlock:^(AxcPlayerControlButton *obj, NSUInteger idx, BOOL *stop) {
        [self addSubview:obj.button];
    }];
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.text = @"00:00 / 00:00";
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (AxcPlayerSlider *)timeSlider {
    if (_timeSlider== nil) {
        _timeSlider = [[AxcPlayerSlider alloc] init];
        [_timeSlider addTarget:self action:@selector(scrubbingBegin) forControlEvents:UIControlEventTouchDown];
        [_timeSlider addTarget:self action:@selector(scrubbingChanged) forControlEvents:UIControlEventValueChanged];
        [_timeSlider addTarget:self action:@selector(scrubbingEnd) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeSlider;
}

@end
