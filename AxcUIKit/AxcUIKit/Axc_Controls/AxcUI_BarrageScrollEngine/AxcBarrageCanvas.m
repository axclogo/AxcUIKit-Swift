//
//  AxcBarrageCanvas.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBarrageCanvas.h"

@implementation AxcBarrageCanvas
- (UIView *)hitTest:(CGPoint)aPoint{
    return nil;
}

- (instancetype)init{
    if (self = [super init]) {
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setLayoutStyle:(AxcBarrageCanvasLayoutStyle)layoutStyle {
    if (_layoutStyle == layoutStyle) {
        return;
    }
}

- (void)resize:(NSNotification *)sender {
    if (self.resizeCallBackBlock) {
        self.resizeCallBackBlock(self.bounds);
    }
}

@end
