//
//  AxcUI_PlayerVideoViewController.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_PlayerVideoViewController.h"
#import "AxcPlayerOrientationDmonitor.h"

@interface AxcUI_PlayerVideoViewController ()



@end

@implementation AxcUI_PlayerVideoViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _axcUI_playerVideo = [[AxcUI_PlayerVideo alloc] init];
        _axcUI_playerVideo.axcUI_playerView.axcUI_supportedOrientations = UIInterfaceOrientationMaskLandscape;
        _axcUI_playerVideo.axcUI_playerView.axcUI_autoFullScreen = NO;
        _axcUI_playerVideo.axcUI_playerView.axcUI_ignoreScreenSystemLock = YES;
        
        if ([_axcUI_playerVideo.axcUI_topMask isKindOfClass:[AxcPlayerTopMask class]]) {
            AxcPlayerTopMask *topMask = (AxcPlayerTopMask *)_axcUI_playerVideo.axcUI_topMask;
            
            __weak typeof(self) weakSelf = self;
            AxcPlayerControlBackButton *backButton = [[AxcPlayerControlBackButton alloc] initWithMask:topMask mainBlock:^{
                weakSelf.axcUI_playerVideo.axcUI_playerView.axcUI_supportedOrientations = UIInterfaceOrientationMaskAll;
                [weakSelf.axcUI_playerVideo.axcUI_playerView AxcUI_performOrientationChange:UIInterfaceOrientationUnknown animated:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.axcUI_playerVideo AxcUI_emptyPlayer];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            topMask.leftButtons = @[ backButton ];
        }
        if ([_axcUI_playerVideo.axcUI_bottomMask isKindOfClass:[AxcPlayerBottomMask class]]) {
            AxcPlayerBottomMask *bottomMask = (AxcPlayerBottomMask *)_axcUI_playerVideo.axcUI_bottomMask;
            bottomMask.rightButtons = @[ [[AxcPlayerControlRateButton alloc] initWithMask:bottomMask],
                                        [[AxcPlayerControlItemAssetMenuButton alloc] initWithMask:bottomMask] ];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.axcUI_playerVideo.axcUI_playerView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.axcUI_playerVideo.axcUI_playerView AxcUI_performOrientationChange:UIInterfaceOrientationLandscapeRight animated:NO];
        self.axcUI_playerVideo.axcUI_playerView.containerView.alpha = 0;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.axcUI_playerVideo.axcUI_playerView.containerView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
