//
//  TestTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "TestTwoVC.h"



@interface TestTwoVC ()<AxcNumberUnitFieldDelegate>
{
    AxcUI_NumberUnitField * Axc;
}

@end

@implementation TestTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Axc = [[AxcUI_NumberUnitField alloc] init];
    Axc.frame = CGRectMake(100, 100, 300, 60);
    Axc.axcUI_numberFieldDelegate = self;
    [Axc addTarget:self action:@selector(changeAxc) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:Axc];
    
}
- (void)changeAxc{
    NSLog(@"  %@",Axc.axcUI_text);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [Axc resignFirstResponder];
}

@end
