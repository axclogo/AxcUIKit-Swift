//
//  AxcTagViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/5.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcTagViewVC.h"


@interface AxcTagViewVC ()<AxcTagViewDataSource,AxcTagViewDelegate>


@property(nonatomic,strong)AxcUI_TagView *tagView;

@property (strong, nonatomic) NSMutableArray <UIView *> *tagViews;
@property(nonatomic, strong)NSArray *textArray;
@property(nonatomic, strong)NSArray *imageNameArray;
@property(nonatomic, strong)NSArray *createInstructionsLabelTextArr;
@property(nonatomic, strong)NSMutableArray <UILabel *>*labelArray;

@property(nonatomic, assign)NSInteger backSelectedSegmentIndex;
@end

@implementation AxcTagViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tagView];
    [self.tagView AxcUI_reloadData];
    
    [self createSegmented];
    
    // 原作者GitHub：https://github.com/zekunyan
    self.instructionsLabel.text = @"根据作者zekunyan的项目TTGTagCollectionView改制\n这并不是图文混排。这只是一个个标签而已\n不过可以根据此思路配合此控件来达到一些简单的图文混排效果\n此处将其细化分模块化控件";
}

- (void)clicksegmented:(UISegmentedControl *)sender{
    switch (sender.tag - 100) {
        case 0: // 对齐风格
            self.tagView.axcUI_alignment = sender.selectedSegmentIndex;

            // 以下为Demo中的业务逻辑
            if (sender.selectedSegmentIndex != _backSelectedSegmentIndex &&
                _backSelectedSegmentIndex == 4) { // 当宽度适配之后将拉伸所有tag，所以需要重置数据
                // 一般在使用当中这些参数都会设置好，并不会向Demo中这样动态演示
                [self clickBtn:nil]; // 重置
            }
            _backSelectedSegmentIndex = sender.selectedSegmentIndex;
            break;
        case 1: // 滚动方向
            self.tagView.axcUI_scrollDirection = sender.selectedSegmentIndex;
            
            // 以下为Demo中的业务逻辑
            if (!sender.selectedSegmentIndex) {
                self.tagView.axcUI_numberOfLines = 0;  // 行数为0默认全部排列下来
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
            self.tagView.axcUI_numberOfLines = sender.value;
            
            [self.labelArray objectAtIndex:0].text = [NSString stringWithFormat:
                                                      @"%@：\t%.0f",self.createInstructionsLabelTextArr[sender.tag - 100],
                                                      sender.value]; // 显示多少行数
            break;
            
        default: break;
    }
}

#pragma mark - AxcUI_tagView数据源方法
- (CGSize)AxcUI_tagView:(AxcUI_TagView *)tagView sizeForTagAtIndex:(NSUInteger)index{
    return self.tagViews[index].frame.size;
}

- (NSUInteger)AxcUI_numberOfTagsInTagView:(AxcUI_TagView *)tagView{
    return self.tagViews.count;
}

- (UIView *)AxcUI_tagView:(AxcUI_TagView *)tagView
          tagViewForIndex:(NSUInteger)index{
    return self.tagViews[index];
}
#pragma mark - AxcUI_tagView代理
- (BOOL)AxcUI_tagView:(AxcUI_TagView *)tagView
      shouldSelectTag:(UIView *)tagView1
              atIndex:(NSUInteger)index{
    return YES;
}

- (void)AxcUI_tagView:(AxcUI_TagView *)tagView
         didSelectTag:(UIView *)tagView1
              atIndex:(NSUInteger)index{
    NSLog(@"点击了第%ld",index);
}

- (void)AxcUI_tagView:(AxcUI_TagView *)tagView1
    updateContentSize:(CGSize)contentSize{
    NSLog(@"刷新TagView");
}

#pragma mark - 懒加载区
- (AxcUI_TagView *)tagView{
    if (!_tagView) {
        _tagView = [[AxcUI_TagView alloc] init];
        _tagView.axcUI_Size = CGSizeMake(SCREEN_WIDTH - 20, 300);
        _tagView.center = self.view.center;
        _tagView.axcUI_Y = 100;
        
        _tagView.axcUI_tagViewDataSource = self;
        _tagView.axcUI_tagViewDelegate = self;
        _tagView.backgroundColor = [UIColor AxcUI_CloudColor];
    }
    return _tagView;
}



- (NSArray *)createInstructionsLabelTextArr{
    if (!_createInstructionsLabelTextArr) {
        _createInstructionsLabelTextArr = @[@"",@"",
                                            @"显示行数",
                                            @"重置刷新所有数据"];
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
    for (int i = 0; i < 4; i ++) {
        CGFloat Y = i * 40 + self.tagView.axcUI_Y + self.tagView.axcUI_Height + 10;
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
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, Y, SCREEN_WIDTH - 20, 30)];
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:self.createInstructionsLabelTextArr[i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.backgroundColor = [UIColor AxcUI_NephritisColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.tag = i + 100;
            [self.view addSubview:button];
        }
        
    }
}

- (void)clickBtn:(UIButton *)sender{
    if (sender) { // 只有循环创建的Btn才有参，手动调用的为nil，不会执行
        [AxcUI_Toast AxcUI_showBottomWithText:@"正在创建模拟数据..."];
    }
    [self.tagViews removeAllObjects];
    self.tagViews = nil;
    [self.tagView AxcUI_reloadData];
}



- (NSMutableArray<UIView *> *)tagViews{
    if (!_tagViews) {
        _tagViews = [NSMutableArray array];
        for (int i = 0; i < 50; i ++) { // 调用规律函数来添加假数据
            NSString *SelectorString = [NSString stringWithFormat:@"addView%d",arc4random()%3];
            SEL faSelector = NSSelectorFromString(SelectorString);
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            // 直接通过这种方式调用函数会有风险，不过此处只是调用Void函数，定义宏来排除警告
            [self performSelector:faSelector];
#pragma clang diagnostic pop
            // 风险如下：
            /*
             调用这些方法的时候有可能返回的是void 或者其他 non-Objects，可以忽略这个警告，
             但是不建议这么做。oc的内存管理机制，有retain必然有release。
             在arc模式下，这些都由编译器做了。
             但是，假如方法返回的是non-Objects(包括void)，
             这时retain或者release，程序就有可能crash掉。
             */
        }
    }
    return _tagViews;
}

- (void)addView0{
    [self.tagViews addObject:[self newLabelWithText:self.textArray[arc4random()%self.textArray.count]
                                           fontSize:arc4random()% 5 + 10
                                          textColor:[UIColor whiteColor]
                                    backgroundColor:[UIColor AxcUI_ArcColor]]];
}
- (void)addView1{
    NSString *str = [NSString stringWithFormat:@"%@(Button)",self.textArray[arc4random()%self.textArray.count]];
    [self.tagViews addObject:[self newButtonWithTitle:str
                                             fontSize:arc4random()% 8 + 10
                                      backgroundColor:[UIColor AxcUI_ArcColor]]];
}
- (void)addView2{
    [_tagViews addObject:[self newImageViewWithImage:[UIImage imageNamed:self.imageNameArray[arc4random()%self.imageNameArray.count]]]];
}

- (NSArray *)textArray{
    if (!_textArray) {
        _textArray = @[@"这几天有时间看了下UICollectionView的东西",@"才发觉它真的非常强大",
                       @"基本使用",@"UICollectionView",@"自定义布局",@"自定义插入删除动画",
                       @"自定义转场动画",@"UICollectionView相对于UITableView",@"可以说是青出于蓝而胜于蓝",
                       @"它和",@"UITableView",@"布局形式比较单一",@"局限于",@"行列表",@"独立的类"];
    }
    return _textArray;
}
- (NSArray *)imageNameArray{
    if (!_imageNameArray) {
        _imageNameArray = @[@"heart-empty",@"heart-full",@"heart-half",@"airplane",@"bike",@"boat",@"bus",
                            @"cable",@"car",@"express",@"light-rail",@"plane",@"platform",
                            @"railway",@"ship",@"shuttle",@"stop",@"subway",@"taxi",@"telpher",
                            @"train",@"tram",@"vehicle"];
    }
    return _imageNameArray;
}

#pragma mark - 函数定义
- (UILabel *)newLabelWithText:(NSString *)text
                     fontSize:(CGFloat)fontSize
                    textColor:(UIColor *)textColor
              backgroundColor:(UIColor *)backgroudColor {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.textColor = textColor;
    label.backgroundColor = backgroudColor;
    [label sizeToFit];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 4.0f;
    
    [self expandSizeForView:label extraWidth:12 extraHeight:8];
    
    return label;
}

- (UIButton *)newButtonWithTitle:(NSString *)title
                        fontSize:(CGFloat)fontSize
                 backgroundColor:(UIColor *)backgroudColor {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = backgroudColor;
    button.userInteractionEnabled = NO;  // 防止触发事件因为被Btn劫持造成的演示Demo体验性下降，
    // 在某种需求情况下可以允许Btn拥有独立的触发事件
    [button sizeToFit];
    [self expandSizeForView:button extraWidth:12 extraHeight:8];
    
    return button;
}
- (UIImageView *)newImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.axcUI_Size = CGSizeMake(30, 30);
    imageView.backgroundColor = [UIColor AxcUI_ArcColor];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 4.0f;
    return imageView;
}
- (void)expandSizeForView:(UIView *)view
               extraWidth:(CGFloat)extraWidth
              extraHeight:(CGFloat)extraHeight {
    CGRect frame = view.frame;
    frame.size.width += extraWidth;
    frame.size.height += extraHeight;
    view.frame = frame;
}

@end
