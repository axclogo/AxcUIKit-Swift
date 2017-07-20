//
//  AxcPlayerBarrageMask.h
//  axctest
//
//  Created by Axc on 2017/7/20.
//  Copyright © 2017年 Axc5324. All rights reserved.
//

#import "AxcPlayerViewMask.h"

#import "AxcUI_Label.h"

@interface AxcPlayerBarrageMask : AxcPlayerViewMask

@property(nonatomic, strong)AxcUI_Label *barrageTextFontSliderLabel;
@property(nonatomic, strong)UISlider *barrageTextFontSlider;
@property(nonatomic, strong)AxcUI_Label *barrageSpeedSliderLabel;
@property(nonatomic, strong)UISlider *barrageSpeedSlider;


@property(nonatomic, strong)UISegmentedControl *barrageSwitchSegmented;

@end
