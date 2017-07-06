//
//  TestTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "TestTwoVC.h"



@interface TestTwoVC (){
    UILabel *label;
}

@end

@implementation TestTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, SCREEN_WIDTH - 20, 300)];
    label.numberOfLines = 0;
    label.text = @"新华社柏林7月5日电（记者严锋　孟娜　刘畅）国家主席习近平5日在柏林同德国总理默克尔举行会谈。两国领导人高度评价中德传统友好，为中德全方位战略伙伴关系下阶段发展描绘新蓝图、明确新目标、规划新路径，一致同意深化政治互信、加强务实合作、深化人文交流、密切多边配合，推动中德关系百尺竿头更进一步";
    [self.view addSubview:label];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    label.attributedText = [label.text AxcUI_markWords:@"国" withColor:[UIColor AxcUI_ArcColor] ];
}

@end
