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


@end

@implementation AxcButtonLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.button];
    
}

- (void)createSegmented{
    NSArray *arr = @[@[@"居中-图左文右",@"居中-图右文左",@"居中-图上文下",@"居中-图下文上"],
                     @[@"居左-图左文右",@"居左-图右文左",@"居右-图左文右",@"居右-图右文左"]];
    for (int i = 0; i < 2; i ++) {
        CGFloat Y = i * 40 + self.button.axcUI_Y + self.button.axcUI_Height + 10;
        UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:arr[i]];
        segmented.frame = CGRectMake(10, Y, SCREEN_WIDTH - 20, 30);
        segmented.selectedSegmentIndex = 0;
        segmented.tag = 100 + i;
        [segmented addTarget:self action:@selector(clicksegmented:)
            forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:segmented];
    }
}


#pragma mark - 懒加载区
- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc] init];
        _button.axcUI_Size = CGSizeMake(SCREEN_WIDTH - 150, 50);
        _button.center = self.view.center;
        _button.axcUI_Y = 140;
        _button.backgroundColor = [UIColor AxcUI_NephritisColor];
        _button.titleLabel.font = [UIFont systemFontOfSize:13];
        [_button setImage:[UIImage imageNamed:@"delected_img"] forState:UIControlStateNormal];
    }
    return _button;
}


@end
