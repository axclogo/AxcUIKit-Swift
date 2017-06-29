//
//  UIImage+AxcFilter.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/29.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AxcFilter)

/**
 *  滤镜饱和度0 - 2 默认 1
 */
@property(nonatomic,assign)CGFloat axcUI_filterStaturation;
/**
 *  滤镜亮度0 - 1 默认 0
 */
@property(nonatomic,assign)CGFloat axcUI_filterBrightness;
/**
 *  滤镜对比度0 - 2 默认 1
 */
@property(nonatomic,assign)CGFloat axcUI_filterContrast;

/**
 *  进行图像渲染处理
 */
- (void)AxcUI_SetFilterImage;

/**
 *  是否取消动态渲染？默认不取消动态渲染，默认NO。如果该值设置为YES，
    那么每当改动以上三个参数的值（饱和、亮度、对比度）将不会渲染到当前Image上，需要手动调用
    - (void)AxcUI_SetFilterImage; 函数来强制执行渲染
 */
@property(nonatomic, assign)BOOL axcUI_filterDynamicRendering;


//色彩滤镜
@property(nonatomic, strong)CIFilter *axcUI_filterColorControlsFilter;
//Core Image上下文
@property(nonatomic, strong)CIContext *axcUI_filterContext;


@end
