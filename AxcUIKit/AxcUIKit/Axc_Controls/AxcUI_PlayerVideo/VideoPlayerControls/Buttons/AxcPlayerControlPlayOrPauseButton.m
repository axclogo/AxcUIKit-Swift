//
//  AxcPlayerControlPlayOrPauseButton.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerControlPlayOrPauseButton.h"
#import "UIImage+AxcImageName.h"
#import "AxcUI_PlayerVideo.h"

@implementation AxcPlayerControlPlayOrPauseButton

- (instancetype)initWithMask:(AxcPlayerViewMask *)mask {
    self = [super initWithMask:mask];
    if (self) {
        [self.button setImage:[UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_PlayerVideo_play_btn"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_PlayerVideo_pause_btn"] forState:UIControlStateSelected];
    }
    return self;
}

- (void)reload {
    self.button.selected = self.currentMask.currentPlayerView.currentPlayer.state == AxcPlayerStatePlaying;
}

- (void)main {
    [self.currentMask.currentPlayerView.currentPlayer AxcUI_resumeOrPause];
}

- (void)playerDidChangedState {
    [self reload];
}

@end
