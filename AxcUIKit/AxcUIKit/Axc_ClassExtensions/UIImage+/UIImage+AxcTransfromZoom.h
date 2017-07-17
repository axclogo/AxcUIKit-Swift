//
//  UIImage+AxcTransfromZoom.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AxcTransfromZoom)

/**
 *  通过Bitmap来进行重设大小
 */
- (UIImage*)AxcUI_transformImageBitmapWidth:(CGFloat)width
                                     height:(CGFloat)height;
/**
 *  通过Bitmap来进行重设大小(size)
 */
- (UIImage*)AxcUI_transformImageBitmapSize:(CGSize )size;


/**
 *  通过Context来进行重设大小
 */
- (UIImage*)AxcUI_transformImageContextWidth:(CGFloat)width
                                      height:(CGFloat)height;
/**
 *  通过Context来进行重设大小(size)
 */
- (UIImage *)AxcUI_transformImageContextSize:(CGSize)size;


/**
 *  通过比例来缩放
 */
- (UIImage *)AxcUI_transformImageScale:(float)scale;

@end
