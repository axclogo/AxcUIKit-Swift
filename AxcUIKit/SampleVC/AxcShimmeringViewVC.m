//
//  AxcShimmeringViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcShimmeringViewVC.h"


@interface AxcShimmeringViewVC ()


@property(nonatomic,strong)UIView *shimmeringView;


@property (nonatomic, strong) UISegmentedControl *shimmeringTypeSegmented;
@property(nonatomic, strong)UISlider *timeSlider;
@property(nonatomic, strong)UILabel *labelTextTimeSlider;

@end

@implementation AxcShimmeringViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.shimmeringView];
    
    [self.view addSubview:self.shimmeringTypeSegmented];
    [self.view addSubview:self.timeSlider];
    [self.view addSubview:self.labelTextTimeSlider];
    [self click_refreshValue];
    
    self.instructionsLabel.text = @"属性可以动态调整，但是动画时间只能重置，无法延续\n其中Label为AxcUI_Label,允许设置文字边距";

}

- (void)click_refreshValue{
    // 重写STE和使用runtime类方法，无先后顺序，设置即可动态调整  ************************************************
    self.shimmeringView.axcUI_shimmeringTextAlignment = NSTextAlignmentCenter;
    if (!self.shimmeringTypeSegmented.selectedSegmentIndex) {
        self.shimmeringView.axcUI_shimmeringTextfont = [UIFont systemFontOfSize:20]; // 设置文字大小
        self.shimmeringView.axcUI_shimmeringForeColor = [UIColor AxcUI_EmeraldColor];// 设置覆盖层颜色
        self.shimmeringView.axcUI_shimmeringBackColor = [UIColor AxcUI_CarrotColor]; // 设置底层颜色
        self.shimmeringView.axcUI_shimmeringText = @"我说过 我不闪躲  我非要这么做"; // 歌词
    }else{
        self.shimmeringView.axcUI_shimmeringTextfont = [UIFont systemFontOfSize:30];// 设置文字大小
        self.shimmeringView.axcUI_shimmeringForeColor = [UIColor lightGrayColor];// 设置覆盖层颜色
        self.shimmeringView.axcUI_shimmeringBackColor = [UIColor whiteColor];// 设置底层颜色
        self.shimmeringView.axcUI_shimmeringText = @"向右滑动来解锁"; // 解锁
    }
    // 设置文字边距
//    self.shimmeringView.axcUI_textEdgeInsets = UIEdgeInsetsMake(10,10,10,10);
    [self.shimmeringView AxcUI_ShimmeringWithType:self.shimmeringTypeSegmented.selectedSegmentIndex
                                         Duration:self.timeSlider.value];
    self.labelTextTimeSlider.text = [NSString stringWithFormat:@"当前动画时间%.2f",self.timeSlider.value];
    
    /* 此处再次高级封装AxcUI_shimmeringEffectStart的API，方便外部调用，Label单独调用该方法只能默认白色闪动效果，通过此示例可以开放更多的使用方式*/
}


#pragma mark - 懒加载
- (UILabel *)labelTextTimeSlider{
    if (!_labelTextTimeSlider) {
        _labelTextTimeSlider = [[UILabel alloc] initWithFrame:CGRectMake(10,160 + 100, self.view.axcUI_Width - 20, 30)];
        _labelTextTimeSlider.font = [UIFont systemFontOfSize:14];
        _labelTextTimeSlider.textColor = [UIColor AxcUI_OrangeColor];
        _labelTextTimeSlider.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_labelTextTimeSlider];
    }
    return _labelTextTimeSlider;
}
- (UISlider *)timeSlider{
    if (!_timeSlider) {
        _timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(10,160 + 140, self.view.axcUI_Width - 20, 30)];
        [_timeSlider addTarget:self action:@selector(click_refreshValue) forControlEvents:UIControlEventValueChanged];
        _timeSlider.minimumValue = 1;
        _timeSlider.maximumValue = 10;
        _timeSlider.value = 0;
    }
    return _timeSlider;
}

- (UIView *)shimmeringView{
    if (!_shimmeringView) {
        _shimmeringView = [[UIView alloc] initWithFrame:CGRectMake(10, 110, self.view.axcUI_Width, 50)];
        _shimmeringView.backgroundColor = [UIColor AxcUI_CloudColor];
    }
    return _shimmeringView;
}

- (UISegmentedControl *)shimmeringTypeSegmented{
    if (!_shimmeringTypeSegmented) {
        _shimmeringTypeSegmented = [[UISegmentedControl alloc] initWithItems:@[@"歌词模式",
                                                                               @"解锁模式"]];
        _shimmeringTypeSegmented.frame = CGRectMake(10, 190,
                                            self.view.axcUI_Width - 20, 30);
        _shimmeringTypeSegmented.selectedSegmentIndex = 0;
        [_shimmeringTypeSegmented addTarget:self action:@selector(click_refreshValue) forControlEvents:UIControlEventValueChanged];
    }
    return _shimmeringTypeSegmented;
}

@end
