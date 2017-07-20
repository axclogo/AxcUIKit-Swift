//
//  AxcPlayerOrientationDmonitor.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerOrientationDmonitor.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreGraphics/CoreGraphics.h>

@interface AxcPlayerOrientationDmonitor ()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic) BOOL originalGeneratesDeviceOrientationNotifications;

@property (nonatomic) UIDeviceOrientation deviceOrientation;
@property (nonatomic, strong) void(^updateHandler)(UIDeviceOrientation deviceOrientation);

@end

@implementation AxcPlayerOrientationDmonitor

- (instancetype)initWidthUpdateHandler:(void(^)(UIDeviceOrientation deviceOrientation))updateHandler {
    self = [super init];
    if (self) {
        self.updateHandler = updateHandler;
        self.operationQueue = [[NSOperationQueue alloc] init];
        
        self.originalGeneratesDeviceOrientationNotifications = [UIDevice currentDevice].isGeneratingDeviceOrientationNotifications;
    }
    return self;
}

- (void)dealloc {
    self.updateHandler = nil;
}

- (void)startDmonitor {
    
    [self stopDmonitor];
    
    if (self.ignoreScreenSystemLock) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 0.5;
        if (![self.motionManager isAccelerometerAvailable]) {
            if (!self.originalGeneratesDeviceOrientationNotifications) {
                [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            }
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
        } else {
            [self.motionManager startDeviceMotionUpdatesToQueue:self.operationQueue withHandler:^(CMDeviceMotion *motion, NSError *error) {
                [self deviceMotionUpdateWithDeviceMotion:motion error:error];
            }];
        }
    } else {
        if (!self.originalGeneratesDeviceOrientationNotifications) {
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
}

- (void)stopDmonitor {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!self.originalGeneratesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    }
    
    if (self.motionManager != nil) {
        [self.motionManager stopDeviceMotionUpdates];
    }
}

- (void)deviceMotionUpdateWithDeviceMotion:(CMDeviceMotion *)deviceMotion error:(NSError *)error {
    if (error) return;
    
    UIDeviceOrientation newDeviceOrientation = self.deviceOrientation;
    
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    
    if (x > 0.5 || y > 0.5 || x < -0.5 || y < -0.5) {
        if (fabs(y) >= fabs(x)) {
            if (y >= 0){
                newDeviceOrientation = UIDeviceOrientationPortraitUpsideDown;
            } else{
                newDeviceOrientation = UIDeviceOrientationPortrait;
            }
        } else {
            if (x >= 0){
                newDeviceOrientation = UIDeviceOrientationLandscapeRight;
            } else{
                newDeviceOrientation = UIDeviceOrientationLandscapeLeft;
            }
        }
    }
    
    if (newDeviceOrientation != self.deviceOrientation) {
        self.deviceOrientation = newDeviceOrientation;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.updateHandler != nil) {
                self.updateHandler(self.deviceOrientation);
            }
        });
    }
}

#pragma mark - selector

- (void)orientationChanged:(NSNotification *)notification {
    UIDevice *device = notification.object;
    
    self.deviceOrientation = device.orientation;
    
    if (self.updateHandler != nil) {
        self.updateHandler(self.deviceOrientation);
    }
}

#pragma mark - getters setters

- (void)setIgnoreScreenSystemLock:(BOOL)ignoreScreenSystemLock {
    if (_ignoreScreenSystemLock == ignoreScreenSystemLock) return;
    _ignoreScreenSystemLock = ignoreScreenSystemLock;
    [self stopDmonitor];
    [self startDmonitor];
}
@end
