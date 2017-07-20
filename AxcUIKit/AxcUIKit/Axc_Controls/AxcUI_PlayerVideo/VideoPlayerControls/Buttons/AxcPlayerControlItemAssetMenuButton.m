//
//  AxcPlayerControlItemAssetMenuButton.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerControlItemAssetMenuButton.h"
#import "AxcUI_PlayerVideo.h"

@interface AxcPlayerControlItemAssetMenuButton ()

@property (nonatomic, strong) AxcPlayerItemAssetMenuMask *itemAssetMenuMask;

@end

@implementation AxcPlayerControlItemAssetMenuButton

- (instancetype)initWithMask:(AxcPlayerViewMask *)mask {
    self = [super initWithMask:mask];
    if (self) {
        self.changeButtonTitleWhenSelected = YES;
        self.button.hidden = YES;
    }
    return self;
}

- (void)reload {
    
    self.button.hidden = !self.currentMask.currentPlayerView.axcUI_isFullScreen || [self.currentMask.currentPlayerView.currentPlayer.currentItem.assets count] <= 1;
    
    if (self.changeButtonTitleWhenSelected) {
        [self.button setTitle:self.currentMask.currentPlayerView.currentPlayer.currentItem.playingAsset.type forState:UIControlStateNormal];
    } else {
        [self.button setTitle:self.currentMask.currentPlayerView.currentPlayer.currentItem.assetTitle forState:UIControlStateNormal];
    }
}

- (void)main {
    if ([self.currentMask.currentPlayerView containsMask:self.itemAssetMenuMask]) {
        [self.currentMask.currentPlayerView AxcUI_removeMask:self.itemAssetMenuMask animated:YES];
    } else {
        CGPoint point = CGPointMake(self.button.frame.origin.x + self.button.frame.size.width/2,
                                    self.button.frame.origin.y + 5);
        self.itemAssetMenuMask.menuPosition = [self.currentMask.currentPlayerView.containerView.maskContainerView convertPoint:point fromView:self.button.superview];
        [self.currentMask.currentPlayerView AxcUI_addMask:self.itemAssetMenuMask animated:YES];
    }
}

- (void)playerViewWillChangeOrientation:(UIInterfaceOrientation)orientation fromOrientation:(UIInterfaceOrientation)fromOrientation {
    self.button.hidden = orientation == UIInterfaceOrientationUnknown || [self.currentMask.currentPlayerView.currentPlayer.currentItem.assets count] <= 1;
}

#pragma mark - getters setters

- (AxcPlayerItemAssetMenuMask *)itemAssetMenuMask {
    if (_itemAssetMenuMask == nil) {
        _itemAssetMenuMask = [[AxcPlayerItemAssetMenuMask alloc] initWithPlayerView:self.currentMask.currentPlayerView];
    }
    return _itemAssetMenuMask;
}

@end
