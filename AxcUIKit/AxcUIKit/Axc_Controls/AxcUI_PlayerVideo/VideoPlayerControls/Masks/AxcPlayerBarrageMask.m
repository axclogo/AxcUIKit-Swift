//
//  AxcPlayerBarrageMask.m
//  axctest
//
//  Created by Axc on 2017/7/20.
//  Copyright © 2017年 Axc5324. All rights reserved.
//

#import "AxcPlayerBarrageMask.h"
#import "AxcUI_PlayerVideo.h"

@implementation AxcPlayerBarrageMask

- (instancetype)initWithPlayerView:(AxcUI_PlayerView *)playerView {
    self = [super initWithPlayerView:playerView];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
//        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.superview == nil) return;
    CGRect superviewFrame = self.superview.frame;
    
    CGFloat y = 0;
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(statusBarOrientation)) {
        y = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    CGRect frame = CGRectMake(superviewFrame.size.width - superviewFrame.size.width / 3,
                              0,
                              superviewFrame.size.width / 3,
                              superviewFrame.size.height);
    
    self.frame = frame;
    
    
    
    self.barrageSwitchSegmented.frame = CGRectMake(10, 30, frame.size.width - 20, 30);
    [self addSubview:self.barrageSwitchSegmented];

    self.barrageTextFontSliderLabel.frame = CGRectMake(10, 70, frame.size.width - 20, 30);
    [self addSubview:self.barrageTextFontSliderLabel];
    
    self.barrageTextFontSlider.frame = CGRectMake(10, 100, frame.size.width - 20, 30);
    [self addSubview:self.barrageTextFontSlider];
    self.barrageTextFontSlider.value = self.currentPlayerView.axcUI_barrageEngine.axcUI_barrageGlobalFont.pointSize;
    
    self.barrageSpeedSliderLabel.frame = CGRectMake(10, 140, frame.size.width - 20, 30);
    [self addSubview:self.barrageSpeedSliderLabel];
    
    self.barrageSpeedSlider.frame = CGRectMake(10, 170, frame.size.width - 20, 30);
    [self addSubview:self.barrageSpeedSlider];
    self.barrageSpeedSlider.value = self.currentPlayerView.axcUI_barrageEngine.axcUI_barrageSpeed;
    
}


- (void)reload{
    [self layoutSubviews];
}


// 修正全局字体
- (void)refreshFont{
    self.currentPlayerView.axcUI_barrageEngine.axcUI_barrageGlobalFont = [UIFont systemFontOfSize:self.barrageTextFontSlider.value];
}
// 修正全局速度
- (void)refreshSpeed{
    self.currentPlayerView.axcUI_barrageEngine.axcUI_barrageSpeed = self.barrageSpeedSlider.value;
}

// 弹幕控制
- (void)click_switchSegmented{
    switch (self.barrageSwitchSegmented.selectedSegmentIndex) {
        case 0: [self.currentPlayerView.axcUI_barrageEngine AxcUI_BarrageStart]; break;
        case 1: [self.currentPlayerView.axcUI_barrageEngine AxcUI_BarragePause]; break;
        case 2: [self.currentPlayerView.axcUI_barrageEngine AxcUI_BarrageStop]; break;
        default: break;
    }
}





















- (void)addAnimationWithCompletion:(void (^)())completion{
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;

    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)removeAnimationWithCompletion:(void(^)())completion {
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (AxcUI_Label *)barrageTextFontSliderLabel{
    if (!_barrageTextFontSliderLabel) {
        _barrageTextFontSliderLabel = [[AxcUI_Label alloc] init];
        _barrageTextFontSliderLabel.font = [UIFont systemFontOfSize:12];
        _barrageTextFontSliderLabel.textColor = [UIColor whiteColor];
        _barrageTextFontSliderLabel.axcUI_textEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _barrageTextFontSliderLabel.text = @"调整弹幕字号";
    }
    return _barrageTextFontSliderLabel;
}

- (UISlider *)barrageTextFontSlider{
    if (!_barrageTextFontSlider) {
        _barrageTextFontSlider = [[UISlider alloc] init];
        [_barrageTextFontSlider addTarget:self action:@selector(refreshFont) forControlEvents:UIControlEventValueChanged];
        _barrageTextFontSlider.minimumValue = 10;
        _barrageTextFontSlider.maximumValue = 20;
        _barrageTextFontSlider.value = 10;
    }
    return _barrageTextFontSlider;
}

- (AxcUI_Label *)barrageSpeedSliderLabel{
    if (!_barrageSpeedSliderLabel) {
        _barrageSpeedSliderLabel = [[AxcUI_Label alloc] init];
        _barrageSpeedSliderLabel.font = [UIFont systemFontOfSize:12];
        _barrageSpeedSliderLabel.textColor = [UIColor whiteColor];
        _barrageSpeedSliderLabel.axcUI_textEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        _barrageSpeedSliderLabel.text = @"调整弹幕速度";
    }
    return _barrageSpeedSliderLabel;
}

- (UISlider *)barrageSpeedSlider{
    if (!_barrageSpeedSlider) {
        _barrageSpeedSlider =
        _barrageSpeedSlider = [[UISlider alloc] init ];
        [_barrageSpeedSlider addTarget:self action:@selector(refreshSpeed) forControlEvents:UIControlEventValueChanged];
        _barrageSpeedSlider.minimumValue = 0;
        _barrageSpeedSlider.maximumValue = 5;
        _barrageSpeedSlider.value = 1;
    }
    return _barrageSpeedSlider;
}

- (UISegmentedControl *)barrageSwitchSegmented{
    if (!_barrageSwitchSegmented) {//啥也没有
        _barrageSwitchSegmented = [[UISegmentedControl alloc] initWithItems:@[@"开始",
                                                                              @"暂停",
                                                                              @"关闭"]];
        _barrageSwitchSegmented.selectedSegmentIndex = 0;
        [_barrageSwitchSegmented addTarget:self action:@selector(click_switchSegmented)
                   forControlEvents:UIControlEventValueChanged];
        [_barrageSwitchSegmented setTintColor:[UIColor whiteColor]];
    }
    return _barrageSwitchSegmented;
}









@end
