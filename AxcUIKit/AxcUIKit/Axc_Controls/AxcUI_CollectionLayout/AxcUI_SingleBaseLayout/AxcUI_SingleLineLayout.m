//
//  AxcUI_ArrangeLayout.m
//  AxcUIKit
//
//  Created by Axc on 2017/9/6.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcUI_SingleLineLayout.h"


@implementation AxcUI_SingleLineLayout


/**
 *  一些初始化工作，最好在这里实现
 */
-(void)prepareLayout{
    [super prepareLayout];
    
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width) / 2;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}


/**
 * 决定了cell怎么排布
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    // 调用父类方法拿到默认的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 获得collectionView最中间的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 在默认布局属性基础上进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // 计算cell中点x 和 collectionView最中间x值  的差距
        CGFloat delta = ABS(centerX - attrs.center.x);
        
        // 利用差距计算出缩放比例（成反比）
        CGFloat scale = 1 - delta / (self.collectionView.frame.size.width + self.itemSize.width);
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return array;
}

/**
 * 当uicollectionView的bounds发生改变时，是否要刷新布局
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

/**
 * targetContentOffset ：通过修改后，collectionView最终的contentOffset(取决定情况)
 * proposedContentOffset ：默认情况下，collectionView最终的contentOffset
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    // 计算最终的可见范围
    CGRect rect;
    rect.origin = proposedContentOffset;
    rect.size = self.collectionView.frame.size;
    
    // 取得cell的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最终中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 计算最小的间距值
    CGFloat minDetal = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDetal) > ABS(attrs.center.x - centerX)) {
            minDetal = attrs.center.x - centerX;
        }
    }
    // 在原有offset的基础上进行微调
    return CGPointMake(proposedContentOffset.x + minDetal, proposedContentOffset.y);
}

@end
