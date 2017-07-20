//
//  AxcPlayerControlBackButton.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerControlBackButton.h"
#import "UIImage+AxcImageName.h"
#import "AxcUI_PlayerVideo.h"

@implementation AxcPlayerControlBackButton

- (instancetype)initWithMask:(AxcPlayerViewMask *)mask {
    self = [super initWithMask:mask];
    if (self) {
        [self.button setImage:[UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_PlayerVideo_back_btn"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)reload {
    self.button.hidden = !self.currentMask.currentPlayerView.axcUI_isFullScreen;
}

- (void)main {
    if (self.currentMask.currentPlayerView.axcUI_isFullScreen) {
        [self.currentMask.currentPlayerView AxcUI_performOrientationChange:UIInterfaceOrientationUnknown animated:YES];
    } else {
        [self.currentMask.currentPlayerView AxcUI_performOrientationChange:UIInterfaceOrientationLandscapeRight animated:YES];
    }
}

- (void)playerViewWillChangeOrientation:(UIInterfaceOrientation)orientation fromOrientation:(UIInterfaceOrientation)fromOrientation {
    self.button.hidden = orientation == UIInterfaceOrientationUnknown;
}

@end
