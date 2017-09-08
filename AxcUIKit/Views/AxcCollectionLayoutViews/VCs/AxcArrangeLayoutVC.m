//
//  AxcArrangeLayoutVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/9/8.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcArrangeLayoutVC.h"


@interface AxcArrangeLayoutVC ()


@property(nonatomic,strong)NSArray *dataArray;


@end

@implementation AxcArrangeLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    AxcUI_MultipleArrangeLayout *layout = [[AxcUI_MultipleArrangeLayout alloc] init];
    
//    layout.itemSize = CGSizeMake(300, 200);
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumLineSpacing = -30;
    
    
    self.collectionViewFlowLayout = layout;
    
}

- (CGSize )AxcLayoutBase_CollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(arc4random()%100+50, 40);
}


@end
