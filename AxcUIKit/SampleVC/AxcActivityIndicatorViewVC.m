//
//  AxcActivityIndicatorViewVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/17.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcActivityIndicatorViewVC.h"
#import "AxcActivityIndicatorViewCell.h"

@interface AxcActivityIndicatorViewVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property(nonatomic,strong)NSArray *dataArray;


@end

@implementation AxcActivityIndicatorViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.view addSubview:self.collectionView];
    
    self.instructionsLabel.text = @"以Vinh Nguyen作者的开源项目：DGActivityIndicatorView为主\n改造结构后融入框架中。在此感谢作者Vinh Nguyen提供的使用许可";
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AxcActivityIndicatorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"axcHUD"
                                                                                   forIndexPath:indexPath];
    cell.backgroundColor = [UIColor AxcUI_ArcColor]; // 预设随机色
    // 设置开始展示  ***************************************************
    [cell setActivityIndicatorViewType:indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDataSource 代理委托
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 33;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(70,70);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

#pragma mark - SET区

#pragma mark - 懒加载区
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,
                                                                             self.view.axcUI_Width, self.view.axcUI_Height)
                                             collectionViewLayout:layout];
//        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor AxcUI_CloudColor]; // 预设颜色
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"AxcActivityIndicatorViewCell"
                                                    bundle:nil]
          forCellWithReuseIdentifier:@"axcHUD"];
        
    }
    return _collectionView;
}


@end
