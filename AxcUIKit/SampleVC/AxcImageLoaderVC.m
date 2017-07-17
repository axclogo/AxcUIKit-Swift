//
//  AxcImageLoaderVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/5.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcImageLoaderVC.h"


@interface AxcImageLoaderVC ()


@property (nonatomic, strong) UISegmentedControl *loaderSegmented;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat progress;

@property(nonatomic, strong)UIButton *removeButton;
@property(nonatomic, strong)UIButton *startButton;

@property(nonatomic, strong)UISwitch *animationSwitch;


@property(nonatomic, assign) AxcUIProgressViewStyle progressStyle;

@end

@implementation AxcImageLoaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.loaderSegmented];

    [self.view addSubview:self.startButton];
    [self.view addSubview:self.removeButton];
    [self.view addSubview:self.animationSwitch];
    
    [self click_startButton];
    
    self.instructionsLabel.text = @"开关为控制移除ProgressView时的动画是否开启。\n一行代码设置progressStyle\n一行代码移除ProgressView\n此处和原版SDProgressView增加了类扩展更方便使用";
}

- (void)timerFired{
    if (self.progress < 1.0) {
        self.progress += 0.01;
        if (self.progress >= 1.0f) {
            self.progress = 0; // 此处设置了重置，所以不会调用axcUI_removeAnimation参数;
        }
        
        // 重写SET & 和指针切换对象，无先后顺序，设置即可动态调整  ************************************************
        self.imageView.axcUI_progressView.axcUI_progress = self.progress;
        self.imageView.axcUI_progressViewStyle = self.progressStyle;
    }
}


- (void)click_removeButton{
    [self.timer invalidate];
    self.timer = nil;
    
    // 调用此方法可以安全移除AxcUI_progressView
    [self.imageView AxcUI_removeAxcUI_progressViewAnimation:self.animationSwitch.on];
    // 或者设置：
    // 此参数只有在Progress >= 1 时才会自动调用；上方设置了重置，所以该参暂时不会调用
//    self.imageView.axcUI_progressView.axcUI_removeAnimation = self.animationSwitch.on;
}
- (void)click_startButton{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                      target:self
                                                    selector:@selector(timerFired)
                                                    userInfo:nil
                                                     repeats:YES];
        self.progress = 0;
    }
    
}
- (void)controllAction:(UISegmentedControl *)sender{
    self.progressStyle = sender.selectedSegmentIndex;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 懒加载
- (UISwitch *)animationSwitch{
    if (!_animationSwitch) {
        _animationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.axcUI_Width / 2 - 25,
                                                                      460, 50, 30)];
        _animationSwitch.on = YES;
        [self.view addSubview:_animationSwitch];
    }
    return _animationSwitch;
}
- (UIButton *)startButton{
    if (!_startButton) {
        _startButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.axcUI_Width - 150, 460, 100, 40)];
        [_startButton setTitle:@"开始加载" forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(click_startButton) forControlEvents:UIControlEventTouchUpInside];
        _startButton.backgroundColor = [UIColor AxcUI_PomegranateColor];
        _startButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _startButton;
}
- (UIButton *)removeButton{
    if (!_removeButton) {
        _removeButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 460, 100, 40)];
        [_removeButton setTitle:@"移除Progress" forState:UIControlStateNormal];
        [_removeButton addTarget:self action:@selector(click_removeButton) forControlEvents:UIControlEventTouchUpInside];
        _removeButton.backgroundColor = [UIColor AxcUI_PomegranateColor];
        _removeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _removeButton;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, self.view.axcUI_Width - 100, 250)];
        _imageView.backgroundColor = [UIColor AxcUI_SilverColor];
        self.imageView.image = [UIImage AxcUI_setImageNamed:@"test_2.jpg"];
    }
    return _imageView;
}

- (UISegmentedControl *)loaderSegmented{
    if (!_loaderSegmented) {
        _loaderSegmented = [[UISegmentedControl alloc] initWithItems:@[@"透明饼图",
                                                                       @"实心饼图",
                                                                       @"循环圆框",
                                                                       @"填充球体",
                                                                       @"加载模式",
                                                                       @"同心循环"]];
        _loaderSegmented.frame = CGRectMake(10, 400, self.view.axcUI_Width - 20, 30);
        _loaderSegmented.selectedSegmentIndex = 0;
        [_loaderSegmented addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _loaderSegmented.tag = 100 + 7;
    }
    return _loaderSegmented;
}
@end
