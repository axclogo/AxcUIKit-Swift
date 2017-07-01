//
//  AxcUI_BarrageScrollEngine.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_BaseBarrageModel.h"
#import "AxcBarrageCanvas.h"

@class AxcUI_BarrageScrollEngine;
@protocol AxcBarrageScrollEngineDelegate <NSObject>
@optional

/**
 在指定时间发射弹幕

 @param barrageEngine 弹幕引擎
 @param time 时间
 @return 发射的弹幕
 */
- (NSArray <__kindof AxcUI_BaseBarrageModel*>*)AxcUI_barrageScrollEngine:(AxcUI_BarrageScrollEngine *)barrageEngine
                                                    didSendBarrageAtTime:(NSUInteger)time;

/**
 是否发射某个弹幕

 @param barrageEngine 弹幕引擎
 @param barrage 弹幕
 @return 是否发射
 */
- (BOOL)AxcUI_barrageScrollEngine:(AxcUI_BarrageScrollEngine *)barrageEngine
                shouldSendBarrage:(__kindof AxcUI_BaseBarrageModel *)barrage;

@end

@interface AxcUI_BarrageScrollEngine : NSObject

@property (weak, nonatomic) id<AxcBarrageScrollEngineDelegate> axcUI_barrageDelegate;

/**
 计时器多少秒调用一次代理方法 默认1s
 */
@property (assign, nonatomic) NSUInteger axcUI_barrageTimeInterval;

/**
 弹幕画布
 */
@property (strong, nonatomic) AxcBarrageCanvas *axcUI_barrageCanvas;

/**
 把窗口平分为多少份 默认0 自动调整
 */
@property (assign, nonatomic) NSInteger axcUI_barrageChannelCount;

/**
 当前时间
 */
@property (assign, nonatomic) NSTimeInterval axcUI_barrageCurrentTime;

/**
 偏移时间 让弹幕偏移一般设置这个就行
 */
@property (assign, nonatomic) NSTimeInterval axcUI_barrageOffsetTime;

/**
 全局文字风格字典 默认不使用 会覆盖个体设置
 */
@property (strong, nonatomic) NSDictionary *axcUI_barrageGlobalAttributedDic;

/**
 全局字体 默认不使用 会覆盖个体设置 方便更改字体大小
 */
@property (strong, nonatomic) UIFont *axcUI_barrageGlobalFont;

/**
 全局字体边缘特效 默认不使用 会覆盖个体设置
 */
@property (assign, nonatomic) AxcBarrageShadowStyle axcUI_barrageGlobalShadowStyle;


/**
 全局速度 默认1.0
 */
@property (assign, nonatomic) float axcUI_barrageSpeed;

/**
 开始计时器 暂停状态就是恢复运动
 */
- (void)AxcUI_BarrageStart;
- (void)AxcUI_BarrageStop;
- (void)AxcUI_BarragePause;

/**
 *  发射弹幕
 *
 *  @param danmaku 单个弹幕
 */
- (void)AxcUI_BarrageSendBarrage:(AxcUI_BaseBarrageModel *)danmaku;
@end
