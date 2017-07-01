//
//  AxcBarrageContainer.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//  弹幕的容器 用来绘制弹幕


#import "AxcUI_FloatBarrageModel.h"
#import "AxcUI_ScrollBarrageModel.h"
#import <UIKit/UIKit.h>

@class AxcUI_BarrageScrollEngine;
@interface AxcBarrageContainer : UILabel
@property (assign, nonatomic) CGPoint originalPosition;
@property (weak, nonatomic) AxcUI_BarrageScrollEngine *danmakuEngine;
- (void)updateAttributed;

- (AxcUI_BaseBarrageModel *)danmaku;
- (instancetype)initWithDanmaku:(AxcUI_BaseBarrageModel *)danmaku;
- (void)setWithDanmaku:(AxcUI_BaseBarrageModel *)danmaku;
/**
 *  更新位置
 *
 *  @param time 当前时间
 *
 *  @return 是否处于激活状态
 */
- (BOOL)updatePositionWithTime:(NSTimeInterval)time;
@end
