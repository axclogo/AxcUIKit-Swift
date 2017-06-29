//
//  UIImage+AxcQRCode.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/29.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIImage+AxcQRCode.h"

#import <objc/runtime.h>





@implementation UIImage (AxcQRCode)


+ (UIImage *)AxcUI_codeImageWithString:(NSString *)string
                                size:(CGFloat)width{
    CIImage *ciImage = [UIImage createQRForString:string];
    if (ciImage) {
        return [UIImage createNonInterpolatedUIImageFormCIImage:ciImage
                                                               size:width];
    } else {
        return nil;
    }
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image
                                                    size:(CGFloat)size {
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent),
                        size/CGRectGetHeight(extent));
    // 1.创建一个位图图像，绘制到其大小的位图上下文
    size_t width        = CGRectGetWidth(extent) * scale;
    size_t height       = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs  = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil,
                                                   width,
                                                   height,
                                                   8,
                                                   0,
                                                   cs,
                                                   (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context     = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.创建具有内容的位图图像
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // 3.清理
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return (UIImage*)[UIImage imageWithCGImage:scaledImage];
}

+ (CIImage *)createQRForString:(NSString *)qrString {
    // 1.将字符串转换为UTF8编码的NSData对象
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 2.创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 3.设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 4.返回CIImage
    return qrFilter.outputImage;
}


void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

+ (UIImage *_Nonnull)AxcUI_codeImageWithString:(NSString *_Nullable)string
                                        size:(CGFloat)width
                                       color:(UIColor *_Nullable)color;{
    
    
    UIImage *image = [UIImage AxcUI_codeImageWithString:string size:width];
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat red     = components[0]*255;
    CGFloat green   = components[1]*255;
    CGFloat blue    = components[2]*255;
    
    const int imageWidth    = image.size.width;
    const int imageHeight   = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf   = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 1.创建上下文
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf,
                                                 imageWidth,
                                                 imageHeight,
                                                 8,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 2.像素转换
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    // 3.生成UIImage
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL,
                                                                  rgbImageBuf,
                                                                  bytesPerRow * imageHeight,
                                                                  ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth,
                                        imageHeight,
                                        8,
                                        32,
                                        bytesPerRow,
                                        colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little,
                                        dataProvider,
                                        NULL,
                                        true,
                                        kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = (UIImage*)[UIImage imageWithCGImage:imageRef];
    
    // 4.释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return resultUIImage;
}

+ (UIImage *_Nonnull)AxcUI_codeImageWithString:(NSString *_Nullable)string
                                        size:(CGFloat)width
                                       color:(UIColor *_Nullable)color
                                        icon:(UIImage *_Nullable)icon
                                   iconWidth:(CGFloat)iconWidth{
    UIImage *bgImage = [UIImage AxcUI_codeImageWithString:string
                                                       size:width
                                                      color:color];
    UIGraphicsBeginImageContext(bgImage.size);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    CGFloat x = (bgImage.size.width - iconWidth) * 0.5;
    CGFloat y = (bgImage.size.height - iconWidth) * 0.5;
    [icon drawInRect:CGRectMake( x,  y, iconWidth,  iconWidth)];
    
    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return (UIImage *)newImage;
}


@end
