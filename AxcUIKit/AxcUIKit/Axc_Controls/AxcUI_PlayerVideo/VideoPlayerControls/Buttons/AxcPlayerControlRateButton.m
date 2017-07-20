//
//  AxcPlayerControlRateButton.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerControlRateButton.h"
#import "AxcUI_PlayerVideo.h"

@interface AxcPlayerControlRateButton ()

@end

@implementation AxcPlayerControlRateButton

- (instancetype)initWithMask:(AxcPlayerViewMask *)mask {
    self = [super initWithMask:mask];
    if (self) {
        self.rates = @[@(1), @(1.2), @(1.5), @(2)];
        self.button.hidden = YES;
        [self setButtonTitleWithRate:1];
    }
    return self;
}

- (void)reload {
    self.button.hidden = !self.currentMask.currentPlayerView.axcUI_isFullScreen;
    [self setButtonTitleWithRate:self.currentMask.currentPlayerView.currentPlayer.rate];
}

- (void)main {
    if ([self.rates count] > 0) {
        __block float nextRate = [[self.rates firstObject] floatValue];
        [self.rates enumerateObjectsUsingBlock:^(NSNumber *rate, NSUInteger idx, BOOL *stop) {
            if ([rate doubleValue] > self.currentMask.currentPlayerView.currentPlayer.rate) {
                nextRate = [rate doubleValue];
                *stop = YES;
            }
        }];
        if (nextRate != self.currentMask.currentPlayerView.currentPlayer.rate) {
            self.currentMask.currentPlayerView.currentPlayer.rate = nextRate;
            [self setButtonTitleWithRate:nextRate];
        }
    }
}

- (void)setButtonTitleWithRate:(float)rate {
    NSString *rateString = [NSString stringWithFormat:@"%.1fX", rate];
    if ([rateString hasSuffix:@".0X"]) {
        rateString = [NSString stringWithFormat:@"%ldX", (long)rate];
    }
    [self.button setTitle:rateString forState:UIControlStateNormal];
}

- (void)playerViewWillChangeOrientation:(UIInterfaceOrientation)orientation fromOrientation:(UIInterfaceOrientation)fromOrientation {
    self.button.hidden = orientation == UIInterfaceOrientationUnknown;
}

@end
