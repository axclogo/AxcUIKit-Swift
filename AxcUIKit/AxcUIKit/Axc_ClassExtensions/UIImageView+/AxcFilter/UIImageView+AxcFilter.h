//
//  UIImage+AxcFilter.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/29.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>



//  更详细专业的滤镜请参考博客：http://blog.csdn.net/daiyibo123/article/details/46759851
/**
 *  预设滤镜风格
 */
typedef NS_ENUM(NSUInteger, AxcFilterPresetStyle) {
    /** LOMO */
    AxcFilterPresetStyleLOMO,
    /** 黑白 */
    AxcFilterPresetStyleBlackWhite,
    /** 复古 */
    AxcFilterPresetStyleRestoringAncientWays,
    /** 哥特 */
    AxcFilterPresetStyleGothic,
    /** 锐化 */
    AxcFilterPresetStyleSharpen,
    /** 淡雅 */
    AxcFilterPresetStyleQuietlyElegant,
    /** 酒红 */
    AxcFilterPresetStyleRedWine,
    /** 清宁 */
    AxcFilterPresetStyleQingNing,
    /** 浪漫 */
    AxcFilterPresetStyleRomantic,
    /** 光晕 */
    AxcFilterPresetStyleHalo,
    /** 蓝调 */
    AxcFilterPresetStyleBlues,
    /** 梦幻 */
    AxcFilterPresetStyleDream,
    /** 夜色 */
    AxcFilterPresetStyleDimLightNight,
    /** 增加亮度 */
    AxcFilterPresetStyleIncreaseLight,
    /** 高灰度 */
    AxcFilterPresetStyleHighGray
};

typedef NS_ENUM(NSUInteger, AxcImageAlgorithmStyle) {
    /** 马赛克 */
    AxcImageAlgorithmStyleMosaic,
    /** 高斯模糊 */
    AxcImageAlgorithmStyleGaussianBlur,
    /** 边缘锐化 */
    AxcImageAlgorithmStyleEdgeDetection,
    /** 浮雕 */
    AxcImageAlgorithmStyleEmboss,
    /** 锐化 */
    AxcImageAlgorithmStyleSharpen,
    /** 进一步锐化 */
    AxcImageAlgorithmStyleNnsharpen,
    /** 形态膨胀/扩张 */
    AxcImageAlgorithmStyleDilate,
    /** 侵蚀 */
    AxcImageAlgorithmStyleErode,
    /** 均衡运算 */
    AxcImageAlgorithmStyleEqualization,
};


@interface UIImageView (AxcFilter)

/**
 *  滤镜饱和度0 - 2 默认 1
 */
@property(nonatomic,assign)CGFloat axcUI_filterStaturation;
/**
 *  滤镜亮度-1 - 1 默认 0
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





/**
 *  预设滤镜风格
 */
@property(nonatomic, assign)AxcFilterPresetStyle axcUI_filterPresetStyle;


/**
 *  预设图像算法处理
 */
@property(nonatomic, assign)AxcImageAlgorithmStyle axcUI_imageAlgorithmStyle;




/**
 *  输入一个图片和滤镜色值，返回一个处理后的图片
 */
+ (UIImage *)AxcUI_drawingWithImage:(UIImage*)inImage withColorMatrix:(const float*)f;





//色彩滤镜
@property(nonatomic, strong)CIFilter *axcUI_filterColorControlsFilter;
//Core Image上下文
@property(nonatomic, strong)CIContext *axcUI_filterContext;


@end



