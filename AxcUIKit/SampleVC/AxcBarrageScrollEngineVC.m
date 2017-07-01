//
//  AxcBarrageScrollEngineVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBarrageScrollEngineVC.h"


@interface AxcBarrageScrollEngineVC ()


@property (strong, nonatomic) AxcUI_BarrageScrollEngine *aEngine;


@end

@implementation AxcBarrageScrollEngineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aEngine = [[AxcUI_BarrageScrollEngine alloc] init];
    [self.view addSubview:self.aEngine.axcUI_barrageCanvas];
    self.aEngine.axcUI_barrageCanvas.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH/2);
    
    [self.aEngine start];
    
    self.instructionsLabel.text = @"阿萨德";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    AxcUI_ScrollBarrageModel *sc = [[AxcUI_ScrollBarrageModel alloc] initWithFontSize:20
                                                                            textColor:[UIColor blackColor]
                                                                                 text:@"text"
                                                                          shadowStyle:AxcBarrageShadowStyleGlow
                                                                                 font:nil
                                                                                speed:arc4random_uniform(100) + 50
                                                                            direction:AxcScrollBarrageDirectionStyleB2TR2L];
    [self.aEngine sendDanmaku: sc];
    
}



@end
