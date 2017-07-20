//
//  AxcPlayerOrientationDmonitor.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AxcPlayerOrientationDmonitor : NSObject

@property (nonatomic, readonly) UIDeviceOrientation deviceOrientation;
@property (nonatomic) BOOL ignoreScreenSystemLock;

- (instancetype)initWidthUpdateHandler:(void(^)(UIDeviceOrientation deviceOrientation))updateHandler;

- (void)startDmonitor;
- (void)stopDmonitor;

@end
