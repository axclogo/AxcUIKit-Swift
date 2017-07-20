//
//  AxcPlayerMenuMask.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxcPlayerViewMask.h"

@interface AxcPlayerMenuMask : AxcPlayerViewMask

@property (nonatomic) CGFloat menuWidth;
@property (nonatomic) CGFloat menuItemHeight;
@property (nonatomic) CGPoint menuPosition;

@property (nonatomic, strong) NSArray<NSString *> *items;

@property (nonatomic) NSInteger selectedIndex;

- (void)selectedIndexDidChanged;

@end
