//
//  AxcEmptyDataPlaceholderView.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcEmptyDataPlaceholderView.h"

#import "UIColor+AxcColor.h"
#import "UIView+AxcExtension.h"
#import "UIButton+AxcButtonContentLayout.h"
#import "UIImage+AxcTransfromZoom.h"

@implementation AxcEmptyDataPlaceholderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor AxcUI_colorWithHexColor:@"f6f6f6"];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"网络连接失败，请点击连接重试！\n（这个是占位图，自定义的View）";
    label.textColor = [UIColor lightGrayColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-64);
        make.width.mas_equalTo(SCREEN_WIDTH - 100);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"Load_failed"];
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(label.mas_top).offset(-10);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH - 100);
        make.height.mas_equalTo(80);
    }];
    
    UIColor *iosSystemBlue = [UIColor AxcUI_colorWithHexColor:@"1296db"];
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [iosSystemBlue CGColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:iosSystemBlue forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(clickLoadBtn) forControlEvents:UIControlEventTouchUpInside];
    
    // 设置图像大小
    [button setContentMode:UIViewContentModeScaleAspectFit];
    [button setImage:[[UIImage imageNamed:@"Refresh_Img"] AxcUI_transformImageScale:0.2]
            forState:UIControlStateNormal];
    
    // 设置布局
    button.axcUI_buttonContentLayoutType = AxcButtonContentLayoutStyleNormal;
    button.axcUI_padding = 10;
    [button setTitle:@"重新加载" forState:UIControlStateNormal];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
}

- (void)clickLoadBtn{
    if (self.clickLoadBtnBlock) {
        self.clickLoadBtnBlock();
    }
}


@end


