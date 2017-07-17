//
//  AxcModifyPlaceholderVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcModifyPlaceholderVC.h"


@interface AxcModifyPlaceholderVC ()


@property(nonatomic,strong)UITextField *textField;

@property(nonatomic, strong)UIButton *ModifyOneBtn;

@property(nonatomic, strong)UIButton *ModifyTwoBtn;

@end

@implementation AxcModifyPlaceholderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.ModifyOneBtn];
    [self.view addSubview:self.ModifyTwoBtn];
    
    self.instructionsLabel.text = @"将PlaceholderLabel通过KVC取出，然后使用Runtime赋予新的属性，以后可以动态灵活方便的设置Placeholder了";
}


#pragma mark- 业务逻辑
// KVC获取内部对象调取至外部接口设置，无先后顺序，设置即可动态调整  ************************************************
- (void)click_ModifyOneBtn{
    self.textField.axcUI_PlaceholderLabel.text = _ModifyOneBtn.titleLabel.text;
}

- (void)click_ModifyTwoBtn{
    self.textField.axcUI_PlaceholderLabel.text = @"我是修改后的占位符";
    self.textField.axcUI_PlaceholderLabel.textColor = [UIColor AxcUI_ArcColor];
}







#pragma mark - 懒加载

- (UIButton *)ModifyOneBtn{
    if (!_ModifyOneBtn) {
        _ModifyOneBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 180 + 64, 250, 30)];
        [_ModifyOneBtn setTitle:@"点击修改Placeholder文字" forState:UIControlStateNormal];
        [_ModifyOneBtn setTitleColor:[UIColor AxcUI_BelizeHoleColor] forState:UIControlStateNormal];
        _ModifyOneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _ModifyOneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_ModifyOneBtn addTarget:self action:@selector(click_ModifyOneBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ModifyOneBtn;
}

- (UIButton *)ModifyTwoBtn{
    if (!_ModifyTwoBtn) {
        _ModifyTwoBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 230 + 64, 250, 30)];
        [_ModifyTwoBtn setTitle:@"点击恢复Placeholder文字修改颜色" forState:UIControlStateNormal];
        [_ModifyTwoBtn setTitleColor:[UIColor AxcUI_BelizeHoleColor] forState:UIControlStateNormal];
        _ModifyTwoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _ModifyTwoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_ModifyTwoBtn addTarget:self action:@selector(click_ModifyTwoBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ModifyTwoBtn;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 123 + 64, 250, 30)];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.layer.cornerRadius = 3;
        _textField.layer.masksToBounds = true;
        _textField.layer.borderWidth = 1;
        _textField.layer.borderColor = [[UIColor AxcUI_PumpkinColor] CGColor];
        
        _textField.placeholder = @"我是占位符"; // 系统设置占位符

        // KVC参数修改，无先后顺序，设置即可动态调整 ************************************************
        _textField.axcUI_PlaceholderLabel.text = @"我是修改后的占位符"; // 扩展修改
        _textField.axcUI_PlaceholderLabel.textColor = [UIColor AxcUI_MidNightColor];   // 修改占位符颜色
        _textField.axcUI_PlaceholderLabel.font = [UIFont systemFontOfSize:14];
        _textField.axcUI_PlaceholderLabel.textAlignment = NSTextAlignmentCenter;    // 修改占位符对齐方式
    }
    return _textField;
}


@end
