//
//  AxcUI_ArrangeLayout.h
//  UICollectionViewDemo
//
//  Created by Axc on 2017/8/26.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <UIKit/UIKit.h>

// 左中右布局
typedef NS_ENUM(NSInteger,AxcArrangeLayoutAlignStyle){
    AxcArrangeLayoutAlignStyleAlignLeft,
    AxcArrangeLayoutAlignStyleAlignCenter,
    AxcArrangeLayoutAlignStyleAlignRight
};


@interface AxcUI_ArrangeLayout : UICollectionViewFlowLayout
//两个Cell之间的距离
@property (nonatomic,assign)CGFloat axcUI_betweenOfCell;
//cell对齐方式
@property (nonatomic,assign)AxcArrangeLayoutAlignStyle axcUI_layoutAlignStyle;


@end
