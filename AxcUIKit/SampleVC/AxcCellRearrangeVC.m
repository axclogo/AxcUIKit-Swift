//
//  AxcCellRearrangeVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcCellRearrangeVC.h"


@interface AxcCellRearrangeVC ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
AxcCollectionViewRearrangeDelegate>


@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation AxcCellRearrangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.collectionView];
    
    self.instructionsLabel.text = @"允许自定义不可排列的个别item，代码示例已设置前3个禁止排序，无法拖动和排序为正常现象";
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor AxcUI_CloudColor]; // 预设颜色
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        // RunTime传值，无先后顺序，设置即可动态调整  ************************************************
        _collectionView.axcUI_rearrangeDelegate = self;// 设置排序代理
        _collectionView.axcUI_enableRearrangement = YES; // 是否允许排序
        _collectionView.axcUI_autoScrollSpeed = 3; // 长按cell接触边缘时collectionView自动滚动的速率，每1/60秒移动的距离
        _collectionView.axcUI_longPressMagnificationFactor = 1.2; // 长按放大倍数  默认为1.2
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"rID"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource 代理委托

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rID"forIndexPath:indexPath];
    cell.backgroundColor = [UIColor AxcUI_ArcColor]; // 预设随机色
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(50,50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(30, 30, 30, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - 排序代理委托

- (BOOL)AxcUI_collectionView:(UICollectionView *)collectionView shouldMoveCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        // 如果不需要参与 长按拖动 和 重排效果 的cell， 在这里判断返回NO 即可。
        return NO;
    }
    //    NSLog(@"开始位置:%ld", indexPath.row);
    return YES;
}

- (void)AxcUI_collectionView:(UICollectionView *)collectionView putDownCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // 最终停留在的
    //    NSLog(@"最终到:%ld",  indexPath.row);
}

- (BOOL)AxcUI_collectionView:(UICollectionView *)collectionView shouldMoveCell:(UICollectionViewCell *)cell fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    //    NSLog(@"从:%ld, 到x:%ld", fromIndexPath.row, toIndexPath.row);
    return YES;
}

- (void)AxcUI_collectionView:(UICollectionView *)collectionView didMoveCell:(UICollectionViewCell *)cell fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    // 途径的位置
    NSLog(@"从:%ld, 到x:%ld", (long)fromIndexPath.row, toIndexPath.row);
}


@end
