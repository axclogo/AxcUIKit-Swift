//
//  AxcPlayerVideoVC.m
//  AxcUIKit
//
//  Created by Axc_5324 on 2017/7/20.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerVideoVC.h"



@interface AxcPlayerVideoVC ()<AxcPlayerViewDelegate>

@property (nonatomic, strong) AxcUI_PlayerVideo *playerVideo;

@end

@implementation AxcPlayerVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;

    // 重写layoutSubviews
    [self.playerVideo.axcUI_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(350);
    }];
    
    // 设置播放的相关参数
    [self settingPlayerItem];
    
    // 原作者GitHub：https://github.com/itribs
    self.instructionsLabel.text = @"根据作者ribs项目RBPlayer改制\n新加入融合了弹幕引擎，支持类B站弹幕解析滚动等功能\n此演示仅演示视频播放的基础功能\n详细使用请研究演示Demo代码部分";
    
}
// 使用模型保存属性进行构造，以Api方式传入函数进行设置，维护性高  ************************************************

- (void)settingPlayerItem{
    AxcPlayerItem *item = [[AxcPlayerItem alloc] init];
    item.title = @"某科学的超电磁炮";
    item.assetTitle = @"清晰";
    AxcPlayerItemAsset *itemAsset1 = [[AxcPlayerItemAsset alloc] initWithType:@"清晰"
                                                                          URL:[NSURL URLWithString:SDURL]];
    AxcPlayerItemAsset *itemAsset2 = [[AxcPlayerItemAsset alloc] initWithType: @"高清"
                                                                          URL:[NSURL URLWithString:SDURL]];
    item.assets = @[itemAsset1, itemAsset2];
    // 添加进播放器
    [self.playerVideo AxcUI_replaceCurrentItemWithPlayerItem:item];
    // 初始播放属性
    [self.playerVideo AxcUI_playWithItemAsset:itemAsset1];
}

// 页面点击Back的时候会触发这个方法
- (BOOL)AxcUI_navigationShouldPopOnBackButton{
    // 置空播放器
    [self.playerVideo AxcUI_emptyPlayer];
    return YES;
}

#pragma mark - AxcPlayerViewDelegate
// 项目锁死横竖屏也能强制改变布局
- (BOOL)playerView:(AxcUI_PlayerView *)playerView willOrientationChange:(UIInterfaceOrientation)orientation {
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation != UIInterfaceOrientationUnknown) {
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        if (UIInterfaceOrientationIsLandscape(statusBarOrientation) && [playerView containsMask:self.playerVideo.axcUI_topMask]) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        } else {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        });
    }
    return YES;
}

- (BOOL)playerView:(AxcUI_PlayerView *)playerView willAxcUI_addMask:(AxcPlayerViewMask *)mask animated:(BOOL)animated {
    if ([mask isEqual:self.playerVideo.axcUI_topMask]) {
        UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(statusBarOrientation)) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
        }
    }
    return YES;
}

- (BOOL)playerView:(AxcUI_PlayerView *)playerView willRemoveMask:(AxcPlayerViewMask *)mask animated:(BOOL)animated {
    if ([mask isEqual:self.playerVideo.axcUI_topMask] && playerView.axcUI_isFullScreen) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    }
    return YES;
}



#pragma mark - 懒加载
- (AxcUI_PlayerVideo *)playerVideo{
    if (!_playerVideo) {
        _playerVideo = [[AxcUI_PlayerVideo alloc] init];
        _playerVideo.axcUI_playerView.axcUI_playerViewDelegate = self;
        _playerVideo.axcUI_playerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:_playerVideo.axcUI_playerView];
    }
    return _playerVideo;
}


@end
