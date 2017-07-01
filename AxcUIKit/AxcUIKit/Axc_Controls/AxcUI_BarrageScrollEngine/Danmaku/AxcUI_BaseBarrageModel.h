//
//  abstractDanmaku.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AxcBarrageContainer;
typedef NS_ENUM(NSUInteger,  AxcBarrageShadowStyle) {
    //啥也没有
    AxcBarrageShadowStyleNone = 100,
    //描边
    AxcBarrageShadowStyleStroke,
    //投影
    AxcBarrageShadowStyleShadow,
    //模糊阴影
    AxcBarrageShadowStyleGlow,
};

@interface AxcUI_BaseBarrageModel : NSObject
@property (assign, nonatomic) NSTimeInterval appearTime;
@property (assign, nonatomic) NSTimeInterval disappearTime;
//额外的速度 用于调节全局速度时更改个体速度 目前只影响滚动弹幕
@property (assign, nonatomic) float extraSpeed;
@property (strong, nonatomic) NSAttributedString *attributedString;

- (NSString *)text;
- (UIColor *)textColor;
- (CGPoint)originalPositonWithContainerArr:(NSArray <AxcBarrageContainer *>*)arr channelCount:(NSInteger)channelCount contentRect:(CGRect)rect danmakuSize:(CGSize)danmakuSize timeDifference:(NSTimeInterval)timeDifference;
/**
 *  更新位置
 *
 *  @param time      当前时间
 *  @param container 容器
 *
 *  @return 是否处于激活状态
 */
- (BOOL)updatePositonWithTime:(NSTimeInterval)time container:(AxcBarrageContainer *)container;
/**
 *  父类方法 不要使用
 */
- (instancetype)initWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor
                            text:(NSString *)text
                     shadowStyle:(AxcBarrageShadowStyle)shadowStyle
                            font:(UIFont *)font;


@end
