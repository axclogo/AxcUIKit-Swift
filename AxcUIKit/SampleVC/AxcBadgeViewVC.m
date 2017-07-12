//
//  AxcBadgeViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/12.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBadgeViewVC.h"


@interface AxcBadgeViewVC ()


@property(nonatomic,strong)AxcUI_BadgeView *badgeView;

@property(nonatomic, strong)NSArray *createInstructionsLabelTextArr;
@property(nonatomic, strong)UILabel *numLabel;

@end

@implementation AxcBadgeViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.badgeView];
    
    [self createSegmented];
}

- (void)clickInsSwitch:(UISwitch *)sender{
    self.badgeView.axcUI_fontSizeAutoFit = sender.on;
}

- (void)clickBtn:(UIButton *)sender{
    
}
- (void)clickStepper:(UIStepper *)sender{
    self.badgeView.axcUI_text = [NSString stringWithFormat:@"%.0f",sender.value];
}

#pragma mark - SET区

#pragma mark - 懒加载区
- (AxcUI_BadgeView *)badgeView{
    if (!_badgeView) {
        _badgeView = [[AxcUI_BadgeView alloc] init];
        _badgeView.axcUI_Size = CGSizeMake(30, 30);
        _badgeView.center = self.view.center;
        _badgeView.axcUI_Y = 150;
    }
    return _badgeView;
}

- (NSArray *)createInstructionsLabelTextArr{
    if (!_createInstructionsLabelTextArr) {
        _createInstructionsLabelTextArr = @[@"显示数字",@"是否根据文本自适应",
                                            @"气泡底色",@"气泡背景色"];
    }
    return _createInstructionsLabelTextArr;
}
- (void)createSegmented{
    NSInteger buttonTag = 0;
    for (int i = 0; i < 4; i ++) {
        CGFloat Y = i * 40 + self.badgeView.axcUI_Y + self.badgeView.axcUI_Height + 100;
        CGFloat width = 150;
        if (i < 2) {
            UILabel *label = [[UILabel alloc] init];
            label.axcUI_Size = CGSizeMake(width, 30);
            label.axcUI_X = 10;
            label.axcUI_Y = Y;
            label.text = self.createInstructionsLabelTextArr[i];
            label.textColor = [UIColor AxcUI_WisteriaColor];
            label.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:label];
            
            if (i == 1) {
                UISwitch *InsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width + 10, Y, 50, 30)];
                InsSwitch.on = NO;
                [InsSwitch addTarget:self action:@selector(clickInsSwitch:)
                    forControlEvents:UIControlEventValueChanged];
                InsSwitch.tag = i + 100;
                [self.view addSubview:InsSwitch];
            }else{
                UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectMake(width + 10 , Y, width, 30)];
                stepper.tag = i + 100;
                stepper.value = 5;
                [stepper addTarget:self action:@selector(clickStepper:)
                    forControlEvents:UIControlEventValueChanged];
                self.numLabel = label;
                self.numLabel.text =  [NSString stringWithFormat:
                                       @"%@：\t5",self.createInstructionsLabelTextArr[i]];
                [self.view addSubview:stepper];
            }
        }else{
            CGFloat BtnWidth = SCREEN_WIDTH / 2 - 20;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width + 10 , Y, BtnWidth, 30)];
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:self.createInstructionsLabelTextArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.backgroundColor = [UIColor AxcUI_ArcPresetColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.tag = buttonTag + 100;
            [self.view addSubview:button];
            buttonTag ++;
            
        }
        
    }
}

@end
