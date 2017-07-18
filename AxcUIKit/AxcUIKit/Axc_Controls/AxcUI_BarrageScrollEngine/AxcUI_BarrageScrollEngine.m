//
//  AxcUI_BarrageScrollEngine.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_BarrageScrollEngine.h"
#import "AxcBarrageClock.h"
#import "AxcBarrageContainer.h"
#import "AxcUI_BarrageFloatModel.h"

@interface AxcUI_BarrageScrollEngine()<AxcBarrageClockDelegate>
@property (strong, nonatomic) AxcBarrageClock *clock;
/**
 *  当前未激活的弹幕
 */
@property (strong, nonatomic) NSMutableArray <AxcBarrageContainer *>*inactiveContainer;
/**
 *  当前激活的弹幕
 */
@property (strong, nonatomic) NSMutableArray <AxcBarrageContainer *>*activeContainer;

@end

@implementation AxcUI_BarrageScrollEngine
{
    //用于记录当前时间的整数值
    NSInteger _intTime;
    float _extraSpeed;
}

- (instancetype)init {
    if (self = [super init]) {
        _intTime = -1;
        _axcUI_barrageTimeInterval = 1;
        [self setAxcUI_barrageSpeed: 1.0];
    }
    return self;
}

- (void)AxcUI_BarrageStart {
    [self.clock start];
}

- (void)AxcUI_BarrageStop {
    _intTime = -_axcUI_barrageTimeInterval;
    [self.clock stop];
    [self.activeContainer enumerateObjectsUsingBlock:^(AxcBarrageContainer * _Nonnull obj,
                                                       NSUInteger idx,
                                                       BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.activeContainer removeAllObjects];
}

- (void)AxcUI_BarragePause {
    [self.clock pause];
}

- (void)setAxcUI_barrageTimeInterval:(NSUInteger)axcUI_barrageTimeInterval {
    _axcUI_barrageTimeInterval = axcUI_barrageTimeInterval;
    _intTime = -_axcUI_barrageTimeInterval;
}

- (void)AxcUI_BarrageSendBarrage:(AxcUI_BarrageModelBase *)danmaku {
    [self sendDanmaku:danmaku updateAppearTime:YES];
}

- (void)setAxcUI_barrageOffsetTime:(NSTimeInterval)axcUI_barrageOffsetTime{
    _intTime = -_axcUI_barrageTimeInterval;
    [self.clock setOffsetTime:axcUI_barrageOffsetTime];
    [self reloadPreDanmaku];
}

- (NSTimeInterval)axcUI_barrageOffsetTime {
    return self.clock.offsetTime;
}

- (void)setAxcUI_barrageCurrentTime:(NSTimeInterval)axcUI_barrageCurrentTime {
    if (axcUI_barrageCurrentTime < 0) return;
    _axcUI_barrageCurrentTime = axcUI_barrageCurrentTime;
    _intTime = -_axcUI_barrageTimeInterval;
    [self.clock setCurrentTime:axcUI_barrageCurrentTime];
    [self reloadPreDanmaku];
}

- (void)setAxcUI_barrageChannelCount:(NSInteger)axcUI_barrageChannelCount {
    if (axcUI_barrageChannelCount >= 0) {
        _axcUI_barrageChannelCount = axcUI_barrageChannelCount;
        [self setAxcUI_barrageCurrentTime:_axcUI_barrageCurrentTime];
    }
}

- (void)setAxcUI_barrageSpeed:(float)axcUI_barrageSpeed {
    _extraSpeed = axcUI_barrageSpeed > 0 ? axcUI_barrageSpeed : 0.1;
    [self.activeContainer enumerateObjectsUsingBlock:^(AxcBarrageContainer * _Nonnull obj,
                                                       NSUInteger idx,
                                                       BOOL * _Nonnull stop) {
        obj.danmaku.extraSpeed = _extraSpeed;
    }];
}

- (float)axcUI_barrageSpeed {
    return _extraSpeed;
}

- (void)setAxcUI_barrageGlobalAttributedDic:(NSDictionary *)axcUI_barrageGlobalAttributedDic {
    if ([_axcUI_barrageGlobalAttributedDic isEqualToDictionary:axcUI_barrageGlobalAttributedDic] == NO) {
        _axcUI_barrageGlobalAttributedDic = axcUI_barrageGlobalAttributedDic;
        NSArray <AxcBarrageContainer *>*activeContainer = self.activeContainer;
        [activeContainer enumerateObjectsUsingBlock:^(AxcBarrageContainer * _Nonnull obj,
                                                      NSUInteger idx,
                                                      BOOL * _Nonnull stop) {
            [obj updateAttributed];
        }];
    }
}

- (void)setAxcUI_barrageGlobalFont:(UIFont *)axcUI_barrageGlobalFont {
    if ([_axcUI_barrageGlobalFont isEqual: axcUI_barrageGlobalFont] == NO) {
        _axcUI_barrageGlobalFont = axcUI_barrageGlobalFont;
        NSArray <AxcBarrageContainer *>*activeContainer = self.activeContainer;
        [activeContainer enumerateObjectsUsingBlock:^(AxcBarrageContainer * _Nonnull obj,
                                                      NSUInteger idx,
                                                      BOOL * _Nonnull stop) {
            [obj updateAttributed];
        }];
    }
}

- (void)setAxcUI_barrageGlobalShadowStyle:(AxcBarrageShadowStyle)axcUI_barrageGlobalShadowStyle {
    if (_axcUI_barrageGlobalShadowStyle != axcUI_barrageGlobalShadowStyle) {
        _axcUI_barrageGlobalShadowStyle = axcUI_barrageGlobalShadowStyle;
        NSArray <AxcBarrageContainer *>*activeContainer = self.activeContainer;
        [activeContainer enumerateObjectsUsingBlock:^(AxcBarrageContainer * _Nonnull obj,
                                                      NSUInteger idx,
                                                      BOOL * _Nonnull stop) {
            [obj updateAttributed];
        }];
    }
}

#pragma mark - AxcBarrageClockDelegate
- (void)danmakuClock:(AxcBarrageClock *)clock time:(NSTimeInterval)time {
    _axcUI_barrageCurrentTime = time;
    //根据间隔获取一次弹幕 开启回退功能时启用
    if ([self.axcUI_barrageDelegate respondsToSelector:@selector(AxcUI_barrageScrollEngine:didSendBarrageAtTime:)] &&
        (NSInteger)_axcUI_barrageCurrentTime - _intTime >= _axcUI_barrageTimeInterval) {
        _intTime = _axcUI_barrageCurrentTime;
        NSArray <AxcUI_BarrageModelBase*>*danmakus = [self.axcUI_barrageDelegate AxcUI_barrageScrollEngine:self
                                                                                      didSendBarrageAtTime:_intTime];
        [danmakus enumerateObjectsUsingBlock:^(AxcUI_BarrageModelBase * _Nonnull obj,
                                               NSUInteger idx,
                                               BOOL * _Nonnull stop) {
            [self sendDanmaku:obj updateAppearTime:NO];
        }];
    }
    
    //遍历激活的弹幕容器 逐一发射
    NSArray <AxcBarrageContainer *>*danmakus = self.activeContainer;
    [danmakus enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(AxcBarrageContainer * _Nonnull container,
                                                                            NSUInteger idx,
                                                                            BOOL * _Nonnull stop) {
        //如果弹幕移出屏幕或者到达显示时长 则移出画布 状态改为失活
        if ([container updatePositionWithTime:_axcUI_barrageCurrentTime] == NO) {
            [self.activeContainer removeObjectAtIndex:idx];
            [self.inactiveContainer addObject:container];
            [container removeFromSuperview];
            container.danmaku.disappearTime = _axcUI_barrageCurrentTime;
        }
    }];
}

#pragma mark - 私有方法
//预加载前5秒的弹幕
- (void)reloadPreDanmaku {
    if ([self.axcUI_barrageDelegate respondsToSelector:@selector(AxcUI_barrageScrollEngine:didSendBarrageAtTime:)]) {
        //移除当前显示的弹幕
        [self.activeContainer enumerateObjectsUsingBlock:^(AxcBarrageContainer * _Nonnull obj,
                                                           NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.activeContainer removeAllObjects];
        
        for (NSInteger i = 1; i <= 5; ++i) {
            NSInteger time = _axcUI_barrageCurrentTime - i;
            NSArray <AxcUI_BarrageModelBase *>*danmakus = [self.axcUI_barrageDelegate AxcUI_barrageScrollEngine:self
                                                                                           didSendBarrageAtTime:time];
            [danmakus enumerateObjectsUsingBlock:^(AxcUI_BarrageModelBase * _Nonnull obj,
                                                   NSUInteger idx,
                                                   BOOL * _Nonnull stop) {
                [self sendDanmaku:obj updateAppearTime:NO];
            }];
        }
    }
}

//重设当前弹幕初始位置
- (void)resetOriginalPosition:(CGRect)bounds {
    [self.activeContainer enumerateObjectsUsingBlock:^(AxcBarrageContainer * _Nonnull obj,
                                                       NSUInteger idx,
                                                       BOOL * _Nonnull stop) {
        obj.originalPosition = [obj.danmaku originalPositonWithContainerArr:self.activeContainer
                                                               channelCount:self.axcUI_barrageChannelCount
                                                                contentRect:bounds danmakuSize:obj.bounds.size
                                                             timeDifference:_axcUI_barrageCurrentTime - obj.danmaku.appearTime];
    }];
}


/**
 发射弹幕

 @param danmaku 弹幕
 @param updateAppearTime 是否更改当前时间为弹幕的时间
 */
- (void)sendDanmaku:(AxcUI_BarrageModelBase *)danmaku updateAppearTime:(BOOL)updateAppearTime {
    
    if ([self.axcUI_barrageDelegate respondsToSelector:@selector(AxcUI_barrageScrollEngine:shouldSendBarrage:)] &&
        [self.axcUI_barrageDelegate AxcUI_barrageScrollEngine:self shouldSendBarrage:danmaku] == NO) {
        return;
    }

    if (updateAppearTime) {
        danmaku.appearTime = _axcUI_barrageCurrentTime;
    }
    
    //附加速度
    danmaku.extraSpeed = _extraSpeed;
    
    //尝试从缓存中获取弹幕容器 没有则创建一个
    AxcBarrageContainer *con = self.inactiveContainer.firstObject;
    if (con == nil) {
        con = [[AxcBarrageContainer alloc] initWithDanmaku:danmaku];
        con.danmakuEngine = self;
    }
    else {
        [self.inactiveContainer removeObject:con];
    }
    
    [con setWithDanmaku:danmaku];
    con.originalPosition = [danmaku originalPositonWithContainerArr:self.activeContainer
                                                       channelCount:self.axcUI_barrageChannelCount
                                                        contentRect:self.axcUI_barrageCanvas.bounds
                                                        danmakuSize:con.bounds.size
                                                     timeDifference:_axcUI_barrageCurrentTime - danmaku.appearTime];
    [self.axcUI_barrageCanvas addSubview: con];
    //将弹幕容器激活
    [self.activeContainer addObject:con];
}

#pragma mark - 懒加载
- (AxcBarrageClock *)clock {
    if(_clock == nil) {
        _clock = [[AxcBarrageClock alloc] init];
        _clock.delegate = self;
    }
    return _clock;
}


- (NSMutableArray <AxcBarrageContainer *> *)inactiveContainer {
    if(_inactiveContainer == nil) {
        _inactiveContainer = [NSMutableArray array];
    }
    return _inactiveContainer;
}

- (NSMutableArray <AxcBarrageContainer *> *)activeContainer {
    if(_activeContainer == nil) {
        _activeContainer = [[NSMutableArray <AxcBarrageContainer *> alloc] init];
    }
    return _activeContainer;
}

- (AxcBarrageCanvas *)axcUI_barrageCanvas {
    if(_axcUI_barrageCanvas == nil) {
        _axcUI_barrageCanvas = [[AxcBarrageCanvas alloc] init];
        __weak typeof(self)weakSelf = self;
        [_axcUI_barrageCanvas setResizeCallBackBlock:^(CGRect bounds) {
            __strong typeof(weakSelf)self = weakSelf;
            if (!self) return;
            [self resetOriginalPosition:bounds];
        }];
    }
    return _axcUI_barrageCanvas;
}

@end
