//
//  AxcUI_ScrollBarrageModel.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_ScrollBarrageModel.h"
#import "AxcBarrageContainer.h"

//当前窗口大小
#define kWindowFrame [UIScreen mainScreen].bounds

@interface AxcUI_ScrollBarrageModel()
@property (assign, nonatomic) CGFloat speed;
@property (assign, nonatomic) AxcScrollBarrageDirectionStyleB2T direction;
@end

@implementation AxcUI_ScrollBarrageModel

- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor text:(NSString *)text shadowStyle:(AxcBarrageShadowStyle)shadowStyle font:(UIFont *)font speed:(CGFloat)speed direction:(AxcScrollBarrageDirectionStyleB2T)direction {
    if (self = [super initWithFontSize:fontSize textColor:textColor text:text shadowStyle:shadowStyle font:font]) {
        _speed = speed;
        if (direction == AxcScrollBarrageDirectionStyleB2TT2B) {
            _direction = AxcScrollBarrageDirectionStyleB2TB2T;
        }else if (direction == AxcScrollBarrageDirectionStyleB2TB2T) {
            _direction = AxcScrollBarrageDirectionStyleB2TT2B;
        }else{
            _direction = direction;
        }
    }
    return self;
}

- (BOOL)updatePositonWithTime:(NSTimeInterval)time container:(AxcBarrageContainer *)container{
    CGRect windowFrame = kWindowFrame;
    CGRect containerFrame = container.frame;
    CGPoint point = container.originalPosition;
    
    switch (_direction) {
        case AxcScrollBarrageDirectionStyleB2TR2L:
        {
            point.x -= (_speed * self.extraSpeed) * (time - self.appearTime);
            containerFrame.origin = point;
            container.frame = containerFrame;
            return containerFrame.origin.x + containerFrame.size.width >= 0;
        }
        case AxcScrollBarrageDirectionStyleB2TL2R:
        {
            point.x += (_speed * self.extraSpeed) * (time - self.appearTime);
            containerFrame.origin = point;
            container.frame = containerFrame;
            return containerFrame.origin.x <= windowFrame.size.width;
        }
        case AxcScrollBarrageDirectionStyleB2TT2B:
        {
            point.y -= (_speed * self.extraSpeed) * (time - self.appearTime);
            containerFrame.origin = point;
            container.frame = containerFrame;
            return containerFrame.origin.y + containerFrame.size.height >= 0;
        }
        case AxcScrollBarrageDirectionStyleB2TB2T:
        {
            point.y += (_speed * self.extraSpeed) * (time - self.appearTime);
            containerFrame.origin = point;
            container.frame = containerFrame;
            return containerFrame.origin.y <= windowFrame.size.height;
        }
    }
    return NO;
}

/**
 *
 遍历所有同方向的弹幕
 如果方向是左右或者右左 channelHeight = 窗口高/channelCount
 如果是上下或者下上 channelHeight = 窗口宽/channelCount
 左右方向按照y/channelHeight 归类
 上下方向按照x/channelHeight 归类
 优先选择没有弹幕的轨道
 如果都有 计算选择弹幕最少的轨道 如果所有轨道弹幕数相同 则随机选择一条
 */
- (CGPoint)originalPositonWithContainerArr:(NSArray <AxcBarrageContainer *>*)arr channelCount:(NSInteger)channelCount contentRect:(CGRect)rect danmakuSize:(CGSize)danmakuSize timeDifference:(NSTimeInterval)timeDifference {
    NSMutableDictionary <NSNumber *, NSMutableArray<AxcBarrageContainer *> *>*dic = [NSMutableDictionary dictionary];
    channelCount = (channelCount == 0) ? [self channelCountWithContentRect:rect danmakuSize:danmakuSize] : channelCount;
    //轨道高
    NSInteger channelHeight = [self channelHeightWithChannelCount:channelCount contentRect:rect];
    for (int i = 0; i < arr.count; ++i) {
        AxcBarrageContainer *obj = arr[i];
        if ([obj.danmaku isKindOfClass:[AxcUI_ScrollBarrageModel class]] && [(AxcUI_ScrollBarrageModel *)obj.danmaku direction] == _direction) {
            //计算弹幕所在轨道
            NSNumber *channel = @([self channelWithFrame:obj.frame channelHeight:channelHeight]);
            
            if (dic[channel] == nil) {
                dic[channel] = [NSMutableArray array];
            }
            
            [dic[channel] addObject:obj];
        }
    }
    
    __block NSInteger channel = channelCount - 1;
    
    if (dic.count >= channelCount) {
        __block NSUInteger minCount = dic[@(0)].count;
        __block BOOL isChange = NO;
        //选出距离最大者
        [dic enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
            if (obj.count <= minCount) {
                channel = key.intValue;
                minCount = obj.count;
                isChange = YES;
            }
        }];
        //没法发生交换 说明轨道弹幕数都一样 随机选取一个轨道
        if (!isChange) {
            channel = arc4random_uniform((u_int32_t)channel);
        }
    }
    else {
        for (NSInteger i = 0; i < channelCount; ++i) {
            if (!dic[@(i)]) {
                channel = i;
                break;
            }
        }
    }
    
    switch (_direction) {
        case AxcScrollBarrageDirectionStyleB2TR2L:
            return CGPointMake(rect.size.width - timeDifference * (_speed * self.extraSpeed), channelHeight * channel);
        case AxcScrollBarrageDirectionStyleB2TL2R:
            return CGPointMake(-danmakuSize.width + timeDifference * (_speed * self.extraSpeed), channelHeight * channel);
        case AxcScrollBarrageDirectionStyleB2TB2T:
            return CGPointMake(channelHeight * channel, -danmakuSize.height + timeDifference * (_speed * self.extraSpeed));
        case AxcScrollBarrageDirectionStyleB2TT2B:
            return CGPointMake(channelHeight * channel, rect.size.height - timeDifference * (_speed * self.extraSpeed));
    }
    return CGPointMake(rect.size.width, rect.size.height);
}

- (CGFloat)speed {
    return _speed;
}

- (AxcScrollBarrageDirectionStyleB2T)direction {
    return _direction;
}


#pragma mark - 私有方法
- (NSInteger)channelCountWithContentRect:(CGRect)contentRect danmakuSize:(CGSize)danmakuSize {
    NSInteger channelCount = 0;
    if (_direction == AxcScrollBarrageDirectionStyleB2TL2R || _direction == AxcScrollBarrageDirectionStyleB2TR2L) {
        channelCount = contentRect.size.height / danmakuSize.height;
        return channelCount > 4 ? channelCount : 4;
    }
    channelCount = contentRect.size.width / danmakuSize.width;
    return channelCount > 4 ? channelCount : 4;
}

- (NSInteger)channelHeightWithChannelCount:(NSInteger)channelCount contentRect:(CGRect)rect {
    if (_direction == AxcScrollBarrageDirectionStyleB2TL2R || _direction == AxcScrollBarrageDirectionStyleB2TR2L) {
        return rect.size.height / channelCount;
    }
    else {
        return rect.size.width / channelCount;
    }
}

/**
 *  计算轨道
 *
 *  @param frame         弹幕 frame
 *  @param channelHeight 轨道高
 *
 *  @return 轨道
 */
- (NSInteger)channelWithFrame:(CGRect)frame channelHeight:(CGFloat)channelHeight {
    if (_direction == AxcScrollBarrageDirectionStyleB2TL2R || _direction == AxcScrollBarrageDirectionStyleB2TR2L) {
        return frame.origin.y / channelHeight;
    }else{
        return frame.origin.x / channelHeight;
    }
}

@end
