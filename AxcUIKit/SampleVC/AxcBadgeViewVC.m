//
//  AxcBadgeViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/14.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBadgeViewVC.h"


@interface AxcBadgeViewVC ()

@property(nonatomic, strong)UIView *testView;

@property(nonatomic,strong)AxcUI_BadgeView *badgeView;

@property(nonatomic, strong)NSArray *createInstructionsLabelTextArr;

@end

@implementation AxcBadgeViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.testView];
    // 添加数字气泡
    [self.testView addSubview:self.badgeView];
    // 设置初始位置
    // 上方
    self.badgeView.axcUI_verticalStyle = AxcBadgeViewVerticalStyleTop;
    // 右方
    self.badgeView.axcUI_horizontalStyle = AxcBadgeViewHorizontalStyleRight;
    
    // 设置控制控件
    [self createControls];
    
    // 原作者GitHub：https://github.com/Marxon13
    self.instructionsLabel.text = @"根据作者McQuilkin项目M13BadgeView改制\n具体详细的参数设置请参见相关控件的Api";
}


// 使用初始化、重写SET方法和setNeedsDisplay，设置即可调用，无先后顺序，设置即可动态调整  ************************************************
- (void)clickInsSwitch:(UISwitch *)sender{
    NSInteger tag = sender.tag - 100;
    switch (tag) {
        case 0: self.badgeView.axcUI_hidesWhenZero = sender.on; break;
        case 1:
            if (sender.on) {
            self.badgeView.axcUI_borderWidth = 2.0;
        } else {
            self.badgeView.axcUI_borderWidth = 0.0;
        } break;
        case 2: self.badgeView.axcUI_showGloss = sender.on; break;
        case 3: self.badgeView.axcUI_shadowBadge = sender.on; break;
        case 4: self.badgeView.axcUI_shadowBorder = sender.on; break;
        case 5: self.badgeView.axcUI_shadowText = sender.on; break;
            
        default: break;
    }
}
- (void)clicksegmented:(UISegmentedControl *)sender{
    NSInteger tag = sender.tag - 100;
    switch (tag) {
        case 6: self.badgeView.axcUI_horizontalStyle = sender.selectedSegmentIndex + 1; break;
        case 7: self.badgeView.axcUI_verticalStyle = sender.selectedSegmentIndex + 1; break;
        default: break;
    }
}
- (void)clickBtn:(UIButton *)sender{
    NSInteger tag = sender.tag - 100;
    UIColor *color = [UIColor AxcUI_ArcColor];
    switch (tag) {
        case 8: self.badgeView.axcUI_textColor = color; break;
        case 9: self.badgeView.axcUI_badgeBackgroundColor = color;  break;
        case 10: self.badgeView.axcUI_borderColor = color;  break;
        default: break;
    }
    sender.backgroundColor = color;
}



#pragma mark - 懒加载
- (AxcUI_BadgeView *)badgeView{
    if (!_badgeView) {
        _badgeView = [[AxcUI_BadgeView alloc] init];
        _badgeView.axcUI_Size = CGSizeMake(24, 24);
        _badgeView.axcUI_text = @"1";
    }
    return _badgeView;
}

- (UIView *)testView{
    if (!_testView) {
        _testView = [[UIView alloc] init];
        _testView.axcUI_Size = CGSizeMake(100, 100);
        _testView.center = self.view.center;
        _testView.axcUI_Y = 130;
        _testView.backgroundColor = [UIColor AxcUI_EmeraldColor];
    }
    return _testView;
}



- (NSArray *)createInstructionsLabelTextArr{
    if (!_createInstructionsLabelTextArr) {
        _createInstructionsLabelTextArr = @[@[@"文本为0时自动隐藏",@"开启边框",@"抛光/高光效果",
                                              @"气泡阴影",@"边框阴影",@"文本阴影"],
                                            @[@"纵向方位",@"横向方位"],
                                            @[@"文本颜色",@"气泡颜色",@"边框颜色"]];
    }
    return _createInstructionsLabelTextArr;
}
- (void)createControls{
//    for (int i = 0; i < self.createInstructionsLabelTextArr.count; i ++) {
    CGFloat Y = 40 + self.testView.axcUI_Y + self.testView.axcUI_Height ;
    NSArray *strArr = self.createInstructionsLabelTextArr[0];
    NSInteger tag = 100;
    
    
    CGFloat labelWidth = 0.0 ;
    CGFloat spacingJ = 0;
    for (int j = 0 ; j < 6; j ++) {
        if (j == 3) {
            Y += 60;
            labelWidth = 0.0 ; spacingJ = 0;}
        NSString *textStr = strArr[j];
        CGFloat width = [textStr AxcUI_widthWithStringFontSize:14];
        CGFloat X = 10 + labelWidth + spacingJ * 20;
        CGFloat switchY = Y;
        
        [self createLabelX:X Y:Y width:width text:textStr];
        
        switchY += 30;
        UISwitch *InsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(X, switchY, 50, 30)];
        InsSwitch.on = NO;
        [InsSwitch addTarget:self action:@selector(clickInsSwitch:)
            forControlEvents:UIControlEventValueChanged];
        InsSwitch.tag = tag;
        [self.view addSubview:InsSwitch];
        spacingJ ++;
        labelWidth = labelWidth + width;
        tag ++;
    }
    
    strArr = self.createInstructionsLabelTextArr[1];
    labelWidth = 0.0 ;
    Y += 65;
    NSArray *arr = @[@[@"左",@"中",@"右"],@[@"上",@"中",@"下"]];
    for (int j = 0; j < 2; j ++) {
        NSString *textStr = strArr[j];
        CGFloat width = [textStr AxcUI_widthWithStringFontSize:14];
        
        [self createLabelX:10 Y:Y width:width text:textStr];
        
        UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:arr[j]];
        segmented.frame = CGRectMake(width + 20, Y, SCREEN_WIDTH - width - 30, 30);
        if (j == 0) {
            segmented.selectedSegmentIndex = 2;
        }else{
            segmented.selectedSegmentIndex = 0;
        }
        segmented.tag = tag;
        [segmented addTarget:self action:@selector(clicksegmented:)
            forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:segmented];
        
        labelWidth = labelWidth + width;
        Y += 40;
        tag ++;
    }
    
    strArr = self.createInstructionsLabelTextArr[2];
    for (int j = 0; j < 3; j ++) {
        CGFloat BtnWidth = (SCREEN_WIDTH - 40)/ 3 ;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(j * BtnWidth + ((j +1)*10) , Y, BtnWidth, 30)];
        [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:strArr[j] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.backgroundColor = [UIColor AxcUI_ArcColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.tag = tag;
        [self.view addSubview:button];
        tag ++;

    }
    
    //    }
}

- (void)createLabelX:(CGFloat )X Y:(CGFloat )Y width:(CGFloat )width text:(NSString *)test{
    UILabel *label = [[UILabel alloc] init];
    label.axcUI_Size = CGSizeMake(width, 30);
    label.axcUI_X = X;
    label.axcUI_Y = Y;
    label.text = test;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor AxcUI_WisteriaColor];
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
}



@end
