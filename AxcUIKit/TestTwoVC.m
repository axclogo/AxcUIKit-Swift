//
//  TestTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "TestTwoVC.h"



@interface TestTwoVC ()
{
    UIImageView *imageView;
}

@end

@implementation TestTwoVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test_1.jpg"]];
    imageView.frame = CGRectMake(100, 100, 200, 100);
    [self.view addSubview:imageView];
    
    imageView.axcUI_filterPresetStyle = AxcFilterPresetStyleLOMO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    imageView.image = [UIImage imageNamed:@"test_1.jpg"];
    imageView.axcUI_filterPresetStyle = arc4random()%13;
}

@end
