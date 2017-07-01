//
//  AxcBarrageCanvas.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  弹幕画布自动布局风格
 */
typedef NS_ENUM(NSUInteger, AxcBarrageCanvasLayoutStyle) {
    /**
     *  不自动布局
     */
    AxcBarrageCanvasLayoutStyleNone,
    /**
     *  在尺寸变化时就布局
     */
    AxcBarrageCanvasLayoutStyleWhenSizeChanging,
    /**
     *  在尺寸变化结束之后布局
     */
    AxcBarrageCanvasLayoutStyleWhenSizeChanged,
};

@interface AxcBarrageCanvas : UIView
//画布布局风格 默认 AxcBarrageCanvasLayoutStyleNone 只在 OSX 中有效
@property (assign, nonatomic) AxcBarrageCanvasLayoutStyle layoutStyle;
@property (copy, nonatomic) void(^resizeCallBackBlock)(CGRect bounds);
@end
