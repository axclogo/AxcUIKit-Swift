//
//  StarRatingViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "StarRatingViewVC.h"


@interface StarRatingViewVC ()


@property(nonatomic,strong)AxcUI_StarRatingView *starRatingView;

@property(nonatomic, strong)UILabel *StartValueLabel;

@property(nonatomic, strong)UISlider *maximumSlider;
@property(nonatomic, strong)UILabel *maximumSliderLabel;

@property(nonatomic, strong)UIButton *changeColorBtn;
@property (nonatomic, strong) UISegmentedControl *switchPictureSegmented;

@property(nonatomic, strong)UISwitch *allowsHalfStarsSwitch;
@property(nonatomic, strong)UILabel *allowsHalfStarsSwitchLabel;

@property(nonatomic, strong)UISwitch *accurateHalfStarsSwitch;
@property(nonatomic, strong)UILabel *accurateHalfStarsSwitchLabel;


@property(nonatomic, strong)UISlider *spacingSlider;
@property(nonatomic, strong)UILabel *spacingSliderLabel;

@property(nonatomic, assign)CGFloat highly;

@end

@implementation StarRatingViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _highly = 100;
    
    [self.view addSubview:self.starRatingView];
    
    __weak typeof(self) WeakSelf = self;
    [self.StartValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.starRatingView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    [self.view addSubview:self.maximumSliderLabel];
    [self.view addSubview:self.maximumSlider];
    
    [self.view addSubview:self.changeColorBtn];
    
    [self.view addSubview:self.switchPictureSegmented];
    
    [self.view addSubview:self.allowsHalfStarsSwitchLabel];
    [self.view addSubview:self.allowsHalfStarsSwitch];
    
    [self.view addSubview:self.accurateHalfStarsSwitchLabel];
    [self.view addSubview:self.accurateHalfStarsSwitch];
    
    [self.view addSubview:self.spacingSliderLabel];
    [self.view addSubview:self.spacingSlider];
    
    
    // 原作者GitHub：https://github.com/hsousa
    self.instructionsLabel.text = @"以Hugo Sousa作者的开源项目：HCSStarRatingView为主\n改造结构后融入框架中。在此感谢作者Hugo Sousa提供的使用许可";
}

// 使用初始化和重写SET方法，设置即可调用，无先后顺序，设置即可动态调整  ************************************************
- (void)starRatingViewDidChangeValue:(AxcUI_StarRatingView *)sender { // 数值
    self.StartValueLabel.text = [NSString stringWithFormat:@"星级评分值：%.1f", sender.axcUI_value];
}
- (void)slidingMaximumSlider{       // 最大值/个数
    self.starRatingView.axcUI_maximumValue = self.maximumSlider.value;
    self.maximumSliderLabel.text = [NSString stringWithFormat:@"最大值：%.0f",self.maximumSlider.value];
}
- (void)clickchangeColorBtn{   // 颜色
    self.starRatingView.tintColor = [UIColor AxcUI_ArcColor]; // 注释因为系统API无法重写
    [self.starRatingView setNeedsDisplay];      // 所以手动调用重新绘制来完成示例中的动态改变效果
    self.changeColorBtn.backgroundColor = self.starRatingView.tintColor;
}
- (void)click_switchPictureSegmented{ // 图片
    if (self.switchPictureSegmented.selectedSegmentIndex == 0) {
        self.starRatingView.axcUI_emptyStarImage = nil;
        self.starRatingView.axcUI_filledStarImage = nil;
    }else{
        self.starRatingView.axcUI_emptyStarImage = [[UIImage imageNamed:@"heart-empty"]
                                                    imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.starRatingView.axcUI_filledStarImage = [[UIImage imageNamed:@"heart-full"]
                                                     imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
}
- (void)click_allowsHalfStarsSwitch{        // 允许选择一半
    self.starRatingView.axcUI_allowsHalfStars = self.allowsHalfStarsSwitch.on;
}
- (void)click_accurateHalfStarsSwitch{  // 更精准的选择
    self.starRatingView.axcUI_accurateHalfStars = self.accurateHalfStarsSwitch.on;
    self.allowsHalfStarsSwitch.on = self.starRatingView.axcUI_allowsHalfStars; // 此参数会默认开启
}
- (void)slidingSpacingSlider{   // 间距
    self.starRatingView.axcUI_spacing = self.spacingSlider.value;
    self.spacingSliderLabel.text = [NSString stringWithFormat:@"间距值：%.2f",self.spacingSlider.value];
}

#pragma mark - 懒加载区
- (AxcUI_StarRatingView *)starRatingView{
    if (!_starRatingView) {
        _starRatingView = [[AxcUI_StarRatingView alloc] init];
        _starRatingView.axcUI_Size = CGSizeMake(SCREEN_WIDTH - 20, 40);
        _starRatingView.center = self.view.center;
        _starRatingView.axcUI_Y = 150;
        _starRatingView.backgroundColor = [UIColor AxcUI_CloudColor];
        
        _starRatingView.axcUI_maximumValue = 5;
        _starRatingView.axcUI_minimumValue = 0;
        _starRatingView.axcUI_value = 3;
        _starRatingView.axcUI_allowsHalfStars = YES;
        _starRatingView.axcUI_accurateHalfStars = YES;
        
        [_starRatingView addTarget:self action:@selector(starRatingViewDidChangeValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _starRatingView;
}












- (UILabel *)spacingSliderLabel{
    if (!_spacingSliderLabel) {
        _spacingSliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,330 + _highly, 100, 25)];
        _spacingSliderLabel.font = [UIFont systemFontOfSize:14];
        _spacingSliderLabel.textColor = [UIColor AxcUI_OrangeColor];
        _spacingSliderLabel.textAlignment = NSTextAlignmentLeft;
        _spacingSliderLabel.text = @"间距值：5.00";
    }
    return _spacingSliderLabel;
}
- (UISlider *)spacingSlider{
    if (!_spacingSlider) {
        _spacingSlider = [[UISlider alloc] initWithFrame:CGRectMake(120,330 + _highly, SCREEN_WIDTH - 130, 30)];
        [_spacingSlider addTarget:self action:@selector(slidingSpacingSlider) forControlEvents:UIControlEventValueChanged];
        _spacingSlider.minimumValue = 1;
        _spacingSlider.maximumValue = 60;
        _spacingSlider.value = 5;
    }
    return _spacingSlider;
}

- (UISwitch *)accurateHalfStarsSwitch{
    if (!_accurateHalfStarsSwitch) {
        _accurateHalfStarsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 290 + _highly, 50, 30)];
        _accurateHalfStarsSwitch.on = YES;
        [_accurateHalfStarsSwitch addTarget:self action:@selector(click_accurateHalfStarsSwitch)
                           forControlEvents:UIControlEventValueChanged];
    }
    return _accurateHalfStarsSwitch;
}

- (UILabel *)accurateHalfStarsSwitchLabel{
    if (!_accurateHalfStarsSwitchLabel) {
        _accurateHalfStarsSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 120,260 + _highly, 90, 25)];
        _accurateHalfStarsSwitchLabel.font = [UIFont systemFontOfSize:14];
        _accurateHalfStarsSwitchLabel.textColor = [UIColor AxcUI_OrangeColor];
        _accurateHalfStarsSwitchLabel.textAlignment = NSTextAlignmentLeft;
        _accurateHalfStarsSwitchLabel.text = @"更精准的选择";
    }
    return _accurateHalfStarsSwitchLabel;
}


- (UISwitch *)allowsHalfStarsSwitch{
    if (!_allowsHalfStarsSwitch) {
        _allowsHalfStarsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(30, 290 + _highly, 50, 30)];
        _allowsHalfStarsSwitch.on = YES;
        [_allowsHalfStarsSwitch addTarget:self action:@selector(click_allowsHalfStarsSwitch)
                          forControlEvents:UIControlEventValueChanged];
    }
    return _allowsHalfStarsSwitch;
}

- (UILabel *)allowsHalfStarsSwitchLabel{
    if (!_allowsHalfStarsSwitchLabel) {
        _allowsHalfStarsSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,260 + _highly, 90, 25)];
        _allowsHalfStarsSwitchLabel.font = [UIFont systemFontOfSize:14];
        _allowsHalfStarsSwitchLabel.textColor = [UIColor AxcUI_OrangeColor];
        _allowsHalfStarsSwitchLabel.textAlignment = NSTextAlignmentLeft;
        _allowsHalfStarsSwitchLabel.text = @"允许选择一半";
    }
    return _allowsHalfStarsSwitchLabel;
}

- (UISegmentedControl *)switchPictureSegmented{
    if (!_switchPictureSegmented) {//啥也没有
        _switchPictureSegmented = [[UISegmentedControl alloc] initWithItems:@[@"默认星星",
                                                                              @"自定义图片"]];
        _switchPictureSegmented.frame = CGRectMake(120, 220 + _highly,
                                            SCREEN_WIDTH - 130, 30);
        _switchPictureSegmented.selectedSegmentIndex = 0;
        [_switchPictureSegmented addTarget:self action:@selector(click_switchPictureSegmented)
                   forControlEvents:UIControlEventValueChanged];
    }
    return _switchPictureSegmented;
}

- (UIButton *)changeColorBtn{
    if (!_changeColorBtn) {
        _changeColorBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 220 + _highly, 100, 30)];
        [_changeColorBtn addTarget:self action:@selector(clickchangeColorBtn) forControlEvents:UIControlEventTouchUpInside];
        [_changeColorBtn setTitle:@"改变颜色" forState:UIControlStateNormal];
        _changeColorBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _changeColorBtn.backgroundColor = [UIColor AxcUI_WetAsphaltColor];
        [_changeColorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changeColorBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _changeColorBtn;
}

- (UILabel *)maximumSliderLabel{
    if (!_maximumSliderLabel) {
        _maximumSliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,180 + _highly, 90, 25)];
        _maximumSliderLabel.font = [UIFont systemFontOfSize:14];
        _maximumSliderLabel.textColor = [UIColor AxcUI_OrangeColor];
        _maximumSliderLabel.textAlignment = NSTextAlignmentLeft;
        _maximumSliderLabel.text = @"最大值：5";
    }
    return _maximumSliderLabel;
}
- (UISlider *)maximumSlider{
    if (!_maximumSlider) {
        _maximumSlider = [[UISlider alloc] initWithFrame:CGRectMake(90,180 + _highly, SCREEN_WIDTH - 100, 30)];
        [_maximumSlider addTarget:self action:@selector(slidingMaximumSlider) forControlEvents:UIControlEventValueChanged];
        _maximumSlider.minimumValue = 1;
        _maximumSlider.maximumValue = 20;
        _maximumSlider.value = 5;
    }
    return _maximumSlider;
}

- (UILabel *)StartValueLabel{
    if (!_StartValueLabel) {
        _StartValueLabel = [[UILabel alloc] init];
        _StartValueLabel.font = [UIFont systemFontOfSize:14];
        _StartValueLabel.textAlignment = NSTextAlignmentCenter;
        _StartValueLabel.textColor = [UIColor AxcUI_AmethystColor];
        _StartValueLabel.axcUI_Width = 100;
        _StartValueLabel.axcUI_Height = 30;
        _StartValueLabel.text = @"当前滤镜：原图";
        [self.view addSubview:_StartValueLabel];
    }
    return _StartValueLabel;
}


@end
