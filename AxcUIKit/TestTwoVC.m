//
//  TestTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//


/**
 
 这个是测试控件属性和运行情况的VC，如果控件各项属性设置正常即可创建一个示例VC作为展示组，此VC不为展示使用
 
 */
#import "TestTwoVC.h"

#import "CollectionViewCell.h"

@interface TestTwoVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView *collectionView;

@end

@implementation TestTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.collectionView];
    
}

#pragma makr - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"axc" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor AxcUI_ArcColor];
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake([UIScreen mainScreen].bounds.size.width - 100,300);
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    self.axc.axcUI_layoutAlignStyle = indexPath.row;
    //    [self.collectionView setCollectionViewLayout:self.axc animated:YES];
    //    [self.collectionView reloadData];
}




- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        AxcUI_SingleLineLayout *layout = [[AxcUI_SingleLineLayout alloc] init];
        
//        layout.itemSize = CGSizeMake(100, 100);
//        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        layout.minimumLineSpacing = 0;
//        layout.sectionInset = UIEdgeInsetsMake(64, 0, 0, 0);
        
        layout.itemSize = CGSizeMake(100, 100);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 500)
                                             collectionViewLayout:layout];
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
