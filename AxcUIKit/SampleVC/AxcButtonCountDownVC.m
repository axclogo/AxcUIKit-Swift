//
//  AxcButtonCountDownVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/13.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcButtonCountDownVC.h"


@interface AxcButtonCountDownVC ()


@property(nonatomic, strong)UIButton *button;

@end

@implementation AxcButtonCountDownVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self.view addSubview:self.button];
    
    // 原作者GitHub：https://github.com/boai
    self.instructionsLabel.text = @"一个快速设置Button进行倒计时的类扩展\n根据作者boai项目BAButton改制\n在此感谢作者提供的使用许可";
}

- (void)getVerificationCode{
    self.button.userInteractionEnabled = NO; // 关闭触发
    
    [self settingRunBtn:self.button];       // 设置倒计时中的颜色
    
    // 函数触发模式，无先后顺序，设置即可触发  ************************************************
    // 开始发起倒计时
    [self.button AxcUI_countDownWithTimeInterval:10 countDownFormat:@"%zd秒后重试"];
    __weak typeof(self) weakSelf = self;
    // 倒计时结束后的Block回调
    self.button.axcUI_buttonTimeStoppedCallback = ^{
        weakSelf.button.userInteractionEnabled = YES;       // 设置启用触发
        
        [weakSelf settingBtn:weakSelf.button];              // 设置初始的颜色等
        NSLog(@"倒计时完毕");
    };
}

- (void)settingRunBtn:(UIButton *)sender{
    sender.backgroundColor = [UIColor AxcUI_CloudColor];
    [sender setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    sender.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)settingBtn:(UIButton *)sender{
    UIColor *iosSystemBlue = [UIColor AxcUI_colorWithHexColor:@"1296db"];
    sender.backgroundColor = [UIColor clearColor];
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = [iosSystemBlue CGColor];
    sender.layer.masksToBounds = YES;
    sender.layer.cornerRadius = 5;
    sender.titleLabel.font = [UIFont systemFontOfSize:13];
    [sender setTitleColor:iosSystemBlue forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
}

#pragma mark - 懒加载区
- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.axcUI_Size = CGSizeMake(200, 50);
        _button.center = self.view.center;
        _button.axcUI_Y = 150;
        [_button addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
        [self settingBtn:_button];
    }
    return _button;
}


@end
