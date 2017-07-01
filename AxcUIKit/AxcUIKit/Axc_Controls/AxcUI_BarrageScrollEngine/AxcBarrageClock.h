//
//  AxcBarrageClock.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AxcBarrageClock;
@protocol AxcBarrageClockDelegate <NSObject>
- (void)danmakuClock:(AxcBarrageClock *)clock time:(NSTimeInterval)time;
@end

@interface AxcBarrageClock : NSObject
@property (weak, nonatomic) id<AxcBarrageClockDelegate> delegate;
@property (assign, nonatomic) NSTimeInterval offsetTime;
- (void)setCurrentTime:(NSTimeInterval)currentTime;
- (void)start;
- (void)stop;
- (void)pause;
@end
