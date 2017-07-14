//
//  AxcBadgeInteractionViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/12.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBadgeInteractionViewVC.h"


@interface AxcBadgeInteractionViewVC ()


@property(nonatomic,strong)AxcUI_BadgeInteractionView *badgeView;

@property(nonatomic, strong)NSArray *createInstructionsLabelTextArr;
@property(nonatomic, strong)UILabel *numLabel;

@end

@implementation AxcBadgeInteractionViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.badgeView];
    
    [self createSegmented];
    
    // 原作者GitHub：https://github.com/smallmuou
    self.instructionsLabel.text = @"类似QQ消息数量标签的可拖拽气泡\n根据原作者smallmuou改制，在此感谢原作者提供的使用许可\n因为涉及到父视图原因需要强引用，但不妨碍父视图执行delloc函数";
}


// 使用初始化、重写SET方法和setNeedsDisplay，设置即可调用，无先后顺序，设置即可动态调整  ************************************************
- (void)clickInsSwitch:(UISwitch *)sender{
    NSInteger tag = sender.tag - 100;
    switch (tag) {
        case 1: self.badgeView.axcUI_fontSizeAutoFit = sender.on; break; // 根据文本自适应
        case 2: self.badgeView.axcUI_hiddenWhenZero = sender.on;  break; // 文本为0时自动隐藏
        default: break;
    }
}

- (void)clickBtn:(UIButton *)sender{
    NSInteger tag = sender.tag - 100;
    switch (tag) {
        case 3:
            self.badgeView.axcUI_textColor = [UIColor AxcUI_ArcColor];  // 文本颜色
            sender.backgroundColor = self.badgeView.axcUI_textColor;
            break;
        case 4:
            self.badgeView.axcUI_tintColor = [UIColor AxcUI_ArcColor];  // 气泡颜色
            sender.backgroundColor = self.badgeView.axcUI_tintColor;
            break;
        case 5:
            [self.badgeView removeFromSuperview];
            self.badgeView = nil;                                       // 清空再次调用懒加载
            [self.view addSubview:self.badgeView];
            break;
        default: break;
    }
}
- (void)clickStepper:(UIStepper *)sender{
    self.badgeView.axcUI_text = [NSString stringWithFormat:@"%.0f",sender.value];   // 显示的文本
    self.numLabel.text =  [NSString stringWithFormat:
                           @"%@：\t%.0f",self.createInstructionsLabelTextArr[sender.tag - 100],sender.value];
}



#pragma mark - 懒加载区
- (AxcUI_BadgeInteractionView *)badgeView{
    if (!_badgeView) {
        _badgeView = [[AxcUI_BadgeInteractionView alloc] init];
        _badgeView.axcUI_Size = CGSizeMake(40, 40);
        _badgeView.center = self.view.center;
        _badgeView.axcUI_Y = 150;
        _badgeView.axcUI_font = [UIFont systemFontOfSize:13];
        _badgeView.axcUI_text = @"5";
    }
    return _badgeView;
}

- (void)dealloc{
    [self.badgeView removeFromSuperview];
    self.badgeView = nil;
}




- (NSArray *)createInstructionsLabelTextArr{
    if (!_createInstructionsLabelTextArr) {
        _createInstructionsLabelTextArr = @[@"显示数字",@"是否根据文本自适应",@"文本为0时自动隐藏",
                                            @"气泡文本色",@"气泡背景色",@"重置气泡"];
    }
    return _createInstructionsLabelTextArr;
}
- (void)createSegmented{
    NSArray *colorArr = @[@"",@"",@"",[UIColor AxcUI_ArcColor],[UIColor redColor],[UIColor AxcUI_ArcColor]];
    for (int i = 0; i < 6; i ++) {
        CGFloat Y = i * 40 + self.badgeView.axcUI_Y + self.badgeView.axcUI_Height + 100;
        CGFloat width = 150;
        if (i < 3) {
            UILabel *label = [[UILabel alloc] init];
            label.axcUI_Size = CGSizeMake(width, 30);
            label.axcUI_X = 10;
            label.axcUI_Y = Y;
            label.text = self.createInstructionsLabelTextArr[i];
            label.textColor = [UIColor AxcUI_WisteriaColor];
            label.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:label];
            
            if(i == 0){
                UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectMake(width + 10 , Y, width, 30)];
                stepper.tag = i + 100;
                stepper.value = 5;
                [stepper addTarget:self action:@selector(clickStepper:)
                  forControlEvents:UIControlEventValueChanged];
                self.numLabel = label;
                self.numLabel.text =  [NSString stringWithFormat:
                                       @"%@：\t5",self.createInstructionsLabelTextArr[i]];
                [self.view addSubview:stepper];
            }else if (i > 0 && i < 3) {
                UISwitch *InsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width + 10, Y, 50, 30)];
                InsSwitch.on = NO;
                [InsSwitch addTarget:self action:@selector(clickInsSwitch:)
                    forControlEvents:UIControlEventValueChanged];
                InsSwitch.tag = i + 100;
                if (i == 2) {
                    InsSwitch.on = YES;
                }
                [self.view addSubview:InsSwitch];
            }
        }else{
            CGFloat BtnWidth = SCREEN_WIDTH / 2 - 20;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width + 10 , Y, BtnWidth, 30)];
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:self.createInstructionsLabelTextArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.backgroundColor = colorArr[i];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.tag = i + 100;
            [self.view addSubview:button];
        }
    }
}

@end
