//
//  AxcPlayerControlButton.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AxcPlayerViewMask.h"

@protocol AxcPlayerControlButtonProtocol <NSObject>

- (void)reload;
- (void)main;

@optional

- (void)playerDidChangedState;
- (void)playerViewWillChangeOrientation:(UIInterfaceOrientation)orientation fromOrientation:(UIInterfaceOrientation)fromOrientation;

@end

/** 播放器按钮基类 */
@interface AxcPlayerControlButton : NSObject <AxcPlayerControlButtonProtocol>

@property (nonatomic, weak, readonly) AxcPlayerViewMask *currentMask;
@property (nonatomic, strong, readonly) UIButton *button;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMask:(AxcPlayerViewMask *)mask;
- (instancetype)initWithMask:(AxcPlayerViewMask *)mask mainBlock:(void(^)())mainBlock;

@end
