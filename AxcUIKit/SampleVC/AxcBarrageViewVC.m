//
//  AxcBarrageViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/30.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBarrageViewVC.h"


@interface AxcBarrageViewVC ()<AxcBarrageViewDelegate>


@property(nonatomic,strong)AxcUI_BarrageView *ordinaryBarrage;

@property(nonatomic, strong)UILabel *contentLabel;
@property(nonatomic, strong)NSString *contentString;

@property(nonatomic,strong)AxcUI_BarrageView *imageOrdinaryBarrage;

@property (nonatomic, strong) UISegmentedControl *ordinaryBarrageSegmented;
@property(nonatomic, strong)UISlider *timeSlider;
@property(nonatomic, strong)UILabel *labelTextTimeSlider;

@property(nonatomic, strong)UISwitch *cycleSwitch;
@property(nonatomic, strong)UILabel *cycleLabel;

@property(nonatomic, strong)UIButton *cycleBtn;

@end

@implementation AxcBarrageViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBarrage];
    
    [self.view addSubview:self.ordinaryBarrageSegmented];
    [self.view addSubview:self.labelTextTimeSlider];
    [self.view addSubview:self.timeSlider];

    __weak typeof(self) WeakSelf = self;

    [self.cycleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.timeSlider.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(100);
    }];
    
    [self.cycleSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.cycleLabel.mas_top).offset(0);
        make.left.mas_equalTo(WeakSelf.cycleLabel.mas_right).offset(5);
    }];
    
    [self.cycleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.cycleLabel.mas_top).offset(0);
        make.left.mas_equalTo(WeakSelf.cycleSwitch.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(WeakSelf.cycleLabel.mas_bottom).offset(0);
    }];
    
    self.instructionsLabel.text = @"该容器的层级结构为：容器承载层和展示层，承载层使用动画来将展示层推动。\n其中展示层可以自定义，不局限于Label组成的弹幕效果和跑马灯效果，也支持多元素动画效果。";
    
    [self createBarrageImage];
}


- (void)createBarrage{
    // 使用初始化和重写SET方法，设置即可调用，无先后顺序，设置即可动态调整  ************************************************
    
    // 设置弹幕的参数
    self.contentString = @"这是普通的弹幕效果";  // 注意下方的SET重写方法
    self.ordinaryBarrage.axcUI_barrageDelegate = self; // 代理参数，有两个动画开始和结束的回调委托
    self.ordinaryBarrage.axcUI_barrageMarqueeDirection  = AxcBarrageMovementStyleBottomFromTop; // 滑动方向
    self.ordinaryBarrage.axcUI_barrageSpeed = 1;  // 速度
    [self.ordinaryBarrage AxcUI_addContentView:self.contentLabel];  // 将一个View展示控件添加到弹幕容器中去
    [self.ordinaryBarrage AxcUI_startAnimation];    // 开始动画
}
- (void)click_refreshValue{ // 修改滑动的方向
    self.ordinaryBarrage.axcUI_barrageMarqueeDirection = self.ordinaryBarrageSegmented.selectedSegmentIndex;
    self.imageOrdinaryBarrage.axcUI_barrageMarqueeDirection = self.ordinaryBarrageSegmented.selectedSegmentIndex;
}
- (void)click_refreshTime{  // 修改滑动的速度
    self.labelTextTimeSlider.text = [NSString stringWithFormat:@"当前速度%.2f",self.timeSlider.value];
    self.ordinaryBarrage.axcUI_barrageSpeed = self.timeSlider.value;  // 速度
    self.imageOrdinaryBarrage.axcUI_barrageSpeed = self.timeSlider.value;  // 速度
}
- (void)controllActionSwitch{ // 是否循环展示
    self.ordinaryBarrage.axcUI_barrageCycle = self.cycleSwitch.on;  // 速度
    self.imageOrdinaryBarrage.axcUI_barrageCycle = self.cycleSwitch.on;  // 速度
}
- (void)click_cycleBtn{ // 开始动画
    [self.ordinaryBarrage AxcUI_startAnimation];
    [self.imageOrdinaryBarrage AxcUI_startAnimation];
}

#pragma mark - 容器回调代理
- (void)AxcUI_barrageView:(AxcUI_BarrageView *)drawMarqueeView
         animationDidStop:(CAAnimation *)anim
                 Finished:(BOOL)finished{
    NSLog(@"容器结束一个周期");
}

- (void)AxcUI_barrageView:(AxcUI_BarrageView *)drawMarqueeView
        animationDidStart:(CAAnimation *)anim{
    NSLog(@"容器准备开始一个周期");
}

///////////////另外示例
- (void)createBarrageImage{
    self.imageOrdinaryBarrage.axcUI_barrageMarqueeDirection  = AxcBarrageMovementStyleRightFromLeft;
    [self.imageOrdinaryBarrage AxcUI_addContentView:[self showImageView]];
    [self.imageOrdinaryBarrage AxcUI_startAnimation];
}

- (UIImageView *)showImageView{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_1.jpg"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = [UIColor AxcUI_NephritisColor];
    imageView.axcUI_Size = CGSizeMake(400, 200);
    UILabel *label = [[UILabel alloc] init];
    label.axcUI_Size = CGSizeMake(200, 40);
    label.center = imageView.center;
    label.text = @"这个是多元素容器展示";
    label.textColor = [UIColor whiteColor];
    [imageView addSubview:label];
    return imageView;
}

#pragma mark - SET区
- (void)setContentString:(NSString *)contentString{
    _contentString = contentString;
    CGFloat width = [_contentString AxcUI_widthWithStringFont:self.contentLabel.font]; // 自动根据Font计算宽度
    self.contentLabel.frame = CGRectMake(0, 0, width, 30); // 重设宽度
    self.contentLabel.text = _contentString;
}


#pragma mark - 懒加载区
- (UILabel *)contentLabel{ // 这个是容器Label
    if (!_contentLabel) {
        _contentLabel  = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14.f];
        _contentLabel.textColor = [UIColor AxcUI_ArcColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (AxcUI_BarrageView *)ordinaryBarrage{
    if (!_ordinaryBarrage) {
        _ordinaryBarrage = [[AxcUI_BarrageView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, 50)];
        _ordinaryBarrage.backgroundColor = [UIColor AxcUI_CloudColor]; // 背景色
        [self.view addSubview:_ordinaryBarrage];
    }
    return _ordinaryBarrage;
}

- (AxcUI_BarrageView *)imageOrdinaryBarrage{
    if (!_imageOrdinaryBarrage) {
        _imageOrdinaryBarrage = [[AxcUI_BarrageView alloc] initWithFrame:CGRectMake(0, 170, self.view.frame.size.width, 200)];
        _imageOrdinaryBarrage.backgroundColor = [UIColor AxcUI_NephritisColor];
        [self.view addSubview:_imageOrdinaryBarrage];
    }
    return _imageOrdinaryBarrage;
}



- (UISegmentedControl *)ordinaryBarrageSegmented{
    if (!_ordinaryBarrageSegmented) {
        _ordinaryBarrageSegmented = [[UISegmentedControl alloc] initWithItems:@[@"从右到左",
                                                                                @"从左到右",
                                                                                @"从上到下",
                                                                                @"从下到上"]];
        _ordinaryBarrageSegmented.frame = CGRectMake(10, 380,
                                                    self.view.axcUI_Width - 20, 30);
        _ordinaryBarrageSegmented.selectedSegmentIndex = 0;
        [_ordinaryBarrageSegmented addTarget:self action:@selector(click_refreshValue) forControlEvents:UIControlEventValueChanged];
    }
    return _ordinaryBarrageSegmented;
}
- (UISlider *)timeSlider{
    if (!_timeSlider) {
        _timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(10,450, self.view.axcUI_Width - 20, 30)];
        [_timeSlider addTarget:self action:@selector(click_refreshTime) forControlEvents:UIControlEventValueChanged];
        _timeSlider.minimumValue = 1;
        _timeSlider.maximumValue = 5;
        _timeSlider.value = 1;
    }
    return _timeSlider;
}
- (UILabel *)labelTextTimeSlider{
    if (!_labelTextTimeSlider) {
        _labelTextTimeSlider = [[UILabel alloc] initWithFrame:CGRectMake(10,420, self.view.axcUI_Width - 20, 30)];
        _labelTextTimeSlider.font = [UIFont systemFontOfSize:14];
        _labelTextTimeSlider.textColor = [UIColor AxcUI_OrangeColor];
        _labelTextTimeSlider.textAlignment = NSTextAlignmentCenter;
        _labelTextTimeSlider.text = @"当前速度：1.00";
    }
    return _labelTextTimeSlider;
}
- (UIButton *)cycleBtn{
    if (!_cycleBtn) {
        _cycleBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 500, 250, 30)];
        [_cycleBtn setTitle:@"点击开始展示" forState:UIControlStateNormal];
        [_cycleBtn setTitleColor:[UIColor AxcUI_BelizeHoleColor] forState:UIControlStateNormal];
        _cycleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _cycleBtn.backgroundColor = [UIColor AxcUI_CloudColor];
        _cycleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cycleBtn addTarget:self action:@selector(click_cycleBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cycleBtn];
    }
    return _cycleBtn;
}

- (UILabel *)cycleLabel{
    if (!_cycleLabel) {
        _cycleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 500, 0, 0)];
        _cycleLabel.text = @"是否开启循环";
        _cycleLabel.font = [UIFont systemFontOfSize:14];
        _cycleLabel.textAlignment = NSTextAlignmentCenter;
        _cycleLabel.textColor = [UIColor AxcUI_AmethystColor];
        _cycleLabel.axcUI_Width = 100;
        _cycleLabel.axcUI_Height = 40;
        [self.view addSubview:_cycleLabel];
    }
    return _cycleLabel;
}

- (UISwitch *)cycleSwitch{
    if (!_cycleSwitch) {
        _cycleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(110, 500, 50, 30)];
        [_cycleSwitch addTarget:self action:@selector(controllActionSwitch) forControlEvents:UIControlEventValueChanged];
        _cycleSwitch.tag = 100 + 3;
        _cycleSwitch.on = YES;
        [self.view addSubview:_cycleSwitch];
    }
    return _cycleSwitch;
}

@end
