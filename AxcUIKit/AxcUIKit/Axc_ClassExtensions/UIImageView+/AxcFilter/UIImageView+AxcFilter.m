//
//  UIImage+AxcFilter.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/29.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIImageView+AxcFilter.h"
#import "UIImage+AxcSpecialEffectsDrawing.h"

#import <objc/runtime.h>

#import "ColorMatrix.h"

static NSString * const kfilterStaturation = @"axcUI_filterStaturation";
static NSString * const kfilterBrightness = @"axcUI_filterBrightness";
static NSString * const kfilterContrast = @"axcUI_filterContrast";
static NSString * const kfilterColorControlsFilter = @"axcUI_filterColorControlsFilter";
static NSString * const kfilterContext = @"axcUI_filterContext";
static NSString * const kfilterDynamicRendering = @"axcUI_filterDynamicRendering";
static NSString * const kfilterPresetStyle = @"axcUI_filterPresetStyle";
static NSString * const kimageAlgorithmStyle = @"axcUI_imageAlgorithmStyle";


@implementation UIImageView (AxcFilter)

- (void)setAxcUI_imageAlgorithmStyle:(AxcImageAlgorithmStyle)axcUI_imageAlgorithmStyle{
    [self willChangeValueForKey:kimageAlgorithmStyle];
    objc_setAssociatedObject(self, &kimageAlgorithmStyle,
                             @(axcUI_imageAlgorithmStyle),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kimageAlgorithmStyle];
    switch (axcUI_imageAlgorithmStyle) {
        case AxcImageAlgorithmStyleMosaic:
            self.image = [self.image AxcUI_drawingWithMosaic]; break;
        case AxcImageAlgorithmStyleGaussianBlur:
            self.image = [self.image AxcUI_drawingWithGaussianBlur]; break;
        case AxcImageAlgorithmStyleEdgeDetection:
            self.image = [self.image AxcUI_drawingWithEdgeDetection]; break;
        case AxcImageAlgorithmStyleEmboss:
            self.image = [self.image AxcUI_drawingWithEmboss]; break;
        case AxcImageAlgorithmStyleSharpen:
            self.image = [self.image AxcUI_drawingWithSharpen]; break;
        case AxcImageAlgorithmStyleNnsharpen:
            self.image = [self.image AxcUI_drawingWithNnsharpen]; break;
        case AxcImageAlgorithmStyleDilate:
            self.image = [self.image AxcUI_drawingWithDilate]; break;
        case AxcImageAlgorithmStyleErode:
            self.image = [self.image AxcUI_drawingWithErode]; break;
        case AxcImageAlgorithmStyleEqualization:
            self.image = [self.image AxcUI_drawingWithEqualization]; break;
        default:
            break;
    }
}

- (AxcImageAlgorithmStyle)axcUI_imageAlgorithmStyle{
    return [objc_getAssociatedObject(self, &kfilterPresetStyle) integerValue];
}




- (void)setAxcUI_filterPresetStyle:(AxcFilterPresetStyle)axcUI_filterPresetStyle{
    [self willChangeValueForKey:kfilterPresetStyle];
    objc_setAssociatedObject(self, &kfilterPresetStyle,
                             @(axcUI_filterPresetStyle),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kfilterPresetStyle];
    switch (axcUI_filterPresetStyle) {
        case AxcFilterPresetStyleLOMO:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_lomo]; break;
        case AxcFilterPresetStyleBlackWhite:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_heibai]; break;
        case AxcFilterPresetStyleRestoringAncientWays:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_huajiu]; break;
        case AxcFilterPresetStyleGothic:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_gete]; break;
        case AxcFilterPresetStyleSharpen:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_ruise]; break;
        case AxcFilterPresetStyleQuietlyElegant:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_danya]; break;
        case AxcFilterPresetStyleRedWine:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_jiuhong]; break;
        case AxcFilterPresetStyleQingNing:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_qingning]; break;
        case AxcFilterPresetStyleRomantic:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_langman]; break;
        case AxcFilterPresetStyleHalo:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_guangyun]; break;
        case AxcFilterPresetStyleBlues:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_landiao]; break;
        case AxcFilterPresetStyleDream:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_menghuan]; break;
        case AxcFilterPresetStyleDimLightNight:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_yese]; break;
        case AxcFilterPresetStyleIncreaseLight:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_liangdu]; break;
        case AxcFilterPresetStyleHighGray:
            self.image = [UIImageView AxcUI_drawingWithImage:self.image withColorMatrix:colormatrix_huidu]; break;
        default:
            break;
    }
}

- (AxcFilterPresetStyle)axcUI_filterPresetStyle{
    return [objc_getAssociatedObject(self, &kfilterPresetStyle) integerValue];
}





static CGContextRef CreateRGBABitmapContext (CGImageRef inImage)// 返回一个使用RGBA通道的位图上下文
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
    unsigned long bitmapByteCount;
    unsigned long bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
    size_t pixelsHigh = CGImageGetHeight(inImage); //纵向
    
    bitmapBytesPerRow	= (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
    bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
    colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
    
    bitmapData = malloc(bitmapByteCount); //分配足够容纳图片字节数的内存空间
    
    context = CGBitmapContextCreate (bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
    
    CGColorSpaceRelease( colorSpace );
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    
    return context;
}

static unsigned char *RequestImagePixelData(UIImage *inImage)
// 返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
{
    CGImageRef img = [inImage CGImage];
    CGSize size = [inImage size];
    
    CGContextRef cgctx = CreateRGBABitmapContext(img); //使用上面的函数创建上下文
    
    CGRect rect = {{0,0},{size.width, size.height}};
    
    CGContextDrawImage(cgctx, rect, img); //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
    unsigned char *data = CGBitmapContextGetData (cgctx);
    
    CGContextRelease(cgctx);//释放上面的函数创建的上下文
    return data;
}

static void changeRGBA(int *red,int *green,int *blue,int *alpha, const float* f)//修改RGB的值
{
    int redV = *red;
    int greenV = *green;
    int blueV = *blue;
    int alphaV = *alpha;
    
    *red = f[0] * redV + f[1] * greenV + f[2] * blueV + f[3] * alphaV + f[4];
    *green = f[0+5] * redV + f[1+5] * greenV + f[2+5] * blueV + f[3+5] * alphaV + f[4+5];
    *blue = f[0+5*2] * redV + f[1+5*2] * greenV + f[2+5*2] * blueV + f[3+5*2] * alphaV + f[4+5*2];
    *alpha = f[0+5*3] * redV + f[1+5*3] * greenV + f[2+5*3] * blueV + f[3+5*3] * alphaV + f[4+5*3];
    // 我的法克？？
    if (*red > 255){
        *red = 255;
    }
    if(*red < 0){
        *red = 0;
    }
    if (*green > 255){
        *green = 255;
    }
    if (*green < 0){
        *green = 0;
    }
    if (*blue > 255){
        *blue = 255;
    }
    if (*blue < 0){
        *blue = 0;
    }
    if (*alpha > 255){
        *alpha = 255;
    }
    if (*alpha < 0){
        *alpha = 0;
    }
}

+ (UIImage *)AxcUI_drawingWithImage:(UIImage*)inImage withColorMatrix:(const float*)f{
    unsigned char *imgPixel = RequestImagePixelData(inImage);
    CGImageRef inImageRef = [inImage CGImage];
    size_t w = CGImageGetWidth(inImageRef);
    size_t h = CGImageGetHeight(inImageRef);
    
    int wOff = 0;
    int pixOff = 0;
    for(GLuint y = 0;y< h;y++){//双层循环按照长宽的像素个数迭代每个像素点
        pixOff = wOff;
        for (GLuint x = 0; x<w; x++){
            int red = (unsigned char)imgPixel[pixOff];
            int green = (unsigned char)imgPixel[pixOff+1];
            int blue = (unsigned char)imgPixel[pixOff+2];
            int alpha = (unsigned char)imgPixel[pixOff+3];
            changeRGBA(&red, &green, &blue, &alpha, f);
            //回写数据
            imgPixel[pixOff] = red;
            imgPixel[pixOff+1] = green;
            imgPixel[pixOff+2] = blue;
            imgPixel[pixOff+3] = alpha;
            pixOff += 4; //将数组的索引指向下四个元素
        }
        wOff += w * 4;
    }
    NSInteger dataLength = w * h * 4;
    
    //下面的代码创建要输出的图像的相关参数
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, NULL);
    
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    unsigned long bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageRef = CGImageCreate(w, h, bitsPerComponent, bitsPerPixel, bytesPerRow,colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);//创建要输出的图像
    
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    return myImage;
}

-(void)setAxcUI_filterContext:(CIContext *)axcUI_filterContext{
    [self willChangeValueForKey:kfilterContext];
    objc_setAssociatedObject(self, &kfilterContext,
                             axcUI_filterContext,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kfilterContext];
}

- (CIContext *)axcUI_filterContext{
     CIContext *_context = objc_getAssociatedObject(self, &kfilterContext);
    if (!_context) {
        // 使用GPU渲染，推荐,但注意GPU的CIContext无法跨应用访问，
        // 例如直接在UIImagePickerController的完成方法中调用上下文处理就会自动降级为CPU渲染，
        // 所以推荐现在完成方法中保存图像，然后在主程序中调用
        _context=[CIContext contextWithOptions:nil];
        [self setAxcUI_filterContext:_context];
    }
    return _context;
}

-(void)setAxcUI_filterColorControlsFilter:(CIFilter *)axcUI_filterColorControlsFilter{
    [self willChangeValueForKey:kfilterColorControlsFilter];
    objc_setAssociatedObject(self, &kfilterColorControlsFilter,
                             axcUI_filterColorControlsFilter,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kfilterColorControlsFilter];
}

- (CIFilter *)axcUI_filterColorControlsFilter{
    CIFilter *_colorControlsFilter = objc_getAssociatedObject(self, &kfilterColorControlsFilter);
    if (!_colorControlsFilter) {
        _colorControlsFilter = [CIFilter filterWithName:@"CIColorControls"];
        CIImage *CIimage = [CIImage imageWithCGImage:self.image.CGImage];
        [_colorControlsFilter setValue:CIimage forKey:@"inputImage"];
        [self setAxcUI_filterColorControlsFilter:_colorControlsFilter];
    }
    return _colorControlsFilter;
}


- (void)AxcUI_SetFilterImage{
    dispatch_async(dispatch_get_main_queue(), ^{
        CIImage *outputImage= [self.axcUI_filterColorControlsFilter outputImage];//取得输出图像
        CGImageRef temp=[self.axcUI_filterContext createCGImage:outputImage fromRect:[outputImage extent]];
        self.image = [UIImage imageWithCGImage:temp];//转化为CGImage显示在界面中
        CGImageRelease(temp);//释放CGImage对象
    });
}







-(void)setAxcUI_filterDynamicRendering:(BOOL)axcUI_filterDynamicRendering{
    [self willChangeValueForKey:kfilterDynamicRendering];
    objc_setAssociatedObject(self, &kfilterDynamicRendering,
                             @(axcUI_filterDynamicRendering),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kfilterDynamicRendering];
}

- (BOOL)axcUI_filterDynamicRendering{
    return [objc_getAssociatedObject(self, &kfilterDynamicRendering) boolValue];
}

-(void)setAxcUI_filterStaturation:(CGFloat)axcUI_filterStaturation{
    [self willChangeValueForKey:kfilterStaturation];
    objc_setAssociatedObject(self, &kfilterStaturation,
                             @(axcUI_filterStaturation),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kfilterStaturation];
    [self.axcUI_filterColorControlsFilter setValue:[NSNumber numberWithFloat:self.axcUI_filterStaturation]
                                            forKey:@"inputSaturation"];
    if (!self.axcUI_filterDynamicRendering) {
        [self AxcUI_SetFilterImage];
    }
}

- (CGFloat)axcUI_filterStaturation{
    return [objc_getAssociatedObject(self, &kfilterStaturation) floatValue];
}

-(void)setAxcUI_filterBrightness:(CGFloat)axcUI_filterBrightness{
    [self willChangeValueForKey:kfilterBrightness];
    objc_setAssociatedObject(self, &kfilterBrightness,
                             @(axcUI_filterBrightness),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kfilterBrightness];
    [self.axcUI_filterColorControlsFilter setValue:[NSNumber numberWithFloat:self.axcUI_filterBrightness]
                                            forKey:@"inputBrightness"];
    if (!self.axcUI_filterDynamicRendering) {
        [self AxcUI_SetFilterImage];
    }
}

- (CGFloat)axcUI_filterBrightness{
    return [objc_getAssociatedObject(self, &kfilterBrightness) floatValue];
}


-(void)setAxcUI_filterContrast:(CGFloat)axcUI_filterContrast{
    [self willChangeValueForKey:kfilterContrast];
    objc_setAssociatedObject(self, &kfilterContrast,
                             @(axcUI_filterContrast),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kfilterContrast];
    [self.axcUI_filterColorControlsFilter setValue:[NSNumber numberWithFloat:self.axcUI_filterContrast]
                                            forKey:@"inputContrast"];
    if (!self.axcUI_filterDynamicRendering) {
        [self AxcUI_SetFilterImage];
    }
}

- (CGFloat)axcUI_filterContrast{
    return [objc_getAssociatedObject(self, &kfilterContrast) floatValue];
}



@end

