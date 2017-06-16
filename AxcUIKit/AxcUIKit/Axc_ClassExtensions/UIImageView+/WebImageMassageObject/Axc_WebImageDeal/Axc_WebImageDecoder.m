//
//  Axc_WebImageDecoder.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "Axc_WebImageDecoder.h"

@implementation UIImage (ForceDecode)

+ (UIImage *)decodedImageWithImage:(UIImage *)image {
    // 不解码图像动画
    if (image.images) { return image; }

    CGImageRef imageRef = image.CGImage;

    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
    BOOL anyAlpha = (alpha == kCGImageAlphaFirst ||
                     alpha == kCGImageAlphaLast ||
                     alpha == kCGImageAlphaPremultipliedFirst ||
                     alpha == kCGImageAlphaPremultipliedLast);

    if (anyAlpha) { return image; }

    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);

    // 当前
    CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(imageRef));
    CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
    
    bool unsupportedColorSpace = (imageColorSpaceModel == 0 || imageColorSpaceModel == -1 || imageColorSpaceModel == kCGColorSpaceModelIndexed);
    if (unsupportedColorSpace)
        colorspaceRef = CGColorSpaceCreateDeviceRGB();

    CGContextRef context = CGBitmapContextCreate(NULL, width,
                                                 height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorspaceRef,
                                                 kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);

    // 画出图像上下文和检索新数据
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(context);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];

    if (unsupportedColorSpace)
        CGColorSpaceRelease(colorspaceRef);
    
    CGContextRelease(context);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

@end
