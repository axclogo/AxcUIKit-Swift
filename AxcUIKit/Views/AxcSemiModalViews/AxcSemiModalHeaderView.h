//
//  AxcSemiModalHeaderView.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxcUIKit.h"


@interface AxcInstructionsLabel : UILabel

@end


@protocol AxcSemiModalHeaderViewDelegate <NSObject>

- (void)AxcSemiModalHeaderViewOption:(NSDictionary *)option;

@end

@interface AxcSemiModalHeaderView : UIView

@property(nonatomic, weak)id <AxcSemiModalHeaderViewDelegate>delegate;

@property(nonatomic, strong)AxcUI_Label *bottomLabel;

@property(nonatomic, strong)UISwitch *traverseParentHierarchy;
@property(nonatomic, strong)UISwitch *pushParentBack;
@property(nonatomic, strong)UISwitch *backgroundView;
@property(nonatomic, strong)UISlider *animationDuration;
@property(nonatomic, strong)UISlider *parentAlpha;
@property(nonatomic, strong)UISlider *parentScale;
@property(nonatomic, strong)UISlider *shadowOpacity;
@property(nonatomic, strong)UISegmentedControl *transitionStyle;


@property(nonatomic, strong)NSMutableDictionary *options;

@property(nonatomic, strong)UIImageView *presentBackgroundView;

// 说明Label
@property(nonatomic, strong)AxcInstructionsLabel *traverseParentHierarchyLabel;
@property(nonatomic, strong)AxcInstructionsLabel *pushParentBackLabel;
@property(nonatomic, strong)AxcInstructionsLabel *backgroundViewLabel;

@property(nonatomic, strong)AxcInstructionsLabel *animationDurationLabel;
@property(nonatomic, strong)AxcInstructionsLabel *parentAlphaLabel;
@property(nonatomic, strong)AxcInstructionsLabel *parentScaleLabel;
@property(nonatomic, strong)AxcInstructionsLabel *shadowOpacityLabel;

@property(nonatomic, strong)AxcInstructionsLabel *transitionStyleLabel;

@end



