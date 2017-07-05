//
//  AxcTagTextViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/5.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcTagTextViewVC.h"


@interface AxcTagTextViewVC ()<AxcTagTextViewDelegate>


@property(nonatomic,strong)AxcUI_TagTextView *tagTextView;

@property(nonatomic, strong)NSArray *textArray;

@end

@implementation AxcTagTextViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tagTextView];
    
    [self.tagTextView AxcUI_addTags:self.textArray];
    self.tagTextView.axcUI_alignment = AxcTagViewAlignmentStyleFillByExpandingWidth;
    [self.tagTextView AxcUI_reloadData];
    
    
}





#pragma mark - 懒加载区
- (AxcUI_TagTextView *)tagTextView{
    if (!_tagTextView) {
        _tagTextView = [[AxcUI_TagTextView alloc] init];
        _tagTextView.axcUI_Size = CGSizeMake(SCREEN_WIDTH - 20, 250);
        _tagTextView.center = self.view.center;
        _tagTextView.axcUI_Y = 100;
        
        _tagTextView.axcUI_tagTextViewDelegate = self;
        _tagTextView.backgroundColor = [UIColor AxcUI_CloudColor];
    }
    return _tagTextView;
}


- (NSArray *)textArray{
    if (!_textArray) {
        _textArray = @[@"Java",@"C",@"C++",@"C#",@"Python",@"VB.NET",@"PHP",@"Java Script",@"Objective - C",@"GO",@"MATLAB",@"Ruby",@"PL/SQL",@"Swift",@"SAS",@"D",@"Dart",@"ABAP",@"COBOL",@"Ada",@"F#",@"Apex",@"MQL4",@"Rush",@"Bash",@"Alice",@"MySQL",@"SQL Sever",@"D",@"R"];
    }
    return _textArray;
}


@end
