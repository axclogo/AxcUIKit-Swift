//
//  AxcBarrageDisplayLink.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBarrageDisplayLink.h"

#import <UIKit/UIKit.h>


typedef enum : unsigned {
    kAxcBarrageDisplayLinkIsRendering = 1u << 0
} AxcBarrageDisplayLinkAtomicFlags;


@interface AxcBarrageDisplayLink () {
    CADisplayLink *_IOSDisplayLink;
    
}

@end

@implementation AxcBarrageDisplayLink


- (void)dealloc {
    [self stop];
}

- (void)start {
    [self stop];
    SEL selector = @selector(displayLink:didRequestFrameForTime:);
    if ([self.delegate respondsToSelector:selector]) {
        _IOSDisplayLink = [CADisplayLink displayLinkWithTarget:self.delegate selector:selector];
        [_IOSDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stop {
    if (_IOSDisplayLink) {
        [_IOSDisplayLink invalidate];
    }
}

@end
