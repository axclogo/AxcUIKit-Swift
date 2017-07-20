//
//  AxcPlayerViewMask.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//
#import <UIKit/UIKit.h>


#define kAxcPlayerTopHeight 44.0f
#define kAxcPlayerTopButtonWidth 50.0f
#define kAxcPlayerBottomHeight 40.0f
#define kAxcPlayerBottomFullScreenHeight 50.0f
#define kAxcPlayerBottomButtonWidth 50.0f


@class AxcUI_PlayerView;

@protocol AxcPlayerViewMaskProtocol <NSObject>

- (void)reload;

@optional

- (NSTimeInterval)autoRemoveSeconds;

- (void)willAddToPlayerView:(AxcUI_PlayerView *)playerView animated:(BOOL)animated;
- (void)willRemoveFromPlayerView:(AxcUI_PlayerView *)playerView animated:(BOOL)animated;

- (void)addAnimationWithCompletion:(void(^)())completion;
- (void)removeAnimationWithCompletion:(void(^)())completion;

- (void)playerDidChangedState;
- (void)playerViewWillChangeOrientation:(UIInterfaceOrientation)orientation fromOrientation:(UIInterfaceOrientation)fromOrientation;

@end


@interface AxcPlayerViewMask : UIView <AxcPlayerViewMaskProtocol>


@property (nonatomic, weak, readonly) AxcUI_PlayerView *currentPlayerView;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithPlayerView:(AxcUI_PlayerView *)playerView;

@end
