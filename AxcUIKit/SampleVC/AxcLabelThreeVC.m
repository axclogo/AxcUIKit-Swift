//
//  AxcLabelTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/26.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcLabelThreeVC.h"

// 关于渐变色搭配的博客：http://blog.sina.com.cn/s/blog_8fc890a201013z8h.html
#define HorizontalColors @[[UIColor AxcUI_R:254 G:67 B:101],[UIColor AxcUI_R:252 G:157 B:154],[UIColor AxcUI_R:249 G:205 B:173],[UIColor AxcUI_R:200 G:200 B:169],[UIColor AxcUI_R:131 G:175 B:155]]

#define VerticalColors @[[UIColor AxcUI_R:1 G:77 B:103],[UIColor AxcUI_R:96 G:143 B:159],[UIColor AxcUI_R:251 G:178 B:23],[UIColor AxcUI_R:237 G:222 B:139]]

@interface AxcLabelThreeVC ()


@property(nonatomic,strong)AxcUI_Label *testLabel;


@end

@implementation AxcLabelThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    self.instructionsLabel.text = @"调用设置两个参数即可完成背景色的渐变功能";
}

- (void)createUI{
    // 水平渲染背景
    AxcUI_Label *HorizontalLabel = [[AxcUI_Label alloc] initWithFrame:CGRectMake(10, 120, SCREEN_WIDTH - 20, 50)];
    HorizontalLabel.text = @"水平渲染背景";
//    HorizontalLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:HorizontalLabel];
//    HorizontalLabel.axcUI_textEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    // 设置渐变色组
    HorizontalLabel.axcUI_backGroundGradientColors = HorizontalColors;
    HorizontalLabel.axcUI_textGradientColors = HorizontalColors;
//    HorizontalLabel.backgroundColor = [UIColor lightGrayColor];
    
    
    
    
    // 纵向渲染背景
    AxcUI_Label *VerticalLabel = [[AxcUI_Label alloc] init];
    VerticalLabel.axcUI_Size = CGSizeMake(200, 300);
    VerticalLabel.center = self.view.center;
    VerticalLabel.axcUI_Y = 200;
    VerticalLabel.text = @"纵向渲染背景";
    VerticalLabel.textColor = [UIColor whiteColor];
    VerticalLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:VerticalLabel];
    
    
    // 调用setNeedsDisplay和重写STE ，无先后顺序，设置即可动态调整  ************************************************
    // 设置渐变色组
    VerticalLabel.axcUI_backGroundGradientColors = VerticalColors;
    // 默认水平，可设置成纵向
    VerticalLabel.axcUI_backGroundDrawDirectionStyle = AxcBackGroundGradientStyleVertical;
    
    /**
     其实渐变色很简单，如果有需求只需要按照我的drawRect逻辑重写一遍给View就能使用，
     也可以把这个Label当View使用，当然我个人感觉Label还是比View稍占内存，毕竟是View的子类
     其实也就多不了太多，不超过几B也就。。。
     */
    
    // 美化切个角什么的。。。
//    HorizontalLabel.axcUI_rectCorner = UIRectCornerAllCorners;
    VerticalLabel.axcUI_rectCorner = UIRectCornerAllCorners;
}



@end
