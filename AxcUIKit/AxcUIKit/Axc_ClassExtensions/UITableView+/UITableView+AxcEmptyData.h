//
//  UITableView+AxcEmptyData.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (AxcEmptyData)


/**
  当此指针拥有一个View的时候，会在TableView无数据的时候展示此占位View
 */
@property (nonatomic,strong) UIView * axcUI_placeHolderView;

/**
  占位View的入场动画和出场动画，默认YES
 */
@property (nonatomic,assign) BOOL axcUI_placeHolderViewAnimations;


@end
