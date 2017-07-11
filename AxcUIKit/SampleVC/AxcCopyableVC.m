//
//  AxcCopyableVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/10.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcCopyableVC.h"


@interface AxcCopyableVC ()


@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic, strong)UILabel *label;
@property(nonatomic, strong)AxcUI_Label *axcUI_label;

@end

@implementation AxcCopyableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.axcUI_label];
    
    
    // 重写SET传值，无先后顺序，设置即可动态调整  ************************************************
    // 添加长摁将内容复制到剪贴板
    self.label.axcUI_copyingEnabled = YES;
    self.axcUI_label.axcUI_copyingEnabled = YES;
    
    
    self.instructionsLabel.text = @"只需要设置一个开关参数即可控制Label是否带有复制到剪贴板的功能";
}

#pragma mark 复用函数
- (void)settingLabel:(UILabel *)label{
    label.textColor = [UIColor AxcUI_AmethystColor];
    label.backgroundColor = [UIColor AxcUI_CloudColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderWidth = 1;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 5;
    label.font = [UIFont systemFontOfSize:13];
}

#pragma mark - 懒加载区
- (UILabel *)label{
    if (!_label) {
        UIColor *iosSystemBlue = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, SCREEN_WIDTH - 20, 40)];
        _label.text = @"长按Label可以带有复制到剪贴板的功能";
        _label.layer.borderColor = [iosSystemBlue CGColor];
        [self settingLabel:_label];
    }
    return _label;
}
- (AxcUI_Label *)axcUI_label{
    if (!_axcUI_label) {
        _axcUI_label = [[AxcUI_Label alloc] initWithFrame:CGRectMake(10, 230, SCREEN_WIDTH - 20, 40)];
        _axcUI_label.text = @"只要是继承自UILabel的对象都能调用该参数";
        _axcUI_label.layer.borderColor = [[UIColor AxcUI_AsbestosColor] CGColor];
        [self settingLabel:_axcUI_label];
    }
    return _axcUI_label;
}



@end
