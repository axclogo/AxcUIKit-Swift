//
//  AxcActivityHUDVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/9.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcActivityHUDVC.h"

#import "AxcActivityHUDVCCollectionViewCell.h"

#import "AxcActivityHUDEffectVC.h"


@interface AxcActivityHUDVC ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout


>

@property (nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic, strong)AxcUI_ActivityHUD *axcActivityHUD;

@property(nonatomic, strong)UIButton *dismissTextButton;
@property(nonatomic, strong)UIButton *dismissButton;

@property(nonatomic, strong)UIButton *showTextButton;
@property(nonatomic, strong)UIButton *showGIFButton;


@property (nonatomic, strong) UISegmentedControl *appearSegmented;
@property (nonatomic, strong) UISegmentedControl *disappearSegmented;
@property (nonatomic, strong) UISegmentedControl *overlaySegmented;

@property(nonatomic, strong)UISwitch *dismissSwitch;
@property(nonatomic, strong)UISwitch *onlyActiveViewSwitch;

@property(nonatomic, strong)UILabel *appearSegmentedLabel;
@property(nonatomic, strong)UILabel *disappearSegmentedLabel;
@property(nonatomic, strong)UILabel *overlaySegmentedLabel;

@property(nonatomic, strong)UILabel *dismissSwitchLabel;
@property(nonatomic, strong)UILabel *onlyActiveViewSwitchLabel;


@end

@implementation AxcActivityHUDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.appearSegmentedLabel];
    [self.view addSubview:self.disappearSegmentedLabel];
    [self.view addSubview:self.overlaySegmentedLabel];

    [self.view addSubview:self.appearSegmented];
    [self.view addSubview:self.disappearSegmented];
    [self.view addSubview:self.overlaySegmented];

    [self.view addSubview:self.showTextButton];
    [self.view addSubview:self.showGIFButton];
    
    [self.view addSubview:self.collectionView];

    [self.view addSubview:self.dismissTextButton];
    [self.view addSubview:self.dismissButton];
    
    [self.view addSubview:self.dismissSwitchLabel];
    [self.view addSubview:self.dismissSwitch];
    
    [self.view addSubview:self.onlyActiveViewSwitchLabel];
    [self.view addSubview:self.onlyActiveViewSwitch];
    
    self.instructionsLabel.text = @"这里可以把这个HUD看成一个View设置相关View属性，也可以添加其他控件。\n不设置即为默认\n在此感谢作者Vinh Nguyen和Cokile Cioi提供的使用许可";
}

#pragma mark - 添加
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self.axcActivityHUD AxcUI_dismissWithSuccess:self.dismissSwitch.on]; // 先销毁之前的
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(click_dismissTextButton) object:nil];

    [self settingType]; // 设置风格
    [self.axcActivityHUD AxcUI_showWithType:indexPath.row];
    
    
    [self performSelector:@selector(click_dismissTextButton) withObject:nil afterDelay:3.0f]; // 延迟3秒后自动退出
}
- (void)click_showTextButton{
    [self settingType];// 设置风格
    [self.axcActivityHUD AxcUI_showWithText:@"努力加载中。。" shimmering:YES];
    [self performSelector:@selector(click_dismissTextButton) withObject:nil afterDelay:3.0f]; // 延迟3秒后自动退出
}
- (void)click_showGIFButton{
    [self settingType];// 设置风格
    [self.axcActivityHUD AxcUI_showWithGIFName:@"test.gif"];
    [self performSelector:@selector(click_dismissTextButton) withObject:nil afterDelay:3.0f]; // 延迟3秒后自动退出
}

- (void)settingType{// 设置风格
    
    // 重写STE方法，无先后顺序，设置即可动态调整  ************************************************
    self.axcActivityHUD.axcUI_isTheOnlyActiveView = self.onlyActiveViewSwitch.on;  // 能否点击背景
    self.axcActivityHUD.axcUI_appearAnimationType = self.appearSegmented.selectedSegmentIndex;       // 入场风格
    self.axcActivityHUD.axcUI_disappearAnimationType = self.disappearSegmented.selectedSegmentIndex; // 出场风格
    self.axcActivityHUD.axcUI_overlayType = self.overlaySegmented.selectedSegmentIndex;    //  背景框的风格
    // 这里可以把他看成一个View设置相关View属性，也可以添加其他控件
//    self.axcActivityHUD.axcUI_Size = CGSizeMake(200, 200);
}

#pragma mark - 移除
- (void)click_dismissTextButton{
    [self.axcActivityHUD AxcUI_dismissWithText:@"这里可以填写文字哦"
                                         delay:0.7
                                       success:self.dismissSwitch.on ];
    // 如果点击了按钮则不执行延迟操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(click_dismissTextButton) object:nil];
}
- (void)click_dismissButton{
    [self.axcActivityHUD AxcUI_dismissWithSuccess:self.dismissSwitch.on];
    // 如果点击了按钮则不执行延迟操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(click_dismissTextButton) object:nil];
}



#pragma mark - 初始化
- (AxcUI_ActivityHUD *)axcActivityHUD{
    if (!_axcActivityHUD) {
        _axcActivityHUD = [[AxcUI_ActivityHUD alloc] init];
       
    }
    return _axcActivityHUD;
}


#pragma mark - UICollectionViewDataSource 代理委托
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 41;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AxcActivityHUDVCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"axcHUD"
                                                                                         forIndexPath:indexPath];
    cell.backgroundColor = [UIColor AxcUI_ArcColor]; // 预设随机色

    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"HUD_%ld",indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(50,50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - 懒加载
- (UILabel *)onlyActiveViewSwitchLabel{
    if (!_onlyActiveViewSwitchLabel) {
        _onlyActiveViewSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.axcUI_Width - 190,
                                                                               self.view.axcUI_Height - 380 ,
                                                                        180, 30)];
        _onlyActiveViewSwitchLabel.font = [UIFont systemFontOfSize:14];
        _onlyActiveViewSwitchLabel.textColor = [UIColor AxcUI_OrangeColor];
        _onlyActiveViewSwitchLabel.textAlignment = NSTextAlignmentRight;
        _onlyActiveViewSwitchLabel.text = @"HUD出现时关闭背景点击";
    }
    return _onlyActiveViewSwitchLabel;
}
- (UISwitch *)onlyActiveViewSwitch{
    if (!_onlyActiveViewSwitch) {
        _onlyActiveViewSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.axcUI_Width - 60,
                                                                           self.view.axcUI_Height - 350, 50, 30)];
        _onlyActiveViewSwitch.on = NO;
    }
    return _onlyActiveViewSwitch;
}
- (UILabel *)dismissSwitchLabel{
    if (!_dismissSwitchLabel) {
        _dismissSwitchLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,self.view.axcUI_Height - 380 ,
                                                                             150, 30)];
        _dismissSwitchLabel.font = [UIFont systemFontOfSize:14];
        _dismissSwitchLabel.textColor = [UIColor AxcUI_OrangeColor];
        _dismissSwitchLabel.text = @"dismiss时的对与错";
    }
    return _dismissSwitchLabel;
}

- (UISwitch *)dismissSwitch{
    if (!_dismissSwitch) {
        _dismissSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10,self.view.axcUI_Height - 350, 50, 30)];
        _dismissSwitch.on = YES;
    }
    return _dismissSwitch;
}

- (UIButton *)showTextButton{
    if (!_showTextButton) {
        _showTextButton = [[UIButton alloc] initWithFrame:CGRectMake(10,
                                                                    self.view.axcUI_Height - 310, 162, 30)];
        [_showTextButton addTarget:self action:@selector(click_showTextButton)
                 forControlEvents:UIControlEventTouchUpInside];
        [_showTextButton setTitle:@"展示纯文字加载" forState:UIControlStateNormal];
        [_showTextButton setTitleColor:[UIColor AxcUI_WetAsphaltColor] forState:UIControlStateNormal];
        _showTextButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _showTextButton.backgroundColor = [UIColor AxcUI_EmeraldColor];
        _showTextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _showTextButton;
}
- (UIButton *)showGIFButton{
    if (!_showGIFButton) {
        _showGIFButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.axcUI_Width - 172,
                                                                    self.view.axcUI_Height - 310, 162, 30)];
        [_showGIFButton addTarget:self action:@selector(click_showGIFButton)
                 forControlEvents:UIControlEventTouchUpInside];
        [_showGIFButton setTitle:@"展示GIF图加载" forState:UIControlStateNormal];
        [_showGIFButton setTitleColor:[UIColor AxcUI_WetAsphaltColor] forState:UIControlStateNormal];
        _showGIFButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _showGIFButton.backgroundColor = [UIColor AxcUI_EmeraldColor];
        _showGIFButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _showGIFButton;
}

- (UILabel *)appearSegmentedLabel{
    if (!_appearSegmentedLabel) {
        _appearSegmentedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,100 , self.view.axcUI_Width - 20, 30)];
        _appearSegmentedLabel.font = [UIFont systemFontOfSize:14];
        _appearSegmentedLabel.textColor = [UIColor AxcUI_OrangeColor];
        _appearSegmentedLabel.textAlignment = NSTextAlignmentCenter;
        _appearSegmentedLabel.text = @"选择入场模式";
    }
    return _appearSegmentedLabel;
}
- (UISegmentedControl *)appearSegmented{
    if (!_appearSegmented) {
        _appearSegmented = [[UISegmentedControl alloc] initWithItems:@[@"上",
                                                                       @"下",
                                                                       @"左",
                                                                       @"右",
                                                                       @"放大",
                                                                       @"渐出"]];
        _appearSegmented.frame = CGRectMake(10, 130,
                                              self.view.axcUI_Width - 20, 30);
        _appearSegmented.selectedSegmentIndex = 0;
    }
    return _appearSegmented;
}

- (UILabel *)disappearSegmentedLabel{
    if (!_disappearSegmentedLabel) {
        _disappearSegmentedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,160 , self.view.axcUI_Width - 20, 30)];
        _disappearSegmentedLabel.font = [UIFont systemFontOfSize:14];
        _disappearSegmentedLabel.textColor = [UIColor AxcUI_OrangeColor];
        _disappearSegmentedLabel.textAlignment = NSTextAlignmentCenter;
        _disappearSegmentedLabel.text = @"选择出场模式";
    }
    return _disappearSegmentedLabel;
}
- (UISegmentedControl *)disappearSegmented{
    if (!_disappearSegmented) {
        _disappearSegmented = [[UISegmentedControl alloc] initWithItems:@[@"上",
                                                                          @"下",
                                                                          @"左",
                                                                          @"右",
                                                                          @"缩小",
                                                                          @"渐隐"]];
        _disappearSegmented.frame = CGRectMake(10, 190,
                                              self.view.axcUI_Width - 20, 30);
        _disappearSegmented.selectedSegmentIndex = 0;
    }
    return _disappearSegmented;
}

- (UILabel *)overlaySegmentedLabel{
    if (!_overlaySegmentedLabel) {
        _overlaySegmentedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,220 , self.view.axcUI_Width - 20, 30)];
        _overlaySegmentedLabel.font = [UIFont systemFontOfSize:14];
        _overlaySegmentedLabel.textColor = [UIColor AxcUI_OrangeColor];
        _overlaySegmentedLabel.textAlignment = NSTextAlignmentCenter;
        _overlaySegmentedLabel.text = @"选择背景属性";
    }
    return _overlaySegmentedLabel;
}
- (UISegmentedControl *)overlaySegmented{
    if (!_overlaySegmented) {
        _overlaySegmented = [[UISegmentedControl alloc] initWithItems:@[@"默认",
                                                                        @"模糊",
                                                                        @"透明",
                                                                        @"阴影"]];
        _overlaySegmented.frame = CGRectMake(10, 250,
                                              self.view.axcUI_Width - 20, 30);
        _overlaySegmented.selectedSegmentIndex = 0;
    }
    return _overlaySegmented;
}

- (UIButton *)dismissButton{
    if (!_dismissButton) {
        _dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.axcUI_Width - 172,
                                                                    self.view.axcUI_Height - 130, 162, 30)];
        [_dismissButton addTarget:self action:@selector(click_dismissButton)
                     forControlEvents:UIControlEventTouchUpInside];
        [_dismissButton setTitle:@"默认dismiss" forState:UIControlStateNormal];
        [_dismissButton setTitleColor:[UIColor AxcUI_CloudColor] forState:UIControlStateNormal];
        _dismissButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _dismissButton.backgroundColor = [UIColor AxcUI_PomegranateColor];
        _dismissButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dismissButton;
}

- (UIButton *)dismissTextButton{
    if (!_dismissTextButton) {
        _dismissTextButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.axcUI_Height - 130, 162, 30)];
        [_dismissTextButton addTarget:self action:@selector(click_dismissTextButton)
                 forControlEvents:UIControlEventTouchUpInside];
        [_dismissTextButton setTitle:@"文字提示方式dismiss" forState:UIControlStateNormal];
        [_dismissTextButton setTitleColor:[UIColor AxcUI_CloudColor] forState:UIControlStateNormal];
        _dismissTextButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _dismissTextButton.backgroundColor = [UIColor AxcUI_PomegranateColor];
        _dismissTextButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dismissTextButton;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.axcUI_Height - 280,
                                                                             self.view.axcUI_Width, 150)
                                             collectionViewLayout:layout];
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor AxcUI_CloudColor]; // 预设颜色
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"AxcActivityHUDVCCollectionViewCell"
                                                    bundle:nil]
          forCellWithReuseIdentifier:@"axcHUD"];

    }
    return _collectionView;
}

@end
