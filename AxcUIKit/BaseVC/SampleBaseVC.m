//
//  SampleBaseVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "SampleBaseVC.h"


@interface SampleBaseVC ()


@property(nonatomic, assign) CGFloat instructionsLabelHeight;


@end

@implementation SampleBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.instructionsLabelHeight = 100;
}


- (UILabel *)instructionsLabel{
    if (!_instructionsLabel) {
        _instructionsLabel = [[AxcUI_Label alloc] initWithFrame:CGRectMake(0, self.view.axcUI_Height - self.instructionsLabelHeight,
                                                                       self.view.axcUI_Width, self.instructionsLabelHeight)];
        _instructionsLabel.font = [UIFont systemFontOfSize:15];
        _instructionsLabel.textAlignment = NSTextAlignmentCenter;
        _instructionsLabel.textColor = [UIColor AxcUI_AmethystColor];
        _instructionsLabel.backgroundColor = [UIColor AxcUI_CloudColor];
        _instructionsLabel.alpha = 0.8;
        _instructionsLabel.numberOfLines = 0;
        _instructionsLabel.axcUI_textEdgeInsets = UIEdgeInsetsMake(0,10,0,10);
        [_instructionsLabel AxcUI_autoresizingMaskLeftAndRight]; // 调用比例适配
        [self.view addSubview:_instructionsLabel];
    }
    return _instructionsLabel;
}


- (void)dealloc{
    // 只要控制器执行此方法，代表VC以及其控件全部已安全从内存中撤出。
    // ARC除去了手动管理内存，但不代表能控制循环引用，虽然去除了内存销毁概念，但引入了新的概念--对象被持有。
    // 框架在使用后能完全从内存中销毁才是最好的优化
    // 不明白ARC和dealloc调用概念的请自行谷歌
    NSLog(@"控制器%s调用情况，已销毁%@",__func__,self);
}

@end
