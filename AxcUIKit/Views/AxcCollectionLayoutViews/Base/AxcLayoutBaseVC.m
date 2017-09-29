//
//  AxcLayoutBaseVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/9/8.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcLayoutBaseVC.h"


@interface AxcLayoutBaseVC ()


@property(nonatomic,strong)NSArray *dataArray;

@property(nonatomic, assign)CGSize itemSize;

@end

@implementation AxcLayoutBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemSize = CGSizeMake(300, 200);
    
}




#pragma mark - SET区

#pragma mark - 懒加载区
#pragma makr - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self AxcLayoutBase_CollectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self AxcLayoutBase_CollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}


- (UICollectionViewCell *)AxcLayoutBase_CollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"axc" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor AxcUI_ArcColor];
    return cell;
}

- (CGSize)AxcLayoutBase_CollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.itemSize;
}



// 如果子类调用Set函数则进行重置布局
- (void)setCollectionViewFlowLayout:(UICollectionViewFlowLayout *)collectionViewFlowLayout{
    _collectionViewFlowLayout = collectionViewFlowLayout;
    [self.collectionView setCollectionViewLayout:_collectionViewFlowLayout animated:YES];
    [self.collectionView reloadData];

}

- (BOOL)AxcUI_navigationShouldPopOnBackButton{
    [self.delegate clickGoBack];
    return YES;
}

- (void)setSegmentedArray:(NSArray *)segmentedArray{
    _segmentedArray = segmentedArray;
    [self.segmented removeAllSegments];
    for (NSString *str in _segmentedArray) {
        [self.segmented insertSegmentWithTitle:str atIndex:0 animated:YES];
    }
    [self.view addSubview:self.segmented];
}

- (UISegmentedControl *)segmented{
    if (!_segmented) {
        _segmented = [[UISegmentedControl alloc] init];
        _segmented.frame = CGRectMake(10, 130, self.view.axcUI_Width - 20, 30);
        _segmented.axcUI_Y = self.collectionView.axcUI_Y + self.collectionView.axcUI_Height + 50;
        _segmented.selectedSegmentIndex = 0;
    }
    return _segmented;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        // 随便搞一个Layout别让他崩溃
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.itemSize = self.itemSize;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100,
                                                                             [UIScreen mainScreen].bounds.size.width , 300)
                                             collectionViewLayout:layout];
        _collectionView.axcUI_CenterX = self.view.axcUI_CenterX;
        [_collectionView.collectionViewLayout invalidateLayout];
        //        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"axc"];
        [self.view addSubview:self.collectionView];
    }
    return  _collectionView;
}


@end
