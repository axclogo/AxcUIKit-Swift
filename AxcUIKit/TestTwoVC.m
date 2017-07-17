//
//  TestTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

//UIImage *stretchableButtonImage = [buttonImage  stretchableImageWithLeftCapWidth:buttonImage.size.width*0.5  topCapHeight:0];


#import "TestTwoVC.h"


#import "AxcUI_BadgeInteractionView.h"

@interface TestTwoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *view;
    UIImageView *imageV;
}


@end

@implementation TestTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
//    view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    view.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:view];
//    view.axcUI_rectCornerRadii = 10;
//    view.axcUI_rectCorner = UIRectCornerTopRight | UIRectCornerTopLeft;
//    view.axcUI_rectCorner = UIRectCornerTopLeft | UIRectCornerBottomRight | UIRectCornerBottomLeft;
//    view.axcUI_rectCornerRadii = 50;
//
//    AxcUI_BadgeInteractionView *dragView = [[AxcUI_BadgeInteractionView alloc] init];
//    dragView.center = self.view.center;
//    dragView.axcUI_Size = CGSizeMake(30, 30);
//    dragView.axcUI_text = @"3";
//    dragView.axcUI_font = [UIFont systemFontOfSize:10];
//    [self.view addSubview:dragView];
    
    imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, 300, 300)];
    imageV.image = [UIImage imageNamed:@"test_4"];
    imageV.backgroundColor = [UIColor AxcUI_CloudColor];
    imageV.axcUI_badgeInteractionText = @"10";
    imageV.userInteractionEnabled = YES;
    [self.view addSubview:imageV];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [imageV AxcUI_drawingWithMosaic];
}

@end
