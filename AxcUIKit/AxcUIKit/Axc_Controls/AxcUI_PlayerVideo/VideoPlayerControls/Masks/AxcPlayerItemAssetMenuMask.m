//
//  AxcPlayerItemAssetMask.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerItemAssetMenuMask.h"
#import "AxcUI_PlayerVideo.h"


@implementation AxcPlayerItemAssetMenuMask

- (void)selectedIndexDidChanged {
    if (self.selectedIndex >= 0) {
        NSUInteger currentSeconds = self.currentPlayerView.currentPlayer.currentItem.currentSeconds;
        AxcPlayerItemAsset *itemAsset = self.currentPlayerView.currentPlayer.currentItem.assets[self.selectedIndex];
        [self.currentPlayerView.currentPlayer AxcUI_playWithItemAsset:itemAsset];
        [self.currentPlayerView.currentPlayer AxcUI_seekToSeconds:currentSeconds];
    }
    [self.currentPlayerView AxcUI_removeMask:self animated:YES];
}

#pragma mark - mask

- (void)reload {
    [super reload];
    
    NSMutableArray *items = [NSMutableArray array];
    __block NSInteger selectedIndex = -1;
    [self.currentPlayerView.currentPlayer.currentItem.assets enumerateObjectsUsingBlock:^(AxcPlayerItemAsset *asset, NSUInteger index, BOOL *stop) {
        if ([asset isEqual:self.currentPlayerView.currentPlayer.currentItem.playingAsset]) {
            selectedIndex = index;
        }
        if ([asset.type length] > 0) {
            [items addObject:asset.type];
        }
    }];
    self.items = items;
    self.selectedIndex = selectedIndex;
}

- (void)willAddToPlayerView:(AxcUI_PlayerView *)playerView animated:(BOOL)animated {
    
    AxcUI_PlayerVideo *player = (AxcUI_PlayerVideo *)playerView.currentPlayer;
    [player.axcUI_playerView AxcUI_lockAutoRemove:YES withMask:player.axcUI_bottomMask];
}

- (void)willRemoveFromPlayerView:(AxcUI_PlayerView *)playerView animated:(BOOL)animated {
    AxcUI_PlayerVideo *player = (AxcUI_PlayerVideo *)playerView.currentPlayer;
    [player.axcUI_playerView AxcUI_lockAutoRemove:NO withMask:player.axcUI_bottomMask];
}

- (void)playerViewWillChangeOrientation:(UIInterfaceOrientation)orientation fromOrientation:(UIInterfaceOrientation)fromOrientation {
    if (orientation != UIInterfaceOrientationUnknown) {
        [self.currentPlayerView AxcUI_removeMask:self animated:NO];
    }
}

@end
