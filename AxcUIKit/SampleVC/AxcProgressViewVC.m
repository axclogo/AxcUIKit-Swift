//
//  AxcProgressViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/7.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcProgressViewVC.h"

#define  margin 50

@interface AxcProgressViewVC ()


@property(nonatomic,strong)AxcUI_ProgressPieView *pieProgressView;
@property(nonatomic,strong)AxcUI_ProgressPieLoopView *pieLoopProgressView;
@property(nonatomic,strong)AxcUI_ProgressLoopView *loopProgressView;
@property(nonatomic,strong)AxcUI_ProgressBallView *ballProgressView;
@property(nonatomic,strong)AxcUI_ProgressLodingView *lodingProgressView;
@property(nonatomic,strong)AxcUI_ProgressTranPieView *tranPieProgressView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat progress;

@property(nonatomic,strong)ProgressViewLabel *pieProgressViewLabel;
@property(nonatomic,strong)ProgressViewLabel *pieLoopProgressViewLabel;
@property(nonatomic,strong)ProgressViewLabel *loopProgressViewLabel;
@property(nonatomic,strong)ProgressViewLabel *ballProgressViewLabel;
@property(nonatomic,strong)ProgressViewLabel *lodingProgressViewLabel;
@property(nonatomic,strong)ProgressViewLabel *tranPieProgressViewLabel;



@end

@implementation AxcProgressViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor AxcUI_ConcreteColor];
    
    
    [self.view addSubview:self.tranPieProgressView];
    [self.view addSubview:self.pieProgressView];
    [self.view addSubview:self.pieLoopProgressView];
    [self.view addSubview:self.loopProgressView];
    [self.view addSubview:self.ballProgressView];
    [self.view addSubview:self.lodingProgressView];
    
    [self createOtherControl];
    
    self.instructionsLabel.text = @"此为借鉴SDProgressView重制扩展版本。\n其中的继承设计十分有利于相关的Progress子类扩展，能增加更多类型的进度指示器。\n在此感谢作者gsdios提供的使用许可";
}



- (void)timerFired{
    if (self.progress < 1.0) {
        self.progress += 0.01;
        if (self.progress >= 1.0f) {
            self.progress = 0; // 此处设置了重置，所以不会调用axcUI_removeAnimation参数;
        }
        
        // 在主线程调用setNeedsDisplay和重写STE，无先后顺序，设置即可动态调整  ************************************************
        self.tranPieProgressView.axcUI_progress = self.progress;
        self.pieProgressView.axcUI_progress = self.progress;
        self.pieLoopProgressView.axcUI_progress = self.progress;
        self.loopProgressView.axcUI_progress = self.progress;
        self.ballProgressView.axcUI_progress = self.progress;
        self.lodingProgressView.axcUI_progress = self.progress;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.timer invalidate];
    self.timer = nil;
    
    // 安全移除，防止内存泄漏
    [self.lodingProgressView removeTimer];
}

#pragma mark - 懒加载区
- (AxcUI_ProgressPieView *)pieProgressView{
    if (!_pieProgressView) {
        _pieProgressView = [[AxcUI_ProgressPieView alloc] init];
        _pieProgressView.frame = CGRectMake(self.view.axcUI_Width - margin - 100, 410, 100, 100);
    }
    return _pieProgressView;
}
- (AxcUI_ProgressPieLoopView *)pieLoopProgressView{
    if (!_pieLoopProgressView) {
        _pieLoopProgressView = [[AxcUI_ProgressPieLoopView alloc] init];
        _pieLoopProgressView.frame = CGRectMake(margin, 410, 100, 100);
    }
    return _pieLoopProgressView;
}
- (AxcUI_ProgressLoopView *)loopProgressView{
    if (!_loopProgressView) {
        _loopProgressView = [[AxcUI_ProgressLoopView alloc] init];
        _loopProgressView.frame = CGRectMake(self.view.axcUI_Width - margin - 100, 260, 100, 100);
    }
    return _loopProgressView;
}
- (AxcUI_ProgressBallView *)ballProgressView{
    if (!_ballProgressView) {
        _ballProgressView = [[AxcUI_ProgressBallView alloc] init];
        _ballProgressView.frame = CGRectMake(margin, 260, 100, 100);
    }
    return _ballProgressView;
}
- (AxcUI_ProgressLodingView *)lodingProgressView{
    if (!_lodingProgressView) {
        _lodingProgressView = [[AxcUI_ProgressLodingView alloc] init];
        _lodingProgressView.frame = CGRectMake(self.view.axcUI_Width - margin - 100, 110, 100, 100);
    }
    return _lodingProgressView;
}
- (AxcUI_ProgressTranPieView *)tranPieProgressView{
    if (!_tranPieProgressView) {
        _tranPieProgressView = [[AxcUI_ProgressTranPieView alloc] init];
        _tranPieProgressView.frame = CGRectMake(margin, 110, 100, 100);
    }
    return _tranPieProgressView;
}


/****************添加说明Label*******************/


- (ProgressViewLabel *)pieProgressViewLabel{
    if (!_pieProgressViewLabel) {
        _pieProgressViewLabel = [[ProgressViewLabel alloc] initWithFrame:CGRectMake(self.view.axcUI_Width - 10 - 180, 520, 0, 30)];
        _pieProgressViewLabel.text = @"AxcUI_ProgressPieView";
    }
    return _pieProgressViewLabel;
}
- (ProgressViewLabel *)pieLoopProgressViewLabel{
    if (!_pieLoopProgressViewLabel) {
        _pieLoopProgressViewLabel = [[ProgressViewLabel alloc] initWithFrame:CGRectMake(10, 520, 0, 30)];
        _pieLoopProgressViewLabel.text = @"AxcUI_ProgressPieLoopView";
    }
    return _pieLoopProgressViewLabel;
}
- (ProgressViewLabel *)loopProgressViewLabel{
    if (!_loopProgressViewLabel) {
        _loopProgressViewLabel = [[ProgressViewLabel alloc] initWithFrame:CGRectMake(self.view.axcUI_Width - 10 - 180, 370, 0, 30)];
        _loopProgressViewLabel.text = @"AxcUI_ProgressLoopView";
    }
    return _loopProgressViewLabel;
}
- (ProgressViewLabel *)ballProgressViewLabel{
    if (!_ballProgressViewLabel) {
        _ballProgressViewLabel = [[ProgressViewLabel alloc] initWithFrame:CGRectMake(10, 370, 0, 30)];
        _ballProgressViewLabel.text = @"AxcUI_ProgressBallView";
    }
    return _ballProgressViewLabel;
}
- (ProgressViewLabel *)lodingProgressViewLabel{
    if (!_lodingProgressViewLabel) {
        _lodingProgressViewLabel = [[ProgressViewLabel alloc] initWithFrame:CGRectMake(self.view.axcUI_Width - 10 - 180, 220, 0, 30)];
        _lodingProgressViewLabel.text = @"AxcUI_ProgressLodingView";
    }
    return _lodingProgressViewLabel;
}
- (ProgressViewLabel *)tranPieProgressViewLabel{
    if (!_tranPieProgressViewLabel) {
        _tranPieProgressViewLabel = [[ProgressViewLabel alloc] initWithFrame:CGRectMake(10, 220, 0, 30)];
        _tranPieProgressViewLabel.text = @"AxcUI_ProgressTranPieView";
    }
    return _tranPieProgressViewLabel;
}



- (void)createOtherControl{
    [self.view addSubview:self.pieProgressViewLabel];
    [self.view addSubview:self.pieLoopProgressViewLabel];
    [self.view addSubview:self.loopProgressViewLabel];
    [self.view addSubview:self.ballProgressViewLabel];
    [self.view addSubview:self.lodingProgressViewLabel];
    [self.view addSubview:self.tranPieProgressViewLabel];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                  target:self
                                                selector:@selector(timerFired)
                                                userInfo:nil
                                                 repeats:YES];
    self.progress = 0;
}

@end

@implementation ProgressViewLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.axcUI_Width = 180;
        self.font = [UIFont systemFontOfSize:13];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
