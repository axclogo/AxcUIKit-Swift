//
//  UIImage+AxcImageName.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/5/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIImage+AxcImageName.h"

#import "NSBundle+AxcUIKitBundle.h"

@implementation UIImage (AxcImageName)

+(UIImage *)AxcUI_setImageNamed:(NSString *)name{
    UIImage *appleImage;
    NSString *imagePath;
    NSArray *arr = [name componentsSeparatedByString:@"."];
    if (arr.count == 1) {
        imagePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    }else{
        imagePath = [[NSBundle mainBundle] pathForResource:[arr firstObject] ofType:[arr lastObject]];
    }
    int size = [self AxcUI_fileSizeAtPath:imagePath];
    if (size < 500) { // 小图选择缓存到内存中
        appleImage = [UIImage imageNamed:name];
    }else{ // 大图不缓存到内存中
        appleImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    }
    return appleImage;
}

+ (int )AxcUI_fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return (int )[[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024;
    }
    return 0;
}

+(UIImage *)AxcUI_axcUIBoundleImageName:(NSString *)name{
    UIImage *image = [self AxcUI_axcUIBoundleImageName:name
                                              InBundle:[NSBundle AxcUIKitBundle]];
    if (!image) {
        NSLog(@"AxcUIKit未找到Bundle资源！\nError Image Name With ：%@\n",name);
    }
    return image;
}


+ (UIImage *)AxcUI_axcUIBoundleImageName:(NSString *)name InBundle:(NSBundle *)bundle {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
#elif __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
#else
    if ([UIImage respondsToSelector:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)]) {
        return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:@"png"]];
    }
#endif
}



@end
