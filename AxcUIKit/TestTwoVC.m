//
//  TestTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

//UIImage *stretchableButtonImage = [buttonImage  stretchableImageWithLeftCapWidth:buttonImage.size.width*0.5  topCapHeight:0];


#import "TestTwoVC.h"



@interface TestTwoVC (){
    UIButton *button;
}

@end

@implementation TestTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 300, 200)];
    button.backgroundColor = [UIColor AxcUI_OrangeColor]; // boat
    button.titleLabel.font = [UIFont systemFontOfSize:13];// tabbar_mainframeHL
    
    [button setImage:[UIImage imageNamed:@"delected_img"] forState:UIControlStateNormal];
    [button setTitle:@"内容居左-图左文右" forState:UIControlStateNormal];
    button.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleRightImageRight;
    button.axcUI_padding = 10;
    
    [self.view addSubview:button];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [button setTitle:@"内容居右-图右文左" forState:UIControlStateNormal];
    button.axcUI_buttonContentLayoutType =  arc4random()%8;
    button.axcUI_padding = 10;
    NSLog(@"%ld",button.axcUI_buttonContentLayoutType);
}

@end
