//
//  AxcQuickBadgeViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/17.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcQuickBadgeViewVC.h"


@interface AxcQuickBadgeViewVC ()


@property(nonatomic,strong)UIView *testView;


@end

@implementation AxcQuickBadgeViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.testView];
    
    
    // 重写SET方法，设置即可调用，无先后顺序，设置即可动态调整  ************************************************
    // 快速设置气泡文本
    self.testView.axcUI_badgeText = @"99+";
    
    // 气泡对象的指针
//    self.testView.axcUI_badgeView
    
    self.instructionsLabel.text = @"其中的Badge对象为‘AxcUI_BadgeView’\n此对象详细属性设置请参见Api或者“AxcBadgeViewVC”";
    
    
    // 设置成iOS5怀旧式风
    self.testView.axcUI_badgeView.axcUI_borderWidth = 2;    // 边框
    self.testView.axcUI_badgeView.axcUI_showGloss = YES;    // 抛光
    self.testView.axcUI_badgeView.axcUI_shadowText = YES;   // 文字阴影
    self.testView.axcUI_badgeView.axcUI_shadowBadge = YES;  // 气泡阴影
    self.testView.axcUI_badgeView.axcUI_shadowBorder = YES; // 边框阴影
    
}

#pragma mark - 懒加载区
- (UIView *)testView{
    if (!_testView) {
        _testView = [[UIView alloc] init];
        _testView.axcUI_Size = CGSizeMake(100, 100);
        _testView.center = self.view.center;
        _testView.axcUI_Y = 130;
        _testView.backgroundColor = [UIColor AxcUI_EmeraldColor];
    }
    return _testView;
}


@end
