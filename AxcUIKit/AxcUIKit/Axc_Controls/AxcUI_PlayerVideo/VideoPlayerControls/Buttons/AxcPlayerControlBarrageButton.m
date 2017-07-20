//
//  AxcPlayerControlBarrageButton.m
//  axctest
//
//  Created by Axc on 2017/7/20.
//  Copyright © 2017年 Axc5324. All rights reserved.
//

#import "AxcPlayerControlBarrageButton.h"

#import "UIImage+AxcImageName.h"
#import "AxcUI_PlayerVideo.h"

@implementation AxcPlayerControlBarrageButton


- (instancetype)initWithMask:(AxcPlayerViewMask *)mask {
    self = [super initWithMask:mask];
    if (self) {
        [self.button setImage:[UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_PlayerVideo_barrage_btn"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)reload {
    self.button.hidden = !self.currentMask.currentPlayerView.axcUI_isFullScreen;
}

- (void)playerViewWillChangeOrientation:(UIInterfaceOrientation)orientation fromOrientation:(UIInterfaceOrientation)fromOrientation {
    self.button.hidden = orientation == UIInterfaceOrientationUnknown;
}

- (void)main{
    // 先隐藏全部
    AxcUI_PlayerVideo *player = (AxcUI_PlayerVideo *)self.currentMask.currentPlayerView.currentPlayer;
    if ([player.axcUI_playerView containsMask:player.axcUI_bottomMask]) {
        [player.axcUI_playerView AxcUI_removeMask:player.axcUI_bottomMask animated:YES];
    } else {
        [player.axcUI_playerView AxcUI_addMask:player.axcUI_bottomMask animated:YES];
    }
    // 然后弹幕设置面板的动画
    if ([player.axcUI_playerView containsMask:player.axcUI_barrageMask]) {
        [player.axcUI_playerView AxcUI_removeMask:player.axcUI_barrageMask animated:YES];
    }else{
        [player.axcUI_playerView AxcUI_addMask:player.axcUI_barrageMask animated:YES];
    }
    
    
    
    
}




@end
