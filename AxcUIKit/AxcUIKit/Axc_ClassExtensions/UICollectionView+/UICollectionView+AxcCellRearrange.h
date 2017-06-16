//
//  UICollectionView+AxcCellRearrange.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//


/*
iOS9以后可以调用系统方案:

//是否允许拖拽
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0);

从sourceIndexPath 拖拽至destinationIndexPath，在这个代理方法里修改数据源即可。
exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex: destinationIndexPath.item

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath NS_AVAILABLE_IOS(9_0);
*/





#import <UIKit/UIKit.h>

@protocol AxcCollectionViewRearrangeDelegate <NSObject>

@optional
/**
 * 开始位置
 */
- (BOOL)AxcUI_collectionView:(nonnull UICollectionView *)collectionView
              shouldMoveCell:(nonnull UICollectionViewCell *)cell
                 atIndexPath:(nonnull NSIndexPath *)indexPath;
/**
 * 最终停留在
 */
- (void)AxcUI_collectionView:(nonnull UICollectionView *)collectionView
                 putDownCell:(nonnull UICollectionViewCell *)cell
                 atIndexPath:(nonnull NSIndexPath *)indexPath;
/**
 * 每次途径后的起点与终点，动画后重置;返回NO后结束
 */
- (BOOL)AxcUI_collectionView:(nonnull UICollectionView *)collectionView
              shouldMoveCell:(nonnull UICollectionViewCell *)cell
               fromIndexPath:(nonnull NSIndexPath *)fromIndexPath
                 toIndexPath:(nonnull NSIndexPath *)toIndexPath;
/**
 * 每次途径后的起点与终点，动画后重置;
 */
- (void)AxcUI_collectionView:(nonnull UICollectionView *)collectionView
                 didMoveCell:(nonnull UICollectionViewCell *)cell
               fromIndexPath:(nonnull NSIndexPath *)fromIndexPath
                 toIndexPath:(nonnull NSIndexPath *)toIndexPath;

@end

@interface UICollectionView (AxcCellRearrange)


/**
 *  排序代理委托
 */
@property (nonatomic, weak) id<AxcCollectionViewRearrangeDelegate> _Nullable axcUI_rearrangeDelegate;
/**
 *  是否允许重排
 */
@property (nonatomic, assign) BOOL axcUI_enableRearrangement;
/**
 *  长按cell接触边缘时collectionView自动滚动的速率，每1/60秒移动的距离
 */
@property (nonatomic, assign) CGFloat axcUI_autoScrollSpeed;
/**
 *  长按放大倍数  默认为1.2
 */
@property (nonatomic, assign) CGFloat axcUI_longPressMagnificationFactor;

@end
