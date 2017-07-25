//
//  AxcUserInteractionControlVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/25.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUserInteractionControlVC.h"


@interface AxcUserInteractionControlVC ()

@property(nonatomic, strong)AxcUI_UserInteractionControl *userInteractionControl;



@end

@implementation AxcUserInteractionControlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.userInteractionControl];
    
    [self addSegmentedControl];
    
    self.instructionsLabel.text = @"继承于UIControl的一个动画控件，预设6个线段动画，可当做Button使用或者添加到其他视图中作为动画展示。";
}



- (void)clickUserInteractionControl{
    NSLog(@"你点击了%@",self.userInteractionControl);
}

- (void)clicksegmented:(UISegmentedControl *)sender{
    self.userInteractionControl.axcUI_currentState = sender.selectedSegmentIndex;
}


#pragma mark - 懒加载区
- (AxcUI_UserInteractionControl *)userInteractionControl{
    if (!_userInteractionControl) {
        _userInteractionControl = [[AxcUI_UserInteractionControl alloc] init];
        _userInteractionControl.axcUI_Size = CGSizeMake(100, 100);
        _userInteractionControl.center = self.view.center;
        _userInteractionControl.axcUI_Y = 130;
        _userInteractionControl.backgroundColor = [UIColor AxcUI_EmeraldColor];
        
// 重写Set函数达到能实时修改的效果，但是并不支持动画效果的实时展示，推荐预设好  ************************************************
//        _userInteractionControl.axcUI_lineHeight = 5;
//        _userInteractionControl.axcUI_lineWidth = 30;
//        _userInteractionControl.axcUI_lineSpacing = 30;
//        _userInteractionControl.lineCap = AxcUserInteractionControlLineCapSquare;
        
        // 继承为UIControl，拥有添加交互的功能
        [_userInteractionControl addTarget:self action:@selector(clickUserInteractionControl)
                          forControlEvents:UIControlEventTouchUpInside];
    }
    return _userInteractionControl;
}

- (void)addSegmentedControl{
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"三道杠",@"左箭头",@"右箭头",@"交叉",@"加号",@"负号"]];
    segmented.axcUI_Size = CGSizeMake(SCREEN_WIDTH - 20, 30);
    segmented.center = self.view.center;
    segmented.axcUI_Y = 300;
    segmented.selectedSegmentIndex = 0;
    segmented.tag = 100 + 0;
    [segmented addTarget:self action:@selector(clicksegmented:)
        forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmented];
}


@end
