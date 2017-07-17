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
@property(nonatomic, strong)NSArray *createInstructionsLabelTextArr;
@property(nonatomic, strong)NSMutableArray <UILabel *>*labelArray;
@property(nonatomic, assign)NSInteger backSelectedSegmentIndex;

@end

@implementation AxcTagTextViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tagTextView];
    
    [self.tagTextView AxcUI_addTags:self.textArray];
    [self.tagTextView AxcUI_reloadData];
    
    [self createSegmented];
    
    self.instructionsLabel.text = @"AxcUI_TagView的纯文字扩展版本，主要以展示文字标签为主的一个控件。\n架构同样借鉴的是作者zekunyan的项目TTGTagCollectionView，\n其中文字样式的定义于Config配置对象中设置";

}


// 使用初始化、重写SET方法和setNeedsDisplay，设置即可调用，无先后顺序，设置即可动态调整  ************************************************
- (void)clicksegmented:(UISegmentedControl *)sender{
    switch (sender.tag - 100) {
        case 0: // 对齐风格
            self.tagTextView.axcUI_alignment = sender.selectedSegmentIndex;
            
            // 以下为Demo中的业务逻辑
            if (sender.selectedSegmentIndex != _backSelectedSegmentIndex &&
                _backSelectedSegmentIndex == 4) { // 当宽度适配之后将拉伸所有tag，所以需要重置数据
                // 一般在使用当中这些参数都会设置好，并不会向Demo中这样动态演示
                [self reloadData]; // 重置
            }
            _backSelectedSegmentIndex = sender.selectedSegmentIndex;
            break;
        case 1: // 滚动方向
            self.tagTextView.axcUI_scrollDirection = sender.selectedSegmentIndex;
            
            // 以下为Demo中的业务逻辑
            if (!sender.selectedSegmentIndex) {
                self.tagTextView.axcUI_numberOfLines = 0;  // 行数为0默认全部排列下来
                UISlider *slider = [self.view viewWithTag:102];
                slider.value = 0;
                [self slidingSlider:slider];
            }
            break;
        default: break;
    }
}
- (void)slidingSlider:(UISlider *)sender{
    switch (sender.tag - 100) {
        case 2: // 设置行数
            self.tagTextView.axcUI_numberOfLines = sender.value;
            
            [self.labelArray objectAtIndex:0].text = [NSString stringWithFormat:
                                                      @"%@：\t%.0f",self.createInstructionsLabelTextArr[sender.tag - 100],
                                                      sender.value]; // 显示多少行数
            break;
            
        default: break;
    }
}

// 使用配置对象来构造标签的属性，传值后即可，无先后顺序  ************************************************
- (void)clickBtn:(UIButton *)sender{
    AxcTagTextConfig *config = [AxcTagTextConfig new];
    config.axcUI_tagTextColor = [UIColor whiteColor];
    config.axcUI_tagSelectedTextColor = [UIColor whiteColor];
    NSArray * tagsArr = [self.textArray subarrayWithRange:NSMakeRange(0, 10)];
    switch (sender.tag - 100) {
        case 3:// 添加随机色的
            config.axcUI_tagTextFont = [UIFont systemFontOfSize:13];
            config.axcUI_tagBackgroundColor = [UIColor AxcUI_ArcColor];
            config.axcUI_tagSelectedBackgroundColor = [UIColor AxcUI_ArcColor];
            [self.tagTextView AxcUI_addTags:tagsArr withConfig:[config copy]]; // 添加进组
            break;
        case 4:// 添加随机字体大小和带阴影的的
            config.axcUI_tagBackgroundColor = [UIColor AxcUI_ArcColor];
            config.axcUI_tagSelectedBackgroundColor = [UIColor AxcUI_ArcColor];
            config.axcUI_tagTextFont = [UIFont systemFontOfSize:arc4random()%10+5];
            config.axcUI_tagShadowColor = [UIColor blackColor];
            config.axcUI_tagShadowOffset = CGSizeMake(2, 2);
            config.axcUI_tagShadowRadius = 2;
            config.axcUI_tagShadowOpacity = 0.3f;
            [self.tagTextView AxcUI_addTags:tagsArr withConfig:[config copy]]; // 添加进组
            break;
        case 5:// 添加原作者风格的
            config.axcUI_tagTextFont = [UIFont systemFontOfSize:16.0f];
            config.axcUI_tagBackgroundColor = [UIColor colorWithRed:0.30 green:0.72 blue:0.53 alpha:1.00];
            config.axcUI_tagSelectedBackgroundColor = [UIColor colorWithRed:0.22 green:0.29 blue:0.36 alpha:1.00];
            config.axcUI_tagCornerRadius = 4.0f;
            config.axcUI_tagSelectedCornerRadius = 4.0f;
            config.axcUI_tagBorderWidth = 1.0f;
            config.axcUI_tagSelectedBorderWidth = 1.0f;
            config.axcUI_tagBorderColor = [UIColor whiteColor];
            config.axcUI_tagSelectedBorderColor = [UIColor whiteColor];
            config.axcUI_tagShadowColor = [UIColor blackColor];
            config.axcUI_tagShadowOffset = CGSizeMake(2, 2);
            config.axcUI_tagShadowRadius = 2;
            config.axcUI_tagShadowOpacity = 0.3f;
            [self.tagTextView AxcUI_addTags:tagsArr withConfig:[config copy]]; // 添加进组
            break;
        case 6: // 清空并重置数据
            [self.tagTextView AxcUI_removeAllTags];
            [self.tagTextView AxcUI_addTags:self.textArray];
            [self reloadData];
            break;
        default:  break;
    }
}



// 重置
- (void)reloadData{
    self.textArray = nil;
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








- (NSArray *)createInstructionsLabelTextArr{
    if (!_createInstructionsLabelTextArr) {
        _createInstructionsLabelTextArr = @[@"",@"",
                                            @"显示行数",
                                            @[@"添加随机色标签",@"添加带阴影标签"],
                                            @[@"添加原作者风标签",@"重置"]];
    }
    return _createInstructionsLabelTextArr;
}
- (NSMutableArray *)labelArray{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (void)createSegmented{
    NSArray *arr = @[@[@"左对齐",@"居中排列",@"右对齐",@"水平分布",@"宽度填充"],
                     @[@"纵向滚动",@"横向滚动"]];
    NSArray *defaultParameters = @[@"",@"",@"0",@"",@"",@"",@""];
    NSInteger buttonTag = 0;
    for (int i = 0; i < 5; i ++) {
        CGFloat Y = i * 40 + self.tagTextView.axcUI_Y + self.tagTextView.axcUI_Height + 10;
        CGFloat width = 150;
        if (i < 2) {
            UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:arr[i]];
            segmented.frame = CGRectMake(10, Y, SCREEN_WIDTH - 20, 30);
            segmented.selectedSegmentIndex = 0;
            segmented.tag = 100 + i;
            [segmented addTarget:self action:@selector(clicksegmented:)
                forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:segmented];
        }else if(i == 2){
            UILabel *label = [[UILabel alloc] init];
            label.axcUI_Size = CGSizeMake(width, 30);
            label.axcUI_X = 10;
            label.axcUI_Y = Y;
            label.text = self.createInstructionsLabelTextArr[i];
            label.textColor = [UIColor AxcUI_WisteriaColor];
            label.font = [UIFont systemFontOfSize:14];
            [self.view addSubview:label];
            [self.labelArray addObject:label];
            
            
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(width + 30,Y, SCREEN_WIDTH - (width + 40), 30)];
            [slider addTarget:self action:@selector(slidingSlider:)
             forControlEvents:UIControlEventValueChanged];
            slider.minimumValue = 0;
            slider.maximumValue = 10;
            slider.value = [defaultParameters[i] floatValue];
            slider.tag = i + 100;
            [self.view addSubview:slider];
            label.text =  [NSString stringWithFormat:
                           @"%@：\t%@",self.createInstructionsLabelTextArr[i],defaultParameters[i]];
        }else{
            NSArray *arr = self.createInstructionsLabelTextArr[i];
            if (buttonTag == 0) {
                buttonTag = i;
            }
            for (int j = 0; j < arr.count; j ++) {
                CGFloat BtnWidth = SCREEN_WIDTH / 2 - 20;
                CGFloat X = j * BtnWidth + 10 + j * 20;
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(X , Y, BtnWidth, 30)];
                [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:arr[j] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:13];
                button.backgroundColor = [UIColor AxcUI_ArcPresetColor];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
                button.tag = buttonTag + 100;
                [self.view addSubview:button];
                buttonTag ++;
            }
            
        }
        
    }
}




- (NSArray *)textArray{
    if (!_textArray) {
        _textArray = @[@"Java",@"C",@"C++",@"C#",@"Python",@"VB.NET",@"PHP",@"Java Script",@"Objective - C",@"GO",@"MATLAB",@"Ruby",@"PL/SQL",@"Swift",@"SAS",@"D",@"Dart",@"ABAP",@"COBOL",@"Ada",@"F#",@"Apex",@"MQL4",@"Rush",@"Bash",@"Alice",@"MySQL",@"SQL Sever",@"D",@"R"];
    }
    return _textArray;
}


@end
