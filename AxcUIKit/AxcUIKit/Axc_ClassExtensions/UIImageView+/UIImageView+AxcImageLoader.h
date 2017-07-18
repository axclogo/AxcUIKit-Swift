//
//  UIImageView+AxcLoader.h
//  ImageLoaderAnimation
//
//  Created by Rounak Jain on 28/12/14.
//  Copyright (c) 2014 Rounak Jain. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "AxcUI_ProgressTranPieView.h"
#import "AxcUI_ProgressPieView.h"
#import "AxcUI_ProgressLoopView.h"
#import "AxcUI_ProgressBallView.h"
#import "AxcUI_ProgressLodingView.h"
#import "AxcUI_ProgressPieLoopView.h"

// 样式枚举
typedef NS_ENUM(NSUInteger, AxcUIProgressViewStyle) {
    AxcUIProgressViewStyleTranPieProgressView,
    AxcUIProgressViewStylePieProgressView,
    AxcUIProgressViewStyleLoopProgressView,
    AxcUIProgressViewStyleBallProgressView,
    AxcUIProgressViewStyleLodingProgressView,
    AxcUIProgressViewStylePieLoopProgressView
};

@interface UIImageView (AxcImageLoader)

/**
 *  progressView的样式，共6种
 */
@property(nonatomic, assign)AxcUIProgressViewStyle axcUI_progressViewStyle;

/**
 *  axcUI_progressView 进度指示器
 */
@property(nonatomic, strong)AxcBaseProgressView *axcUI_progressView;


- (void)AxcUI_removeAxcUI_progressViewAnimation:(BOOL )animation;



@end
