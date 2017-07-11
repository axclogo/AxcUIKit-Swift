//
//  AxcCopyableVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/10.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcCopyableVC.h"


@interface AxcCopyableVC ()


@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic, strong)UILabel *label;

@end

@implementation AxcCopyableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - SET区

#pragma mark - 懒加载区
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, SCREEN_WIDTH - 20, 40)];
        _label.text = @"";
        _label.backgroundColor = [UIColor AxcUI_CloudColor];
        _label.layer.borderWidth = 1;
        _label.layer.borderColor = [iosSystemBlue CGColor];
        _label.layer.masksToBounds = YES;
        _label.layer.cornerRadius = 5;
        _label.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _label;
}


@end
