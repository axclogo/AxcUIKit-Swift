//
//  UIView+AxcSpecialEffectsDrawing.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/13.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AxcSpecialEffectsDrawing)

/**
 *  马赛克化
 */
- (UIImage *)AxcUI_drawingWithMosaic;

/**
 *  高斯模糊
 */
- (UIImage *)AxcUI_drawingWithGaussianBlur;

/**
 *  边缘锐化
 */
- (UIImage *)AxcUI_drawingWithEdgeDetection;

/**
 *  浮雕
 */
- (UIImage *)AxcUI_drawingWithEmboss;

/**
 *  锐化
 */
- (UIImage *)AxcUI_drawingWithSharpen;

/**
 *  进一步锐化
 */
- (UIImage *)AxcUI_drawingWithNnsharpen;

// 几何操作：
/**
 *  图片旋转
 */
- (UIImage *)AxcUI_drawingWithRotateInRadians:(float)radians;


// 形态操作：
/**
 *  形态膨胀/扩张
 */
- (UIImage *)AxcUI_drawingWithDilate;
/**
 *  形态多倍膨胀/扩张
 */
- (UIImage *)AxcUI_drawingWithDilateIterations:(int)iterations;

/**
 *  侵蚀
 */
- (UIImage *)AxcUI_drawingWithErode;
/**
 *  多倍侵蚀
 */
- (UIImage *)AxcUI_drawingWithErodeIterations:(int)iterations;

/**
 *  均衡运算
 */
- (UIImage *)AxcUI_drawingWithEqualization;

/**
 *  梯度
 */
- (UIImage *)AxcUI_drawingWithGradientIterations:(int)iterations;

/**
 *  顶帽运算
 */
- (UIImage *)AxcUI_drawingWithTophatIterations:(int)iterations;

/**
 *  黑帽运算
 */
- (UIImage *)AxcUI_drawingWithBlackhatIterations:(int)iterations;







#pragma mark - 复用函数
/**
 *  混合函数(内部使用)
 */
- (UIImage *)AxcUI_imageBlendedWithImage:(UIImage *)overlayImage
                               blendMode:(CGBlendMode)blendMode
                                   alpha:(CGFloat)alpha;

@end
