//
//  AxcPlayerControlFullScreenButton.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerControlFullScreenButton.h"
#import "UIImage+AxcImageName.h"
#import "AxcUI_PlayerVideo.h"

@implementation AxcPlayerControlFullScreenButton

- (instancetype)initWithMask:(AxcPlayerViewMask *)mask {
    self = [super initWithMask:mask];
    if (self) {
        [self.button setImage:[UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_PlayerVideo_fullScreen_btn"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_PlayerVideo_fullScreen_btn"] forState:UIControlStateNormal | UIControlStateHighlighted];
        [self.button setImage:[UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_PlayerVideo_minScreen_btn"] forState:UIControlStateSelected];
        [self.button setImage:[UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_PlayerVideo_minScreen_btn"] forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    return self;
}

- (void)reload {
    self.button.selected = self.currentMask.currentPlayerView.axcUI_isFullScreen;
}

- (void)main {
    if (self.currentMask.currentPlayerView.axcUI_isFullScreen) {
        [self.currentMask.currentPlayerView AxcUI_performOrientationChange:UIInterfaceOrientationUnknown animated:YES];
    } else {
        [self.currentMask.currentPlayerView AxcUI_performOrientationChange:UIInterfaceOrientationLandscapeRight animated:YES];
    }
}

- (void)playerViewWillChangeOrientation:(UIInterfaceOrientation)orientation fromOrientation:(UIInterfaceOrientation)fromOrientation  {
    self.button.selected = orientation != UIInterfaceOrientationUnknown;
}

@end
