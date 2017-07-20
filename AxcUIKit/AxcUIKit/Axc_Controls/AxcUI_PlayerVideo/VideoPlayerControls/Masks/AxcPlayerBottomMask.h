//
//  AxcPlayerBottomMask.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxcPlayerViewMask.h"
#import "AxcPlayerSlider.h"
#import "AxcPlayerControlButton.h"

@interface AxcPlayerBottomMask : AxcPlayerViewMask

@property (nonatomic, strong, readonly) AxcPlayerSlider *timeSlider;

@property (nonatomic, strong) NSArray<AxcPlayerControlButton *> *leftButtons;
@property (nonatomic, strong) NSArray<AxcPlayerControlButton *> *rightButtons;

@end
