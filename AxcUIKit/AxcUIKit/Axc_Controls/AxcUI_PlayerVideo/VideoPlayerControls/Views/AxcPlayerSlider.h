//
//  AxcPlayerSlider.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AxcPlayerSlider : UIControl

@property(nonatomic) float value;
@property(nonatomic) float loadedValue;
@property(nonatomic) float maximumValue;

@property(nonatomic, strong) UIColor *maximumTrackTintColor;
@property(nonatomic, strong) UIColor *loadedTrackTintColor;
@property(nonatomic, strong) UIColor *tintColor;
@property(nonatomic, strong) UIColor *thumbTintColor;

@property(nonatomic) CGFloat thumbSize;
@property(nonatomic) CGFloat trackSize;

@property(nonatomic,getter=isContinuous) BOOL continuous;

- (void)setValue:(float)value animated:(BOOL)animated;

@end
