//
//  AxcArrangeLayoutVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/9/8.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcArrangeLayoutVC.h"


@interface AxcArrangeLayoutVC ()

@property(nonatomic,strong)AxcUI_MultipleArrangeLayout *layout;

@end

@implementation AxcArrangeLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.layout = [[AxcUI_MultipleArrangeLayout alloc] init];
    
    self.segmentedArray = @[@"右对齐",@"居中",@"左对齐"];
    
    self.segmented.selectedSegmentIndex = 0;
    [self.segmented addTarget:self action:@selector(clickSegmented:) forControlEvents:UIControlEventValueChanged];
    
    [self clickSegmented:self.segmented];

}

- (void)clickSegmented:(UISegmentedControl *)sender{
    self.layout.axcUI_layoutAlignStyle = sender.selectedSegmentIndex;
    self.collectionViewFlowLayout = self.layout;
}




- (CGSize )AxcLayoutBase_CollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(arc4random()%100+50, 40);
}


@end
