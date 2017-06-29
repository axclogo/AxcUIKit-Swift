//
//  TestTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "TestTwoVC.h"

#import "AxcUI_PhotoBrowser.h"

#import "Axc_ImageCache.h"

#import "AxcUI_Toast.h"

@interface TestTwoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *array;

}


@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UISlider *parentScale;

@end

@implementation TestTwoVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.parentScale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-130);
    }];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage AxcUI_setImageNamed:@"test_4"]];
    _imageView.frame = CGRectMake(100, 100, 100, 100);
//    _imageView.axcUI_filterDynamicRendering = YES;
    [self.view addSubview:_imageView];
    
    
    
    
}
- (void)controllAction:(UISlider *)sender{
    _imageView.axcUI_filterStaturation = sender.value;
//    _imageView.axcUI_filterBrightness = sender.value;
    _imageView.axcUI_filterContrast = sender.value;
}
- (UISlider *)parentScale{
    if (!_parentScale) {
        _parentScale = [[UISlider alloc] init];
        [_parentScale addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _parentScale.minimumValue = 0;
        _parentScale.maximumValue = 2;
        _parentScale.value = 0.8;
        _parentScale.tag = 100 + 2;
        [self.view addSubview:_parentScale];
    }
    return _parentScale;
}


@end
