//
//  TestTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//


/**
 
 这个是测试控件属性和运行情况的VC，如果控件各项属性设置正常即可创建一个示例VC作为展示组，此VC不为展示使用
 
 */
#import "TestTwoVC.h"
#import "AxcXmlUtil.h"


#import "AxcUI_BadgeInteractionView.h"

@interface TestTwoVC ()<AxcPlayerViewDelegate,AxcPlayerViewBarrageDataSource>
{
    UIView *view;
    UIImageView *imageV;
}
@property (nonatomic, strong) AxcUI_PlayerVideo *player;
@property (strong, nonatomic) NSDictionary *barrageDic;


@end

@implementation TestTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSString *url = @"http://data.vod.itc.cn/?key=BWsfsIs1q9pPTVWz2ieDWJ2MpVq6Ygar&prod=flash&pt=1&new=/225/180/3r3bfP49ClrLVaOCNJJ3S4.mp4&rb=1";
    
    self.player = [[AxcUI_PlayerVideo alloc] init];
    //self.player.view.axcUI_ignoreScreenSystemLock = YES;
    [self.view addSubview:self.player.axcUI_playerView];
    
    self.player.axcUI_playerView.axcUI_playerViewDelegate = self;
    self.player.axcUI_playerView.axcUI_playerViewBarrageDataSource = self;
    
    self.player.axcUI_playerView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.player.axcUI_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(350);
    }];
    
    
    AxcPlayerItem *item = [[AxcPlayerItem alloc] init];
    item.title = @"某科学的超电磁炮";
    item.assetTitle = @"清晰";
    
    AxcPlayerItemAsset *itemAsset1 = [[AxcPlayerItemAsset alloc] initWithType:@"清晰" URL:[NSURL URLWithString:url]];
    AxcPlayerItemAsset *itemAsset2 = [[AxcPlayerItemAsset alloc] initWithType: @"高清" URL:[NSURL URLWithString:url]];
    
    item.assets = @[itemAsset1, itemAsset2];
    
    [self.player AxcUI_replaceCurrentItemWithPlayerItem:item];
    [self.player AxcUI_playWithItemAsset:itemAsset1];
    
    AxcPlayerTopMask *topMask = (AxcPlayerTopMask *)_player.axcUI_topMask;
    AxcPlayerControlBarrageButton *barrageButton = [[AxcPlayerControlBarrageButton alloc] initWithMask:topMask mainBlock:nil];
    topMask.rightButtons = @[ barrageButton];
    
    
    [self.player.axcUI_playerView.axcUI_barrageEngine AxcUI_BarrageStart];
    
}

- (NSArray <__kindof AxcUI_BarrageModelBase*>*)AxcUI_playeBarrageScrollEngine:(AxcUI_BarrageScrollEngine *)barrageEngine
                                                         didSendBarrageAtTime:(NSUInteger)time{
    return self.barrageDic[@(time)];
}


- (BOOL)AxcUI_navigationShouldPopOnBackButton{
    [self.player AxcUI_emptyPlayer];
    return YES;
}


#pragma mark - AxcPlayerViewDelegate

- (BOOL)playerView:(AxcUI_PlayerView *)playerView willOrientationChange:(UIInterfaceOrientation)orientation {
    
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation != UIInterfaceOrientationUnknown) {
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
        if (UIInterfaceOrientationIsLandscape(statusBarOrientation) && [playerView containsMask:self.player.axcUI_topMask]) {
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
    if ([mask isEqual:self.player.axcUI_topMask]) {
        UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(statusBarOrientation)) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
        }
    }
    return YES;
}

- (BOOL)playerView:(AxcUI_PlayerView *)playerView willRemoveMask:(AxcPlayerViewMask *)mask animated:(BOOL)animated {
    if ([mask isEqual:self.player.axcUI_topMask] && playerView.axcUI_isFullScreen) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    }
    return YES;
}


// 解析假的弹幕数据
- (NSDictionary *)barrageDic {
    if(_barrageDic == nil) {
        _barrageDic = [AxcXmlUtil dicWithObj:[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"]]];
    }
    return _barrageDic;
}

@end
