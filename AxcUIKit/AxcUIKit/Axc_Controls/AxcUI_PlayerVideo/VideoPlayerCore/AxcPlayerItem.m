//
//  AxcPlayerItem.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerItem.h"

@interface AxcPlayerItem ()

@property (nonatomic) NSUInteger duration;
@property (nonatomic) NSUInteger currentSeconds;
@property (nonatomic) NSUInteger bufferedSeconds;

@property (nonatomic, strong) AxcPlayerItemAsset *playingAsset;

@end

@implementation AxcPlayerItem

- (void)updateDuration:(NSUInteger)duration {
    self.duration = duration;
}

- (void)updateCurrentSeconds:(NSUInteger)currentSeconds {
    self.currentSeconds = currentSeconds;
}

- (void)updateBufferedSeconds:(NSUInteger)bufferedSeconds {
    self.bufferedSeconds = bufferedSeconds;
}

- (void)updatePlayingAsset:(AxcPlayerItemAsset *)playingAsset {
    self.playingAsset = playingAsset;
}

@end

@implementation AxcPlayerItemAsset

- (instancetype)initWithType:(NSString *)type URL:(NSURL *)URL {
    self = [super init];
    if (self) {
        _type = type;
        _URL = URL;
    }
    return self;
}

@end
