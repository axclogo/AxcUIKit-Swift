//
//  AxcUI_BarrageFloatModel.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_BarrageFloatModel.h"
#import "AxcBarrageContainer.h"

@interface AxcUI_BarrageFloatModel()
@property (assign, nonatomic) CGFloat during;
@property (assign, nonatomic) AxcBarrageFloatDirectionStyle direction;
@end

@implementation AxcUI_BarrageFloatModel
- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor text:(NSString *)text shadowStyle:(AxcBarrageShadowStyle)shadowStyle font:(UIFont *)font during:(CGFloat)during direction:(AxcBarrageFloatDirectionStyle)direction{
    
    if (self = [super initWithFontSize:fontSize textColor:textColor text:text shadowStyle:shadowStyle font:font]) {
        _direction = direction;
        _during = during;
    }
    return self;
}

- (BOOL)updatePositonWithTime:(NSTimeInterval)time container:(AxcBarrageContainer *)container{
    return self.appearTime + _during >= time;
}

/**
 *  找出同方向的弹幕 按照所在轨道归类弹幕
 优先选择没有弹幕的轨道
 如果都有 选择弹幕最少的轨道
 *
 */
- (CGPoint)originalPositonWithContainerArr:(NSArray <AxcBarrageContainer *>*)arr channelCount:(NSInteger)channelCount contentRect:(CGRect)rect danmakuSize:(CGSize)danmakuSize timeDifference:(NSTimeInterval)timeDifference{
    NSMutableDictionary <NSNumber *, NSMutableArray <AxcBarrageContainer *>*>*dic = [NSMutableDictionary dictionary];
    channelCount = (channelCount == 0) ? [self channelCountWithContentRect:rect danmakuSize:danmakuSize] : channelCount;
    //轨道高
    NSInteger channelHeight = rect.size.height / channelCount;
    
    for (int i = 0; i < arr.count; ++i) {
        AxcBarrageContainer *obj = arr[i];
        if ([obj.danmaku isKindOfClass:[AxcUI_BarrageFloatModel class]] && [(AxcUI_BarrageFloatModel *)obj.danmaku direction] == _direction) {
            //判断弹幕所在轨道
            NSInteger channel = obj.frame.origin.y / channelHeight;
            
            if (!dic[@(channel)]) dic[@(channel)] = [NSMutableArray array];
            
            [dic[@(channel)] addObject:obj];
        }
    }
    
    __block NSInteger channel = channelCount - 1;
    //每条轨道都有弹幕
    if (dic.count == channelCount) {
        __block NSInteger minCount = dic[@(0)].count;
        [dic enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSMutableArray<AxcBarrageContainer *> * _Nonnull obj, BOOL * _Nonnull stop) {
            if (minCount >= obj.count) {
                minCount = obj.count;
                channel = key.intValue;
            }
        }];
    }
    else {
        //mac坐标原点为左下角 弹幕方向为上到下 按升序查找轨道
        if (_direction == AxcBarrageFloatDirectionStyleT2B) {
            for (NSInteger i = 0; i < channelCount; ++i) {
                if (!dic[@(i)]) {
                    channel = i;
                    break;
                }
            }
        }
        else{
            for (NSInteger i = channelCount - 1; i >= 0; --i) {
                if (!dic[@(i)]) {
                    channel = i;
                    break;
                }
            }
        }
    }
    return CGPointMake((rect.size.width - danmakuSize.width) / 2, channelHeight * channel);
}


- (CGFloat)during{
    return _during;
}

- (AxcBarrageFloatDirectionStyle)direction{
    return _direction;
}

#pragma mark - 私有方法
- (NSInteger)channelCountWithContentRect:(CGRect)contentRect danmakuSize:(CGSize)danmakuSize{
    NSInteger channelCount = contentRect.size.height / danmakuSize.height;
    return channelCount > 4 ? channelCount : 4;
}
@end
