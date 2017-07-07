//
//  AxcButtonLayoutVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/7.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcButtonLayoutVC.h"


@interface AxcButtonLayoutVC ()


@property(nonatomic,strong)UIButton *button;
@property(nonatomic,strong)NSArray *segmentedTitleArray;
@property(nonatomic,strong)NSArray *createInstructionsLabelTextArr;
@property(nonatomic, strong)NSMutableArray <UILabel *>*labelArray;

@end

@implementation AxcButtonLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.button];
    
    [self createSegmented];
    
    // 原作者GitHub：https://github.com/boai
    self.instructionsLabel.text = @"根据作者boai项目BAButton改制\n感谢原作者通过类方法给我灵感，在不使用继承的方式快速融入到原有项目中\n摘取部分代码独立分割";
}

// 重写SET传值，需要在图文元素确定后才能设置布局，之后参数即可动态调整  ************************************************
- (void)clicksegmented:(UISegmentedControl *)sender{
    NSInteger tag = sender.tag - 100;
    NSArray *arr = self.segmentedTitleArray[tag];
    switch (tag) {
        case 0:
            self.button.axcUI_buttonContentLayoutType = sender.selectedSegmentIndex;
            [self.button setTitle:arr[sender.selectedSegmentIndex] forState:UIControlStateNormal];
            break;
        case 1:
            self.button.axcUI_buttonContentLayoutType = sender.selectedSegmentIndex + 4;
            [self.button setTitle:arr[sender.selectedSegmentIndex] forState:UIControlStateNormal];
            break;
        default: break;
    }
}
- (void)slidingSlider:(UISlider *)sender{
    NSInteger tag = sender.tag - 100;
    switch (tag) {
        case 2:
            self.button.axcUI_padding = sender.value;
            [self.labelArray objectAtIndex:0].text = [NSString stringWithFormat:
                                                      @"%@：\t%.0f",self.createInstructionsLabelTextArr[tag],
                                                      sender.value];
            break;
        case 3:
            self.button.axcUI_paddingInset = sender.value;
            [self.labelArray objectAtIndex:1].text = [NSString stringWithFormat:
                                                      @"%@：\t%.0f",self.createInstructionsLabelTextArr[tag],
                                                      sender.value];
            break;
        default: break;
    }
}



#pragma mark - 懒加载区
- (UIButton *)button{
    if (!_button) {
        UIColor *iosSystemBlue = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
        _button = [[UIButton alloc] init];
        _button.axcUI_Size = CGSizeMake(SCREEN_WIDTH - 150, 50);
        _button.center = self.view.center;
        _button.axcUI_Y = 140;
        _button.backgroundColor = [UIColor clearColor];
        _button.layer.borderWidth = 1;
        _button.layer.borderColor = [iosSystemBlue CGColor];
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 5;
        _button.titleLabel.font = [UIFont systemFontOfSize:13];
        [_button setTitleColor:iosSystemBlue forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_button setImage:[UIImage imageNamed:@"delected_img"] forState:UIControlStateNormal];
        // 设置初始参数
        _button.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleNormal;
        [_button setTitle:@"居中-图左文右" forState:UIControlStateNormal];
    }
    return _button;
}

- (void)createSegmented{
    NSArray *defaultParameters = @[@"",@"",@"0",@"5"];

    for (int i = 0; i < 4; i ++) {
        CGFloat width = 150;
        CGFloat Y = i * 40 + self.button.axcUI_Y + self.button.axcUI_Height + 50;
        if (i < self.segmentedTitleArray.count) {
            UISegmentedControl *segmented = [[UISegmentedControl alloc]
                                             initWithItems:self.segmentedTitleArray[i]];
            segmented.frame = CGRectMake(10, Y, SCREEN_WIDTH - 20, 30);
            segmented.tag = 100 + i;
            segmented.momentary = YES;
            [segmented addTarget:self action:@selector(clicksegmented:)
                forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:segmented];
        }
        
        if (i >= 2) {
            UILabel *label = [[UILabel alloc] init];
            label.axcUI_Size = CGSizeMake(width, 30);
            label.axcUI_X = 10;
            label.axcUI_Y = Y;
            label.text = self.createInstructionsLabelTextArr[i];
            label.textColor = [UIColor AxcUI_WisteriaColor];
            label.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:label];
            [self.labelArray addObject:label];
            
            
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(width + 30,Y, SCREEN_WIDTH - (width + 40), 30)];
            [slider addTarget:self action:@selector(slidingSlider:)
             forControlEvents:UIControlEventValueChanged];
            slider.minimumValue = 0;
            slider.maximumValue = 30;
            slider.value = [defaultParameters[i] floatValue];
            slider.tag = i + 100;
            [self.view addSubview:slider];
            label.text =  [NSString stringWithFormat:
                           @"%@：\t%@",self.createInstructionsLabelTextArr[i],defaultParameters[i]];
        }
    }
}
- (NSArray *)createInstructionsLabelTextArr{
    if (!_createInstructionsLabelTextArr) {
        _createInstructionsLabelTextArr = @[@"",@"",
                                            @"图文间距",
                                            @"图文边界间距"];
    }
    return _createInstructionsLabelTextArr;
}
- (NSMutableArray *)labelArray{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}
- (NSArray *)segmentedTitleArray{
    if (!_segmentedTitleArray) {
        _segmentedTitleArray = @[@[@"居中-图左文右",@"居中-图右文左",@"居中-图上文下",@"居中-图下文上"],
                                 @[@"居左-图左文右",@"居左-图右文左",@"居右-图左文右",@"居右-图右文左"]];
    }
    return _segmentedTitleArray;
}


@end
