//
//  AxcNumberUnitFieldVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcNumberUnitFieldVC.h"


@interface AxcNumberUnitFieldVC ()


@property(nonatomic,strong) AxcUI_NumberUnitField * numberUnitField;

@property(nonatomic, strong)NSArray *createInstructionsLabelTextArr;
@property(nonatomic, strong)NSMutableArray <UILabel *>*labelArray;
@end

@implementation AxcNumberUnitFieldVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.numberUnitField];
    
    // 被吐槽说是UI代码大于示例代码。。。以后创建示例控制代码就用循环来做了 =。=
    [self createInstructionsLabel];
    
    // 原作者GitHub：https://github.com/zhwayne
    self.instructionsLabel.text = @"根据作者Wayne的项目WLUnitField改制\n一个很兼容XIB使用的控件输入器，非常好用，稍作修改后加入到框架中";
}

// 使用初始化、重写SET方法和setNeedsDisplay，设置即可调用，无先后顺序，设置即可动态调整  ************************************************
- (void)clickInsSwitch:(UISwitch *)sender{
    switch (sender.tag - 100) {
        case 0:self.numberUnitField.axcUI_secureTextEntry = sender.on; break; // 是否密文
        case 1:self.numberUnitField.axcUI_autoResignFirstResponderWhenInputFinished = sender.on; break; // 自动输入完取消响应
        default:            break;
    }
}
- (void)slidingSlider:(UISlider *)sender{
    NSInteger i = sender.tag - 100;
    switch (i) {
        case 2:
            self.numberUnitField.axcUI_unitSpace = sender.value;
            [self.labelArray objectAtIndex:i].text = [NSString stringWithFormat:
                                                      @"%@：\t\t%.2f",self.createInstructionsLabelTextArr[i],
                                                      sender.value];
            break; // 间距
        case 3:
            self.numberUnitField.axcUI_borderRadius = sender.value;
            [self.labelArray objectAtIndex:i].text = [NSString stringWithFormat:
                                                      @"%@：\t\t%.2f",self.createInstructionsLabelTextArr[i],
                                                      sender.value];break; // 圆角
        case 4:
            self.numberUnitField.axcUI_borderWidth = sender.value;
            [self.labelArray objectAtIndex:i].text = [NSString stringWithFormat:
                                                      @"%@：\t\t%.2f",self.createInstructionsLabelTextArr[i],
                                                      sender.value];break; // 边框宽度
            
        default:
            break;
    }
}
- (void)clickBtn:(UIButton *)sender{
    switch (sender.tag - 100) {
        case 5:
            self.numberUnitField.axcUI_textColor = [UIColor AxcUI_ArcColor];
            sender.backgroundColor = self.numberUnitField.axcUI_textColor;
            break; // 文字颜色
        case 6:
            self.numberUnitField.axcUI_tintColor = [UIColor AxcUI_ArcColor];
            sender.backgroundColor = self.numberUnitField.axcUI_tintColor;
            break; // 未输入时边框色
        case 7:
            self.numberUnitField.axcUI_trackTintColor = [UIColor AxcUI_ArcColor];
            sender.backgroundColor = self.numberUnitField.axcUI_trackTintColor;
            break; // 已输入时边框色
        case 8:
            self.numberUnitField.axcUI_cursorColor = [UIColor AxcUI_ArcColor];
            sender.backgroundColor = self.numberUnitField.axcUI_cursorColor;
            break; // 光标颜色
            
        default:
            break;
    }
}







- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.numberUnitField resignFirstResponder];
}

#pragma mark - 懒加载区
- (AxcUI_NumberUnitField *)numberUnitField{
    if (!_numberUnitField) {
        _numberUnitField = [[AxcUI_NumberUnitField alloc] init];
        _numberUnitField.axcUI_Size = CGSizeMake(SCREEN_WIDTH - 150, 50);
        _numberUnitField.center = self.view.center;
        _numberUnitField.axcUI_Y = 140;
        _numberUnitField.backgroundColor = [UIColor AxcUI_CloudColor];
    }
    return _numberUnitField;
}

- (NSArray *)createInstructionsLabelTextArr{
    if (!_createInstructionsLabelTextArr) {
        _createInstructionsLabelTextArr = @[@"是否密文",@"自动输入完取消响应",
                                            @"间距",@"圆角",@"边框宽度",
                                            @"文字颜色",@"未输入时边框色",@"已输入时边框色",@"光标颜色"];
    }
    return _createInstructionsLabelTextArr;
}
- (NSMutableArray *)labelArray{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}
- (void)createInstructionsLabel{
    NSArray *defaultParameters = @[@"",@"",@"6.0",@"6.0",@"1.0",@"",@"",@"",@""];
    for (int i = 0; i < self.createInstructionsLabelTextArr.count; i ++) {
        CGFloat Y = i * 40 + self.numberUnitField.axcUI_Y + self.numberUnitField.axcUI_Height + 20;
        UILabel *label = [[UILabel alloc] init];
        label.axcUI_Size = CGSizeMake(150, 30);
        label.axcUI_X = 10;
        label.axcUI_Y = Y;
        label.text = self.createInstructionsLabelTextArr[i];
        label.textColor = [UIColor AxcUI_WisteriaColor];
        label.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:label];
        [self.labelArray addObject:label];
        if (i <= 1) {
            UISwitch *InsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(180, Y, 50, 30)];
            InsSwitch.on = NO;
            [InsSwitch addTarget:self action:@selector(clickInsSwitch:)
                               forControlEvents:UIControlEventValueChanged];
            InsSwitch.tag = i + 100;
            [self.view addSubview:InsSwitch];
        }else if (i >1 && i <= 4){
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(180,Y, SCREEN_WIDTH - 190, 30)];
            [slider addTarget:self action:@selector(slidingSlider:)
             forControlEvents:UIControlEventValueChanged];
            if (i != 4) {
                slider.minimumValue = 0;
            }else{
                slider.minimumValue = 1;
            }
            slider.maximumValue = 30;
            slider.value = [defaultParameters[i] floatValue];
            slider.tag = i + 100;
            [self.view addSubview:slider];
            label.text =  [NSString stringWithFormat:
                           @"%@：\t\t%@",self.createInstructionsLabelTextArr[i],defaultParameters[i]];
        }else{
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(180, Y, 150, 30)];
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:self.createInstructionsLabelTextArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.backgroundColor = [UIColor AxcUI_ArcColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.tag = i + 100;
            [self.view addSubview:button];
        }
    }
}

@end
