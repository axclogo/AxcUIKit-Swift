//
//  UIImage+AxcFilter.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/29.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIImageView+AxcFilter.h"

#import <objc/runtime.h>

static NSString * const kfilterStaturation = @"axcUI_filterStaturation";
static NSString * const kfilterBrightness = @"axcUI_filterBrightness";
static NSString * const kfilterContrast = @"axcUI_filterContrast";
static NSString * const kfilterColorControlsFilter = @"axcUI_filterColorControlsFilter";
static NSString * const kfilterContext = @"axcUI_filterContext";
static NSString * const kfilterDynamicRendering = @"axcUI_filterDynamicRendering";


@implementation UIImageView (AxcFilter)

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
        _colorControlsFilter=[CIFilter filterWithName:@"CIColorControls"];
        CIImage *CIimage=[CIImage imageWithCGImage:self.image.CGImage];
        [_colorControlsFilter setValue:CIimage forKey:@"inputImage"];
        [self setAxcUI_filterColorControlsFilter:_colorControlsFilter];
    }
    return _colorControlsFilter;
}

- (void)AxcUI_SetFilterImage{
    CIImage *outputImage= [self.axcUI_filterColorControlsFilter outputImage];//取得输出图像
    CGImageRef temp=[self.axcUI_filterContext createCGImage:outputImage fromRect:[outputImage extent]];
    self.image = [UIImage imageWithCGImage:temp];//转化为CGImage显示在界面中
    CGImageRelease(temp);//释放CGImage对象
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
    [self.axcUI_filterColorControlsFilter setValue:[NSNumber numberWithFloat:self.axcUI_filterStaturation]
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
    [self.axcUI_filterColorControlsFilter setValue:[NSNumber numberWithFloat:self.axcUI_filterStaturation]
                                            forKey:@"inputContrast"];
    if (!self.axcUI_filterDynamicRendering) {
        [self AxcUI_SetFilterImage];
    }
}

- (CGFloat)axcUI_filterContrast{
    return [objc_getAssociatedObject(self, &kfilterContrast) floatValue];
}



@end
