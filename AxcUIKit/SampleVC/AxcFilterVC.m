//
//  AxcFilterVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/29.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcFilterVC.h"


@interface AxcFilterVC ()<
UIImagePickerControllerDelegate
,UINavigationControllerDelegate

>


@property(nonatomic,strong)UIImageView *MainImageView;

//系统照片选择控制器
@property(nonatomic, strong)UIImagePickerController *imagePickerController;
// 处理滑竿
@property (strong, nonatomic)  UISlider *Staturation;
@property (strong, nonatomic)  UISlider *Brightness;
@property (strong, nonatomic)  UISlider *Contrast;
// 说明Label
@property(nonatomic, strong)AxcFilterInstructionsLabel *StaturationLabel;
@property(nonatomic, strong)AxcFilterInstructionsLabel *BrightnessLabel;
@property(nonatomic, strong)AxcFilterInstructionsLabel *ContrastLabel;

@property(nonatomic, strong)UISwitch *dynamicRendering;
@property(nonatomic, strong)AxcFilterInstructionsLabel *dynamicRenderingLabel;

@property(nonatomic, strong)UIButton *ModifyOneBtn;

@end

@implementation AxcFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imagePickerController=[[UIImagePickerController alloc]init];
    _imagePickerController.delegate =self;
    
    [self.view addSubview:self.MainImageView];
    
    self.instructionsLabel.text = @"需要添加相册权限字段：NSPhotoLibraryUsageDescription才能调用相册。\n开启取消动态渲染后，需每次调整完数值后点击按钮使用函数触发渲染\n动态渲染效率较低，所以开放此接口供手动调节调用";
    
    [self autolayout];
}

// 重写SET传值，无先后顺序，设置即可动态调整  ************************************************
- (void)click_ModifyOneBtn{     // 渲染函数
    [self.MainImageView AxcUI_SetFilterImage];
}
- (void)controllActionSwitch{       // 是否开启“取消动态渲染”
    self.MainImageView.axcUI_filterDynamicRendering = self.dynamicRendering.on;
}
- (void)controllAction:(UISlider *)sender{      // 基础渲染三项参数设置
    switch (sender.tag - 100) {
        case 0:
            self.MainImageView.axcUI_filterStaturation = sender.value;
            self.StaturationLabel.text = [NSString stringWithFormat:@"饱和度：%.2f",sender.value];
            break;
        case 1:
            self.MainImageView.axcUI_filterBrightness = sender.value;
            self.BrightnessLabel.text = [NSString stringWithFormat:@"亮度：%.2f",sender.value];
            break;
        case 2:
            self.MainImageView.axcUI_filterContrast = sender.value;
            self.ContrastLabel.text = [NSString stringWithFormat:@"对比度：%.2f",sender.value];
            break;
        default:
            break;
    }
}

- (void)autolayout{
    __weak typeof(self) WeakSelf = self;

    [self.StaturationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.MainImageView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.Staturation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.StaturationLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.BrightnessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.Staturation.mas_bottom).offset(0);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.Brightness mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.BrightnessLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.ContrastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.Brightness.mas_bottom).offset(0);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.Contrast mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.ContrastLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.dynamicRenderingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.Contrast.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(100);
    }];
    
    [self.dynamicRendering mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.dynamicRenderingLabel.mas_top).offset(0);
        make.left.mas_equalTo(WeakSelf.dynamicRenderingLabel.mas_right).offset(5);
    }];
    
    [self.ModifyOneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.dynamicRenderingLabel.mas_top).offset(0);
        make.left.mas_equalTo(WeakSelf.dynamicRendering.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(WeakSelf.dynamicRenderingLabel.mas_bottom).offset(0);
    }];
}


- (void)SelectImage{
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark - 图片选择器选择图片代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //关闭图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    //取得选择图片
    UIImage *selectedImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.MainImageView.image = selectedImage;
    //把Slider的值重置成默认值
    self.Staturation.value = 1;
    self.Brightness.value = 0;
    self.Contrast.value = 1;
    // 此处为：如果图片发生切换，则手动置空释放空色彩滤镜 ****************************************
    if (self.MainImageView.axcUI_filterColorControlsFilter) {
        self.MainImageView.axcUI_filterColorControlsFilter = nil;
    }
}

#pragma mark - 懒加载
- (UIButton *)ModifyOneBtn{
    if (!_ModifyOneBtn) {
        _ModifyOneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
        [_ModifyOneBtn setTitle:@"点击渲染图片" forState:UIControlStateNormal];
        [_ModifyOneBtn setTitleColor:[UIColor AxcUI_BelizeHoleColor] forState:UIControlStateNormal];
        _ModifyOneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _ModifyOneBtn.backgroundColor = [UIColor AxcUI_CloudColor];
        _ModifyOneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_ModifyOneBtn addTarget:self action:@selector(click_ModifyOneBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_ModifyOneBtn];
    }
    return _ModifyOneBtn;
}

- (AxcFilterInstructionsLabel *)dynamicRenderingLabel{
    if (!_dynamicRenderingLabel) {
        _dynamicRenderingLabel = [[AxcFilterInstructionsLabel alloc] init];
        _dynamicRenderingLabel.text = @"关闭动态渲染";
        [self.view addSubview:_dynamicRenderingLabel];
    }
    return _dynamicRenderingLabel;
}

- (UISwitch *)dynamicRendering{
    if (!_dynamicRendering) {
        _dynamicRendering = [[UISwitch alloc] init];
        [_dynamicRendering addTarget:self action:@selector(controllActionSwitch) forControlEvents:UIControlEventValueChanged];
        _dynamicRendering.tag = 100 + 3;
        _dynamicRendering.on = NO;
        [self.view addSubview:_dynamicRendering];
    }
    return _dynamicRendering;
}

- (AxcFilterInstructionsLabel *)ContrastLabel{
    if (!_ContrastLabel) {
        _ContrastLabel = [[AxcFilterInstructionsLabel alloc] init];
        _ContrastLabel.text = @"对比度：1.00";
        [self.view addSubview:_ContrastLabel];
    }
    return _ContrastLabel;
}

- (UISlider *)Contrast{
    if (!_Contrast) {
        _Contrast = [[UISlider alloc] init];
        [_Contrast addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _Contrast.minimumValue = 0;
        _Contrast.maximumValue = 2;
        _Contrast.value = 1;
        _Contrast.tag = 100 + 2 ;
        [self.view addSubview:_Contrast];
    }
    return _Contrast;
}

- (AxcFilterInstructionsLabel *)BrightnessLabel{
    if (!_BrightnessLabel) {
        _BrightnessLabel = [[AxcFilterInstructionsLabel alloc] init];
        _BrightnessLabel.text = @"亮度：0.00";
        [self.view addSubview:_BrightnessLabel];
    }
    return _BrightnessLabel;
}

- (UISlider *)Brightness{
    if (!_Brightness) {
        _Brightness = [[UISlider alloc] init];
        [_Brightness addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _Brightness.minimumValue = -1;
        _Brightness.maximumValue = 1;
        _Brightness.value = 0;
        _Brightness.tag = 100 +1 ;
        [self.view addSubview:_Brightness];
    }
    return _Brightness;
}

- (AxcFilterInstructionsLabel *)StaturationLabel{
    if (!_StaturationLabel) {
        _StaturationLabel = [[AxcFilterInstructionsLabel alloc] init];
        _StaturationLabel.text = @"饱和度：1.00";
        [self.view addSubview:_StaturationLabel];
    }
    return _StaturationLabel;
}

- (UISlider *)Staturation{
    if (!_Staturation) {
        _Staturation = [[UISlider alloc] init];
        [_Staturation addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _Staturation.minimumValue = 0;
        _Staturation.maximumValue = 2;
        _Staturation.value = 1;
        _Staturation.tag = 100 ;
        [self.view addSubview:_Staturation];
    }
    return _Staturation;
}

- (UIImageView *)MainImageView{
    if (!_MainImageView) {
        _MainImageView = [[UIImageView alloc] init];
        _MainImageView.axcUI_Size = CGSizeMake(250, 250);
        _MainImageView.axcUI_CenterX = self.view.axcUI_CenterX;
        _MainImageView.axcUI_Y = 100;
        _MainImageView.backgroundColor = [UIColor AxcUI_CloudColor];
        _MainImageView.contentMode = UIViewContentModeScaleAspectFit;
        _MainImageView.image = [UIImage imageNamed:@"add_Image"];
        _MainImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(SelectImage)];
        [_MainImageView addGestureRecognizer:tap];
    }
    return _MainImageView;
}

@end


@implementation AxcFilterInstructionsLabel

- (instancetype)init{
    if (self == [super init]) {
        self.font = [UIFont systemFontOfSize:14];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor AxcUI_AmethystColor];
        self.axcUI_Width = 100;
        self.axcUI_Height = 40;
    }
    return self;
}


@end
