//
//  AxcBarrageScrollEngineVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBarrageScrollEngineVC.h"
#import "AxcXmlUtil.h"


@interface AxcBarrageScrollEngineVC ()<AxcBarrageScrollEngineDelegate>


@property (strong, nonatomic) AxcUI_BarrageScrollEngine *barrageEngine;

@property (strong, nonatomic) NSDictionary *barrageDic;
@property(nonatomic, strong)UISlider *timeSlider;
@property(nonatomic, strong)UILabel *labelTextTimeSlider;
@property(nonatomic, strong)UISlider *fontSlider;
@property(nonatomic, strong)UILabel *labelFontSlider;
@property (nonatomic, strong) UISegmentedControl *fontEffectsSegmented;

@property(nonatomic, strong)UISlider *spacingSlider;
@property(nonatomic, strong)UILabel *labelSpacingSlider;

@property (nonatomic, strong) UISegmentedControl *switchSegmented;

@property(nonatomic, strong)UISwitch *testSwitch;
@property(nonatomic, strong)UILabel *labelTestModel;

@property(nonatomic, strong)UITextField *barrageTextFiled;
@property(nonatomic, strong)UIButton *barrageStyleBtn;
@property(nonatomic, assign)NSInteger barrageStyle;

@property(nonatomic, strong)UIButton *barrageDirectionBtn;
@property(nonatomic, assign)NSInteger barrageDirection;


@end

@implementation AxcBarrageScrollEngineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加弹幕视图到桌布
    [self.view addSubview:self.barrageEngine.axcUI_barrageCanvas];
    // 添加控制器到桌面
    
    [self.view addSubview:self.barrageStyleBtn];
    [self.view addSubview:self.barrageDirectionBtn];

    [self.view addSubview:self.labelTestModel];
    [self.view addSubview:self.testSwitch];

    [self.view addSubview:self.barrageTextFiled];
    
    [self.view addSubview:self.switchSegmented];

    [self.view addSubview:self.labelSpacingSlider];
    [self.view addSubview:self.spacingSlider];
    
    [self.view addSubview:self.fontEffectsSegmented];

    [self.view addSubview:self.labelFontSlider];
    [self.view addSubview:self.fontSlider];
    [self.view addSubview:self.labelTextTimeSlider];
    [self.view addSubview:self.timeSlider];
    _barrageStyle = 0; // 默认滚动
    _barrageDirection = 0; // 默认从右到左
    
    
    // 原作者GitHub：https://github.com/sunsx9316
    self.instructionsLabel.text = @"根据作者sunsx9316的项目JHDanmakuRender改制\n多弹幕情况下效率较高，占用内存以及CPU极少。\nAxcUI_BarrageView是根据此架构修改后的多元素展示控件";
}

// 发射弹幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.barrageTextFiled resignFirstResponder]; // 解除第一响应者
    AxcUI_BarrageModelBase *sc;                 // 声明父类弹幕
    NSString *str = self.barrageTextFiled.text; // 准备弹幕文字
    if (!str || [str isEqualToString:@""]) {
        str = self.barrageTextFiled.axcUI_PlaceholderLabel.text;
    }
    if (_barrageStyle == 0) {   // 创建滚动弹幕模组
        sc = [[AxcUI_BarrageScrollModel alloc] initWithFontSize:13
                                                      textColor:[UIColor AxcUI_ArcColor]  // 随机色
                                                           text:str
                                                    shadowStyle:AxcBarrageShadowStyleNone // 字体特效
                                                           font:nil
                                                          speed:arc4random_uniform(100) + 50
                                                      direction:_barrageDirection + 10];
    }else{  // 创建浮动弹幕模组
        sc = [[AxcUI_BarrageFloatModel alloc] initWithFontSize:13
                                                     textColor:[UIColor AxcUI_ArcColor] // 随机色
                                                          text:str
                                                   shadowStyle:AxcBarrageShadowStyleNone  // 字体特效
                                                          font:nil
                                                        during:5        // 持续时间
                                                     direction:_barrageDirection + 100];
    }
    // 发送该弹幕
    [self.barrageEngine AxcUI_BarrageSendBarrage: sc];
    
}

// 使用初始化和重写SET方法，设置即可调用，无先后顺序，设置即可动态调整  ************************************************

// 弹幕控制
- (void)click_switchSegmented{
    switch (self.switchSegmented.selectedSegmentIndex) {
        case 0: [self.barrageEngine AxcUI_BarrageStart]; break;
        case 1: [self.barrageEngine AxcUI_BarragePause]; break;
        case 2: [self.barrageEngine AxcUI_BarrageStop]; break;
        default: break;
    }
}
// 调整弹幕间距
- (void)click_spacingSlider{
    self.barrageEngine.axcUI_barrageChannelCount = self.spacingSlider.value;
    self.labelSpacingSlider.text = [NSString stringWithFormat:@"弹幕间距：%.0f",self.spacingSlider.value];
}
// 调整全局字体特效
- (void)click_fontEffectsSegmented{
    switch (self.fontEffectsSegmented.selectedSegmentIndex) {
        case 0: self.barrageEngine.axcUI_barrageGlobalShadowStyle = AxcBarrageShadowStyleNone; break;
        case 1: self.barrageEngine.axcUI_barrageGlobalShadowStyle = AxcBarrageShadowStyleStroke; break;
        case 2: self.barrageEngine.axcUI_barrageGlobalShadowStyle = AxcBarrageShadowStyleShadow; break;
        case 3: self.barrageEngine.axcUI_barrageGlobalShadowStyle = AxcBarrageShadowStyleGlow; break;
        default: break;
    }
}
// 调整字号
- (void)click_refreshFont{
    self.barrageEngine.axcUI_barrageGlobalFont = [UIFont systemFontOfSize:self.fontSlider.value];
    self.labelFontSlider.text = [NSString stringWithFormat:@"全局字号：%.1f",self.fontSlider.value];
}
// 调整速度
- (void)click_refreshTime{
    self.barrageEngine.axcUI_barrageSpeed = self.timeSlider.value;
    self.labelTextTimeSlider.text = [NSString stringWithFormat:@"全局速度：%.2f",self.timeSlider.value];
}
// 回调代理
#pragma mark - AxcUI_BarrageScrollEngineDelegate
- (NSArray <__kindof AxcUI_BarrageModelBase*>*)AxcUI_barrageScrollEngine:(AxcUI_BarrageScrollEngine *)barrageEngine
                                                    didSendBarrageAtTime:(NSUInteger)time {
    if (self.testSwitch.on) { // 测试开关
        return self.barrageDic[@(time)];
    }
    return nil;
}


#pragma mark - 懒加载
- (AxcUI_BarrageScrollEngine *)barrageEngine{
    if (!_barrageEngine) {
        _barrageEngine = [[AxcUI_BarrageScrollEngine alloc] init];
        _barrageEngine.axcUI_barrageCanvas.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH/2 + 20);
        _barrageEngine.axcUI_barrageCanvas.backgroundColor = [UIColor AxcUI_WetAsphaltColor];
        // 代理
        _barrageEngine.axcUI_barrageDelegate = self;
        // 计时器多少秒调用一次代理方法 默认1s
        _barrageEngine.axcUI_barrageTimeInterval = 1;
        // 开始滚动弹幕
        [_barrageEngine AxcUI_BarrageStart];
    }
    return _barrageEngine;
}
// 解析假的弹幕数据
- (NSDictionary *)barrageDic {
    if(_barrageDic == nil) {
        _barrageDic = [AxcXmlUtil dicWithObj:[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"]]];
    }
    return _barrageDic;
}


#pragma mark - 控制元素区 ============
- (UIButton *)barrageDirectionBtn{
    if (!_barrageDirectionBtn) {
        _barrageDirectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, SCREEN_WIDTH/2 + 125, 100, 30)];
        [_barrageDirectionBtn addTarget:self action:@selector(clickBarrageDirectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_barrageDirectionBtn setTitle:@"选择弹幕方位" forState:UIControlStateNormal];
        _barrageDirectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _barrageDirectionBtn.backgroundColor = [UIColor AxcUI_WetAsphaltColor];
        [_barrageDirectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _barrageDirectionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _barrageDirectionBtn;
}

- (UIButton *)barrageStyleBtn{
    if (!_barrageStyleBtn) {
        _barrageStyleBtn = [[UIButton alloc] initWithFrame:CGRectMake(130, SCREEN_WIDTH/2 + 125, 130, 30)];
        [_barrageStyleBtn addTarget:self action:@selector(clickBarrageStyleBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_barrageStyleBtn setTitle:@"弹幕类型：滚动弹幕" forState:UIControlStateNormal];
        _barrageStyleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _barrageStyleBtn.backgroundColor = [UIColor AxcUI_WetAsphaltColor];
        [_barrageStyleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _barrageStyleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _barrageStyleBtn;
}

- (UITextField *)barrageTextFiled{
    if (!_barrageTextFiled) {
        _barrageTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 315,
                                                                          self.view.axcUI_Width - 20, 30)];
        _barrageTextFiled.placeholder = @"在这里输入你想发的弹幕内容，点击屏幕发送";
        _barrageTextFiled.font = [UIFont systemFontOfSize:14];
        _barrageTextFiled.layer.cornerRadius = 5;
        _barrageTextFiled.layer.masksToBounds = YES;
        _barrageTextFiled.layer.borderWidth = 1;
        _barrageTextFiled.layer.borderColor = [[UIColor AxcUI_PumpkinColor] CGColor];
    }
    return _barrageTextFiled;
}
- (UILabel *)labelTestModel{
    if (!_labelTestModel) {
        _labelTestModel = [[UILabel alloc] initWithFrame:CGRectMake(5,SCREEN_WIDTH/2 + 125, 60, 30)];
        _labelTestModel.font = [UIFont systemFontOfSize:14];
        _labelTestModel.textColor = [UIColor AxcUI_OrangeColor];
        _labelTestModel.textAlignment = NSTextAlignmentLeft;
        _labelTestModel.text = @"模拟弹幕";
    }
    return _labelTestModel;
}
- (UISwitch *)testSwitch{
    if (!_testSwitch) {
        _testSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(70, SCREEN_WIDTH/2 + 125, 50, 30)];
        _testSwitch.on = NO;
    }
    return _testSwitch;
}
- (UISegmentedControl *)switchSegmented{
    if (!_switchSegmented) {//啥也没有
        _switchSegmented = [[UISegmentedControl alloc] initWithItems:@[@"开始",
                                                                       @"暂停",
                                                                       @"停止"]];
        _switchSegmented.frame = CGRectMake(10, SCREEN_HEIGHT - 275,
                                                 self.view.axcUI_Width - 20, 30);
        _switchSegmented.selectedSegmentIndex = 0;
        [_switchSegmented addTarget:self action:@selector(click_switchSegmented)
                        forControlEvents:UIControlEventValueChanged];
    }
    return _switchSegmented;
}

- (UILabel *)labelSpacingSlider{
    if (!_labelSpacingSlider) {
        _labelSpacingSlider = [[UILabel alloc] initWithFrame:CGRectMake(5,SCREEN_HEIGHT - 240, 120, 30)];
        _labelSpacingSlider.font = [UIFont systemFontOfSize:14];
        _labelSpacingSlider.textColor = [UIColor AxcUI_OrangeColor];
        _labelSpacingSlider.textAlignment = NSTextAlignmentLeft;
        _labelSpacingSlider.text = @"弹幕间距：0.00";
    }
    return _labelSpacingSlider;
}
- (UISlider *)spacingSlider{
    if (!_spacingSlider) {
        _spacingSlider = [[UISlider alloc] initWithFrame:CGRectMake(110,SCREEN_HEIGHT - 240, self.view.axcUI_Width - 130, 30)];
        [_spacingSlider addTarget:self action:@selector(click_spacingSlider) forControlEvents:UIControlEventValueChanged];
        _spacingSlider.minimumValue = 0;
        _spacingSlider.maximumValue = 100;
        _spacingSlider.value = 0;
    }
    return _spacingSlider;
}
- (UISegmentedControl *)fontEffectsSegmented{
    if (!_fontEffectsSegmented) {//啥也没有
        _fontEffectsSegmented = [[UISegmentedControl alloc] initWithItems:@[@"字体特效-无",
                                                                            @"描边",
                                                                            @"投影",
                                                                            @"模糊阴影"]];
        _fontEffectsSegmented.frame = CGRectMake(10, SCREEN_HEIGHT - 200,
                                                     self.view.axcUI_Width - 20, 30);
        _fontEffectsSegmented.selectedSegmentIndex = 0;
        [_fontEffectsSegmented addTarget:self action:@selector(click_fontEffectsSegmented)
                        forControlEvents:UIControlEventValueChanged];
    }
    return _fontEffectsSegmented;
}

- (UILabel *)labelFontSlider{
    if (!_labelFontSlider) {
        _labelFontSlider = [[UILabel alloc] initWithFrame:CGRectMake(5,SCREEN_HEIGHT - 160, 120, 30)];
        _labelFontSlider.font = [UIFont systemFontOfSize:14];
        _labelFontSlider.textColor = [UIColor AxcUI_OrangeColor];
        _labelFontSlider.textAlignment = NSTextAlignmentLeft;
        _labelFontSlider.text = @"全局字号：13";
    }
    return _labelFontSlider;
}
- (UISlider *)fontSlider{
    if (!_fontSlider) {
        _fontSlider = [[UISlider alloc] initWithFrame:CGRectMake(110,SCREEN_HEIGHT - 160, self.view.axcUI_Width - 130, 30)];
        [_fontSlider addTarget:self action:@selector(click_refreshFont) forControlEvents:UIControlEventValueChanged];
        _fontSlider.minimumValue = 10;
        _fontSlider.maximumValue = 20;
        _fontSlider.value = 13;
    }
    return _fontSlider;
}

- (UILabel *)labelTextTimeSlider{
    if (!_labelTextTimeSlider) {
        _labelTextTimeSlider = [[UILabel alloc] initWithFrame:CGRectMake(5,SCREEN_HEIGHT - 130, 120, 30)];
        _labelTextTimeSlider.font = [UIFont systemFontOfSize:14];
        _labelTextTimeSlider.textColor = [UIColor AxcUI_OrangeColor];
        _labelTextTimeSlider.textAlignment = NSTextAlignmentLeft;
        _labelTextTimeSlider.text = @"全局速度：1.00";
    }
    return _labelTextTimeSlider;
}
- (UISlider *)timeSlider{
    if (!_timeSlider) {
        _timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(110,SCREEN_HEIGHT - 130, self.view.axcUI_Width - 130, 30)];
        [_timeSlider addTarget:self action:@selector(click_refreshTime) forControlEvents:UIControlEventValueChanged];
        _timeSlider.minimumValue = 0;
        _timeSlider.maximumValue = 5;
        _timeSlider.value = 1;
    }
    return _timeSlider;
}

- (void)clickBarrageDirectionBtn:(UIButton *)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择弹幕方位"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    if (_barrageStyle == 0) {
        UIAlertAction *BarrageAction = [UIAlertAction actionWithTitle:@"从右到左"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  _barrageDirection = 0;
                                                              }];
        UIAlertAction *BarrageAction1 = [UIAlertAction actionWithTitle:@"从左到右"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   _barrageDirection = 1;
                                                               }];
        UIAlertAction *BarrageAction2 = [UIAlertAction actionWithTitle:@"从上到下"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   _barrageDirection = 2;
                                                               }];
        UIAlertAction *BarrageAction3 = [UIAlertAction actionWithTitle:@"从下到上"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   _barrageDirection = 3;
                                                               }];
        [alertController addAction:BarrageAction];
        [alertController addAction:BarrageAction1];
        [alertController addAction:BarrageAction2];
        [alertController addAction:BarrageAction3];
        
    }else{
        UIAlertAction *BarrageAction = [UIAlertAction actionWithTitle:@"底部悬浮"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  _barrageDirection = 0;
                                                              }];
        UIAlertAction *BarrageAction1 = [UIAlertAction actionWithTitle:@"顶部悬浮"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   _barrageDirection = 1;
                                                               }];
        [alertController addAction:BarrageAction];
        [alertController addAction:BarrageAction1];
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)clickBarrageStyleBtn:(UIButton *)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择弹幕类型"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ScrollBarrageAction = [UIAlertAction actionWithTitle:@"滚动弹幕"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [sender setTitle:@"弹幕类型：滚动弹幕"
                                                                            forState:UIControlStateNormal];
                                                                    _barrageStyle = 0;
                                                                }];
    UIAlertAction *FloatBarrageAction = [UIAlertAction actionWithTitle:@"浮动弹幕"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   [sender setTitle:@"弹幕类型：浮动弹幕"
                                                                           forState:UIControlStateNormal];
                                                                   _barrageStyle = 1;
                                                               }];
    [alertController addAction:ScrollBarrageAction];
    [alertController addAction:FloatBarrageAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
