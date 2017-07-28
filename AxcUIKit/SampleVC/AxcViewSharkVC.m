//
//  AxcViewSharkVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcViewSharkVC.h"



@interface AxcViewSharkVC ()



@property (strong, nonatomic)  UILabel *label;
@property (strong, nonatomic)  UIButton *button;
@property (strong, nonatomic)  UITextField *textField;
@property (strong, nonatomic)  UIStepper *stepper;
@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic)  UIView *testView;
@property (strong, nonatomic)  UIButton *shakingButton;

@property(nonatomic, assign) CGFloat Nav_Height;

@end

@implementation AxcViewSharkVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.Nav_Height = 100;
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.button];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.stepper];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.testView];
    [self.view addSubview:self.shakingButton];
    
    self.instructionsLabel.text = @"只要是继承于UIView的控件，均可以调用该方法";
    
}

- (void)clickShakingButton{
    for (UIView *subView in self.view.subviews) {
        // 一行代码触发晃动  ************************************************
        [subView AxcUI_viewShaking];
    }
}



#pragma mark - 懒加载
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(105, 20 + _Nav_Height, 165, 21)];
        _label.text = @"可以晃动的Label";
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] initWithFrame:CGRectMake(103, 49 + _Nav_Height, 168, 30)];
        [_button setTitle:@"可以晃动的Button" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor AxcUI_BelizeHoleColor] forState:UIControlStateNormal];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _button;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(112, 123 + _Nav_Height, 151, 30)];
        _textField.text = @"可以晃动的TextField";
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.layer.cornerRadius = 3;
        _textField.layer.masksToBounds = true;
        _textField.layer.borderWidth = 1;
        _textField.layer.borderColor = [[UIColor AxcUI_PumpkinColor] CGColor];
    }
    return _textField;
}
- (UIStepper *)stepper{
    if (!_stepper) {
        _stepper = [[UIStepper alloc] initWithFrame:CGRectMake(140, 161 + _Nav_Height, 94, 29)];
    }
    return _stepper;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 198 + _Nav_Height, 114, 94)];
        _imageView.image = [UIImage AxcUI_setImageNamed:@"test_0"];
    }
    return _imageView;
}
- (UIView *)testView{
    if (!_testView) {
        _testView = [[UIView alloc] initWithFrame:CGRectMake(149, 306 + _Nav_Height, 77, 71)];
        _testView.backgroundColor = [UIColor AxcUI_ArcColor];
    }
    return _testView;
}
- (UIButton *)shakingButton{
    if (!_shakingButton) {
        _shakingButton = [[UIButton alloc] initWithFrame:CGRectMake(114, 400 + _Nav_Height, 162, 30)];
        [_shakingButton addTarget:self action:@selector(clickShakingButton) forControlEvents:UIControlEventTouchUpInside];
        [_shakingButton setTitle:@"点击晃动" forState:UIControlStateNormal];
        [_shakingButton setTitleColor:[UIColor AxcUI_WetAsphaltColor] forState:UIControlStateNormal];
        _shakingButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _shakingButton;
}


@end
