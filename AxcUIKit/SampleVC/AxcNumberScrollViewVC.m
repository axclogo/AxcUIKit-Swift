//
//  AxcNumberScrollViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcNumberScrollViewVC.h"


@interface AxcNumberScrollViewVC ()


@property(nonatomic,strong)AxcUI_NumberScrollView * numberScrollView;

@property(nonatomic, strong)NSArray *createInstructionsLabelTextArr;
@property(nonatomic, strong)NSMutableArray <UILabel *>*labelArray;
@end

@implementation AxcNumberScrollViewVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.numberScrollView];
    
    [self createInstructionsLabel];
}

- (void)clickInsSwitch:(UISwitch *)sender{
    _numberScrollView.axcUI_isAscending = sender.on;
}
- (void)slidingSlider:(UISlider *)sender{
    NSInteger i = sender.tag - 100;
    switch (i) {
        case 1:
            self.numberScrollView.axcUI_duration = sender.value;
            [self.labelArray objectAtIndex:i].text = [NSString stringWithFormat:
                                                      @"%@：\t%.2f",self.createInstructionsLabelTextArr[i],
                                                      sender.value]; // 动画总持续时间
            break;
        case 2:
            self.numberScrollView.axcUI_durationOffset = sender.value;
            [self.labelArray objectAtIndex:i].text = [NSString stringWithFormat:
                                                      @"%@：\t%.2f",self.createInstructionsLabelTextArr[i],
                                                      sender.value];break; // 相邻两个动画时间间隔
        case 3:
            self.numberScrollView.axcUI_minLength = sender.value;
            [self.labelArray objectAtIndex:i].text = [NSString stringWithFormat:
                                                      @"%@：\t%.2f",self.createInstructionsLabelTextArr[i],
                                                      sender.value];break; // 最小显示长度
            
        default:
            break;
    }

}

- (void)clickBtn:(UIButton *)sender{
    switch (sender.tag - 100) {
        case 4:
            self.numberScrollView.axcUI_number = @(arc4random() % 9999);
            [self.numberScrollView AxcUI_startAnimation];
            break; // 变换数字
        case 5:
            self.numberScrollView.axcUI_textColor = [UIColor AxcUI_ArcColor];
            sender.backgroundColor = self.numberScrollView.axcUI_textColor;
            break; // 文字颜色
        case 6:
            self.numberScrollView.backgroundColor = [UIColor AxcUI_ArcColor];
            sender.backgroundColor = self.numberScrollView.backgroundColor;
            break; // 背景颜色
        case 7:
            [self.numberScrollView AxcUI_startAnimation];
            break; // 开始动画
        default: break;
    }
}


#pragma mark - 懒加载区
- (AxcUI_NumberScrollView *)numberScrollView{
    if (!_numberScrollView) {
        _numberScrollView = [[AxcUI_NumberScrollView alloc] init];
        _numberScrollView.axcUI_Size = CGSizeMake(SCREEN_WIDTH - 150, 50);
        _numberScrollView.center = self.view.center;
        _numberScrollView.axcUI_Y = 140;
        _numberScrollView.axcUI_minLength = 4;
        _numberScrollView.backgroundColor = [UIColor blackColor];
        _numberScrollView.axcUI_textColor = [UIColor whiteColor];
    }
    return _numberScrollView;
}

- (NSArray *)createInstructionsLabelTextArr{
    if (!_createInstructionsLabelTextArr) {
        _createInstructionsLabelTextArr = @[@"滚动方向",
                                            @"持续时间",@"相邻动画间隔",@"显示长度",
                                            @"变换数字",@"数字颜色",@"背景颜色",@"开始动画"];
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
    NSArray *defaultParameters = @[@"",@"1.5",@"0.2",@"4",@"",@"",@""];
    for (int i = 0; i < self.createInstructionsLabelTextArr.count; i ++) {
        CGFloat Y = i * 40 + self.numberScrollView.axcUI_Y + self.numberScrollView.axcUI_Height + 20;
        CGFloat width = 150;
        UILabel *label = [[UILabel alloc] init];
        label.axcUI_Size = CGSizeMake(width, 30);
        label.axcUI_X = 10;
        label.axcUI_Y = Y;
        label.text = self.createInstructionsLabelTextArr[i];
        label.textColor = [UIColor AxcUI_WisteriaColor];
        label.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:label];
        [self.labelArray addObject:label];
        if (i == 0) {
            UISwitch *InsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width + 30, Y, 50, 30)];
            InsSwitch.on = NO;
            [InsSwitch addTarget:self action:@selector(clickInsSwitch:)
                forControlEvents:UIControlEventValueChanged];
            InsSwitch.tag = i + 100;
            [self.view addSubview:InsSwitch];
        }else if (i != 0 && i <= 3) {
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(width + 30,Y, SCREEN_WIDTH - (width + 40), 30)];
            [slider addTarget:self action:@selector(slidingSlider:)
             forControlEvents:UIControlEventValueChanged];
            slider.minimumValue = 0;
            if (i == 1) {
                slider.maximumValue = 5;
            }else if (i == 2){
                slider.maximumValue = 1;
            }else{
                slider.maximumValue = 8;
            }
            slider.value = [defaultParameters[i] floatValue];
            slider.tag = i + 100;
            [self.view addSubview:slider];
            label.text =  [NSString stringWithFormat:
                           @"%@：\t%@",self.createInstructionsLabelTextArr[i],defaultParameters[i]];
        }else{
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width + 30, Y, 150, 30)];
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
