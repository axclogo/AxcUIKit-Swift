//
//  AxcRectCornerVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/12.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcRectCornerVC.h"


@interface AxcRectCornerVC ()


@property(nonatomic,strong)UIView *testView;

@property(nonatomic, strong)NSArray *createInstructionsLabelTextArr;
@property(nonatomic, strong)NSMutableArray *RectCornerArr;


@end

@implementation AxcRectCornerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _RectCornerArr = [NSMutableArray array];
    [self.view addSubview:self.testView];
    
    [self createSwitch];
    
    
    self.instructionsLabel.text = @"自动绘制圆角，自动根据半径判断不走形，可使用位运算符支持多个枚举选项";
}

- (void)clickInsSwitch:(UISwitch *)sender{
    switch (sender.tag - 100) {
        case 0:
            if (sender.on) {
                [_RectCornerArr addObject:@(UIRectCornerTopLeft)];
            }else{
                [_RectCornerArr removeObject:@(UIRectCornerTopLeft)];
            }break;
        case 1:
            if (sender.on) {
                [_RectCornerArr addObject:@(UIRectCornerBottomLeft)];
            }else{
                [_RectCornerArr removeObject:@(UIRectCornerBottomLeft)];
            }break;
        case 2:
            if (sender.on) {
                [_RectCornerArr addObject:@(UIRectCornerTopRight)];
            }else{
                [_RectCornerArr removeObject:@(UIRectCornerTopRight)];
            }break;
        case 3:
            if (sender.on) {
                [_RectCornerArr addObject:@(UIRectCornerBottomRight)];
            }else{
                [_RectCornerArr removeObject:@(UIRectCornerBottomRight)];
            }break;
        case 4:
            if (sender.on) {
                [_RectCornerArr addObject:@(UIRectCornerAllCorners)];
            }else{
                [_RectCornerArr removeObject:@(UIRectCornerAllCorners)];
            }break;
        default:
            break;
    }
    // 重写SET传值，无先后顺序，设置即可动态调整  ************************************************
    switch (_RectCornerArr.count) {
        case 0: self.testView.axcUI_rectCorner = 0; break;
        case 1:
            self.testView.axcUI_rectCorner = [_RectCornerArr[0] integerValue] ;break;
        case 2:
            self.testView.axcUI_rectCorner = [_RectCornerArr[0] integerValue] | [_RectCornerArr[1] integerValue];break;
        case 3:
            self.testView.axcUI_rectCorner = [_RectCornerArr[0] integerValue] | [_RectCornerArr[1] integerValue] |
                                             [_RectCornerArr[2] integerValue] ;break;
        case 4:
            self.testView.axcUI_rectCorner = [_RectCornerArr[0] integerValue] | [_RectCornerArr[1] integerValue] |
                                             [_RectCornerArr[2] integerValue] | [_RectCornerArr[3] integerValue];break;
        default: break;
    }
}
- (void)slidingSlider:(UISlider *)sender{
    self.testView.axcUI_cornerRadii = sender.value;
    ((UILabel *)[self.view viewWithTag:5324 + sender.tag - 100]).text = [NSString stringWithFormat:
                                                                         @"%@：\t%.2f",self.createInstructionsLabelTextArr[sender.tag - 100],
                                                                         sender.value];
}

- (void)createSwitch{
    NSArray *defaultParameters = @[@"",@"",@"",@"",@"",@"20",@""];

    for (int i = 0; i < 6; i ++) {
        CGFloat Y = i * 40 + self.testView.axcUI_Y + self.testView.axcUI_Height + 10;
        CGFloat width = 150;
        UILabel *label = [[UILabel alloc] init];
        label.axcUI_Size = CGSizeMake(width, 30);
        label.axcUI_X = 10;
        label.axcUI_Y = Y;
        label.text = self.createInstructionsLabelTextArr[i];
        label.textColor = [UIColor AxcUI_WisteriaColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:label];
        
        if (i < 5) {
            UISwitch *InsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width + 10, Y, 50, 30)];
            InsSwitch.on = NO;
            [InsSwitch addTarget:self action:@selector(clickInsSwitch:)
                forControlEvents:UIControlEventValueChanged];
            InsSwitch.tag = i + 100;
            [self.view addSubview:InsSwitch];
        }else{
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(width + 30,Y, SCREEN_WIDTH - (width + 40), 30)];
            [slider addTarget:self action:@selector(slidingSlider:)
             forControlEvents:UIControlEventValueChanged];
            slider.minimumValue = 0;
            slider.maximumValue = 200;
            slider.value = [defaultParameters[i] floatValue];
            slider.tag = i + 100;
            [self.view addSubview:slider];
            label.text =  [NSString stringWithFormat:
                           @"%@：\t%@",self.createInstructionsLabelTextArr[i],defaultParameters[i]];
            label.tag = 5324 + i;
        }
    }
}

- (UIView *)testView{
    if (!_testView) {
        _testView = [[UIView alloc] init];
        _testView.axcUI_Size = CGSizeMake(200, 200);
        _testView.center = self.view.center;
        _testView.axcUI_Y = 100;
        _testView.backgroundColor = [UIColor AxcUI_EmeraldColor];
        // 初始20，看起来大一点
        _testView.axcUI_cornerRadii = 20;
    }
    return _testView;
}
- (NSArray *)createInstructionsLabelTextArr{
    if (!_createInstructionsLabelTextArr) {
        _createInstructionsLabelTextArr = @[@"上左角",@"下左角",@"上右角",@"下右角",@"全角",
                                            @"圆角半径"];
    }
    return _createInstructionsLabelTextArr;
}

@end
