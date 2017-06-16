//
//  AxcNetworkLoadImageVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcLoadImageVC.h"

#define NetWorkLoadImage @"http://pic.58pic.com/58pic/13/88/95/27p58PICWau_1024.jpg"
#define NetWorkProgressLoadImage @"http://images.missyuan.com/attachments/day_080414/20080414_5651a9ad503e6852ae9e6GVhuTdhVFAc.jpg"
#define netWorkqueueProgressLoadImage @"http://pic28.nipic.com/20130424/11588775_115415688157_2.jpg"
#define netWorkqueueProgressGIFLoadImage @"http://ww4.sinaimg.cn/bmiddle/62faf073jw1ds4rt49wbqg.gif"
// 因为需要一个独立于三方库的SDK，所以制作了一个简易的下载图片的框架，很多功能待完善，慎用。常规推荐SDWebImage。
// 因为需要一个独立于三方库的SDK，所以制作了一个简易的下载图片的框架，很多功能待完善，慎用。常规推荐SDWebImage。
// 因为需要一个独立于三方库的SDK，所以制作了一个简易的下载图片的框架，很多功能待完善，慎用。常规推荐SDWebImage。

@interface AxcLoadImageVC ()

@property (nonatomic, strong)UIImageView *localLoadImageView; // 本地

@property (nonatomic, strong)UIImageView *netWorkLoadImageView; // 网络

@property (nonatomic, strong)UIImageView *netWorkProgressLoadImageView; // 网络 + 进度

// 带队列下载----------------------------------------------适合用tableView等多图下载使用

@property (nonatomic, strong)UIImageView *netWorkqueueProgressLoadImageView; // 网络 + 进度

@property (nonatomic, strong)UIImageView *netWorkqueueProgressGIFLoadImageView; // 网络 + 进度 + GIF


@property(nonatomic, strong)UIButton *loadButton;
@property(nonatomic, strong)UIButton *clearCacheButton;

@end

@implementation AxcLoadImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.localLoadImageView];
    [self.view addSubview:self.netWorkLoadImageView];
    [self.view addSubview:self.netWorkProgressLoadImageView];
    
    [self.view addSubview:self.netWorkqueueProgressLoadImageView];
    [self.view addSubview:self.netWorkqueueProgressGIFLoadImageView];
    
    [self click_loadButton];
    
    [self.view addSubview:self.loadButton];
    [self.view addSubview:self.clearCacheButton];
    
    self.instructionsLabel.text = @"1.加载本地图片资源，如果图片资源大于500K则不缓存在内存，如果小于500K则缓存到内存\n2.加载网络图片，以Data方式缓存到磁盘中，下次加载不会从网络获取(无队列，适合单次加载一张超大图)";
}

- (void)click_clearCacheButton{
    [Axc_WebimageCache AxcUI_webimageCacheClearCache];  // 清除图片缓存
    [Axc_WebimageCache AxcUI_imageCachePurge];  // 清除队列的坏下载以及磁盘缓存
}

- (void)click_loadButton{
    // 加载本地图片资源，如果图片资源大于500K则不缓存在内存，如果小于500K则缓存到内存
    self.localLoadImageView.image = [UIImage AxcUI_setImageNamed:@"test_0.jpg"];
    
    // 加载网络图片，以Data方式缓存到磁盘中，下次加载不会从网络获取
    
    /*   不带占位符
     [self.netWorkLoadImageView AxcUI_setImageWithURL:<#(NSString *)#>];
     */
    //   带占位符
    [self.netWorkLoadImageView AxcUI_setImageWithURL:NetWorkLoadImage
                                    placeholderImage:@"placeholder.jpg"];
    
    /*   不带占位符
     [self.netWorkProgressLoadImageView AxcUI_setImageWithURL:<#(NSString *)#> Progress:<#^(CGFloat progress)progress#>];
     */
    //   带占位符
    [self.netWorkProgressLoadImageView AxcUI_setImageWithURL:NetWorkProgressLoadImage
                                            placeholderImage:@"placeholder.jpg"
                                                    Progress:^(CGFloat progress) {
                                                        NSLog(@"%.2f",progress);
                                                    }];
    
    // ---------------安全队列式下载（仿SDWebImageView结构）
    [self.netWorkqueueProgressLoadImageView AxcUI_queueSetImageWithURL:netWorkqueueProgressLoadImage
                                                              Progress:^(CGFloat progress) {
                                                                  NSLog(@"%.2f",progress);
                                                              }];
    
    
    [self.netWorkqueueProgressGIFLoadImageView AxcUI_queueSetImageWithURL:netWorkqueueProgressGIFLoadImage];
    
}


#pragma mark - 懒加载
- (UIButton *)clearCacheButton{
    if (!_clearCacheButton) {
        _clearCacheButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.axcUI_Width - 50 - 120, 450, 120, 30)];
        [_clearCacheButton setTitle:@"清除缓存" forState:UIControlStateNormal];
        [_clearCacheButton addTarget:self action:@selector(click_clearCacheButton) forControlEvents:UIControlEventTouchUpInside];
        _clearCacheButton.backgroundColor = [UIColor AxcUI_PomegranateColor];
        _clearCacheButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _clearCacheButton;
}
- (UIButton *)loadButton{
    if (!_loadButton) {
        _loadButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 450, 120, 30)];
        [_loadButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_loadButton addTarget:self action:@selector(click_loadButton) forControlEvents:UIControlEventTouchUpInside];
        _loadButton.backgroundColor = [UIColor AxcUI_PomegranateColor];
        _loadButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _loadButton;
}
- (UIImageView *)netWorkqueueProgressLoadImageView{
    if (!_netWorkqueueProgressLoadImageView) {
        _netWorkqueueProgressLoadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.axcUI_Width - 50 - 120, 150, 120, 90)];
        _netWorkqueueProgressLoadImageView.contentMode = UIViewContentModeScaleAspectFit;
        _netWorkqueueProgressLoadImageView.backgroundColor = [UIColor AxcUI_BelizeHoleColor];
    }
    return _netWorkqueueProgressLoadImageView;
}
- (UIImageView *)netWorkqueueProgressGIFLoadImageView{
    if (!_netWorkqueueProgressGIFLoadImageView) {
        _netWorkqueueProgressGIFLoadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.axcUI_Width - 50 - 120, 250, 120, 90)];
        _netWorkqueueProgressGIFLoadImageView.contentMode = UIViewContentModeScaleAspectFit;
        _netWorkqueueProgressGIFLoadImageView.backgroundColor = [UIColor AxcUI_BelizeHoleColor];
    }
    return _netWorkqueueProgressGIFLoadImageView;
}

- (UIImageView *)localLoadImageView{
    if (!_localLoadImageView) {
        _localLoadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 150, 120, 90)];
        _localLoadImageView.contentMode = UIViewContentModeScaleAspectFit;
        _localLoadImageView.backgroundColor = [UIColor AxcUI_BelizeHoleColor];
    }
    return _localLoadImageView;
}


- (UIImageView *)netWorkLoadImageView{
    if (!_netWorkLoadImageView) {
        _netWorkLoadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 250, 120, 90)];
        _netWorkLoadImageView.contentMode = UIViewContentModeScaleAspectFit;
        _netWorkLoadImageView.backgroundColor = [UIColor AxcUI_BelizeHoleColor];
    }
    return _netWorkLoadImageView;
}
- (UIImageView *)netWorkProgressLoadImageView{
    if (!_netWorkProgressLoadImageView) {
        _netWorkProgressLoadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 350, 120, 90)];
        _netWorkProgressLoadImageView.contentMode = UIViewContentModeScaleAspectFit;
        _netWorkProgressLoadImageView.backgroundColor = [UIColor AxcUI_BelizeHoleColor];
    }
    return _netWorkProgressLoadImageView;
}

@end
