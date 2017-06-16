//
//  AxcSemiModalPresentView.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcSemiModalPresentView.h"
#import <Masonry.h>
#import "AxcUIKit.h"

#define imageURL @"http://img.zcool.cn/community/01a39157a980340000012e7e022368.jpg@900w_1l_2o_100sh.jpg"

@implementation AxcSemiModalPresentView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
//    __weak typeof(self) WeakSelf = self;
    [self.testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    [self.imageView AxcUI_setImageWithURL:imageURL
                         placeholderImage:@"placeholder.jpg"];

}

- (UILabel *)testLabel{
    if (!_testLabel) {
        _testLabel = [[UILabel alloc] init];
        _testLabel.text = @"测试推出的文字";
        _testLabel.textColor = [UIColor whiteColor];
        _testLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_testLabel];
    }
    return _testLabel;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview: _imageView];
    }
    return _imageView;
}

@end
