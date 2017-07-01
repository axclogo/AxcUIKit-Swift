//
//  AxcBarrageClock.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBarrageClock.h"
#import "AxcBarrageDisplayLink.h"
@interface AxcBarrageClock()<AxcBarrageDisplayLinkDelegate>
@property (strong, nonatomic) AxcBarrageDisplayLink *displayLink;
@property (strong, nonatomic) NSDate *previousDate;
@end

@implementation AxcBarrageClock
{
    BOOL _isStart;
    NSTimeInterval _currentTime;
    NSTimeInterval _offsetTime;
}

- (void)start {
    _isStart = YES;
    [self.displayLink start];
}

- (void)stop {
    _previousDate = nil;
    _currentTime = 0.0;
    [self.displayLink stop];
}

- (void)pause {
    _isStart = NO;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    if (currentTime >= 0) {
        _currentTime = currentTime;
    }
}

- (void)setOffsetTime:(NSTimeInterval)offsetTime {
    _offsetTime = offsetTime;
}

- (void)updateTime {
    NSDate *date = [NSDate date];
    _currentTime += [date timeIntervalSinceDate:self.previousDate] * _isStart;
    self.previousDate = date;
    
    if ([self.delegate respondsToSelector:@selector(danmakuClock:time:)]) {
        [self.delegate danmakuClock:self time:_currentTime + _offsetTime];
    }
}

- (void)displayLink:(AxcBarrageDisplayLink *)displayLink didRequestFrameForTime:(const CVTimeStamp *)outputTimeStamp {
    [self updateTime];
}

#pragma mark - 懒加载

- (NSDate *)previousDate {
    if(_previousDate == nil) {
        _previousDate = [NSDate date];
    }
    return _previousDate;
}

- (AxcBarrageDisplayLink *)displayLink {
    if(_displayLink == nil) {
        _displayLink = [[AxcBarrageDisplayLink alloc] init];
        _displayLink.delegate = self;
    }
    return _displayLink;
}

@end
