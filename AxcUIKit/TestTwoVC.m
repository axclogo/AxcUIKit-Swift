//
//  TestTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

//UIImage *stretchableButtonImage = [buttonImage  stretchableImageWithLeftCapWidth:buttonImage.size.width*0.5  topCapHeight:0];


#import "TestTwoVC.h"



@interface TestTwoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *view;
}


@end

@implementation TestTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    view.axcUI_cornerRadii = 10;
    view.axcUI_rectCorner = UIRectCornerTopRight | UIRectCornerTopLeft;
    view.axcUI_rectCorner = UIRectCornerTopLeft | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    view.axcUI_cornerRadii = 50;

    
}

@end
