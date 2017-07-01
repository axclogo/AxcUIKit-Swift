//
//  AxcBarrageDisplayLink.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <CoreVideo/CoreVideo.h>
#import <Foundation/Foundation.h>

@protocol AxcBarrageDisplayLinkDelegate;

@interface AxcBarrageDisplayLink : NSObject

@property (nonatomic, weak) id <AxcBarrageDisplayLinkDelegate> delegate;

@property (nonatomic) dispatch_queue_t dispatchQueue;

- (void)start;
- (void)stop;

@end


@protocol AxcBarrageDisplayLinkDelegate <NSObject>
- (void)displayLink:(AxcBarrageDisplayLink *)displayLink didRequestFrameForTime:(const CVTimeStamp *)outputTimeStamp;
@end
