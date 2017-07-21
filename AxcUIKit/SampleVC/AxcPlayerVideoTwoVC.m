//
//  AxcPlayerVideoVC.m
//  AxcUIKit
//
//  Created by Axc_5324 on 2017/7/20.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerVideoTwoVC.h"

#import "AxcXmlUtil.h"


@interface AxcPlayerVideoTwoVC ()<AxcPlayerViewDelegate,AxcPlayerViewBarrageDataSource>

@property (nonatomic, strong) AxcUI_PlayerVideo *playerVideo;
@property (strong, nonatomic) NSDictionary *barrageDic;

@end

@implementation AxcPlayerVideoTwoVC

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
    
    // 1、添加弹幕数据源协议，并且实现一个必须实现的协议函数
    self.playerVideo.axcUI_playerView.axcUI_playerViewBarrageDataSource = self;
    
    // 2、播放器TopMask中添加一个预设的“弹幕设置”按钮
    // 2.1、获取播放器的topMask
    AxcPlayerTopMask *topMask = (AxcPlayerTopMask *)self.playerVideo.axcUI_topMask;
    // 2.2、实例化一个弹幕设置按钮，注：如果手动设置MainBlock则不会执行按钮预设的功能
    AxcPlayerControlBarrageButton *barrageButton = [[AxcPlayerControlBarrageButton alloc] initWithMask:topMask
                                                                                             mainBlock:nil];
    // 2.3、添加到右边的按钮组
    topMask.rightButtons = @[ barrageButton];
    
    // 3、开始滚动弹幕
    [self.playerVideo.axcUI_playerView.axcUI_barrageEngine AxcUI_BarrageStart];

    self.instructionsLabel.text = @"播放器+弹幕引擎的使用Demo，支持类B站弹幕解析滚动等功能\n此演示为视频播放+弹幕引擎部分的功能\n详细弹幕设置请参见“弹幕渲染引擎”演示Demo";

    // Q：如何获得视频播放器中弹幕引擎的指针/对象呢？
//    AxcUI_BarrageScrollEngine *barrageEngine = self.playerVideo.axcUI_playerView.axcUI_barrageEngine;
    // Q：我如果使用适配框架来布局视频播放器，弹幕会不会走形呢？
    // 不会的，重写了layoutSubviews之后，只要布局改变，弹幕视图都会跟随视频播放器适配
}

#pragma mark - 弹幕数据源协议函数
- (NSArray<AxcUI_BarrageModelBase *> *)AxcUI_playeBarrageScrollEngine:(AxcUI_BarrageScrollEngine *)barrageEngine
                                                 didSendBarrageAtTime:(NSUInteger)time{
    // 此函数使用与“弹幕引擎“使用方法相同，解析弹幕数据后使用键值对方式回调至此
     return self.barrageDic[@(time)];
}

// 解析B站格式的弹幕数据（与“弹幕引擎”使用相同）
- (NSDictionary *)barrageDic {
    if(_barrageDic == nil) {
        _barrageDic = [AxcXmlUtil dicWithObj:[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"]]];
    }
    return _barrageDic;
}



// 使用模型保存属性进行构造，以Api方式传入函数进行设置，维护性高  ************************************************
- (void)settingPlayerItem{
    AxcPlayerItem *item = [[AxcPlayerItem alloc] init];
    item.title = @"某科学的超电磁炮";
    item.assetTitle = @"清晰";
    AxcPlayerItemAsset *itemAsset1 = [[AxcPlayerItemAsset alloc] initWithType:@"清晰"
                                                                          URL:[NSURL URLWithString:SDURL]];
    AxcPlayerItemAsset *itemAsset2 = [[AxcPlayerItemAsset alloc] initWithType: @"高清"// 这里可以换填高清或者其对应的URL
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
