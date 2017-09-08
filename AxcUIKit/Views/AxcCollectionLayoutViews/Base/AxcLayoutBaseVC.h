//
//  AxcLayoutBaseVC.h
//  AxcUIKit
//
//  Created by Axc on 2017/9/8.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "SampleBaseVC.h"
#import "CollectionViewCell.h"

@protocol AxcLayoutBaseVC_Delegate <NSObject>

- (void)clickGoBack;

@end


@interface AxcLayoutBaseVC : SampleBaseVC  <UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *collectionView;

@property(nonatomic, strong)UICollectionViewFlowLayout *collectionViewFlowLayout;

@property(nonatomic, weak)id <AxcLayoutBaseVC_Delegate> delegate;

// 移接函数
- (UICollectionViewCell *)AxcLayoutBase_CollectionView:(UICollectionView *)collectionView
                                cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)AxcLayoutBase_CollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
