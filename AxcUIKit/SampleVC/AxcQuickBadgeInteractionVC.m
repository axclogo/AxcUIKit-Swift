//
//  AxcQuickBadgeInteractionVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/17.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//  

#import "AxcQuickBadgeInteractionVC.h"


@interface AxcQuickBadgeInteractionVC ()


@property(nonatomic,strong)    UIImageView *imageV;



@end

@implementation AxcQuickBadgeInteractionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.imageV];
    
    // 重写SET方法，设置即可调用，无先后顺序，设置即可动态调整  ************************************************
    // 设置气泡文本
    self.imageV.axcUI_badgeInteractionText = @"10";
    // 气泡对象的指针
//    self.imageV.axcUI_badgeInteractionView
    
    self.instructionsLabel.text = @"此气泡可拖拽\n其中的Badge对象为‘AxcUI_BadgeInteractionView’\n此对象详细属性设置请参见Api或者“AxcBadgeInteractionViewVC”";

}

// 因为交互原因，有部分代码被循环引用，因此需要手动置空一部分指针
- (void)dealloc{
    [self.imageV.axcUI_badgeInteractionView empty];
}


#pragma mark - 懒加载区
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, 300, 300)];
        _imageV.center = self.view.center;
        _imageV.image = [UIImage imageNamed:@"test_6"];
        _imageV.backgroundColor = [UIColor AxcUI_CloudColor];
        _imageV.userInteractionEnabled = YES;
    }
    return _imageV;
}


@end
