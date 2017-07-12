//
//  UIImage+AxcImageName.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/5/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIImage+AxcImageName.h"

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
    return [UIImage imageNamed:[NSString stringWithFormat:@"AxcUIKitBundle.bundle/%@",name]];
}





@end
