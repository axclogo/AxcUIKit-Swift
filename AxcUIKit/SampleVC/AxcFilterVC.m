//
//  AxcFilterVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/29.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcFilterVC.h"


@interface AxcFilterVC ()


@property(nonatomic,strong)UIImageView *MainImageView;


@end

@implementation AxcFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



- (UIImageView *)MainImageView{
    if (!_MainImageView) {
        _MainImageView = [[UIImageView alloc] init];
    }
    return _MainImageView;
}

@end
