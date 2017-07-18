//
//  AxcBannerViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/17.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBannerViewVC.h"


@interface AxcBannerViewVC ()<AxcBannerViewDataSource, AxcBannerViewDelegate>

@property (nonatomic, strong) AxcUI_BannerView *bannerView;

@property(nonatomic,strong) NSArray *dataArray;


@end

@implementation AxcBannerViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.bannerView];

    [self createControl];
    
    // 原作者GitHub：https://github.com/zzyspace
    self.instructionsLabel.text = @"原作者：zzyspace，相关方法未任何修改，只是将命名全部统一并融合进来而已";
}
// 重写SET方法，设置即可调用，无先后顺序，设置即可动态调整  ************************************************
- (void)clickInsSwitch:(UISwitch *)sender{
    switch (sender.tag - 100) {
        case 0: // 无限轮播
            self.bannerView.axcUI_shouldLoop = sender.on;
            break;
        case 1: // 自动轮播
            self.bannerView.axcUI_autoScroll = sender.on;
            break;
        case 2: // 开启左拉详情(此选项开启后无限轮播自动失效)
            self.bannerView.axcUI_showFooter = sender.on;
            break;
        default:break;
    }
}


#pragma mark - 代理区
#pragma mark AxcBannerViewDataSource
// 返回 Banner 需要显示 Item(View) 的个数
- (NSInteger)AxcUI_numberOfItemsInBanner:(AxcUI_BannerView *)banner{
    return self.dataArray.count;
}

// 返回 Banner 在不同的 index 所要显示的 View (可以是完全自定义的v iew, 且无需设置 frame)
- (UIView *)AxcUI_banner:(AxcUI_BannerView *)banner viewForItemAtIndex:(NSInteger)index{
    // 取出数据
    NSString *imageName = self.dataArray[index];
    // 创建将要显示控件
    UIImageView *imageView = [[UIImageView alloc] init];
    // 加载图片，返回任意View即可，这里使用网络加载图片展示简单轮播
    [imageView AxcUI_queueSetImageWithURL:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return imageView;
}
// 当self.bannerView.axcUI_showFooter = YES 的时候才会回调这个委托
- (void)AxcUI_bannerFooterDidTrigger:(AxcUI_BannerView *)banner{
    NSLog(@"触发了footer");
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor AxcUI_CloudColor];
    vc.title = @"新测试VC";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)AxcUI_banner:(AxcUI_BannerView *)banner didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"点击了第%zi个View",index);
}
// 返回 Footer 在不同状态时要显示的文字
- (NSString *)AxcUI_banner:(AxcUI_BannerView *)banner titleForFooterWithState:(AxcBannerFooterState)footerState{
    if (footerState == AxcBannerFooterStateIdle) {
        return @"拖动进入下一页";
    } else if (footerState == AxcBannerFooterStateTrigger) {
        return @"释放进入下一页";
    }
    return nil;
}


#pragma mark - 懒加载区
- (AxcUI_BannerView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[AxcUI_BannerView alloc] init];
        _bannerView.axcUI_bannerDataSource = self;
        _bannerView.axcUI_bannerDelegate = self;
        // 设置frame
        _bannerView.frame = CGRectMake(0, 100, SCREEN_WIDTH, 200);
    }
    return _bannerView;
}


- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"http://pic.58pic.com/58pic/13/88/95/27p58PICWau_1024.jpg",
                       @"http://images.missyuan.com/attachments/day_080414/20080414_5651a9ad503e6852ae9e6GVhuTdhVFAc.jpg",
                       @"http://pic28.nipic.com/20130424/11588775_115415688157_2.jpg",
                       @"http://ww4.sinaimg.cn/bmiddle/62faf073jw1ds4rt49wbqg.gif"];
    }
    return _dataArray;
}

- (void)createControl{
    NSArray *testArr = @[@"无限轮播",@"自动轮播",@"开启左拉详情"];
    for (int i = 0; i < 3; i ++) {
        CGFloat Y = i * 40 + self.bannerView.axcUI_Y + self.bannerView.axcUI_Height + 10;
        CGFloat width = 150;
        
        UILabel *label = [[UILabel alloc] init];
        label.axcUI_Size = CGSizeMake(width, 30);
        label.axcUI_X = 10;
        label.axcUI_Y = Y;
        label.text = testArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor AxcUI_WisteriaColor];
        label.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:label];
        
        
        UISwitch *InsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width + 30, Y, 50, 30)];
        InsSwitch.on = NO;
        [InsSwitch addTarget:self action:@selector(clickInsSwitch:)
            forControlEvents:UIControlEventValueChanged];
        InsSwitch.tag = i + 100;
        [self.view addSubview:InsSwitch];
    }
}



@end
