//
//  AxcPlayerBarrageMask.m
//  axctest
//
//  Created by Axc on 2017/7/20.
//  Copyright © 2017年 Axc5324. All rights reserved.
//

#import "AxcPlayerBarrageMask.h"
#import "AxcUI_PlayerVideo.h"

@implementation AxcPlayerBarrageMask

- (instancetype)initWithPlayerView:(AxcUI_PlayerView *)playerView {
    self = [super initWithPlayerView:playerView];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
//        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.superview == nil) return;
    CGRect superviewFrame = self.superview.frame;
    
    CGFloat y = 0;
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(statusBarOrientation)) {
        y = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    CGRect frame = CGRectMake(superviewFrame.size.width - superviewFrame.size.width / 3,
                              0,
                              superviewFrame.size.width / 3,
                              superviewFrame.size.height);
    
    self.frame = frame;
    
    
    
}

- (void)reload{
    [self layoutSubviews];
}
























- (void)addAnimationWithCompletion:(void (^)())completion{
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;

    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)removeAnimationWithCompletion:(void(^)())completion {
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}














@end
